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

fastfetch

# Set nvim as default editor
export EDITOR=nvim
export VISUAL=nvim

# Optional machine-local overrides (not tracked in git).
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
