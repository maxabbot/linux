# System Layer — Ansible

This layer handles **system-level configuration** — packages, services, kernel parameters, and driver setup — using Ansible playbooks and roles.

## Quick Start

```bash
cd system

# 1. Install Ansible Galaxy dependencies
ansible-galaxy install -r requirements.yml

# 2. Set your profile in inventory/hosts.yml
#    (uncomment home_desktop or work_laptop)

# 3. Run the full playbook
ansible-playbook playbooks/site.yml --ask-become-pass

# Or run a specific layer
ansible-playbook playbooks/base.yml --ask-become-pass
ansible-playbook playbooks/development.yml --ask-become-pass
```

## Directory Structure

```
system/
├── ansible.cfg                 # Ansible configuration
├── requirements.yml            # Galaxy dependencies
├── inventory/
│   └── hosts.yml               # Inventory (localhost)
├── group_vars/
│   ├── all.yml                 # Default variables & feature toggles
│   ├── home_desktop.yml        # Home desktop profile overrides
│   └── work_laptop.yml         # Work laptop profile overrides
├── playbooks/
│   ├── site.yml                # Full system playbook
│   ├── base.yml                # Base packages only
│   ├── development.yml         # Dev tools only
│   ├── productivity.yml        # Productivity apps only
│   ├── nvidia.yml              # NVIDIA drivers only
│   └── gaming.yml              # Gaming packages only
└── roles/
    ├── aur/                    # AUR helper installation
    ├── base/                   # Core system, networking, CLI tools
    ├── development/            # Languages, containers, cloud tools
    ├── productivity/           # Desktop, office, browsers, media
    ├── nvidia/                 # NVIDIA driver stack & CUDA
    └── gaming/                 # Steam, Wine, performance tools
```

## Profiles

Edit `inventory/hosts.yml` to select your profile. Each profile sets different variable overrides in `group_vars/`:

| Profile | File | Roles | Notes |
|---------|------|-------|-------|
| Home Desktop | `home_desktop.yml` | base, dev, prod, nvidia, gaming | RTX 40-series, CUDA enabled |
| Work Laptop | `work_laptop.yml` | base, dev, prod | TLP power management, no gaming |

## Feature Toggles

Override in `group_vars/all.yml` or per-profile:

| Variable | Default | Description |
|----------|---------|-------------|
| `power_management` | `power-profiles-daemon` | `power-profiles-daemon` or `tlp` |
| `enable_docker` | `true` | Install Docker + docker-compose |
| `enable_libvirt` | `false` | Install QEMU/KVM + virt-manager |
| `enable_database_servers` | `false` | PostgreSQL, MariaDB, Redis, SQLite |
| `enable_gui_db_clients` | `false` | DBeaver, pgcli, mycli, litecli |
| `enable_data_platforms` | `false` | Airflow, Spark, DuckDB |
| `enable_cuda_stack` | `false` | CUDA, cuDNN (nvidia role) |
| `enable_creative_suite` | `false` | GIMP, Inkscape, Krita, Kdenlive |
| `enable_streaming_tools` | `false` | Shotcut, RustDesk, AnyDesk |
| `enable_secondary_browsers` | `false` | Brave, Zen Browser |
| `enable_sync_clients` | `false` | Dropbox, Google Drive, MEGA |
| `install_apollo` | `false` | Apollo game launcher |

## Running Specific Tags

```bash
# Only base + development
ansible-playbook playbooks/site.yml --tags base,development --ask-become-pass

# Skip gaming
ansible-playbook playbooks/site.yml --skip-tags gaming --ask-become-pass
```

## Idempotency

All tasks are idempotent — running them multiple times produces the same result. Ansible will skip already-installed packages and already-enabled services.
