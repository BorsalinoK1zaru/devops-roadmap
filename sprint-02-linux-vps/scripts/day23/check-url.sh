#!/usr/bin/env bash

set -euo pipefail

URL="${1:-http://127.0.0.1:9000}"

echo "Checking URL: $URL"

if curl -fsS "$URL" > /dev/null; then
  echo "OK: service is reachable"
  exit 0
else
  echo "ERROR: service is not reachable"
  exit 1
fi