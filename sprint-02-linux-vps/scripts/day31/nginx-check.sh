#!/usr/bin/env bash

set -euo pipefail

echo "Nginx reverse proxy check"
echo "========================="
echo

echo "1. Nginx service:"
systemctl is-active nginx
systemctl is-enabled nginx
echo

echo "2. Nginx version:"
nginx -v
echo

echo "3. Nginx config test:"
sudo nginx -t
echo

echo "4. Listening ports:"
ss -tulpn | grep -E ':22|:80|:8070|:6379' || true
echo

echo "5. Local proxy healthcheck:"
curl -fsS http://127.0.0.1/health
echo
echo

echo "6. Local proxy redis check:"
curl -fsS http://127.0.0.1/redis-check
echo
echo

echo "7. Nginx logs:"
sudo tail -n 20 /var/log/nginx/devops-app.access.log || true
sudo tail -n 20 /var/log/nginx/devops-app.error.log || true
echo

echo "Nginx check finished"
