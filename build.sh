#!/bin/bash
# AcreetionOS32 — proper Arch Linux 32-bit ISO build
set -e
WORK=$(mktemp -d)
OUTDIR="/tmp/acreetionos32-output"
mkdir -p "$OUTDIR"
ISO_NAME="AcreetionOS32-$(date +%Y%m%d)-i686.iso"

docker run --privileged --rm -v $OUTDIR:/output archlinux:latest bash -c "
  set -e
  pacman -Sy --noconfirm archiso git

  # Create a proper mkarchiso profile directory for i686
  mkdir -p /profile/airootfs/root
  mkdir -p /profile/efiboot
  mkdir -p /profile/syslinux

  # pacman.conf for 32-bit
  cat > /profile/pacman.conf << 'PACMAN'
[options]
Architecture = i686
[core]
Server = https://mirror.archlinux32.org/i686/\$repo
[extra]
Server = https://mirror.archlinux32.org/i686/\$repo
[community]
Server = https://mirror.archlinux32.org/i686/\$repo
PACMAN

  # Package list
  cat > /profile/packages.i686 << 'PKGS'
base
base-devel
linux
linux-firmware
cinnamon
calamares
calamares_config
grub
efibootmgr
networkmanager
xorg-server
xorg-xinit
nano
vim
sudo
PKGS

  # profiledef.sh
  cat > /profile/profiledef.sh << 'PROFILE'
#!/usr/bin/env bash
iso_name='AcreetionOS32'
iso_label='ACREETIONOS32_\$(date +%Y%m)'
iso_publisher='AcreetionOS'
iso_application='AcreetionOS 32-bit Install Media'
iso_version='\$(date +%Y.%m)'
install_dir='arch'
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.grub.esp' 'uefi-x64.grub.eltorito')
arch='i686'
pacman_conf='pacman.conf'
airootfs_image_type='squashfs'
airootfs_image_tool_options=('-comp' 'xz')
PROFILE

  chmod +x /profile/profiledef.sh

  # Build the ISO
  mkarchiso -v -w /work -o /output /profile 2>&1

  echo '=== Build complete ==='
  ls -lh /output/
" 2>&1

echo "Done"