# Feature flags are defined early so later snippets can safely consume them.

if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end

set -q FISH_ENABLE_FASTFETCH; or set -g FISH_ENABLE_FASTFETCH 0
set -q FISH_ENABLE_AUTO_SUDO_DNF; or set -g FISH_ENABLE_AUTO_SUDO_DNF 0
set -q FISH_ENABLE_BAT_CAT; or set -g FISH_ENABLE_BAT_CAT 0
set -q FISH_USE_NERD_FONT; or set -g FISH_USE_NERD_FONT 1
