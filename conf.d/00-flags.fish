# Feature flags are defined early so later snippets can safely consume them.

if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end

set -q FISH_ENABLE_FASTFETCH; or set -g FISH_ENABLE_FASTFETCH 0
set -q FISH_ENABLE_AUTO_SUDO_DNF; or set -g FISH_ENABLE_AUTO_SUDO_DNF 0
set -q FISH_ENABLE_BAT_CAT; or set -g FISH_ENABLE_BAT_CAT 0
set -q FISH_ENABLE_FZF_BINDINGS; or set -g FISH_ENABLE_FZF_BINDINGS 0
set -q FISH_ENABLE_ATUIN; or set -g FISH_ENABLE_ATUIN 0
set -q FISH_ENABLE_STARSHIP; or set -g FISH_ENABLE_STARSHIP 0
set -q FISH_ENABLE_CARAPACE; or set -g FISH_ENABLE_CARAPACE 0
set -q FISH_ENABLE_FNM; or set -g FISH_ENABLE_FNM 0
set -q FISH_ENABLE_MISE; or set -g FISH_ENABLE_MISE 0
set -q FISH_ENABLE_PYENV; or set -g FISH_ENABLE_PYENV 0
set -q FISH_ENABLE_ABBR_CONTAINERS; or set -g FISH_ENABLE_ABBR_CONTAINERS 0
set -q FISH_ENABLE_ABBR_SYSTEMD; or set -g FISH_ENABLE_ABBR_SYSTEMD 0
set -q FISH_ENABLE_ABBR_JS; or set -g FISH_ENABLE_ABBR_JS 0
set -q FISH_ENABLE_ABBR_PYTHON; or set -g FISH_ENABLE_ABBR_PYTHON 0
set -q FISH_USE_NERD_FONT; or set -g FISH_USE_NERD_FONT 1

# These can overlap, so keep them opt-in and decide the combination explicitly.
# In particular, enabling `mise` together with `fnm` and/or `pyenv` can change PATH order.
