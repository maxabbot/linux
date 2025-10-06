# linux-setup-scripts
Automation for rebuilding Arch Linux workstations with repeatable, modular scripts.

## Repository layout

```text
modules/      # Reusable install modules (base, development, productivity, NVIDIA, gaming)
profiles/     # Orchestrators that chain modules for common hosts
arch-setup/   # Legacy stage-by-stage installer (kept for manual runs)
arch-work-laptop/ & arch-home-desktop/  # Wrappers around the shared modules
what i need.md  # Human-readable checklist of requirements
```

## Quick start

Profiles deliver the fastest path from bare metal to a configured machine:

```bash
git clone https://github.com/maxabbot/linux-setup-scripts.git
cd linux-setup-scripts

# Work laptop (development + productivity)
chmod +x profiles/work-laptop.sh
./profiles/work-laptop.sh

# Home desktop (adds NVIDIA + gaming stack)
chmod +x profiles/home-desktop.sh
./profiles/home-desktop.sh
```

Tweak behaviour via environment variables before running a profile, e.g.

```bash
POWER_MANAGEMENT=tlp ENABLE_LIBVIRT=1 ./profiles/work-laptop.sh
```

## Modules at a glance

- `modules/base.sh` – core system utilities, networking, power management, printing, yay bootstrap.
- `modules/development.sh` – languages, databases, containers, IaC tooling, IDEs, cloud CLIs.
- `modules/productivity.sh` – desktop environment, office suite, communication, media, sync.
- `modules/nvidia.sh` – proprietary driver stack, CUDA/cuDNN, Coolbits, LTS kernel fallback.
- `modules/gaming.sh` – Steam/Proton, auxiliary launchers, controllers, streaming, benchmarking.

Each module is idempotent and safe to rerun.

📦 Maintaining package lists? See [`packages/README.md`](packages/README.md) for duplication hotspots, conflict notes, and suggested opt-in flags.

## Environment switches

Modules respect a handful of environment toggles so you can opt in to heavier stacks only when needed:

| Variable | Default | Effect |
|----------|---------|--------|
| `POWER_MANAGEMENT` | `tlp` (laptops) | Choose `tlp` or `power-profiles-daemon`. Unknown values fall back to `power-profiles-daemon`. |
| `ENABLE_GUFW` | `1` | Install the GUFW firewall UI. Set to `0` for headless systems. |
| `ENABLE_DOCKER` | `0` | Enable Docker service after install. |
| `ENABLE_LIBVIRT` | `0` | Enable libvirtd/KVM. |
| `ENABLE_DATA_PLATFORMS` | `1` | Install Apache Airflow, Spark, and DuckDB. |
| `ENABLE_DATABASE_SERVERS` | `1` | Install PostgreSQL, MariaDB, Redis, and SQLite. |
| `ENABLE_GUI_DB_CLIENTS` | `1` | Install DBeaver, litecli, and CLI DB helpers. |
| `ENABLE_SYNC_CLIENTS` | `1` | Include Syncthing, Nextcloud client, Dropbox, and Google Drive. |
| `ENABLE_CREATIVE_SUITE` | `1` | Install creative apps (GIMP, Krita, Kdenlive, etc.). |
| `ENABLE_STREAMING_TOOLS` | `1` | Install Shotcut, remote desktop helpers, and gaming streaming extras. |
| `ENABLE_SECONDARY_BROWSERS` | `1` | Keep Brave and Zen browser alongside Google Chrome. |
| `ENABLE_CUDA_STACK` | `1` | Install CUDA/cuDNN alongside the NVIDIA driver stack. |
| `INSTALL_APOLLO` | `0` | Include the Apollo streaming client when set to `1`. |

Combine them just like other profiles, e.g.:

```bash
ENABLE_DATA_PLATFORMS=0 ENABLE_STREAMING_TOOLS=0 ./profiles/work-laptop.sh
```

## Legacy installers

`arch-setup/install/*.sh` continue to exist for staged installs or fine-grained usage. They now consume the shared modules internally so there’s a single source of truth for package lists.

## Maintenance helpers

- `bin/sync-packages.sh` – regenerate `arch-setup/packages/*.txt`, lint duplicates, and surface common conflicts. Run this after editing package arrays so the staged manifests stay aligned.

## Contributing

- File an issue or PR with package/content changes.
- Keep additions modular where possible—extend modules or add new profiles.
- Run `shellcheck` (or similar linters) on modified scripts.

## License

[MIT](LICENSE)
