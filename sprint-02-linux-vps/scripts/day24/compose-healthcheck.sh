#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
PROJECT_DIR="$REPO_ROOT/docker/task-02-compose-redis-app"
ENV_FILE="$PROJECT_DIR/.env.dev"

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "ERROR: project directory not found: $PROJECT_DIR"
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: env file not found: $ENV_FILE"
  exit 1
fi

APP_PORT="$(grep -E '^APP_PORT=' "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2-)"
APP_PORT="${APP_PORT:-8070}"

BASE_URL="http://127.0.0.1:$APP_PORT"
FAILURES=0

check_endpoint() {
  local name="$1"
  local url="$2"

  echo
  echo "Checking $name: $url"

  if response="$(curl -fsS "$url")"; then
    echo "OK: $name"
    echo "$response"
  else
    echo "ERROR: $name is not reachable"
    FAILURES=$((FAILURES + 1))
  fi
}

echo "Compose app healthcheck"
echo "Base URL: $BASE_URL"

check_endpoint "health" "$BASE_URL/health"
check_endpoint "config" "$BASE_URL/config"
check_endpoint "redis-check" "$BASE_URL/redis-check"
check_endpoint "counter" "$BASE_URL/counter"

echo
if [[ "$FAILURES" -eq 0 ]]; then
  echo "All checks passed."
  exit 0
else
  echo "Checks failed: $FAILURES"
  exit 1
fi