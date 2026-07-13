#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
PROJECT_DIR="$REPO_ROOT/docker/task-02-compose-redis-app"
ENV_FILE="$PROJECT_DIR/.env.server"
BASE_URL="http://127.0.0.1:8070"

echo "Server deploy"
echo "============="
echo

echo "1. Checking paths..."

if [[ ! -d "$REPO_ROOT/.git" ]]; then
  echo "ERROR: repo root is not a git repository: $REPO_ROOT"
  exit 1
fi

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "ERROR: project directory not found: $PROJECT_DIR"
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: env file not found: $ENV_FILE"
  echo "Create it manually on the server: $ENV_FILE"
  exit 1
fi

echo "OK: paths are valid"
echo

echo "2. Updating repository..."
cd "$REPO_ROOT"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "ERROR: repository has local changes."
  echo "Fix them before deploy:"
  git status --short
  exit 1
fi

git pull --ff-only
echo

echo "3. Validating compose config..."
cd "$PROJECT_DIR"
docker compose --env-file "$ENV_FILE" config > /dev/null
echo "OK: compose config is valid"
echo

echo "4. Building and starting containers..."
docker compose --env-file "$ENV_FILE" up -d --build
echo

echo "5. Compose status:"
docker compose --env-file "$ENV_FILE" ps
echo

echo "6. Healthcheck:"
curl -fsS "$BASE_URL/health"
echo
curl -fsS "$BASE_URL/redis-check"
echo
docker compose --env-file "$ENV_FILE" exec -T redis redis-cli ping
echo

echo "Deploy finished successfully"
