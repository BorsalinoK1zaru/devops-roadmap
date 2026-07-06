#!/usr/bin/env bash

set -euo pipefail

echo "Server baseline check"
echo "====================="
echo

echo "1. User:"
whoami
id
groups
echo

echo "2. Host:"
hostname
uname -a
echo

echo "3. OS:"
if [[ -f /etc/os-release ]]; then
  cat /etc/os-release
else
  echo "ERROR: /etc/os-release not found"
fi
echo

echo "4. Current directory:"
pwd
echo

echo "5. Disk:"
df -h
echo

echo "6. Memory:"
free -h
echo

echo "7. Listening ports:"
ss -tulpn || true
echo

echo "8. Internet check:"
if curl -fsS https://example.com > /dev/null; then
  echo "OK: internet connection works"
else
  echo "ERROR: internet connection failed"
fi
echo

echo "9. Sudo check:"
if sudo -n true 2>/dev/null; then
  echo "OK: sudo is available without password prompt right now"
else
  echo "INFO: sudo may require password or is not available"
fi

echo
echo "Baseline check finished"
