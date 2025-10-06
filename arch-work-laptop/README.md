# Arch Linux Work Laptop Setup

This directory now ships **convenience wrappers** for the shared module stack in `../modules/`. Each script simply sources the module and runs the corresponding installer so that existing automation keeps working without duplicating package lists.

## Recommended path

For a full workstation build, run the curated profile instead of calling each script manually:

```bash
chmod +x ../profiles/work-laptop.sh
../profiles/work-laptop.sh
```

The profile executes:

1. `install_base`
2. `install_development`
3. `install_productivity`

Environment switches (`POWER_MANAGEMENT`, `ENABLE_DOCKER`, `ENABLE_LIBVIRT`) can be exported before invoking the profile.

## Individual stages

Need to re-run only part of the stack? The wrapper scripts still do the job:

- `01-base-system.sh` → shared base system module (defaults to `POWER_MANAGEMENT=tlp`).
- `02-development-tools.sh` → development toolchain module (`ENABLE_DOCKER=1`, `ENABLE_LIBVIRT=0`).
- `03-productivity-apps.sh` → productivity/Desktop module.

Scripts are idempotent (`pacman --needed`, `yay --needed`) so repeating them is safe.

## Post-install reminders

- Log out/in after the development stage so Docker group membership activates.
- Apply Git identity, SSH keys, and IDE configuration as usual.
- Sign into cloud and communication apps once the productivity stage finishes.

## Troubleshooting

- Check network connectivity and free disk space when installs fail.
- Inspect AUR build logs for manual interventions.
- Consult the [Arch Wiki](https://wiki.archlinux.org/) for package-specific tuning.
