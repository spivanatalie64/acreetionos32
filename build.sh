#!/bin/bash
# AcreetionOS32 — build 32-bit ISO from Arch Linux 32-bit repos
set -e
WORK=$(mktemp -d)
ISO_NAME="AcreetionOS32-$(date +%Y%m%d)-i686.iso"
echo "=== Building $ISO_NAME ==="

# Build in Arch container
docker run --privileged --rm archlinux:latest bash -c "
  pacman -Sy --noconfirm archiso git && \
  git clone https://github.com/AcreetionOS-Code/acreetionos /tmp/src && \
  cd /tmp/src && \
  # Patch for 32-bit
  sed -i 's/x86_64/i686/g' profiledef.sh 2>/dev/null || true && \
  mkarchiso -L ACREETIONOS32 -o /output .
" 2>&1 && cp /tmp/acreetionos32-*.iso /tmp/ISO_NAME 2>/dev/null || true

echo "=== Build complete ==="
ls -lh *.iso 2>/dev/null || echo "No ISO produced"
