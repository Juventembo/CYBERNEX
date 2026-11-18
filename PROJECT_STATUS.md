# CYBERNEX project backup — status snapshot

Snapshot date: 2026-11-18
Repository: https://github.com/Juventembo/CYBERNEX
Local working directory used by the developer: `~/CYBERNEX/CYBERNEX`

## Project goal

CYBERNEX is a lightweight, Windows-inspired Debian 13 (Trixie) amd64 live desktop using XFCE. The target test machine is an older Intel Core 2 system with 4 GB RAM. The ISO is intended to be built on GitHub Actions so the target machine does not need to compile it.

## Included in this archive

- Debian Live `auto/config` with Trixie, amd64, systemd, hybrid ISO and non-free firmware components.
- XFCE desktop defaults, CYBERNEX wallpaper and OS identity files.
- Package list with compatibility edits made during build troubleshooting.
- Debian security APT source for `trixie-security`.
- GitHub Actions build workflow and shell build/check scripts.
- README, MIT license and this status note.

## Build status

**No successful ISO build has been confirmed yet.**

Root cause of the `lb_binary_syslinux` failure (`/root/isolinux/isolinux.bin`, `vesamenu.c32`): the `ubuntu-24.04` runner installs Ubuntu's `live-build 3.0~a57-1ubuntu49`, an old fork that copies Syslinux files from `/root/isolinux` inside the chroot and cannot build Debian Trixie images.

Fix applied (untested on a real runner): the workflow now builds in a privileged `debian:trixie` container with Debian's live-build. Other fixes: `auto/config` now sets bootloaders (`syslinux,grub-efi`), no debian-installer, ISO name/volume; `build-iso.sh` restores exec bits (lost on GitHub web upload), verifies Trixie was applied, logs to `build/build.log`; the `/etc/issue` and `check-build-host.sh` escape bugs; the hard-coded 1920x1080 panel position; `.gitignore` entries; and `lightdm-gtk-greeter`/`xserver-xorg`/`dbus-x11` added to the package list.

## Important next steps

1. Push these changes and re-run **Build CYBERNEX ISO**; if it fails, download the `cybernex-build-log` artifact.
2. Download the ISO artifact and verify its SHA-256 checksum.
3. Boot-test in a VM in both legacy BIOS and UEFI modes.
4. Test on the Core 2 target hardware before installation (note: many Core 2 machines are BIOS-only, and some early ones have 32-bit-only UEFI).

## Backup guidance

Keep this ZIP as a source snapshot. Also keep a copy of the GitHub repository and any future successful ISO plus its `.sha256` checksum. The build workflow's uploaded artifact retention is currently configured for 14 days, so download artifacts promptly after a successful run.

## Safety

Use network scanning and assessment tools only on systems and networks you own or have explicit permission to test.
