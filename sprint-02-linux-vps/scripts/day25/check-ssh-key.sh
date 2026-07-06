#!/usr/bin/env bash

set -euo pipefail

KEY_PATH="${1:-$HOME/.ssh/devops_vps_ed25519}"
PUB_KEY_PATH="${KEY_PATH}.pub"

echo "SSH key check"
echo "Private key: $KEY_PATH"
echo "Public key:  $PUB_KEY_PATH"
echo

if [[ ! -f "$KEY_PATH" ]]; then
  echo "ERROR: private key not found"
  exit 1
fi

if [[ ! -f "$PUB_KEY_PATH" ]]; then
  echo "ERROR: public key not found"
  exit 1
fi

echo "File permissions:"
ls -l "$KEY_PATH" "$PUB_KEY_PATH"

echo
echo "Public key fingerprint:"
ssh-keygen -lf "$PUB_KEY_PATH"

echo
echo "OK: SSH key files exist"