#!/bin/sh
set -eu
echo "CYBERNEX build host check"
echo "Architecture: $(dpkg --print-architecture 2>/dev/null || uname -m)"
echo "Kernel: $(uname -r)"
echo "Available memory:"
free -h 2>/dev/null || true
echo "Available disk space:"
df -h .
for tool in lb debootstrap xorriso mksquashfs; do
  if command -v "$tool" >/dev/null 2>&1; then printf 'OK   %s: ' "$tool"; command -v "$tool"; else printf 'MISS %s\\n' "$tool"; fi
done
