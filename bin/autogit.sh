#!/usr/bin/env bash
# autogit – vereinfachtes „git add . && commit && push“ mit Sicherheitsabfrage

read -rp "Commit-message: " msg
echo
echo "Git Status:"
git status --short
echo
read -rp "really commit and push? [y/N] " yesno

case "$yesno" in
  [Yy]*)
    git add . &&
    git commit -m "$msg" &&
    git push origin main
    ;;
  *)
    echo "Abbruch – nichts unternommen."
    ;;
esac
