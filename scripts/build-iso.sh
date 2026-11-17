#!/bin/bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
if [[ "$(id -u)" -ne 0 ]]; then echo "Run with sudo: sudo ./scripts/build-iso.sh" >&2; exit 1; fi
if [[ "$(dpkg --print-architecture)" != "amd64" ]]; then echo "CYBERNEX currently targets amd64 build hosts." >&2; exit 1; fi
for tool in lb debootstrap xorriso mksquashfs; do
  command -v "$tool" >/dev/null 2>&1 || { echo "Missing $tool. Install live-build debootstrap xorriso squashfs-tools." >&2; exit 1; }
done
mkdir -p build
lb clean --purge || true
lb config
echo "Building CYBERNEX; this may take a while..."
lb build
ISO="$(find "$ROOT" -maxdepth 1 -type f \( -name '*.hybrid.iso' -o -name '*.iso' \) -printf '%T@ %p\n' | sort -nr | head -n1 | cut -d' ' -f2-)"
if [[ -z "$ISO" || ! -f "$ISO" ]]; then echo "Build ended but no ISO was found in project root." >&2; exit 1; fi
cp "$ISO" "$ROOT/build/cybernex-0.1-amd64.hybrid.iso"
sha256sum "$ROOT/build/cybernex-0.1-amd64.hybrid.iso" | tee "$ROOT/build/cybernex-0.1-amd64.hybrid.iso.sha256"
ls -lh "$ROOT/build/"*
