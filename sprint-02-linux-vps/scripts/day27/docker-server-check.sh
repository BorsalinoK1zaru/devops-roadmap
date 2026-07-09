#!/usr/bin/env bash

set -euo pipefail

echo "Docker server check"
echo "==================="
echo

echo "1. User:"
whoami
id
groups
echo

echo "2. Docker service:"
systemctl is-active docker
systemctl is-enabled docker
echo

echo "3. Docker version:"
docker version
echo

echo "4. Docker Compose version:"
docker compose version
echo

echo "5. Docker Buildx version:"
docker buildx version
echo

echo "6. Docker containers:"
docker ps -a
echo

echo "7. Docker images:"
docker images
echo

echo "8. Listening ports:"
ss -tulpn
echo

echo "Docker server check finished"
