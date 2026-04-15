# Fish Config

Clean, developer-focused Fish config for people who want a solid shell without a framework.

This repo is:

- small
- readable
- safe by default
- Fedora-first, but not Fedora-only
- easy to extend

This repo is not:

- a big dotfiles bundle
- a framework
- a Starship-only setup
- a config that forces aggressive behavior by default

**Quick Start**

Install Fish, clone the repo, and run the installer:

```bash
sudo dnf install fish
git clone https://github.com/D3anDark/my-fedora-fish.git
cd my-fedora-fish
./install.sh
chsh -s "$(command -v fish)"
exec fish
```

If you start `install.sh` from a file manager, it tries to open a terminal automatically.

On KDE, it first tries your configured default terminal from Plasma settings.

If you want to force a specific terminal:

```bash
INSTALL_TERMINAL=ghostty ./install.sh
```

**What You Get**

- custom prompt with Git awareness
- project version detection for Node, Bun, Deno, Python, Rust, Go, and PHP
- right prompt for SSH and Python environment info
- helpers like `mkcd`, `extract`, `croot`, `venv`
- clean `abbr` setup
- sane fallbacks like `eza -> lsd -> ls`
- optional integrations that stay off unless enabled

**Installer**

`install.sh` is interactive.

It:

- copies the config into `${XDG_CONFIG_HOME:-~/.config}/fish`
- creates a timestamped backup of an existing Fish config
- preserves `fish_variables`
- asks about every optional feature with `[y/n]` prompts
- explains what each option does before asking
- writes your choices to `config.local.fish`

Recommended defaults in the installer are intentionally conservative:

- `FISH_USE_NERD_FONT` defaults to `y`
- `FISH_ENABLE_FZF_BINDINGS` defaults to `y`
- everything more invasive or tool-specific defaults to `n`

**Safe Defaults**

Out of the box:

- `fastfetch` is off
- auto-`sudo` for `dnf` is off
- `cat -> bat` is off
- `atuin`, `starship`, `carapace`, `fnm`, `mise`, and `pyenv` are off
- extra abbreviation packs are off
- Nerd Font mode is on

That means the config works on minimal systems and does not depend on optional tools.

**Common Installs**

Minimal Fedora setup:

```bash
sudo dnf install fish
./install.sh
```

More comfortable Fedora setup with common extras:

```bash
sudo dnf install fish git fzf jq eza bat fastfetch zoxide direnv fd-find ripgrep lsd atuin starship carapace
./install.sh
```

**Feature Flags**

All optional behavior is controlled by flags.

Core behavior:

- `FISH_ENABLE_FASTFETCH`
- `FISH_ENABLE_AUTO_SUDO_DNF`
- `FISH_ENABLE_BAT_CAT`
- `FISH_USE_NERD_FONT`

Interactive tools:

- `FISH_ENABLE_FZF_BINDINGS`
- `FISH_ENABLE_ATUIN`
- `FISH_ENABLE_STARSHIP`
- `FISH_ENABLE_CARAPACE`

Version managers:

- `FISH_ENABLE_FNM`
- `FISH_ENABLE_MISE`
- `FISH_ENABLE_PYENV`

Extra abbreviation packs:

- `FISH_ENABLE_ABBR_CONTAINERS`
- `FISH_ENABLE_ABBR_SYSTEMD`
- `FISH_ENABLE_ABBR_JS`
- `FISH_ENABLE_ABBR_PYTHON`

Default values:

```fish
set -g FISH_ENABLE_FASTFETCH 0
set -g FISH_ENABLE_AUTO_SUDO_DNF 0
set -g FISH_ENABLE_BAT_CAT 0
set -g FISH_ENABLE_FZF_BINDINGS 0
set -g FISH_ENABLE_ATUIN 0
set -g FISH_ENABLE_STARSHIP 0
set -g FISH_ENABLE_CARAPACE 0
set -g FISH_ENABLE_FNM 0
set -g FISH_ENABLE_MISE 0
set -g FISH_ENABLE_PYENV 0
set -g FISH_ENABLE_ABBR_CONTAINERS 0
set -g FISH_ENABLE_ABBR_SYSTEMD 0
set -g FISH_ENABLE_ABBR_JS 0
set -g FISH_ENABLE_ABBR_PYTHON 0
set -g FISH_USE_NERD_FONT 1
```

If you prefer to change flags manually later:

```fish
set -Ux FISH_ENABLE_ATUIN 1
set -Ux FISH_ENABLE_FZF_BINDINGS 1
set -Ux FISH_ENABLE_ABBR_JS 1
exec fish
```

If you enable both `mise` and `fnm` or `pyenv`, do it on purpose. They can overlap and affect `PATH` order.

**Optional Tools**

Everything below is optional. The config still works without them.

- `git` for branch and dirty state in the prompt
- `fastfetch` for startup system info
- `fzf` for `Ctrl-T` and `Alt-C`
- `atuin` for history UI on `Ctrl-R`
- `starship` as an alternative prompt
- `carapace` for broader shell completions
- `zoxide` for smarter directory jumping
- `direnv` for directory-based environment loading
- `fnm`, `mise`, `pyenv` for toolchain activation
- `eza`, `lsd`, `bat`, `jq`, `fd`, `ripgrep` for nicer command-line tooling

**Prompt Behavior**

This repo uses a custom Fish prompt by default.

Reason:

- no extra runtime dependency
- easy to audit
- easy to modify
- predictable startup behavior

If you prefer `starship`, enable `FISH_ENABLE_STARSHIP=1`.

Example prompt:

```text
~/work/app on git main [*] is pkg v1.4.2 via node v22.9.0 · pnpm v9.12.0
> 
```

Right prompt example:

```text
[myenv] [SSH]
```

**Local Overrides**

Machine-specific tweaks live in:

```text
~/.config/fish/config.local.fish
```

The installer writes this file for you.

You can edit it later by hand, for example:

```fish
set -g FISH_ENABLE_FASTFETCH 1
set -g FISH_ENABLE_ATUIN 1
set -g FISH_ENABLE_FZF_BINDINGS 1
set -g FISH_ENABLE_ABBR_JS 1
```

**File Layout**

- `config.fish` - bootstrap, PATH, colors, shared setup
- `conf.d/00-flags.fish` - feature flags and early local overrides
- `conf.d/10-tools.fish` - optional tool integrations and wrappers
- `conf.d/15-bindings.fish` - key binding overrides for optional tools
- `conf.d/20-abbr.fish` - abbreviations and command fallbacks
- `functions/helpers.fish` - prompt helpers and helper functions
- `functions/fish_prompt.fish` - main prompt
- `functions/fish_right_prompt.fish` - right prompt
- `install.sh` - interactive installer

**Design Notes**

- optional features stay optional
- missing tools should degrade gracefully
- `dnf` auto-sudo is opt-in only
- `fastfetch` stays off by default to avoid startup noise
- list command fallback is `eza -> lsd -> ls`
- prompt stays functional without external prompt frameworks

**Philosophy**

- clean Fish config
- developer-focused
- easy to read
- easy to extend
- no "works only on my machine" assumptions
