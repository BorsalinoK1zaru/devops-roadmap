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

cd "$PROJECT_DIR"

echo "Compose project status:"
docker compose --env-file "$ENV_FILE" ps

echo
echo "Compose services:"
docker compose --env-file "$ENV_FILE" config --services

echo
echo "Docker containers related to project:"
docker ps --filter "name=task2" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"