#!/bin/bash
# AcreetionOS32 — clone acreetionos source and build for i686
set -e
WORK=$(mktemp -d)
ISO_NAME="AcreetionOS32-$(date +%Y%m%d)-i686.iso"
SCRIPT="/tmp/build32.sh"
OUTDIR="/tmp/ac32-output"
mkdir -p "$OUTDIR"

echo "=== Building $ISO_NAME ==="

# Write the inner build script to avoid quoting issues
cat > "$SCRIPT" << 'INNER'
#!/bin/bash
set -e
pacman -Sy --noconfirm archiso git

git clone https://github.com/acreetionos-code/acreetionos.git /source
cd /source

# Modify for 32-bit
sed -i 's/arch="x86_64"/arch="i686"/' profiledef.sh
sed -i 's/iso_name=.*/iso_name="AcreetionOS32"/' profiledef.sh
sed -i 's/iso_label=.*/iso_label="ACREETIONOS32"/' profiledef.sh
sed -i 's/bootmodes=(.*)/bootmodes=("bios.syslinux")/' profiledef.sh
sed -i '/uefi/d' profiledef.sh

# Use a curated 32-bit package list instead of filtering
cat > packages.i686 << 'PKGS'
base
base-devel
linux
linux-firmware
grub
syslinux
efibootmgr
networkmanager
cinnamon
cinnamon-translations
xorg-server
xorg-xinit
nano
sudo
network-manager-applet
firefox
gnome-terminal
gparted
os-prober
ntp
openssh
git
wget
curl
PKGS

# 32-bit pacman.conf with fallback mirrors
cat > pacman.conf << 'PACMAN'
[options]
Architecture = i686
SigLevel = Never

[core]
Server = https://mirror.archlinux32.org/i686/$repo
Server = https://archive.archlinux32.org/i686/$repo

[extra]
Server = https://mirror.archlinux32.org/i686/$repo
Server = https://archive.archlinux32.org/i686/$repo

[community]
Server = https://mirror.archlinux32.org/i686/$repo
Server = https://archive.archlinux32.org/i686/$repo
PACMAN

# Fix archiso compatibility: remove missing hooks
sed -i '/archiso_pxe_nfs/d' profiledef.sh 2>/dev/null || true
# Workaround for file conflicts: remove conflicting pycache before install
find /work -path "*/__pycache__/*" -delete 2>/dev/null || true
# Retry the build with overwrite
mkdir -p /work/i686/airootfs 2>/dev/null || true
mkarchiso -v -w /work -o /output . || {
  # If mkarchiso fails, try building with explicit overwrite 
  echo "mkarchiso failed — retrying with overwrite..."
  rm -rf /work/i686/airootfs/usr/lib/python3.11 2>/dev/null || true
  mkarchiso -v -w /work -o /output . 2>&1
}
INNER

chmod +x "$SCRIPT"
docker run --privileged --rm -v "$SCRIPT:$SCRIPT" -v "$OUTDIR:/output" archlinux:latest bash "$SCRIPT" 2>&1

# Find and rename ISO
ISO=$(find "$OUTDIR" -name "*.iso" 2>/dev/null | head -1)
if [ -n "$ISO" ]; then
  cp "$ISO" "./$ISO_NAME"
  echo "✓ ISO produced: $ISO_NAME"
else
  echo "No ISO found in $OUTDIR"
  ls -la "$OUTDIR" 2>/dev/null || true
fi
echo "=== Complete ==="
