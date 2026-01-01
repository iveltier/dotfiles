#!/usr/bin/env bash
# autogit – vereinfachtes „git add . && commit && push“ mit Sicherheitsabfrage
# Leer-Eingabe → Default-Message "readme update"
echo "Git Status:"
git status --short
echo
read -rp "commit-message [readme update]: " msg
msg=${msg:-readme update}
echo
echo "Commit message: \"$msg\""
echo
read -rp "really commit and push? [y/N] " yesno

case "$yesno" in
  [Yy]*)
    git add . &&
    git commit -m "$msg" &&
    git push origin main
    ;;
  *)
    echo "Abort, nothing done"
    ;;
esac
