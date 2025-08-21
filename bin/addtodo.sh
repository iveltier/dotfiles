#!/bin/bash

TODO_FILE="$HOME/.config/calcurse/todo"
DEFAULT_PRIORITY=0

# Funktion: Hilfe anzeigen
show_help() {
    cat << EOF
Verwendung: todo [OPTION] [ARGUMENT]

  ohne Option
      Neues To-Do hinzufügen mit Priorität $DEFAULT_PRIORITY:
        todo "text"

  -p <Zahl>
      To-Do mit angegebener Priorität hinzufügen
      kann auch "todo [ARGUMENT] -p <zahl>" sein

  -r "Text"
      To-Do mit genau diesem Text löschen

  -c "Text" <Zahl>
        Priorität von To-Do änden

  -t
      Alle To-Dos ausgeben (wie calcurse -t)

  -h
      Diese Hilfe anzeigen
EOF
}

# Funktion: alle To-Dos auflisten
list_todos() {
    if command -v calcurse >/dev/null 2>&1; then
        calcurse -D ~/.config/calcurse -t
    else
        nl -w2 -s'. ' "$TODO_FILE"
    fi
}

# Funktion: To-Do hinzufügen
add_todo() {
    local prio=$1; shift
    echo "[$prio] $*" >> "$TODO_FILE"
    echo "✅ To-Do hinzugefügt (Priorität $prio): $*"
}

# Funktion: To-Do löschen mit Existenzprüfung
remove_todo() {
    if grep -Fq "$*" "$TODO_FILE"; then
        grep -vF "$*" "$TODO_FILE" > "$TODO_FILE.tmp" && mv "$TODO_FILE.tmp" "$TODO_FILE"
        echo "🗑️ To-Do gelöscht: $*"
    else
        echo "⚠️ Kein To-Do gefunden mit dem Text: \"$*\""
        exit 1
    fi
}

# Funktion: Priorität eines bestehenden To-Dos ändern
change_priority() {
    local text="$1"
    local new_prio="$2"
    if grep -Fq "$text" "$TODO_FILE"; then
        # Ersetze die Zeile mit neuer Priorität
        sed -i "s/^\[[0-9]\+\] $text$/[$new_prio] $text/" "$TODO_FILE"
        echo "✏️ Priorität geändert: \"$text\" → $new_prio"
    else
        echo "⚠️ Kein To-Do gefunden mit dem Text: \"$text\""
        exit 1
    fi
}

# Hauptlogik
if [[ "$1" == "-h" ]]; then
    show_help
    exit 0
fi

if [[ "$1" == "-t" ]]; then
    list_todos
    exit 0
fi

if [[ "$1" == "-r" ]]; then
    shift
    [ -z "$1" ] && { echo "⚠️ Bitte Text angeben."; exit 1; }
    remove_todo "$*"
    exit 0
fi

if [[ "$1" == "-c" ]]; then
    shift
    [ $# -lt 2 ] && { echo "⚠️ Bitte Text und neue Priorität angeben."; exit 1; }
    todo_text="$1"
    shift
    new_prio="$1"
    if ! [[ $new_prio =~ ^[0-9]+$ ]]; then
        echo "⚠️ Bitte eine gültige Priorität (Zahl) angeben."
        exit 1
    fi
    change_priority "$todo_text" "$new_prio"
    exit 0
fi

# Argumente parsen für flexible Reihenfolge
prio="$DEFAULT_PRIORITY"
todo_text=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p)
            shift
            if ! [[ $1 =~ ^[0-9]+$ ]]; then
                echo "⚠️ Bitte eine gültige Priorität (Zahl) angeben."
                exit 1
            fi
            prio="$1"
            shift
            ;;
        *)
            # Alles andere als Text zusammenfügen
            if [ -z "$todo_text" ]; then
                todo_text="$1"
            else
                todo_text="$todo_text $1"
            fi
            shift
            ;;
    esac
done

if [ -n "$todo_text" ]; then
    if [[ "$todo_text" == -* ]]; then
        echo "⚠️ Der Text darf nicht mit '-' beginnen."
        exit 1
    fi
    add_todo "$prio" "$todo_text"
else
    echo "⚠️ Keine Aktion angegeben."
    show_help
    exit 1
fi
