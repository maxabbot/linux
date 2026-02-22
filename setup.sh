#!/usr/bin/env bash
# =============================================================================
# setup.sh — Single entry point for linux-setup-scripts
#
# This script handles the full lifecycle:
#   1. Install prerequisites (git, ansible, chezmoi)
#   2. Run Ansible system playbooks
#   3. Apply Chezmoi dotfiles
# =============================================================================

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)

# Colors
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
CYAN=$'\033[0;36m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

log_info()    { printf "${BLUE}[INFO]${RESET}    %s\n" "$*"; }
log_success() { printf "${GREEN}[OK]${RESET}      %s\n" "$*"; }
log_warn()    { printf "${YELLOW}[WARN]${RESET}    %s\n" "$*"; }
log_error()   { printf "${RED}[ERROR]${RESET}   %s\n" "$*" >&2; }
log_header()  { printf "\n${BOLD}${CYAN}━━━ %s ━━━${RESET}\n\n" "$*"; }

# ─── Locale Configuration ───────────────────────────────────────────────────

configure_locale() {
  # Detect if locale is missing or misconfigured
  if ! locale -a 2>/dev/null | grep -q "en_US.utf8"; then
    log_warn "System locale en_US.UTF-8 not found. Generating..."
    
    # Step 1: Uncomment en_US.UTF-8 in /etc/locale.gen if not already present
    if ! grep -q "^en_US.UTF-8" /etc/locale.gen; then
      log_info "Uncommenting en_US.UTF-8 in /etc/locale.gen..."
      # Use sed to uncomment it if commented, or add it if missing entirely
      if grep -q "^#en_US.UTF-8" /etc/locale.gen; then
        sudo sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
      else
        # Not even commented, so add it
        echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen >/dev/null
      fi
    fi
    
    # Step 2: Run locale-gen to generate all enabled locales
    log_info "Running locale-gen..."
    if command -v locale-gen &>/dev/null; then
      sudo locale-gen 2>&1 | grep -E "(en_US|Generation)" || true
    elif [ -x /usr/sbin/locale-gen ]; then
      sudo /usr/sbin/locale-gen 2>&1 | grep -E "(en_US|Generation)" || true
    else
      log_error "locale-gen not found on system!"
      return 1
    fi
    
    # Step 3: Verify locale was created
    if ! locale -a 2>/dev/null | grep -q "en_US.utf8"; then
      log_error "Failed to generate en_US.UTF-8 locale. System may have issues."
      return 1
    fi
  fi
  
  # Step 4: Set environment variables for current session AND write to /etc/locale.conf
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  export LANGUAGE=en_US.UTF-8
  
  # Also write to /etc/locale.conf for system-wide persistence
  sudo tee /etc/locale.conf >/dev/null <<EOF
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
LANGUAGE=en_US.UTF-8
EOF
  
  log_success "Locale configured: $LANG"
}

# ─── Prerequisites ───────────────────────────────────────────────────────────

ensure_pacman_pkg() {
  local pkg="$1"
  if ! pacman -Qi "$pkg" &>/dev/null; then
    log_info "Installing $pkg..."
    sudo pacman -S --noconfirm --needed "$pkg"
  fi
}

install_prerequisites() {
  log_header "Prerequisites"

  ensure_pacman_pkg git
  ensure_pacman_pkg ansible
  ensure_pacman_pkg python
  ensure_pacman_pkg python-pip

  # Install chezmoi if not present
  if ! command -v chezmoi &>/dev/null; then
    log_info "Installing chezmoi..."
    if pacman -Ss chezmoi &>/dev/null; then
      sudo pacman -S --noconfirm --needed chezmoi
    else
      sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
      export PATH="$HOME/.local/bin:$PATH"
    fi
  fi

  # Install Ansible Galaxy collections
  log_info "Installing Ansible Galaxy requirements..."
  # Explicitly set locale for ansible to avoid initialization errors
  LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 ansible-galaxy collection install -r "${SCRIPT_DIR}/system/requirements.yml" --force

  log_success "Prerequisites installed."
}

# ─── Profile Selection ───────────────────────────────────────────────────────

select_profile() {
  log_header "Profile Selection"

  echo "Available profiles:"
  echo ""
  echo "  ${BOLD}1)${RESET} Home Desktop  — base + dev + productivity + nvidia + gaming"
  echo "  ${BOLD}2)${RESET} Work Laptop   — base + dev + productivity"
  echo "  ${BOLD}3)${RESET} Minimal       — base only"
  echo "  ${BOLD}4)${RESET} Custom        — choose roles interactively"
  echo ""

  read -rp "Select profile [1-4]: " choice

  case "$choice" in
    1) PROFILE="home_desktop" ;;
    2) PROFILE="work_laptop" ;;
    3) PROFILE="minimal" ;;
    4) PROFILE="custom" ;;
    *) log_warn "Invalid choice, defaulting to Home Desktop."; PROFILE="home_desktop" ;;
  esac

  log_info "Selected profile: $PROFILE"
}

# ─── System Configuration (Ansible) ──────────────────────────────────────────

run_system_playbook() {
  log_header "System Configuration (Ansible)"

  local playbook_dir="${SCRIPT_DIR}/system"
  cd "$playbook_dir"

  case "$PROFILE" in
    home_desktop)
      log_info "Running full Home Desktop playbook..."
      LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 ansible-playbook "playbooks/site.yml" \
        -i "inventory/hosts.yml" \
        -l home_desktop \
        --ask-become-pass
      ;;
    work_laptop)
      log_info "Running Work Laptop playbook..."
      LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 ansible-playbook "playbooks/site.yml" \
        -i "inventory/hosts.yml" \
        -l work_laptop \
        --ask-become-pass
      ;;
    minimal)
      log_info "Running Base-only playbook..."
      LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 ansible-playbook "playbooks/site.yml" \
        -i "inventory/hosts.yml" \
        -l minimal \
        --ask-become-pass
      ;;
    custom)
      local selected_roles=()
      echo ""
      echo "Select roles to install (space-separated numbers):"
      echo "  1) base   2) development   3) productivity   4) nvidia   5) gaming"
      echo ""
      read -rp "Roles: " roles_input

      for r in $roles_input; do
        case "$r" in
          1) selected_roles+=("base") ;;
          2) selected_roles+=("development") ;;
          3) selected_roles+=("productivity") ;;
          4) selected_roles+=("nvidia") ;;
          5) selected_roles+=("gaming") ;;
        esac
      done

      if [[ ${#selected_roles[@]} -eq 0 ]]; then
        log_warn "No roles selected, running base only."
        selected_roles=("base")
      fi

      # Build JSON array for profile_roles extra var: ["base","development",...]
      local roles_json joined
      printf -v joined '"%s",' "${selected_roles[@]}"
      roles_json="[${joined%,}]"

      log_info "Running playbook with roles: ${selected_roles[*]}"
      LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 ansible-playbook "playbooks/site.yml" \
        -i "inventory/hosts.yml" \
        -l minimal \
        -e "profile_roles=${roles_json}" \
        --ask-become-pass
      ;;
  esac

  cd "$SCRIPT_DIR"
  log_success "System configuration complete."
}

# ─── User Environment (Chezmoi) ──────────────────────────────────────────────

apply_dotfiles() {
  log_header "User Environment (Chezmoi)"

  echo "Apply dotfiles?"
  echo "  ${BOLD}1)${RESET} Yes — apply all dotfiles via chezmoi"
  echo "  ${BOLD}2)${RESET} Dry run — preview changes only"
  echo "  ${BOLD}3)${RESET} Skip — do not apply dotfiles"
  echo ""

  read -rp "Choice [1-3]: " df_choice

  case "$df_choice" in
    1)
      log_info "Initialising chezmoi from ${SCRIPT_DIR}/user..."
      chezmoi init --source "${SCRIPT_DIR}/user" --apply
      log_success "Dotfiles applied."
      ;;
    2)
      log_info "Dry run..."
      chezmoi init --source "${SCRIPT_DIR}/user"
      chezmoi apply --dry-run --verbose
      log_info "No changes made (dry run)."
      ;;
    3)
      log_info "Skipping dotfiles."
      ;;
    *)
      log_warn "Invalid choice, skipping dotfiles."
      ;;
  esac
}

# ─── Summary ─────────────────────────────────────────────────────────────────

print_summary() {
  log_header "Setup Complete"

  cat <<EOF
${GREEN}✓${RESET} System configured with profile: ${BOLD}${PROFILE}${RESET}

${BOLD}Next steps:${RESET}
  1. Reboot to load new kernel modules / drivers
  2. Run ${CYAN}p10k configure${RESET} to customise your Zsh prompt
  3. Open Neovim — plugins will auto-install on first launch
  4. Run ${CYAN}:Mason${RESET} inside Neovim to verify LSP servers

${BOLD}Useful commands:${RESET}
  Re-run system config:  ${CYAN}ansible-playbook system/playbooks/site.yml -i system/inventory/hosts.yml --ask-become-pass${RESET}
  Re-apply dotfiles:     ${CYAN}chezmoi apply${RESET}
  Update dotfiles:       ${CYAN}chezmoi update${RESET}
  Check diff:            ${CYAN}chezmoi diff${RESET}
EOF
}

# ─── Main ─────────────────────────────────────────────────────────────────────

main() {
  log_header "linux-setup-scripts — IaC Setup"

  echo "This script will configure your Arch Linux system using:"
  echo "  • ${BOLD}Ansible${RESET} for system packages and services"
  echo "  • ${BOLD}Chezmoi${RESET} for dotfiles and user configuration"
  echo ""

  read -rp "Continue? [Y/n] " confirm
  if [[ "${confirm,,}" == "n" ]]; then
    log_info "Aborted."
    exit 0
  fi

  configure_locale
  install_prerequisites
  select_profile
  run_system_playbook
  apply_dotfiles
  print_summary
}

main "$@"
