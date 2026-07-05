#!/usr/bin/env bash

set -euo pipefail

URL="${1:-http://127.0.0.1:9000}"
PORT="${2:-9000}"
LOG_FILE="${3:-$HOME/server-practice/day23/server.log}"

echo "Service check started"
echo "URL: $URL"
echo "PORT: $PORT"
echo "LOG_FILE: $LOG_FILE"
echo

echo "1. Checking URL..."
if curl -fsS "$URL" > /dev/null; then
  echo "OK: URL is reachable"
else
  echo "ERROR: URL is not reachable"
fi

echo
echo "2. Checking port..."
if ss -tulpn | grep -E ":${PORT}\b" > /dev/null; then
  echo "OK: port $PORT is listening"
  ss -tulpn | grep -E ":${PORT}\b"
else
  echo "ERROR: port $PORT is not listening"
fi

echo
echo "3. Showing logs..."
if [[ -f "$LOG_FILE" ]]; then
  tail -n 10 "$LOG_FILE"
else
  echo "ERROR: log file does not exist: $LOG_FILE"
fi

echo
echo "Service check finished"