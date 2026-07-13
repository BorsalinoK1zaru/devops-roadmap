#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
PROJECT_DIR="$REPO_ROOT/docker/task-02-compose-redis-app"
ENV_FILE="$PROJECT_DIR/.env.server"
BASE_URL="http://127.0.0.1:8070"

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "ERROR: project directory not found: $PROJECT_DIR"
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: env file not found: $ENV_FILE"
  exit 1
fi

cd "$PROJECT_DIR"

echo "Server healthcheck"
echo "=================="
echo

echo "1. Compose services:"
docker compose --env-file "$ENV_FILE" ps
echo

echo "2. /health:"
curl -fsS "$BASE_URL/health"
echo
echo

echo "3. /config:"
curl -fsS "$BASE_URL/config"
echo
echo

echo "4. /redis-check:"
curl -fsS "$BASE_URL/redis-check"
echo
echo

echo "5. /counter:"
curl -fsS "$BASE_URL/counter"
echo
echo

echo "6. Redis ping:"
docker compose --env-file "$ENV_FILE" exec -T redis redis-cli ping
echo

echo "Healthcheck finished successfully"
