# Arch Linux Home Desktop Setup

The home-desktop scripts are now wrappers around the shared modules in `../modules/`. They keep backwards compatibility while encouraging you to run the `profiles/home-desktop.sh` orchestrator for the full experience.

## Recommended path

```bash
chmod +x ../profiles/home-desktop.sh
../profiles/home-desktop.sh
```

The profile chains together:

1. Base system install (defaults to `POWER_MANAGEMENT=power-profiles-daemon`).
2. Development tooling.
3. Productivity/Desktop apps.
4. NVIDIA driver stack.
5. Gaming stack and streaming utilities.

Override behaviour via environment variables (`ENABLE_DOCKER`, `ENABLE_LIBVIRT`, `INSTALL_APOLLO` etc.) before invoking the profile.

## Module wrappers

- `01-base-system.sh` → shared base module tuned for desktops.
- `02-development-tools.sh` → development stack.
- `03-productivity-apps.sh` → productivity & desktop experience.
- `04-nvidia-drivers.sh` → NVIDIA driver stack (Wayland-ready, Coolbits, LTS kernel fallback).
- `05-gaming.sh` → Steam/Proton, auxiliary launchers, streaming and benchmarking tooling.

Run any script individually when you only need to refresh that layer.

## After running

- Reboot once the NVIDIA stack completes so the new initramfs loads.
- Launch Steam, enable Proton for all titles, and install Proton-GE via ProtonUp-Qt.
- Pair Moonlight/Sunshine or Parsec if you rely on game streaming.
- Configure OBS with the new Vulkan capture plugins.
- Adjust fan curves/overclocking in `nvidia-settings` thanks to Coolbits.

## Troubleshooting tips

- `journalctl -b` is invaluable if the display manager fails after driver updates.
- ProtonDB and `PROTON_LOG=1 %command%` help isolate per-title issues.
- `nvtop`, `ferret`, and MangoHud/GOverlay provide quick performance visibility.
- All scripts are idempotent—rerun them if an install fails mid-way.
