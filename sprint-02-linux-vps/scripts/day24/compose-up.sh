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
  echo "Create it from .env.dev.example if needed."
  exit 1
fi

echo "Starting Compose project..."
echo "Project: $PROJECT_DIR"
echo "Env file: $ENV_FILE"

cd "$PROJECT_DIR"

docker compose --env-file "$ENV_FILE" up -d --build

echo
echo "Current status:"
docker compose --env-file "$ENV_FILE" ps