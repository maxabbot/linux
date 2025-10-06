# Package maintenance guide

This document highlights the current package sets defined in `modules/*.sh` and the legacy text manifests under `arch-setup/packages/`. Use it as a living checklist when refreshing the catalog or tailoring a profile.

## Duplicates handled upstream

Core utilities now live in `modules/base.sh`, so downstream modules no longer repeat them. `bin/sync-packages.sh` will flag any future duplicates when you regenerate the manifests.

## Conflict alerts

- The project standardises on `visual-studio-code-bin`. If `code` creeps back in, the sync script will warn.
- `rustup` replaces the repo `rust` package to avoid conflicting toolchains.
- The Spotify target is `spotify-launcher`; avoid shipping the `spotify` AUR package in parallel.

## Heavy / niche packages to gate behind flags

Large installs are configurable through environment switches:

| Flag | What it controls |
|------|------------------|
| `ENABLE_CUDA_STACK` | CUDA/cuDNN alongside the NVIDIA driver stack. |
| `ENABLE_DATA_PLATFORMS` | Apache Airflow, Spark, and DuckDB. |
| `ENABLE_DATABASE_SERVERS` | PostgreSQL, MariaDB, Redis, and SQLite. |
| `ENABLE_GUI_DB_CLIENTS` | DBeaver, litecli, pgcli, and mycli. |
| `ENABLE_SYNC_CLIENTS` | Syncthing, Nextcloud, Dropbox, Google Drive. |
| `ENABLE_CREATIVE_SUITE` | GIMP, Krita, Kdenlive, etc. |
| `ENABLE_STREAMING_TOOLS` | Shotcut, RustDesk, AnyDesk, GPU streaming helpers. |
| `ENABLE_SECONDARY_BROWSERS` | Brave and Zen browser alongside Google Chrome. |

## Aging or superseded packages

- [`eza`](https://github.com/eza-community/eza) replaces the deprecated `exa` alias.
- Microsoft Teams now ships as a Flatpak (`com.microsoft.Teams`) instead of `teams-for-linux`.
- The default Chromium build is `google-chrome`; Brave and Zen are optional via `ENABLE_SECONDARY_BROWSERS`.

## Suggested next refactors

1. **Automate validation:** extend `bin/sync-packages.sh` to run lightweight smoke checks (e.g. `shellcheck`) before committing package changes.
2. **CI hook:** wire the sync script into a pre-commit or CI job so manifests stay consistent.
3. **Module tests:** add minimal BATS tests that assert each `get_*_packages` helper returns unique, sorted entries.

Keep this file updated each time you stage a significant package change or add a new profile. A short note about why a package exists (and when to drop it) goes a long way during future cleanups.
