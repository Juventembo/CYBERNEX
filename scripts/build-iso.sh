#!/bin/bash
# Build the CYBERNEX live ISO. Run as root on an amd64 Debian 13 host
# (or in a debian:trixie container). Does not require sudo when already root.
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run as root: sudo ./scripts/build-iso.sh" >&2
  exit 1
fi
if [[ "$(dpkg --print-architecture)" != "amd64" ]]; then
  echo "CYBERNEX currently targets amd64 build hosts." >&2
  exit 1
fi
for tool in lb debootstrap xorriso mksquashfs; do
  command -v "$tool" >/dev/null 2>&1 || {
    echo "Missing $tool. Install live-build debootstrap xorriso squashfs-tools." >&2
    exit 1
  }
done

# Uploading via the GitHub web UI drops executable bits; live-build silently
# ignores a non-executable auto/config and would build the wrong distribution.
chmod +x auto/* scripts/*.sh

mkdir -p build
echo "live-build version: $(lb --version 2>&1 || true)"
lb clean --purge || true
lb config

# Fail early if the config did not pick up Trixie.
grep -Eqs 'LB_DISTRIBUTION[A-Z_]*="?trixie' config/bootstrap config/common config/chroot \
  || { echo "auto/config was not applied (distribution is not trixie)." >&2; exit 1; }

echo "Building CYBERNEX; this may take a while..."
lb build 2>&1 | tee build/build.log

ISO="$(find "$ROOT" -maxdepth 1 -type f -name '*.iso' -printf '%T@ %p\n' | sort -nr | head -n1 | cut -d' ' -f2-)"
if [[ -z "$ISO" || ! -f "$ISO" ]]; then
  echo "Build ended but no ISO was found in project root." >&2
  exit 1
fi
cp "$ISO" "$ROOT/build/cybernex-0.1-amd64.hybrid.iso"
( cd "$ROOT/build" && sha256sum cybernex-0.1-amd64.hybrid.iso | tee cybernex-0.1-amd64.hybrid.iso.sha256 )
ls -lh "$ROOT/build/"
