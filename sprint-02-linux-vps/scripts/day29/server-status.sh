#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
PROJECT_DIR="$REPO_ROOT/docker/task-02-compose-redis-app"
ENV_FILE="$PROJECT_DIR/.env.server"

echo "Server project status"
echo "====================="
echo

echo "1. User:"
whoami
id
groups
echo

echo "2. Host:"
hostname
echo

echo "3. Project directory:"
echo "$PROJECT_DIR"
echo

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "ERROR: project directory not found: $PROJECT_DIR"
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: env file not found: $ENV_FILE"
  exit 1
fi

cd "$PROJECT_DIR"

echo "4. Git status:"
cd "$REPO_ROOT"
git status --short
git log --oneline -3
echo

echo "5. Docker Compose services:"
cd "$PROJECT_DIR"
docker compose --env-file "$ENV_FILE" ps
echo

echo "6. Docker containers:"
docker ps
echo

echo "7. Listening ports:"
ss -tulpn | grep -E ':22|:8070|:6379' || true
echo

echo "8. Firewall:"
sudo ufw status verbose
echo

echo "Status check finished"
