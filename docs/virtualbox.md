# Running `linux-setup-scripts` inside a VirtualBox VM

This guide walks through building an Arch Linux virtual machine with VirtualBox and applying the repository profiles/modules to configure it. It assumes you are starting from a typical desktop host (Windows, macOS, or Linux) with VirtualBox installed.

## 0. Prerequisites

- **VirtualBox 7.x** (or newer) plus the Extension Pack for USB 3.0 and NVMe support.
- **Arch Linux ISO** – download the latest `archlinux-YYYY.MM.DD-x86_64.iso` from <https://archlinux.org/download/> and verify the SHA256 checksum.
- **Minimum hardware** for a smooth experience:
  - 2 vCPUs, 4 GiB RAM (8 GiB recommended if you plan to run heavy development tooling).
  - 40 GiB virtual disk (dynamic VDI works fine).
  - Reliable broadband access inside the VM (NAT networking is sufficient; bridged mode is optional).
- Basic familiarity with VirtualBox VM creation and the Arch installer (`archinstall` or manual steps).

> ℹ️ The scripts expect to run on an installed Arch system (not the live ISO). The high-level flow is:
>
> 1. Create and install Arch in the VM.
> 2. Boot into the new system.
> 3. Clone this repository and run a profile (e.g., `profiles/work-laptop.sh`).

## 1. Create the VirtualBox VM

1. Launch VirtualBox → **New**.
2. Name it something like `arch-linux-setup` and set **Type** = Linux, **Version** = Arch Linux (64-bit).
3. Allocate resources:
   - Memory: 4096 MB minimum (8192 MB preferred).
   - CPUs: 2 or more (enable “Enable PAE/NX”).
4. Create a virtual hard disk:
   - VDI (dynamically allocated) → 40 GB or larger.
5. Open **Settings → System**:
   - Motherboard: enable **EFI** (this repo assumes UEFI).
   - Processor: enable **I/O APIC** and **Nested VT-x/AMD-V** if available.
6. **Display → Screen**: set video memory to 128 MB; optionally enable 3D acceleration.
7. **Storage**: attach the Arch ISO to the optical drive. Keep the VDI as SATA (or switch to NVMe if the Extension Pack is installed).
8. **Network**: NAT works out of the box. Use bridged adapter if you need the VM to be on the same LAN.
9. Optional: enable shared clipboard/drag-and-drop for convenience.

### Advanced: install to a real disk partition

If you prefer the VM to live on a real disk partition instead of a virtual disk file, VirtualBox can expose host partitions as a **raw-disk** VMDK. This is powerful but risky—corrupting the partition will damage the underlying drive. Double-check every disk identifier before you run these commands.

1. Create two partitions on the host disk using Disk Management (Windows) or `gparted`/`parted` (Linux/macOS host):
   - **EFI partition** ~512 MiB (will be formatted as FAT32 inside the VM).
   - **Root partition** (ext4) sized for Arch.
   Do **not** assign drive letters or mount points; the Arch installer will format both partitions.
2. Take the disk **offline** on the host so the OS won’t auto-mount it while VirtualBox is using it:

   ```powershell
   # Run PowerShell as Administrator
   Get-Disk
   # Identify the disk number, then:
   diskpart
   select disk <DISK_NUMBER>
   offline disk
   exit
   ```

3. Generate a raw VMDK that maps to the partitions. Adjust the `-partitions` flag to match your EFI/root numbers (on Windows, partition numbers usually start at 1):

   ```powershell
   cd "C:\Program Files\Oracle\VirtualBox"
    .\VBoxManage.exe internalcommands createrawvmdk `
       -filename "C:\VirtualBox\arch-raw.vmdk" `
       -rawdisk \\.\PhysicalDrive<DISK_NUMBER> `
       -partitions <EFI_PARTITION>,<ROOT_PARTITION>
   ```

   - The command creates `arch-raw.vmdk` acting as a shim that VirtualBox can attach.
   - Ensure the output directory (e.g., `C:\VirtualBox\`) exists and is writable by your user.
4. Give your user account read/write permission to the generated VMDK so VirtualBox can access it without elevation:

   ```powershell
   icacls "C:\VirtualBox\arch-raw.vmdk" /grant %USERNAME%:F
   ```

5. Edit the VM’s storage controller and **Add → Existing Disk…**, then pick `arch-raw.vmdk`. You can remove the placeholder VDI created earlier if you no longer need it.
6. Always launch VirtualBox with administrative privileges when using raw disks on Windows. Remember to keep the host disk offline while the VM is using it; bring it back online when you’re done:

   ```powershell
   diskpart
   select disk <DISK_NUMBER>
   online disk
   exit
   ```

From here the Arch installation steps are identical to the virtual-disk workflow. When partitioning inside the installer, select the mapped EFI and root partitions that correspond to your raw disk.

## 2. Install Arch Linux in the VM

Boot the VM; it should load the Arch installer.

You can use either the guided `archinstall` or a manual install. A fast guided approach:

1. Log in as `root` on the live ISO.
2. Run `archinstall` and choose:
   - **Language**: your preference.
   - **Keyboard**: (default `us` if unsure).
   - **Mirror region**: pick a nearby region.
   - **Disk configuration**: use your 40 GB VDI, wipe disk, create a single ext4 root partition with 512 MB EFI (default template works).
   - **Bootloader**: `systemd-boot` (simple and works with EFI).
   - **Profile**: `minimal`.
   - **Hostname**: e.g., `arch-vbox`.
   - **User**: create a normal user with sudo privileges.
   - **Packages**: add `git`, `base-devel`, and `virtualbox-guest-utils` now to save steps later.
   - **Network**: `NetworkManager`.
   - **Timezone/locale**: select your options.
   - **Run`install`**.
3. When `archinstall` finishes, choose **No** for chroot shell (optional), then reboot.
4. Detach the ISO when prompted (Devices → Optical Drives → Remove disk from virtual drive) before the VM boots again.

Manual installation steps are fine too (pacstrap, genfstab, etc.), but ensure you include `NetworkManager`, `sudo`, and `virtualbox-guest-utils` so the profiles can run smoothly.

## 3. First boot tasks

After the VM boots into your new Arch install and you’ve logged in as the user you created:

```bash
sudo pacman -Syu
# If not already present, install dependencies
sudo pacman -S --needed git base-devel virtualbox-guest-utils

# Enable VirtualBox guest integration (mouse, clipboard, dynamic resolution)
sudo systemctl enable --now vboxservice.service
```

If you skipped adding your user to the `wheel` group during installation, do it now:

```bash
sudo usermod -aG wheel "$USER"
```

Log out and back in to apply group changes.

## 4. Clone the repository inside the VM

```bash
cd ~
mkdir -p projects && cd projects
git clone https://github.com/maxabbot/linux-setup-scripts.git
cd linux-setup-scripts
```

Run the automated test suite (optional but recommended):

```bash
bats tests
```

If `bats` is missing, install it with `sudo pacman -S bats` first.

## 5. Run a profile (recommended path)

Profiles orchestrate the shared modules and are the quickest way to configure the VM.

```bash
chmod +x profiles/work-laptop.sh
# Optional: tweak environment defaults before running
POWER_MANAGEMENT=power-profiles-daemon ENABLE_DATA_PLATFORMS=0 ./profiles/work-laptop.sh
```

Available profiles:

- `profiles/work-laptop.sh` – base + development + productivity stacks (good for VM use).
- `profiles/home-desktop.sh` – includes NVIDIA + gaming modules (overkill inside VirtualBox, but safe if you want the tooling).

### Environment toggle tips

VirtualBox rarely benefits from GPU or heavy data-stack tooling. Consider disabling resource-heavy bundles:

```bash
ENABLE_DATA_PLATFORMS=0 ENABLE_DATABASE_SERVERS=0 ENABLE_STREAMING_TOOLS=0 ./profiles/work-laptop.sh
```

All toggles are documented in [README](../README.md#environment-switches).

## 6. Optional: staged installers

If you prefer smaller steps, the legacy staged scripts under `arch-setup/install/` still work:

```bash
cd ~/projects/linux-setup-scripts/arch-setup/install
sudo ./01-base.sh
sudo ./02-dev.sh
sudo ./03-productivity.sh
# ...and so on
```

These share the same module implementations, so mixing them with profiles is safe.

## 7. Snapshot and iterate

After the profile completes:

1. Shut down the VM (`sudo poweroff`).
2. In VirtualBox, **Machine → Take Snapshot** (e.g., "Post-work-laptop profile").
3. Revert to this snapshot whenever you want a clean starting point, or clone the VM for experiments.

## 8. Troubleshooting

| Issue | Fix |
|-------|-----|
| VM boots back to ISO | Detach ISO (Devices → Optical Drives → Remove disk) and ensure the virtual disk is first in boot order. |
| No network after install | `sudo systemctl enable --now NetworkManager` and verify adapter is set to NAT/Bridged in VM settings. |
| Clipboard / screen resize not working | Confirm `virtualbox-guest-utils` is installed and `vboxservice.service` is running. Reboot the VM. |
| `shellcheck` missing during linting | Install it via `sudo pacman -S shellcheck` before running lint commands inside the VM. |
| `bats` missing | `sudo pacman -S bats`. |
| Running gaming/NVIDIA modules | VirtualBox doesn’t expose a real NVIDIA GPU; set `ENABLE_CUDA_STACK=0` to skip heavy CUDA installs inside the VM. |

## 9. Copy the VM to a USB drive

Once you have a golden VM image, you can back it up or share it by writing it directly to a mounted USB drive. The repository ships with a helper script that supports two workflows:

```bash
# Export the powered-off VM to an OVA appliance on the USB drive
bin/copy-vm-to-usb.sh --vm-name arch-vbox --usb-path /run/media/$USER/BACKUP

# Mirror the VM directory structure onto the USB drive (rsync-based copy)
bin/copy-vm-to-usb.sh --mode mirror --vm-name arch-vbox --usb-path /run/media/$USER/BACKUP
```

Key behavior:

- Default mode exports the VM via `VBoxManage export`, producing an `.ova` archive in the target directory. Add `--include-manifest` to generate VirtualBox checksums.
- `--mode mirror` copies the VM directory (by default `~/VirtualBox VMs/<name>`) using `rsync`. Provide `--vm-path` if the VM lives elsewhere.
- The script verifies free space (when it can estimate VM size), ensures the VM is powered off before exporting, and writes to a temporary `.partial` path before swapping it into place. Use `--force` to overwrite an existing export.

## 10. Next steps

- Review `.github/workflows/ci.yml` to replicate the CI jobs locally if desired.
- Use `bin/sync-packages.sh` to regenerate package manifests after tweaking module arrays.
- Consider exporting the VM (`File → Export Appliance`) once it’s configured so you can share or archive a baseline image.

With these steps, you can exercise `linux-setup-scripts` end-to-end in a disposable VirtualBox environment before applying the same profiles to real hardware.
