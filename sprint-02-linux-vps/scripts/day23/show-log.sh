#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="${1:-$HOME/server-practice/day23/server.log}"
LINES="${2:-20}"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "ERROR: log file does not exist: $LOG_FILE"
  exit 1
fi

echo "Showing last $LINES lines from: $LOG_FILE"
tail -n "$LINES" "$LOG_FILE"