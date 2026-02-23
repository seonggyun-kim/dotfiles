# Dotfiles

Personal dotfiles managed from a single repo under `~/dotfiles`.

## Currently managed

- `.zshrc`
- `.config/nvim`
- `.config/tmux/tmux.conf`
- `.config/alacritty`
- `.config/fontconfig`
- `.XCompose`

`~/.zprofile` is intentionally not managed, so you can keep machine-specific login PATH/env settings local.

`~/.tmux.conf` is also symlinked to `~/.config/tmux/tmux.conf` for compatibility with older tmux versions.

## Install on this machine or a new machine

```bash
./install.sh
```

Preview changes first:

```bash
./install.sh --dry-run
```

The installer creates symlinks into `$HOME` and backs up existing files to:

`~/.dotfiles-backups/<timestamp>/`

## OS compatibility

- Works on Linux and macOS (requires `bash`, `ln`, `mv`, `readlink`, `mkdir`).
- On Windows, use WSL or a Unix-like shell environment.

## Add another dotfile later

1. Put it in this repo using the same path it should have under `$HOME`.
2. Add the path to `managed_paths` in `install.sh`.
3. Run `./install.sh` again.

## Keep private data out of git

- Put personal compose entries in `~/.XCompose.local`.
- Put machine- or account-specific shell settings in `~/.zshrc.local` or local `~/.zprofile`.
- These `*.local` files are ignored by git.

## Good next candidates to track

- `.gitconfig`
- `.config/kitty`
- `.config/niri`
- `.Xresources`
