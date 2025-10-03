# Arch Linux Work Laptop Setup

This folder contains scripts for provisioning a data/software engineering workstation on Arch Linux.

## Prerequisites

- Fresh Arch Linux installation
- Internet connection
- User account with sudo privileges

## Scripts overview

- `01-base-system.sh` — installs essential utilities, networking tools, and bootstraps the `yay` AUR helper.
- `02-development-tools.sh` — sets up programming languages, data stores, Docker/k8s tooling, IDEs, and development utilities.
- `03-productivity-apps.sh` — installs office replacements, communication apps, media tools, and general productivity software.

## Usage

```bash
chmod +x *.sh
./01-base-system.sh
./02-development-tools.sh
./03-productivity-apps.sh
```

## Notes

- Scripts use `--noconfirm` to minimise interactive prompts; review them before running in production environments.
- Log out and back in after `02-development-tools.sh` so Docker group membership takes effect.
- Some AUR packages may take time to build or require manual intervention.
- Adjust package lists to suit your workflow.
- The `arch-home-desktop` setup reuses these scripts via thin wrappers; keep shared tooling authoritative here.

## Post-installation

### Development setup

1. Configure Git: `git config --global user.name "Your Name"` and `git config --global user.email "you@example.com"`.
2. Generate SSH keys and add them to GitHub/GitLab.
3. Sign in to container registries or package registries if required.
4. Configure IDEs (VS Code, JetBrains) and install extensions/plugins.
5. Secure databases and set passwords for PostgreSQL, MariaDB, and Redis.

### Productivity setup

1. Sign into communication tools (Slack, Teams, Zoom, Discord).
2. Configure email accounts in Thunderbird.
3. Connect cloud storage clients (Dropbox, Google Drive, etc.).
4. Sync browser profiles and extensions.
5. Import or unlock your password manager vault (KeePassXC, Bitwarden, etc.).

## Troubleshooting

- Verify network connectivity and disk space if package installs fail.
- Review build logs for AUR packages that error out.
- Consult the Arch Wiki for package-specific guidance.
- Re-run scripts as needed; they are idempotent thanks to `--needed` flags.
