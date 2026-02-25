#!/usr/bin/env bash
# SessionEnd hook: prefix plan filenames with their last-modified date (YYYY-MM-DD_)

CWD=$(cat - | jq -r '.cwd')
PLANS_DIR="$CWD/.claude/plans"

[[ -d "$PLANS_DIR" ]] || exit 0

for file in "$PLANS_DIR"/*.md; do
  [[ -f "$file" ]] || continue
  basename=$(basename "$file")

  # Skip if already date-prefixed
  [[ "$basename" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}_ ]] && continue

  mdate=$(stat -f "%Sm" -t "%Y-%m-%d" "$file")
  mv "$file" "$PLANS_DIR/${mdate}_${basename}"
done
