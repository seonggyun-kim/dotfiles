# Tmux

The tmux config lives at `.config/tmux/tmux.conf`.

`install.sh` links it to both:

- `~/.config/tmux/tmux.conf`
- `~/.tmux.conf`

The second link is for compatibility with older tmux startup behavior.

## Status Line

The status bar is a single top line:

- left: session name, separator, window list
- right: CPU, MEM, separator, identity

CPU and MEM are rendered by:

- `.config/tmux/scripts/status-metric`

Identity is rendered by:

- `.config/tmux/scripts/status-identity`

The CPU/MEM script uses `hendrikmi/tmux-cpu-mem-monitor` when the plugin is installed. If the plugin or Python dependency is missing, it prints a stable fallback such as `CPU --`.

## Plugins

Plugins are declared in `.config/tmux/tmux.conf` and installed through TPM:

- `tmux-plugins/tpm`
- `tmux-plugins/tmux-sensible`
- `hendrikmi/tmux-cpu-mem-monitor`

`install.sh` installs TPM when `git` is available, runs TPM's plugin installer when `tmux` is available, and sets up a Python virtual environment for the CPU/MEM plugin when `python3` is available.

## Validation

Parse the config without applying it:

```bash
tmux source-file -n .config/tmux/tmux.conf
```

Apply it to the current tmux server:

```bash
tmux source-file .config/tmux/tmux.conf
```

Check helper scripts:

```bash
bash -n .config/tmux/scripts/status-metric
bash -n .config/tmux/scripts/status-identity
```
