#!/usr/bin/env bats

load './test_helpers'

setup() {
  REPO_ROOT=$(cd -- "$(dirname "${BATS_TEST_FILENAME}")/.." >/dev/null 2>&1 && pwd)
  # shellcheck source=modules/base.sh
  source "${REPO_ROOT}/modules/base.sh"
  # shellcheck source=modules/development.sh
  source "${REPO_ROOT}/modules/development.sh"
  # shellcheck source=modules/productivity.sh
  source "${REPO_ROOT}/modules/productivity.sh"
  # shellcheck source=modules/nvidia.sh
  source "${REPO_ROOT}/modules/nvidia.sh"
  # shellcheck source=modules/gaming.sh
  source "${REPO_ROOT}/modules/gaming.sh"
}

@test "base packages are unique and sorted" {
  mapfile -t pkgs < <(get_base_pacman_packages)
  assert_unique_sorted pkgs
}

@test "development packages respond to flags" {
  export ENABLE_DATA_PLATFORMS=0
  export ENABLE_DATABASE_SERVERS=0
  export ENABLE_GUI_DB_CLIENTS=0
  mapfile -t pkgs < <(get_development_pacman_packages)
  refute_array pkgs apache-airflow
  refute_array pkgs postgresql
  refute_array pkgs pgcli

  export ENABLE_DATA_PLATFORMS=1
  export ENABLE_DATABASE_SERVERS=1
  export ENABLE_GUI_DB_CLIENTS=1
  mapfile -t pkgs < <(get_development_pacman_packages)
  assert_array pkgs apache-airflow
  assert_array pkgs postgresql
  assert_array pkgs pgcli
}

@test "productivity flatpaks include teams" {
  mapfile -t apps < <(get_productivity_flatpak_apps)
  assert_array apps com.microsoft.Teams
}

@test "nvidia package flag gates cuda" {
  export ENABLE_CUDA_STACK=0
  mapfile -t pkgs < <(get_nvidia_pacman_packages)
  refute_array pkgs cuda
  export ENABLE_CUDA_STACK=1
  mapfile -t pkgs < <(get_nvidia_pacman_packages)
  assert_array pkgs cuda
}

@test "gaming aur list respects apollo flag" {
  export INSTALL_APOLLO=0
  mapfile -t pkgs < <(get_gaming_aur_packages)
  refute_array pkgs apollo-bin
  export INSTALL_APOLLO=1
  mapfile -t pkgs < <(get_gaming_aur_packages)
  assert_array pkgs apollo-bin
}
