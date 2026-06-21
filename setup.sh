#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC="$DOTFILES_DIR/.claude/skills"
SKILLS_DST="$HOME/.claude/skills"

mkdir -p "$HOME/.claude"

if [ -L "$SKILLS_DST" ]; then
    echo "~/.claude/skills is already a symlink → $(readlink "$SKILLS_DST")"
    echo "Nothing to do."
    exit 0
fi

if [ -d "$SKILLS_DST" ]; then
    echo "~/.claude/skills exists as a directory. Backing up to ~/.claude/skills.bak"
    mv "$SKILLS_DST" "${SKILLS_DST}.bak"
fi

ln -s "$SKILLS_SRC" "$SKILLS_DST"
echo "Linked $SKILLS_DST → $SKILLS_SRC"
