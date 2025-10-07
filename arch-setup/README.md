# Arch Setup Automation

This directory turns the checklist in `docs/reference/requirements-checklist.md` into a reproducible Arch Linux bootstrap flow. It contains package lists, installation scripts, and placeholders for dotfiles so you can rebuild a workstation with one repo.

## Layout

```text
arch-setup/
├── aur/                    # AUR helper bootstrap
├── dotfiles/               # Stubs for tracked config files
├── install/                # Ordered install scripts (01–06)
├── packages/               # Pacman/AUR package manifests
└── README.md
```

## Quick start

Run these scripts in order on a fresh Arch install:

```bash
./aur/install-aur.sh                 # optional: installs yay (default) or paru
./install/01-base.sh                 # core utilities, networking, power, printing
./install/02-dev.sh                  # development toolchain & containers
./install/03-productivity.sh         # desktop experience, fonts, Wayland apps
./install/04-gaming.sh               # Steam, Proton, NVIDIA, streaming tools
./install/05-optional.sh             # browsers, media, backup, productivity
./install/06-post-install.sh         # services, dotfiles, audits
```

> Tip: scripts are idempotent—rerunning them is safe thanks to `pacman --needed` and helper checks.

## Environment toggles

Each script supports environment variables so you can fine-tune behaviour without editing files.

| Script | Variable | Default | Purpose |
|--------|----------|---------|---------|
| `01-base.sh` | `POWER_MANAGEMENT` | `power-profiles-daemon` | Switch to `tlp` when targeting laptops. |
|              | `ENABLE_GUFW` | `1` | Install the optional GUFW GUI (`0` to skip). |
| `02-dev.sh` | `ENABLE_DOCKER` | `0` | Enable and start `docker.service`. |
|             | `ENABLE_LIBVIRT` | `0` | Enable `libvirtd.service` for virtualization. |
| `04-gaming.sh` | `INSTALL_APOLLO` | `0` | Append `apollo-bin` to the AUR install list. |
| `06-post-install.sh` | `DOTFILES_METHOD` | `chezmoi` | Alternatives: `bare`, `none`. |
|                     | `DOTFILES_REPO` | *(empty)* | HTTPS/SSH URL for your dotfiles repo. |
|                     | `RUN_SECURITY_AUDIT` | `0` | Run `lynis` when set to `1`. |

Example: enable Docker when running `02-dev.sh`.

```bash
ENABLE_DOCKER=1 ./install/02-dev.sh
```

## Package manifests

The manifests mirror the scripts and make it easy to snapshot or restore packages.

```bash
# Install every repo package listed
sudo pacman -S --needed - < packages/pacman-packages.txt

# Install every AUR package using yay
yay -S --needed - < packages/aur-packages.txt
```

Exporting your current system back into the lists:

```bash
pacman -Qq > packages/pacman-packages.txt
yay -Qq > packages/aur-packages.txt
```

## Dotfiles

Drop tracked configuration inside the folders under `dotfiles/` (e.g. `dotfiles/hyprland/`, `dotfiles/nvim/`). Pair the contents with your dotfiles manager of choice via `DOTFILES_METHOD`/`DOTFILES_REPO`, or delete these folders if you prefer an external dotfiles repository.

## Post-install checklist

`install/06-post-install.sh` enforces service enablement (PipeWire, NetworkManager, reflector timer), optionally applies dotfiles, and reminds you to configure backups, snapshots, and theming. Review the tail of the script after running it for manual follow-up tasks.

## Next steps

- Populate `dotfiles/` with your actual configs and commit them.
- Extend package lists as your workflow evolves.
- Add CI (GitHub Actions) to lint shell scripts or validate package manifests.
- Fork the scripts per host type (desktop vs laptop) using additional environment switches.
