#!/usr/bin/env bash

set -euo pipefail

SERVICE="${1:-app}"
TAIL_LINES="${2:-120}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
PROJECT_DIR="$REPO_ROOT/docker/task-02-compose-redis-app"
ENV_FILE="$PROJECT_DIR/.env.server"

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "ERROR: project directory not found: $PROJECT_DIR"
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: env file not found: $ENV_FILE"
  exit 1
fi

cd "$PROJECT_DIR"

echo "Showing logs"
echo "============"
echo "Service: $SERVICE"
echo "Tail: $TAIL_LINES"
echo

docker compose --env-file "$ENV_FILE" logs --tail="$TAIL_LINES" "$SERVICE"
