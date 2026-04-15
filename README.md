# Fish Config

A clean, dev-focused Fish shell config that stays small, readable, and safe by default.

This repo is for people who want a good Fish setup without adopting a framework or a huge shell distribution.

It is:

- Fedora-first
- safe on minimal systems
- safe over SSH
- safe in containers
- easy to extend
- explicit about optional features

It is not:

- a framework
- a giant dotfiles bundle
- a Starship preset
- a config that forces controversial behavior by default

## What It Does

- custom prompt with Git awareness
- project version detection
- project stack detection for Node, Bun, Deno, Python, Rust, Go, and PHP
- SSH-aware prompt and right prompt
- Python `venv` and Conda environment display
- small developer helpers like `mkcd`, `extract`, `croot`, `venv`
- optional `fastfetch`
- optional auto-`sudo` for `dnf` and `dnf5`
- optional `cat -> bat` replacement
- tool fallbacks for `eza -> lsd -> ls`
- optional detection for `zoxide` and `direnv`

## File Layout

- `config.fish` - bootstrap, PATH, colors, shared setup
- `conf.d/00-flags.fish` - feature flags and early local overrides
- `conf.d/10-tools.fish` - optional tool integrations and wrappers
- `conf.d/20-abbr.fish` - abbreviations and command fallbacks
- `functions/helpers.fish` - prompt helpers and small dev helpers
- `functions/fish_prompt.fish` - main prompt
- `functions/fish_right_prompt.fish` - right prompt

## Safe Defaults

The default behavior is intentionally conservative:

- `fastfetch` is off
- auto-`sudo` for `dnf` is off
- `cat -> bat` is off
- Nerd Font mode is on, but the prompt still stays readable without forcing other optional tools

## Feature Flags

These flags control all optional behavior:

- `FISH_ENABLE_FASTFETCH`
- `FISH_ENABLE_AUTO_SUDO_DNF`
- `FISH_ENABLE_BAT_CAT`
- `FISH_USE_NERD_FONT`

Default values:

```fish
set -g FISH_ENABLE_FASTFETCH 0
set -g FISH_ENABLE_AUTO_SUDO_DNF 0
set -g FISH_ENABLE_BAT_CAT 0
set -g FISH_USE_NERD_FONT 1
```

Recommended way to enable them permanently:

```fish
set -Ux FISH_ENABLE_FASTFETCH 1
set -Ux FISH_ENABLE_AUTO_SUDO_DNF 1
set -Ux FISH_ENABLE_BAT_CAT 1
set -Ux FISH_USE_NERD_FONT 1
exec fish
```

Recommended way to disable them permanently:

```fish
set -Ux FISH_ENABLE_FASTFETCH 0
set -Ux FISH_ENABLE_AUTO_SUDO_DNF 0
set -Ux FISH_ENABLE_BAT_CAT 0
set -Ux FISH_USE_NERD_FONT 0
exec fish
```

## OOTB Installation

### Fedora minimal

If you want this config to work out of the box on a fresh Fedora install, the minimum is just Fish itself:

```bash
sudo dnf install fish
mkdir -p ~/.config/fish/conf.d ~/.config/fish/functions ~/.config/fish/completions
cp -f config.fish ~/.config/fish/
cp -f conf.d/*.fish ~/.config/fish/conf.d/
cp -f functions/*.fish ~/.config/fish/functions/
cp -f completions/*.fish ~/.config/fish/completions/
chsh -s "$(command -v fish)"
exec fish
```

That gives you a working setup with safe defaults and no required optional tools.

### Fedora comfortable setup

If you want the nicer optional experience right away:

```bash
sudo dnf install fish git fzf jq eza bat fastfetch zoxide direnv fd-find ripgrep lsd
mkdir -p ~/.config/fish/conf.d ~/.config/fish/functions ~/.config/fish/completions
cp -f config.fish ~/.config/fish/
cp -f conf.d/*.fish ~/.config/fish/conf.d/
cp -f functions/*.fish ~/.config/fish/functions/
cp -f completions/*.fish ~/.config/fish/completions/
chsh -s "$(command -v fish)"
exec fish
```

Then enable the optional flags you actually want:

```fish
set -Ux FISH_ENABLE_FASTFETCH 1
set -Ux FISH_ENABLE_AUTO_SUDO_DNF 1
set -Ux FISH_ENABLE_BAT_CAT 1
exec fish
```

### If you cloned the repo directly into `~/.config/fish`

```bash
git clone <REPO_URL> ~/.config/fish
chsh -s "$(command -v fish)"
exec fish
```

## Optional Tools

Everything below is optional. The config still works without them.

- `git` - branch and dirty state in the prompt
- `fastfetch` - startup system info if enabled
- `fzf` - better interactive fuzzy workflows if you use it
- `eza` - preferred `ls` replacement
- `lsd` - fallback `ls` replacement if `eza` is missing
- `bat` or `batcat` - only used if you explicitly enable `FISH_ENABLE_BAT_CAT`
- `jq` - better JSON version parsing for `package.json` and `composer.json`
- `zoxide` - auto-initialized if installed
- `direnv` - auto-initialized if installed
- `fd` / `fd-find` - optional standalone search tool
- `rg` / `ripgrep` - optional standalone search tool

## Intentional Choices

### `dnf` auto-sudo is intentional

This repo can wrap `dnf` and `dnf5` with `sudo`, but only if you opt in.

Reason:

- Fedora users often copy commands from docs or COPR pages that omit `sudo`
- this removes friction
- it should still be user choice, not a forced default

### `fastfetch` is optional

It looks nice locally, but it adds noise in some environments.

That is why it stays off by default, especially for:

- SSH sessions
- containers
- minimal systems
- people who prefer instant shell startup

### Custom prompt instead of Starship

This repo uses a custom prompt on purpose.

Reason:

- fewer moving parts
- no extra runtime dependency
- easier to audit and modify
- prompt behavior is visible in plain Fish code

## Fallback Strategy

The repo is designed so it does not collapse when optional tools are missing.

- list command: `eza -> lsd -> ls`
- `bat` only activates if you explicitly enable it
- `jq` improves parsing, but simple regex fallback remains in place
- `zoxide` and `direnv` only initialize if installed

## Example Prompt

```text
~/work/app on git main [*] is pkg v1.4.2 via node v22.9.0 · pnpm v9.12.0
> 
```

Right prompt example:

```text
[myenv] [SSH]
```

## Local Overrides

You can keep private machine-specific tweaks in:

```text
~/.config/fish/config.local.fish
```

This file is loaded before the other optional snippets, so it is a good place for local flags or environment overrides.

Example:

```fish
set -g FISH_ENABLE_FASTFETCH 1
set -g FISH_ENABLE_BAT_CAT 1
```

## Philosophy

- clean Fish config
- developer-focused
- Fedora-first, but not Fedora-only
- optional features stay optional
- easy to read
- easy to extend
- no "works only on my machine" assumptions
