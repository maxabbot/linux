# Host Profiles

Profiles stitch together the reusable module scripts under `../modules/` to recreate common workstation roles. Each profile is just a thin orchestrator that sets a few defaults and runs the shared installers.

## Available profiles

| Profile | Description | Runs |
|---------|-------------|------|
| `work-laptop.sh` | Data/software engineering laptop with strong productivity defaults. | Base → Development → Productivity |
| `home-desktop.sh` | Desktop with NVIDIA RTX graphics and gaming stack. | Base → Development → Productivity → NVIDIA → Gaming |

## Usage

Run profiles from the repository root.

```bash
chmod +x profiles/*.sh

# Work laptop
./profiles/work-laptop.sh

# Home desktop
./profiles/home-desktop.sh
```

### Environment tweaks

Profiles respect the same environment switches exposed by the modules:

| Variable | Purpose |
|----------|---------|
| `POWER_MANAGEMENT` | `tlp` for laptops or `power-profiles-daemon` for desktops. |
| `ENABLE_GUFW` | `1` installs the GUFW firewall UI, `0` skips it. |
| `ENABLE_DOCKER` | `1` enables and starts Docker after install. |
| `ENABLE_LIBVIRT` | `1` enables libvirtd/KVM services. |
| `ENABLE_DATA_PLATFORMS` | Toggle heavyweight data platforms (Airflow, Spark, DuckDB). |
| `ENABLE_DATABASE_SERVERS` | Install or skip PostgreSQL, MariaDB, Redis, and SQLite. |
| `ENABLE_GUI_DB_CLIENTS` | Control DBeaver, litecli, and other DB clients. |
| `ENABLE_SYNC_CLIENTS` | Gate Syncthing, Nextcloud, Dropbox, and Google Drive helpers. |
| `ENABLE_CREATIVE_SUITE` | Install creative tooling (GIMP, Krita, Kdenlive, etc.). |
| `ENABLE_STREAMING_TOOLS` | Install streaming/remote desktop extras such as Shotcut and RustDesk. |
| `ENABLE_SECONDARY_BROWSERS` | Keep or drop Brave/Zen alongside Google Chrome. |
| `ENABLE_CUDA_STACK` | Install CUDA/cuDNN in the NVIDIA stack when set to `1`. |
| `INSTALL_APOLLO` | Include the Apollo streaming client in the gaming stack. |

Example:

```bash
POWER_MANAGEMENT=tlp ENABLE_LIBVIRT=1 ./profiles/work-laptop.sh
```

## Customising

1. Edit the module files in `modules/` to add or remove packages.
2. Create additional profiles (copy an existing one) and choose which modules to call.
3. Extend modules with more environment switches if you need host-specific behaviour.
