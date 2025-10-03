# Arch Linux Home Desktop Setup

This folder extends the `arch-work-laptop` automation with home-desktop extras for dedicated GPUs, gaming, and streaming.

## Prerequisites

- Fresh Arch Linux installation
- Internet connection
- User account with sudo privileges
- NVIDIA RTX 4070 (or similar) GPU

## Relationship to `arch-work-laptop`

- Scripts `01`–`03` are thin wrappers that execute their counterparts in `../arch-work-laptop`.
- Run the laptop scripts first to provision the shared base, development, and productivity tooling.
- Home-desktop scripts focus on GPU drivers, gaming packages, and streaming utilities layered on top of the shared baseline.

## Scripts overview

### Shared wrappers (01–03)

- `01-base-system.sh` → calls `../arch-work-laptop/01-base-system.sh`.
- `02-development-tools.sh` → calls `../arch-work-laptop/02-development-tools.sh`.
- `03-productivity-apps.sh` → calls `../arch-work-laptop/03-productivity-apps.sh`.

### Desktop-only scripts

- `04-nvidia-drivers.sh` — installs proprietary NVIDIA drivers, CUDA/cuDNN, Vulkan/OpenCL support, monitoring tools, and enables DRM modesetting.
- `05-gaming.sh` — installs Steam, Proton helpers, Lutris, Heroic, Apollo/Moonlight, GameMode, Gamescope, MangoHud, and other gaming utilities.

## Usage

Run the shared scripts first, then the desktop extras:

```bash
# Shared baseline
pushd ../arch-work-laptop
chmod +x *.sh
./01-base-system.sh
./02-development-tools.sh
./03-productivity-apps.sh
popd

# Desktop enhancements
chmod +x *.sh
./04-nvidia-drivers.sh
./05-gaming.sh
```

## Important notes

### NVIDIA driver installation

- Reboot after running `04-nvidia-drivers.sh`.
- The script configures kernel parameters and initramfs for smooth Wayland support (`nvidia-drm.modeset=1`).
- NVIDIA persistence daemon and monitoring utilities (e.g., `nvtop`) are installed.

### Gaming setup notes

- Multilib repository is enabled automatically for 32-bit compatibility.
- Enable Steam Play (Proton) for all titles in Steam settings.
- Use ProtonUp-Qt to install Proton-GE builds.
- Add `mangohud %command%` to Steam launch options to display the overlay.

### Apollo streaming (Moonlight)

- Moonlight-Qt requires a host PC running GeForce Experience or the Sunshine server.
- Pair the client with the host and adjust bitrate/resolution to match your network.

## Post-installation

### Development setup

Follow the post-install checklist in `../arch-work-laptop/README.md` (Git config, SSH keys, IDE personalization, database credentials).

### Gaming setup

1. Launch Steam and sign in.
2. Enable Proton for all titles and install a Proton-GE build via ProtonUp-Qt.
3. Configure Moonlight-Qt or Apollo to connect to your host machine.
4. Tune MangoHud through GOverlay and add it to launch options.
5. Verify controller mappings in Steam → Settings → Controller.

### NVIDIA configuration

1. Run `nvidia-settings` to configure displays, G-SYNC, and power management.
2. Monitor GPU usage with `nvtop` or `nvidia-smi`.
3. Re-run the driver script if a kernel update breaks the DKMS module.

## Performance tips

- Use GameMode for automatic CPU governor and I/O tuning.
- Gamescope offers upscaling, frame limiting, and HDR toggles.
- Close unnecessary background applications before gaming sessions.
- Persist favorite MangoHud profiles to `~/.config/MangoHud/MangoHud.conf`.

## Troubleshooting

### NVIDIA issues

- Check `lsmod | grep nvidia` to ensure modules are loaded.
- Review `journalctl -b -1` after a failed boot for driver errors.
- If the display manager fails, boot into a TTY and rerun the driver script.

### Gaming issues

- Consult [ProtonDB](https://www.protondb.com/) for per-title tweaks.
- Test alternative Proton versions (GE, Experimental) when games fail to launch.
- Use `PROTON_LOG=1 %command%` in Steam launch options to capture logs.

### General issues

- Verify network connectivity and disk space before rerunning scripts.
- Some AUR packages may require manual intervention; follow the build output.
- Reference the Arch Wiki for package-specific guidance.

## Resources

- [Arch Wiki – NVIDIA](https://wiki.archlinux.org/title/NVIDIA)
- [Arch Wiki – Steam](https://wiki.archlinux.org/title/Steam)
- [ProtonDB](https://www.protondb.com/)
- [Moonlight Documentation](https://moonlight-stream.org/)
- [MangoHud](https://github.com/flightlessmango/MangoHud)
