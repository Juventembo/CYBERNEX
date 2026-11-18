# CYBERNEX 0.1

**A lightweight, Windows-inspired Debian 13 live desktop for older PCs.**

This is the initial CYBERNEX source project, created from scratch. It is a build configuration and source tree, **not a prebuilt ISO**. The first target is `amd64` (64-bit Intel/AMD), with XFCE and a familiar bottom-panel desktop.

## Design

- Debian 13 (Trixie), amd64
- XFCE desktop, Whisker application menu, task list, system tray and clock
- Dark blue CYBERNEX branding, readable fonts and familiar desktop layout
- NetworkManager and common firmware packages
- Carefully selected system, disk and authorized network-assessment utilities
- Debian Live hybrid ISO output, intended to support legacy BIOS and UEFI boot
- Cloud build workflow so the older 4 GB machine does not have to compile the ISO

## Build the ISO in the cloud (recommended)

The included GitHub Actions workflow runs on a hosted Ubuntu runner but builds inside a `debian:trixie` container, so it uses Debian's modern `live-build`.

1. Create an empty repository on GitHub.
2. Upload the contents of this folder to the repository root (the `.github` folder must be included).
3. Open **Actions** and enable workflows if prompted.
4. Choose **Build CYBERNEX ISO** and click **Run workflow**.
5. When it completes, download the `cybernex-iso` artifact. It contains the ISO and SHA-256 checksum.

The hosted runner's time, storage and package availability are subject to GitHub's current limits. The workflow is configured for manual runs and source changes on `main`.

## Build locally (Debian/Ubuntu amd64)

A local build needs substantial temporary disk space and RAM. On the target 4 GB PC, use the cloud workflow instead.

```bash
# On Debian 13 (or a debian:trixie container). Ubuntu's live-build is too old.
sudo apt update
sudo apt install -y live-build debootstrap xorriso squashfs-tools isolinux syslinux-common grub-pc-bin grub-efi-amd64-bin mtools dosfstools
sudo ./scripts/build-iso.sh
```

The resulting ISO, checksum and `build.log` are copied to `build/`.

## Test safely

1. Verify the SHA-256 checksum.
2. Test in a virtual machine before using physical hardware.
3. Boot the target computer from USB and choose the live/try option first.
4. Check display, keyboard, mouse, Ethernet/Wi-Fi, audio, USB and shutdown.
5. Back up personal data before considering any installation.

**Important:** this first milestone creates a live system. It is not yet a validated installed-OS experience or a guarantee that every Core 2-era graphics, Wi-Fi or BIOS implementation will work. Hardware testing is required before calling it stable. Some wireless devices need firmware not included in the image.

## Project structure

```text
CYBERNEX/
├── .github/workflows/build-iso.yml
├── auto/config
├── config/package-lists/cybernex.list.chroot
├── config/includes.chroot/       # desktop defaults, branding, OS identity and APT sources
├── scripts/                      # build and host checks
├── .gitignore
└── README.md
```

## Security and licensing

Use scanning and assessment tools only on systems and networks you own or have explicit permission to test. The project configuration and original CYBERNEX artwork are released under the MIT License. Debian packages retain their own licenses and notices.

## Next milestones

1. Build the first ISO in CI.
2. Fix any package/build issues from the actual build log.
3. Boot-test in a VM and on the Core 2 target.
4. Tune memory use, boot time, drivers and desktop usability from measured results.
5. Add an installer workflow only after the live system is verified.

## Installing to disk

Boot the live ISO and double-click **Install** on the desktop (Calamares). Test in a VM first; the installer is new and untested.
