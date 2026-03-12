#!/usr/bin/env bash

PROC="bongocat"
CMD="$HOME/.local/bin/bongocat"   # anpassen falls woanders installiert

# Falls bongocat im PATH liegt, überschreibt PATH-Version den CMD-Pfad
if command -v bongocat >/dev/null 2>&1; then
    CMD="$(command -v bongocat)"
fi

if pgrep -x "$PROC" >/dev/null; then
    echo "kill"
    pkill -x "$PROC"
else
    echo "start"
    nohup "$CMD" >/dev/null 2>&1 &
fi
