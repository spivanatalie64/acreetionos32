#!/bin/bash
# AcreetionOS32 — clone acreetionos source and build for i686
set -e
WORK=$(mktemp -d)
ISO_NAME="AcreetionOS32-$(date +%Y%m%d)-i686.iso"
echo "=== Building $ISO_NAME ==="

docker run --privileged --rm -v $PWD:/repo archlinux:latest bash -c "
  set -e
  pacman -Sy --noconfirm archiso git

  # Clone the AcreetionOS source
  git clone https://github.com/acreetionos-code/acreetionos.git /source
  cd /source

  # Modify profiledef.sh for 32-bit
  sed -i 's/arch=\"x86_64\"/arch=\"i686\"/' profiledef.sh
  sed -i 's/iso_name=.*/iso_name=\"AcreetionOS32\"/' profiledef.sh
  sed -i 's/iso_label=.*/iso_label=\"ACREETIONOS32\"/' profiledef.sh

  # Create 32-bit package list if needed
  if [ -f packages.x86_64 ]; then
    cp packages.x86_64 packages.i686 || true
  fi
  if [ -f bootstrap_packages.x86_64 ]; then
    cp bootstrap_packages.x86_64 bootstrap_packages.i686 || true
  fi

  # Update pacman.conf for 32-bit
  cat > pacman.conf << 'PACMAN'
[options]
Architecture = i686
[core]
Server = https://mirror.archlinux32.org/i686/\$repo
[extra]
Server = https://mirror.archlinux32.org/i686/\$repo
[community]
Server = https://mirror.archlinux32.org/i686/\$repo
PACMAN

  # Build
  mkarchiso -v -w /work -o /output . 2>&1
" 2>&1

# Move ISO
mv /output/*.iso . 2>/dev/null || true
echo "=== Complete ==="
ls -lh *.iso 2>/dev/null || echo "No ISO produced"
