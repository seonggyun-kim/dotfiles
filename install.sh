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
)

for relative_path in "${managed_paths[@]}"; do
  link_path "${DOTFILES_DIR}/${relative_path}" "${HOME_DIR}/${relative_path}"
done

# Keep ~/.tmux.conf linked for compatibility with older tmux versions.
link_path "${HOME_DIR}/.config/tmux/tmux.conf" "${HOME_DIR}/.tmux.conf"

# Keep personal compose sequences in a local untracked file.
ensure_file "${HOME_DIR}/.XCompose.local"

if [[ -d "${BACKUP_DIR}" ]]; then
  printf 'backup directory: %s\n' "${BACKUP_DIR}"
fi

printf 'done\n'
