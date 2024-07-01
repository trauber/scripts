#!/usr/bin/bash
# fzfclip.sh - fuzzy find with a filter and pipe it to the clipboard

FILE="$1"
PATTERN="$2"

cat "$1" | fzf --filter="$2" | fzf --disabled | vis-clipboard --copy
