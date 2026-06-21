# Fastfetch Wrapper

The zsh function in `.zshrc` routes plain `fastfetch`, `fastfetch --refresh-cache`, and `fastfetch --cache-path` through `.local/bin/dotfiles-fastfetch`.

Other fastfetch arguments are passed directly to the real `fastfetch` binary.

## What It Does

`.local/bin/dotfiles-fastfetch` builds a custom ASCII logo:

1. Ask fastfetch for the normal distro logo only.
2. Generate a hostname banner with `figlet`.
3. Overlay the banner onto the distro logo.
4. Write the composed logo to a cache file.
5. Run fastfetch with that cached logo and the normal module config.

Current font rules:

- One-line hostnames use `slant`.
- Hostnames containing `-` are split across lines and use `smslant`.
- Example: `coal-docker` renders as `coal` and `docker`.

The banner uses fastfetch logo color slot `$8`, which is forced to `default` foreground at render time. This keeps the banner white/default while preserving distro logo colors.

## Cache

Cache files live under:

```text
${XDG_CACHE_HOME:-~/.cache}/dotfiles/fastfetch/
```

The cache key includes:

- wrapper cache version
- short hostname
- selected figlet font

Useful commands:

```bash
~/.local/bin/dotfiles-fastfetch --cache-path
~/.local/bin/dotfiles-fastfetch --refresh-cache
```

## Terminal Safety

The wrapper briefly disables terminal echo while fastfetch runs interactively. This avoids echoed terminal control replies, especially in nested sessions such as Windows Terminal or PowerShell -> SSH -> tmux.

Cleanup always restores the original tty state and removes temporary files.

## Failure Behavior

If logo extraction, figlet, or composition fails, the wrapper falls back to plain `fastfetch`.

If stdout is not a tty, the wrapper also falls back to plain `fastfetch` unless `DOTFILES_FASTFETCH_FORCE=1` is set.
