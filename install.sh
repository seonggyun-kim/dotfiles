#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME:?HOME is not set}"
BACKUP_DIR="${HOME_DIR}/.dotfiles-backups/$(date +"%Y%m%d-%H%M%S")"
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run]

Symlink managed dotfiles from this repo into your home directory.
Existing files are moved to ~/.dotfiles-backups/<timestamp>/ before linking.
Tmux plugins are installed automatically when git and tmux are available.
EOF
}

run() {
  if [[ "${DRY_RUN}" -eq 1 ]]; then
    printf '[dry-run]'
    for arg in "$@"; do
      printf ' %q' "${arg}"
    done
    printf '\n'
  else
    "$@"
  fi
}

link_path() {
  local source_path="$1"
  local target_path="$2"

  if [[ ! -e "${source_path}" && ! -L "${source_path}" ]]; then
    printf 'Missing source: %s\n' "${source_path}" >&2
    return 1
  fi

  run mkdir -p "$(dirname "${target_path}")"

  if [[ -L "${target_path}" ]]; then
    local existing_target
    existing_target="$(readlink "${target_path}")"
    if [[ "${existing_target}" == "${source_path}" ]]; then
      printf 'already linked: %s -> %s\n' "${target_path}" "${source_path}"
      return 0
    fi
  fi

  if [[ -e "${target_path}" || -L "${target_path}" ]]; then
    local relative_target backup_target
    relative_target="${target_path#"${HOME_DIR}/"}"
    backup_target="${BACKUP_DIR}/${relative_target}"
    run mkdir -p "$(dirname "${backup_target}")"
    run mv "${target_path}" "${backup_target}"
    printf 'backup: %s -> %s\n' "${target_path}" "${backup_target}"
  fi

  run ln -s "${source_path}" "${target_path}"
  printf 'linked: %s -> %s\n' "${target_path}" "${source_path}"
}

ensure_file() {
  local file_path="$1"

  if [[ -e "${file_path}" || -L "${file_path}" ]]; then
    return 0
  fi

  run mkdir -p "$(dirname "${file_path}")"
  run touch "${file_path}"
  printf 'created: %s\n' "${file_path}"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

tmux_plugin_root() {
  if [[ "${DRY_RUN}" -eq 0 ]] && command_exists tmux; then
    local env_line plugin_root
    if env_line="$(tmux start-server \; show-environment -g TMUX_PLUGIN_MANAGER_PATH 2>/dev/null)"; then
      plugin_root="${env_line#TMUX_PLUGIN_MANAGER_PATH=}"
      plugin_root="${plugin_root/#\~/${HOME_DIR}}"
      plugin_root="${plugin_root/#\$HOME/${HOME_DIR}}"
      printf '%s\n' "${plugin_root%/}"
      return 0
    fi
  fi

  local xdg_tmux_dir="${XDG_CONFIG_HOME:-${HOME_DIR}/.config}/tmux"
  if [[ -f "${xdg_tmux_dir}/tmux.conf" ]]; then
    printf '%s\n' "${xdg_tmux_dir}/plugins"
  else
    printf '%s\n' "${HOME_DIR}/.tmux/plugins"
  fi
}

install_tpm() {
  local tpm_dir="${HOME_DIR}/.tmux/plugins/tpm"

  if [[ -d "${tpm_dir}/.git" ]]; then
    printf 'already installed: %s\n' "${tpm_dir}"
    return 0
  fi

  if [[ -e "${tpm_dir}" ]]; then
    printf 'tmux plugin manager skipped: %s exists but is not a git checkout\n' "${tpm_dir}" >&2
    return 0
  fi

  if [[ "${DRY_RUN}" -eq 0 ]] && ! command_exists git; then
    printf 'tmux plugin manager skipped: git is required\n' >&2
    return 0
  fi

  run mkdir -p "$(dirname "${tpm_dir}")"
  run git clone https://github.com/tmux-plugins/tpm "${tpm_dir}"
  printf 'installed tmux plugin manager: %s\n' "${tpm_dir}"
}

install_tmux_cpu_mem_deps() {
  local plugin_root="$1"
  local plugin_dir="${plugin_root}/tmux-cpu-mem-monitor"
  local venv_dir="${plugin_dir}/venv"

  if [[ "${DRY_RUN}" -eq 1 ]]; then
    run python3 -m venv "${venv_dir}"
    run "${venv_dir}/bin/python" -m pip install -r "${plugin_dir}/requirements.txt"
    return 0
  fi

  if [[ ! -d "${plugin_dir}" ]]; then
    return 0
  fi

  if ! command_exists python3; then
    printf 'tmux cpu/mem plugin setup skipped: python3 is required\n' >&2
    return 0
  fi

  if [[ -x "${venv_dir}/bin/python" ]] && "${venv_dir}/bin/python" -c 'import psutil' >/dev/null 2>&1; then
    printf 'already installed: %s Python deps\n' "${plugin_dir}"
    return 0
  fi

  if ! run python3 -m venv "${venv_dir}"; then
    printf 'tmux cpu/mem plugin setup skipped: python3-venv is required\n' >&2
    return 0
  fi

  if ! run "${venv_dir}/bin/python" -m pip install -r "${plugin_dir}/requirements.txt"; then
    printf 'tmux cpu/mem plugin setup skipped: failed to install Python deps\n' >&2
    return 0
  fi

  printf 'installed tmux cpu/mem Python deps: %s\n' "${plugin_dir}"
}

install_tmux_plugins() {
  local tpm_dir="${HOME_DIR}/.tmux/plugins/tpm"

  install_tpm

  if [[ "${DRY_RUN}" -eq 0 ]] && ! command_exists tmux; then
    printf 'tmux plugins skipped: tmux is required\n' >&2
    return 0
  fi

  if [[ "${DRY_RUN}" -eq 0 ]] && [[ ! -x "${tpm_dir}/bin/install_plugins" ]]; then
    printf 'tmux plugins skipped: TPM installer not found at %s\n' "${tpm_dir}/bin/install_plugins" >&2
    return 0
  fi

  run tmux start-server \; source-file "${HOME_DIR}/.config/tmux/tmux.conf"
  run "${tpm_dir}/bin/install_plugins"
  install_tmux_cpu_mem_deps "$(tmux_plugin_root)"
  run tmux source-file "${HOME_DIR}/.config/tmux/tmux.conf"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

managed_paths=(
  ".zshrc"
  ".XCompose"
  ".config/alacritty"
  ".config/fontconfig"
  ".config/nvim"
  ".config/tmux/tmux.conf"
  ".config/tmux/scripts"
)

for relative_path in "${managed_paths[@]}"; do
  link_path "${DOTFILES_DIR}/${relative_path}" "${HOME_DIR}/${relative_path}"
done

# Keep ~/.tmux.conf linked for compatibility with older tmux versions.
link_path "${HOME_DIR}/.config/tmux/tmux.conf" "${HOME_DIR}/.tmux.conf"

# Keep personal compose sequences in a local untracked file.
ensure_file "${HOME_DIR}/.XCompose.local"

install_tmux_plugins

if [[ -d "${BACKUP_DIR}" ]]; then
  printf 'backup directory: %s\n' "${BACKUP_DIR}"
fi

printf 'done\n'
