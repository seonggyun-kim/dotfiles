# Created by newuser for 5.9
export PATH="/usr/local/texlive/2025/bin/x86_64-linux:$PATH"
export PATH="$HOME/.local/bin:$PATH"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
## ---- zinit ----
# source ~/.zinit/bin/zinit.zsh
#
# fast syntax highlighting (minimal, not flashy)
zinit light zdharma-continuum/fast-syntax-highlighting

# autosuggestions (subtle, fish-like)
zinit light zsh-users/zsh-autosuggestions

# smarter tab completion
zinit light zsh-users/zsh-completions

# history substring search (↑ ↓ actually useful)
zinit light zsh-users/zsh-history-substring-search
# history substring search bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

alias zshconfig='nvim ~/.zshrc'
alias nvimconfig='nvim ~/.config/nvim/init.lua'
alias vim=nvim

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# # ---- daily system update guard ----
# UPDATE_CACHE="$HOME/.cache/last_system_update"
# NOW=$(date +%s)
# DAY=$((24 * 60 * 60))
#
# # Detect OS
# if [[ -f /etc/os-release ]]; then
#   . /etc/os-release
# fi
#
# # Read last update time
# if [[ -f "$UPDATE_CACHE" ]]; then
#   LAST_UPDATE=$(cat "$UPDATE_CACHE")
# else
#   LAST_UPDATE=0
# fi
#
# if (( NOW - LAST_UPDATE > DAY )); then
#   if [[ "$ID" == "ubuntu" || "$ID_LIKE" == *"debian"* ]]; then
#     echo "Running daily apt update..."
#     sudo apt update && sudo apt upgrade -y && echo "$NOW" > "$UPDATE_CACHE"
#   elif [[ "$ID" == "arch" || "$ID_LIKE" == *"arch"* ]]; then
#     echo "Running daily paru update..."
#     paru -Syu --noconfirm && echo "$NOW" > "$UPDATE_CACHE"
#   fi
# fi
# # ----------------------------------

if command -v fastfetch >/dev/null 2>&1; then
    fastfetch 2>/dev/null || true
fi

ssh() {
  TERM=xterm-256color command ssh "$@"
}

# Set nvim as default editor
export EDITOR=nvim
export VISUAL=nvim

export PAGER='less'
export LESS='-R -i -F -X -M'

setopt prompt_subst
autoload -Uz add-zsh-hook

dotfiles_git_prompt_status() {
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

  local branch dirty
  branch="$(command git symbolic-ref --quiet --short HEAD 2>/dev/null \
    || command git rev-parse --short HEAD 2>/dev/null)" || return 0

  [[ -n "$(command git status --porcelain 2>/dev/null)" ]] && dirty=" *"
  printf '%s%s' "${branch//\%/%%}" "${dirty}"
}

dotfiles_prompt_precmd() {
  local prompt_user prompt_host left_width git_status terminal_width gap_width gap

  [[ -n "${DOTFILES_DISABLE_PROMPT:-}" ]] && return 0

  prompt_user="${(%):-%n}"
  prompt_host="${(%):-%m}"
  left_width=$(( ${#prompt_user} + 1 + ${#prompt_host} ))
  git_status="$(dotfiles_git_prompt_status)"
  terminal_width="${COLUMNS:-80}"
  (( terminal_width > 0 )) || terminal_width=80

  if [[ -n "${git_status}" ]]; then
    gap_width=$(( terminal_width - left_width - ${#git_status} ))
    (( gap_width < 1 )) && gap_width=1
    gap="${(pl:${gap_width}:: :)}"
    PROMPT=$'\n'"%B%n@%F{#88c0d0}%m%f%b${gap}${git_status}"$'\n'"%# "
  else
    PROMPT=$'\n'"%B%n@%F{#88c0d0}%m%f%b"$'\n'"%# "
  fi
}

add-zsh-hook precmd dotfiles_prompt_precmd

# Optional machine-local overrides (not tracked in git).
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
