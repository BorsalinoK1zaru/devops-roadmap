#!/usr/bin/env bash

set -euo pipefail

PORT="${1:-9000}"

echo "Checking port: $PORT"

if ss -tulpn | grep -E ":${PORT}\b" > /dev/null; then
  echo "OK: port $PORT is listening"
  ss -tulpn | grep -E ":${PORT}\b"
  exit 0
else
  echo "ERROR: port $PORT is not listening"
  exit 1
fi