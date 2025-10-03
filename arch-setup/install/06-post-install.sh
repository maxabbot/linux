#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

DOTFILES_METHOD=${DOTFILES_METHOD:-chezmoi}
DOTFILES_REPO=${DOTFILES_REPO:-}
RUN_SECURITY_AUDIT=${RUN_SECURITY_AUDIT:-0}

log_info "Enabling core services"
enable_service_now cups.service
enable_service_now bluetooth.service
enable_service_now NetworkManager.service
enable_service_now ufw.service || true

if systemctl list-unit-files | grep -q '^reflector.timer'; then
  enable_service_now reflector.timer
else
  log_warn "reflector.timer not available; ensure reflector package is installed."
fi

log_info "Configuring PipeWire (user-level)"
if command -v systemctl >/dev/null 2>&1; then
  systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service || log_warn "PipeWire user services could not be enabled (ensure this script runs within a graphical session)."
fi

case "${DOTFILES_METHOD}" in
  chezmoi)
    if [[ -n "${DOTFILES_REPO}" ]]; then
      if command -v chezmoi >/dev/null 2>&1; then
        log_info "Applying dotfiles with chezmoi from ${DOTFILES_REPO}"
        chezmoi init "${DOTFILES_REPO}"
        chezmoi apply
      else
        log_warn "chezmoi not installed; skipping dotfiles apply."
      fi
    else
      log_warn "DOTFILES_REPO not set; skipping chezmoi apply."
    fi
    ;;
  bare)
    if [[ -n "${DOTFILES_REPO}" ]]; then
      log_info "Cloning bare dotfiles repository from ${DOTFILES_REPO}"
      git clone --bare "${DOTFILES_REPO}" "$HOME/.cfg"
      config(){ /usr/bin/git --git-dir="$HOME/.cfg" --work-tree="$HOME" "$@"; }
      if config checkout; then
        config config status.showUntrackedFiles no
      else
        log_warn "Dotfiles checkout encountered conflicts; resolve manually."
      fi
    else
      log_warn "DOTFILES_REPO not set; skipping bare git dotfiles."
    fi
    ;;
  none)
    log_info "DOTFILES_METHOD=none; skipping dotfiles management."
    ;;
  *)
    log_warn "Unknown DOTFILES_METHOD '${DOTFILES_METHOD}'."
    ;;
 esac

if [[ "${RUN_SECURITY_AUDIT}" == "1" ]]; then
  if command -v lynis >/dev/null 2>&1; then
    log_info "Running lynis audit"
    sudo lynis audit system || log_warn "lynis audit completed with warnings."
  else
    log_warn "lynis not installed; skipping audit."
  fi
else
  log_warn "Security audit skipped (set RUN_SECURITY_AUDIT=1 to enable)."
fi

log_success "Post-install tasks completed. Review TODOs for manual steps like restic/timeshift setup."
