# Clean Fish config bootstrap.

set -g fish_greeting

fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.npm-global/bin

if test -f ~/.config/fish/functions/helpers.fish
    source ~/.config/fish/functions/helpers.fish
end

status is-interactive; or return

set -g fish_color_command cyan
set -g fish_color_keyword magenta
set -g fish_color_quote yellow
set -g fish_color_error red
set -g fish_color_comment brblack
set -g fish_color_autosuggestion 555
set -g fish_color_valid_path --underline

if command -q fzf
    set -gx FZF_DEFAULT_OPTS "--height=50% --layout=reverse --border"
end
