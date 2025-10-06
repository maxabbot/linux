#!/usr/bin/env bats

load './test_helpers'

setup() {
  REPO_ROOT=$(cd -- "$(dirname "${BATS_TEST_FILENAME}")/.." >/dev/null 2>&1 && pwd)
  export REPO_ROOT
}

@test "sync script writes manifests without conflicts" {
  pacman_tmp=$(mktemp)
  aur_tmp=$(mktemp)
  PACMAN_OUTPUT="${pacman_tmp}" AUR_OUTPUT="${aur_tmp}" run bash bin/sync-packages.sh
  assert_success
  assert_output --partial "No conflicts detected."
  [[ -s "${pacman_tmp}" ]] || fail "pacman manifest empty"
  [[ -s "${aur_tmp}" ]] || fail "aur manifest empty"
}

@test "sync script reports known conflicts" {
  pacman_tmp=$(mktemp)
  aur_tmp=$(mktemp)
  EXTRA_PACMAN_PACKAGES="code" EXTRA_AUR_PACKAGES="spotify" \
    PACMAN_OUTPUT="${pacman_tmp}" AUR_OUTPUT="${aur_tmp}" run bash bin/sync-packages.sh
  assert_success
  assert_output --partial "Conflicts detected:"
  assert_output --partial "Remove repo code"
  assert_output --partial "Drop spotify"
}

teardown() {
  [[ -n "${pacman_tmp:-}" && -f "${pacman_tmp}" ]] && rm -f "${pacman_tmp}"
  [[ -n "${aur_tmp:-}" && -f "${aur_tmp}" ]] && rm -f "${aur_tmp}"
}
