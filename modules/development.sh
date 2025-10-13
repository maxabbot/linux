#!/usr/bin/env bash
# shellcheck disable=SC1091 # dynamic module includes resolved at runtime
# Development tooling installation shared across profiles.

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

: "${ENABLE_DOCKER:=0}"
: "${ENABLE_LIBVIRT:=0}"
: "${ENABLE_DATA_PLATFORMS:=1}"
: "${ENABLE_DATABASE_SERVERS:=1}"
: "${ENABLE_GUI_DB_CLIENTS:=1}"

get_development_pacman_packages() {
  local lang_runtime_packages=(
    python
    python-pip
    python-virtualenv
    python-numpy
    python-pandas
    python-matplotlib
    python-scipy
    python-scikit-learn
    jupyter-notebook
    nodejs
    npm
    go
    rustup
    jdk-openjdk
    gcc
    clang
    cmake
    make
  )

  local dev_util_packages=(
    fd
    helix
    neovim
    alacritty
    kitty
    direnv
    tree
    starship
    zsh
    git-lfs
    github-cli
    tig
  )

  local database_server_packages=(
    postgresql
    mariadb
    redis
    sqlite
  )

  local data_platform_packages=()

  local cli_database_helpers=(
    pgcli
  )

  local container_packages=(
    podman
    podman-compose
    docker
    docker-compose
    kubectl
    minikube
    helm
    ansible
    terraform
    opentofu
    kubectx
  )

  local cloud_cli_packages=(
    aws-cli-v2
    azure-cli
    doctl
  )

  local api_tooling_packages=(
    httpie
  )

  local packages=(
    "${lang_runtime_packages[@]}"
    "${dev_util_packages[@]}"
    "${container_packages[@]}"
    "${cloud_cli_packages[@]}"
    "${api_tooling_packages[@]}"
  )

  if flag_enabled ENABLE_DATABASE_SERVERS 1; then
    packages+=("${database_server_packages[@]}")
  fi

  if flag_enabled ENABLE_DATA_PLATFORMS 1; then
    packages+=("${data_platform_packages[@]}")
  fi

  if flag_enabled ENABLE_GUI_DB_CLIENTS 1; then
    packages+=("${cli_database_helpers[@]}")
  fi

  printf '%s\n' "${packages[@]}"
}

get_development_aur_packages() {
  local aur_packages=(
    visual-studio-code-bin
    nvm
    sdkman-cli
    mongodb-bin
    litecli
    rapidsai
    postman-bin
    insomnia-bin
    wiremock-standalone
    dbeaver
    oh-my-zsh-git
    kind-bin
    google-cloud-cli
    grpcurl-bin
  )

  local aur_data_platform_packages=(
    duckdb-bin
    apache-airflow
    apache-spark
  )

  local aur_cli_helpers=(
    mycli
  )

  local filtered=()

  local gui_clients_enabled=0
  if flag_enabled ENABLE_GUI_DB_CLIENTS 1; then
    gui_clients_enabled=1
  fi

  for pkg in "${aur_packages[@]}"; do
    if [[ ${gui_clients_enabled} -eq 0 ]] && [[ "$pkg" =~ ^(litecli|dbeaver)$ ]]; then
      continue
    fi
    filtered+=("$pkg")
  done

  if flag_enabled ENABLE_DATA_PLATFORMS 1; then
    filtered+=("${aur_data_platform_packages[@]}")
  fi

  if [[ ${gui_clients_enabled} -eq 1 ]]; then
    filtered+=("${aur_cli_helpers[@]}")
  fi

  if ((${#filtered[@]})); then
    printf '%s\n' "${filtered[@]}"
  fi
}

install_development() {
  mapfile -t pacman_packages < <(get_development_pacman_packages)
  pacman_install "${pacman_packages[@]}"

  mapfile -t aur_packages < <(get_development_aur_packages)
  yay_install "${aur_packages[@]}"

  local pip_packages=(
    tensorflow
    torch
    jupyterlab
    sqlalchemy
    psycopg2-binary
    xgboost
    lightgbm
    mlflow
    huggingface_hub
    onnxruntime
  )

  pip_install_user "${pip_packages[@]}"

  if flag_enabled ENABLE_DOCKER 0; then
    enable_service_now docker.service
    log_info "Adding ${USER} to docker group"
    sudo usermod -aG docker "${USER}"
  else
    log_warn "Docker service not enabled (set ENABLE_DOCKER=1 to auto-enable)."
  fi

  if flag_enabled ENABLE_LIBVIRT 0; then
    enable_service_now libvirtd.service
    log_info "Add ${USER} to libvirt group: sudo usermod -aG libvirt ${USER}"
  else
    log_warn "libvirtd service not enabled (set ENABLE_LIBVIRT=1 to auto-enable)."
  fi

  log_success "Development tooling installed."
}
