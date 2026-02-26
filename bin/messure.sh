#!/usr/bin/env bash
# ============================================================
#  measure_game.sh – CPU & RAM Messung, exakt 60 Sekunden
#  Spiel läuft in separatem Kitty-Fenster, wird nach 60s
#  automatisch beendet.
#  Unterstützt: ASM-Binary, C++-Binary, Node.js (.js)
#  Repo: https://github.com/iveltier/facharbeit
#  Arch x86_64
# ============================================================

set -euo pipefail

DURATION=60           # Messdauer in Sekunden
INTERVAL=0.5
LOG_DIR="./logs"
PYTHON=$(command -v python3 || command -v python)

usage() {
    echo ""
    echo "Verwendung: $0 <programm> [Spielname]"
    echo ""
    echo "Beispiele:"
    echo "  $0 ./asm/game        ASM"
    echo "  $0 ./cpp/game        CPP"
    echo "  $0 ./js/game.js      JS"
    echo ""
    exit 1
}

[[ $# -lt 1 ]] && usage

EXECUTABLE="$1"
GAME_NAME="${2:-$(basename "$1")}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="${LOG_DIR}/${GAME_NAME}_${TIMESTAMP}.csv"
PID_FILE="/tmp/measure_game_${GAME_NAME}_$$.pid"

# ---------- Abhängigkeiten prüfen ---------------------------
command -v kitty &>/dev/null || {
    echo "FEHLER: kitty nicht gefunden.  sudo pacman -S kitty"
    exit 1
}
"$PYTHON" -c "import psutil" &>/dev/null || {
    echo "FEHLER: psutil nicht installiert."
    echo "  sudo pacman -S python-psutil"
    exit 1
}

# ---------- Befehl & Typ ermitteln --------------------------
if [[ "$EXECUTABLE" == *.js ]]; then
    NODE=$(command -v node || command -v nodejs || true)
    [[ -n "$NODE" ]] || { echo "FEHLER: node nicht gefunden.  sudo pacman -S nodejs"; exit 1; }
    [[ -f "$EXECUTABLE" ]] || { echo "FEHLER: '$EXECUTABLE' nicht gefunden"; exit 1; }
    CMD=("$NODE" "$EXECUTABLE")
    TYPE="Node.js"
elif [[ "$EXECUTABLE" == *.py ]]; then
    [[ -f "$EXECUTABLE" ]] || { echo "FEHLER: '$EXECUTABLE' nicht gefunden"; exit 1; }
    CMD=("$PYTHON" "-u" "$EXECUTABLE")
    TYPE="Python"
else
    [[ -f "$EXECUTABLE" ]] || { echo "FEHLER: '$EXECUTABLE' nicht gefunden"; exit 1; }
    [[ -x "$EXECUTABLE" ]] || chmod +x "$EXECUTABLE"
    CMD=("$EXECUTABLE")
    TYPE="Native-Binary (ASM/C++)"
fi

mkdir -p "$LOG_DIR"

echo ""
echo "============================================================"
echo "  CPU & RAM Messung  –  ${DURATION}s"
echo "  Spiel    : $GAME_NAME"
echo "  Typ      : $TYPE"
echo "  Befehl   : ${CMD[*]}"
echo "  Log      : $LOG_FILE"
echo "============================================================"
echo ""
echo "Das Spiel öffnet sich in einem neuen Kitty-Fenster."
echo "Nach genau ${DURATION} Sekunden wird es automatisch beendet."
echo ""
read -rp ">>> Drücke ENTER zum Starten..."
echo ""

# ---------- Wrapper für Kitty-Fenster -----------------------
WRAPPER=$(mktemp /tmp/game_wrapper_XXXXXX.sh)
chmod +x "$WRAPPER"
cat > "$WRAPPER" <<WRAPPER_EOF
#!/usr/bin/env bash
echo \$\$ > "$PID_FILE"
exec ${CMD[*]}
WRAPPER_EOF

# Kitty-Fenster öffnen
kitty \
    --title "[$GAME_NAME] – läuft ${DURATION}s..." \
    --override font_size=14 \
    bash "$WRAPPER" &

# Warten bis PID-Datei erscheint (max 10s)
WAIT=0
while [[ ! -f "$PID_FILE" ]] && [[ $WAIT -lt 20 ]]; do
    sleep 0.5
    WAIT=$((WAIT + 1))
done

if [[ ! -f "$PID_FILE" ]]; then
    echo "FEHLER: Spiel hat sich nicht gestartet (PID-Datei fehlt)"
    rm -f "$WRAPPER"
    exit 1
fi

GAME_PID=$(cat "$PID_FILE")
rm -f "$PID_FILE" "$WRAPPER"

echo "  Spiel läuft (PID: $GAME_PID)"
echo "  Messung läuft – ${DURATION} Sekunden..."
echo ""

# ---------- Python-Monitor (60s, dann kill) -----------------
"$PYTHON" - "$GAME_PID" "$GAME_NAME" "$LOG_FILE" "$INTERVAL" "$DURATION" <<'PYEOF'
import sys, time, csv, psutil, threading, os, signal

game_pid  = int(sys.argv[1])
name      = sys.argv[2]
log_file  = sys.argv[3]
interval  = float(sys.argv[4])
duration  = float(sys.argv[5])

samples    = []
stop_event = threading.Event()

def collect():
    try:
        proc = psutil.Process(game_pid)
    except psutil.NoSuchProcess:
        print("[INFO] Prozess bereits beendet.")
        return

    # Ersten cpu_percent-Wert wegwerfen (immer 0.0)
    time.sleep(0.3)
    try:
        proc.cpu_percent()
        for c in proc.children(recursive=True):
            try: c.cpu_percent()
            except: pass
    except psutil.NoSuchProcess:
        return

    with open(log_file, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["timestamp", "elapsed_s", "cpu_percent", "ram_mb", "ram_percent"])
        start = time.time()

        while not stop_event.is_set():
            try:
                all_procs = [proc] + proc.children(recursive=True)
                cpu_total = 0.0
                ram_total = 0.0
                ram_pct   = 0.0
                for p in all_procs:
                    try:
                        cpu_total += p.cpu_percent(interval=None)
                        m = p.memory_info()
                        ram_total += m.rss / 1024 / 1024
                        ram_pct   += p.memory_percent()
                    except (psutil.NoSuchProcess, psutil.AccessDenied):
                        pass

                elapsed = round(time.time() - start, 2)
                ts      = time.strftime("%H:%M:%S")
                writer.writerow([ts, elapsed,
                                  round(cpu_total, 2),
                                  round(ram_total, 2),
                                  round(ram_pct,   3)])
                f.flush()
                samples.append((cpu_total, ram_total))

            except (psutil.NoSuchProcess, psutil.AccessDenied):
                break

            time.sleep(interval)

# Countdown-Anzeige im Terminal
def countdown():
    for remaining in range(int(duration), 0, -1):
        if stop_event.is_set():
            break
        print(f"\r  ⏱  Noch {remaining:>2}s ...   ", end="", flush=True)
        time.sleep(1)
    if not stop_event.is_set():
        print(f"\r  ✓  60s abgelaufen – Spiel wird beendet...   ")

monitor   = threading.Thread(target=collect,    daemon=True)
countdown_t = threading.Thread(target=countdown, daemon=True)
monitor.start()
countdown_t.start()

# 60 Sekunden warten, dann Spiel killen
time.sleep(duration)
stop_event.set()

# Prozess und alle Kind-Prozesse beenden
try:
    proc = psutil.Process(game_pid)
    children = proc.children(recursive=True)
    # Erst sanft beenden
    for p in [proc] + children:
        try: p.terminate()
        except (psutil.NoSuchProcess, psutil.AccessDenied): pass
    # Kurz warten
    time.sleep(1)
    # Falls noch am Leben: hart killen
    for p in [proc] + children:
        try: p.kill()
        except (psutil.NoSuchProcess, psutil.AccessDenied): pass
except psutil.NoSuchProcess:
    pass  # Spiel hatte sich schon selbst beendet

monitor.join(timeout=2)
countdown_t.join(timeout=2)

# ---------- Auswertung --------------------------------------
print("\n")

if not samples:
    print("[WARNUNG] Keine Messdaten – Spiel zu kurz oder Startfehler.")
    sys.exit(0)

cpu_vals = [s[0] for s in samples]
ram_vals = [s[1] for s in samples]

cpu_avg  = sum(cpu_vals) / len(cpu_vals)
cpu_max  = max(cpu_vals)
cpu_min  = min(cpu_vals)
ram_avg  = sum(ram_vals) / len(ram_vals)
ram_max  = max(ram_vals)
ram_min  = min(ram_vals)
actual   = round(len(samples) * interval, 1)

summary = f"""
============================================================
  ERGEBNIS: {name}
============================================================
  Messdauer       : {actual} s  (Soll: {int(duration)} s)
  Messungen       : {len(samples)}

  CPU-Auslastung  (inkl. Kind-Prozesse)
    Durchschnitt  : {cpu_avg:.2f} %
    Maximum       : {cpu_max:.2f} %
    Minimum       : {cpu_min:.2f} %

  RAM-Verbrauch   (inkl. Kind-Prozesse)
    Durchschnitt  : {ram_avg:.1f} MB
    Maximum       : {ram_max:.1f} MB
    Minimum       : {ram_min:.1f} MB

  Rohdaten (CSV)  : {log_file}
============================================================
"""

print(summary)

summary_file = log_file.replace(".csv", "_summary.txt")
with open(summary_file, "w") as f:
    f.write(summary)
print(f"  Zusammenfassung: {summary_file}\n")
PYEOF
