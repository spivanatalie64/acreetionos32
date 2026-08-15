# AcreetionOS 32 Edition

32-bit (i686) Community Edition.

> Self-contained archiso profile. Builds standalone from standard Arch mirrors.

## Build

```bash
git clone https://github.com/spivanatalie64/acreetionos32.git
cd acreetionos32
./build.sh
```

ISO lands in `./ISO/`. CI builds weekly and on push, then publishes a GitHub
release with the ISO asset.

## Layout

| Path | Purpose |
|------|---------|
| `profiledef.sh` | Edition metadata |
| `packages.i686` | Static package list |
| `pacman.conf` | Standard Arch mirrors |
| `airootfs/` | Live-environment overlay (DM, configs) |
| `.github/workflows/` | CI: ISO build + lint + release |

## Community

- **Discord:** AcreetionOS Community Server
- **Issues:** https://github.com/spivanatalie64/acreetionos32/issues
- **Website:** https://acreetionos.org
