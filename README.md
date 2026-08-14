# AcreetionOS 32-bit Edition

AcreetionOS for i686 hardware. Keep old machines alive.

> A self-contained [AcreetionOS](https://acreetionos.org) community edition.
> Builds standalone from standard Arch Linux mirrors — no custom repos required.

## Features

- i686 (32-bit) support
- archlinux32 repositories
- Cinnamon desktop
- Lightweight by nature

## Build

Requirements: `archiso` (or Docker/Podman with an `archlinux:latest` image).

```bash
git clone https://github.com/spivanatalie64/acreetionos32.git
cd acreetionos-32
./build.sh
```

The ISO lands in `../ISO/`. Checksums are generated alongside.

## Layout

| Path | Purpose |
|------|---------|
| `profiledef.sh` | Edition metadata (name, label, arch, boot modes) |
| `packages.x86_64` | Static package list (verified against Arch repos) |
| `pacman.conf` | Standard Arch mirrors (legacy custom repos commented) |
| `airootfs/` | Live-environment overlay (DMs, configs, wallpapers) |
| `grub/` `syslinux/` `efiboot/` | Bootloader configs |
| `.github/workflows/` | CI: weekly ISO build + linting |

## Community

- **Discord:** AcreetionOS Community Server
- **Issues:** https://github.com/spivanatalie64/acreetionos32/issues
- **Website:** https://acreetionos.org

Licensed under [GPL-3.0](LICENSE).
