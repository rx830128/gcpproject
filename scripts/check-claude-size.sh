#!/usr/bin/env bash
set -euo pipefail

LIMIT=40000
FILE="CLAUDE.md"

if [ ! -f "$FILE" ]; then
  echo "ERROR: $FILE not found" >&2
  exit 1
fi

count=$(wc -c < "$FILE" | tr -d ' ')

if [ "$count" -gt "$LIMIT" ]; then
  echo "ERROR: $FILE is ${count} bytes (> ${LIMIT}). Please trim it." >&2
  echo "Current size: ${count} bytes" >&2
  echo "Size limit:   ${LIMIT} bytes" >&2
  echo "Excess:       $((count - LIMIT)) bytes" >&2
  exit 1
else
  echo "OK: $FILE is ${count} bytes (<= ${LIMIT})."
fi