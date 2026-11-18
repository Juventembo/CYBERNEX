#!/bin/sh
set -eu
echo "CYBERNEX build host check"
echo "Architecture: $(dpkg --print-architecture 2>/dev/null || uname -m)"
echo "Kernel: $(uname -r)"
[ -r /etc/os-release ] && . /etc/os-release && echo "OS: ${PRETTY_NAME:-unknown}"
echo "Available memory:"
free -h 2>/dev/null || true
echo "Available disk space:"
df -h .
for tool in lb debootstrap xorriso mksquashfs; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf 'OK   %s: %s\n' "$tool" "$(command -v "$tool")"
  else
    printf 'MISS %s\n' "$tool"
  fi
done
if command -v lb >/dev/null 2>&1; then
  echo "live-build: $(lb --version 2>&1 || true)"
  echo "Note: Trixie images need Debian's live-build (2023+), not Ubuntu's 3.0~a57."
fi
