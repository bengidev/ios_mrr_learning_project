#!/bin/sh

set -eu

REPO_ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
CONFIG_PATH="$REPO_ROOT/uncrustify.cfg"

if ! command -v uncrustify >/dev/null 2>&1; then
  echo "uncrustify is not installed. Install it with: brew install uncrustify" >&2
  exit 1
fi

find "$REPO_ROOT/MRR Project" "$REPO_ROOT/MRR ProjectTests" \
  \( -name '*.h' -o -name '*.m' \) -print0 |
  while IFS= read -r -d '' file_path; do
    uncrustify -c "$CONFIG_PATH" --replace --no-backup "$file_path"
  done

echo "Objective-C formatting completed."
