#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: copy-vm-to-usb.sh [OPTIONS]

Copy or export a VirtualBox VM onto a mounted USB drive.

Required flags:
  --usb-path <path>          Mount point of the USB drive (must be writable).

One of the following MUST be supplied:
  --vm-name <name>           Name/UUID of the VirtualBox VM (for export mode).
  --vm-path <path>           Path to the VM directory (for mirror mode).

Optional flags:
  --mode <export|mirror>     Export to an OVA (default) or mirror the VM directory.
  --output-name <name>       Override the output filename/directory.
  --include-manifest         Include a manifest when exporting (VirtualBox export only).
  --force                    Overwrite an existing output file/directory.
  --help                     Show this message and exit.

Examples:
  copy-vm-to-usb.sh --vm-name arch-vbox --usb-path /run/media/$USER/BACKUP
  copy-vm-to-usb.sh --mode mirror --vm-name arch-vbox --usb-path /mnt/usb
EOF
}

log() {
  printf '[%s] %s\n' "$(date +'%Y-%m-%dT%H:%M:%S')" "$*"
}

error() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

warn() {
  printf 'Warning: %s\n' "$*" >&2
}

vm_name=""
vm_path=""
usb_path=""
mode="export"
output_name=""
include_manifest=0
force=0

while (($#)); do
  case "$1" in
    --vm-name)
      [[ $# -ge 2 ]] || error "--vm-name requires an argument"
      vm_name="$2"
      shift 2
      ;;
    --vm-path)
      [[ $# -ge 2 ]] || error "--vm-path requires an argument"
      vm_path="$2"
      shift 2
      ;;
    --usb-path)
      [[ $# -ge 2 ]] || error "--usb-path requires an argument"
      usb_path="$2"
      shift 2
      ;;
    --mode)
      [[ $# -ge 2 ]] || error "--mode requires an argument"
      mode="$2"
      shift 2
      ;;
    --output-name)
      [[ $# -ge 2 ]] || error "--output-name requires an argument"
      output_name="$2"
      shift 2
      ;;
    --include-manifest)
      include_manifest=1
      shift
      ;;
    --force)
      force=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      error "Unknown argument: $1"
      ;;
  esac
done

if [[ -z "${usb_path}" ]]; then
  error "--usb-path is required"
fi

if [[ -z "${vm_name}" && -z "${vm_path}" ]]; then
  error "Provide either --vm-name or --vm-path"
fi

if [[ "${mode}" != "export" && "${mode}" != "mirror" ]]; then
  error "--mode must be either export or mirror"
fi

resolve_path() {
  local target="$1"
  if [[ -d "${target}" ]]; then
    (cd "${target}" >/dev/null 2>&1 && pwd -P) || return 1
  else
    local dir
    dir=$(dirname "${target}")
    local base
    base=$(basename "${target}")
    (cd "${dir}" >/dev/null 2>&1 && printf '%s/%s\n' "$(pwd -P)" "${base}") || return 1
  fi
}

usb_path=$(resolve_path "${usb_path}" 2>/dev/null) || error "Unable to resolve USB path"
if [[ ! -d "${usb_path}" ]]; then
  error "USB path ${usb_path} does not exist or is not a directory"
fi
if [[ ! -w "${usb_path}" ]]; then
  error "USB path ${usb_path} is not writable"
fi

require_command() {
  local cmd="$1"
  command -v "${cmd}" >/dev/null 2>&1 || error "${cmd} is required but not found in PATH"
}

resolve_vm_dir() {
  if [[ -n "${vm_path}" ]]; then
    resolve_path "${vm_path}" 2>/dev/null || return 1
    return 0
  fi

  if [[ -z "${vm_name}" ]]; then
    return 1
  fi

  if command -v VBoxManage >/dev/null 2>&1; then
    local cfg
    if cfg=$(VBoxManage showvminfo "${vm_name}" --machinereadable 2>/dev/null | grep '^CfgFile=' | cut -d'=' -f2-); then
      cfg=${cfg%\"}
      cfg=${cfg#\"}
      local dir
      dir=$(dirname "${cfg}")
      if [[ -d "${dir}" ]]; then
        resolve_path "${dir}" 2>/dev/null
        return 0
      fi
    fi
  fi

  local fallback="${HOME}/VirtualBox VMs/${vm_name}"
  if [[ -d "${fallback}" ]]; then
    resolve_path "${fallback}" 2>/dev/null
    return 0
  fi

  return 1
}

vm_dir=""
if vm_dir=$(resolve_vm_dir 2>/dev/null); then
  :
else
  [[ "${mode}" == "export" ]] || error "Unable to determine VM directory; use --vm-path"
fi

estimate_vm_size_bytes() {
  local path="$1"
  [[ -z "${path}" ]] && return 1
  du -sb -- "${path}" 2>/dev/null | awk '{print $1}'
}

check_free_space() {
  local required_bytes="$1"
  [[ -z "${required_bytes}" ]] && return 0
  local available_kb
  available_kb=$(df --output=avail -k "${usb_path}" | tail -n1 | tr -d ' ')
  local required_kb
  required_kb=$(( (required_bytes + 1023) / 1024 ))
  if (( required_kb > available_kb )); then
    error "Insufficient space on ${usb_path}: need ${required_kb} KiB, available ${available_kb} KiB"
  fi
}

case "${mode}" in
  export)
    require_command VBoxManage
    if [[ -z "${vm_name}" ]]; then
      error "--vm-name is required in export mode"
    fi
    ;;
  mirror)
    require_command rsync
    if [[ -z "${vm_dir}" ]]; then
      error "--vm-path is required in mirror mode"
    fi
    ;;
esac

if [[ -n "${vm_dir}" ]]; then
  required_bytes=$(estimate_vm_size_bytes "${vm_dir}") || required_bytes=""
  if [[ -n "${required_bytes}" ]]; then
    log "VM size estimate: $(( required_bytes / (1024 * 1024) )) MiB"
    check_free_space "${required_bytes}"
  else
    warn "Unable to estimate VM size; skipping free-space check"
  fi
fi

if [[ -z "${output_name}" ]]; then
  timestamp=$(date +'%Y%m%d-%H%M')
  if [[ -n "${vm_name}" ]]; then
    base_name="${vm_name// /_}"
  elif [[ -n "${vm_dir}" ]]; then
    base_name=$(basename "${vm_dir}")
  else
    base_name="vm-backup"
  fi
  if [[ "${mode}" == "export" ]]; then
    output_name="${base_name}-${timestamp}.ova"
  else
    output_name="${base_name}-${timestamp}"
  fi
fi

output_path="${usb_path}/${output_name}"
partial_path="${output_path}.partial"

cleanup_partial() {
  if [[ -e "${partial_path}" ]]; then
    log "Removing partial output ${partial_path}"
    rm -rf -- "${partial_path}"
  fi
}

trap cleanup_partial EXIT

if [[ -e "${output_path}" ]]; then
  if (( force )); then
    log "Removing existing ${output_path}"
    rm -rf -- "${output_path}"
  else
    error "Output ${output_path} already exists. Use --force to overwrite."
  fi
fi

cleanup_partial

case "${mode}" in
  export)
    state=$(VBoxManage showvminfo "${vm_name}" --machinereadable | grep '^VMState=' | cut -d'=' -f2 | tr -d '"' || true)
    if [[ "${state}" != "poweroff" ]]; then
      error "VM ${vm_name} is not powered off (current state: ${state:-unknown}). Shut it down before exporting."
    fi

    log "Exporting ${vm_name} to ${output_path}"
    args=(export "${vm_name}" --output "${partial_path}")
    if (( include_manifest )); then
      args+=(--options manifest)
    fi
  VBoxManage "${args[@]}"
  mv -f "${partial_path}" "${output_path}"
    log "Export complete: ${output_path}"
    ;;
  mirror)
    mkdir -p -- "${partial_path}"
    log "Mirroring ${vm_dir} to ${output_path}"
  rsync --archive --info=progress2 --human-readable "${vm_dir}/" "${partial_path}/"
  mv -f "${partial_path}" "${output_path}"
    log "Mirror complete: ${output_path}"
    ;;
esac

trap - EXIT
cleanup_partial

log "All done."
