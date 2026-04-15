status is-interactive; or return

if contains -- "$FISH_ENABLE_FASTFETCH" 1 yes true on
    if command -q fastfetch
        if test -z "$SSH_CONNECTION"
            if test -z "$TMUX"
                fastfetch
            end
        end
    end
end

if command -q zoxide
    zoxide init fish | source
end

if command -q direnv
    direnv hook fish | source
end

if contains -- "$FISH_ENABLE_FZF_BINDINGS" 1 yes true on
    if command -q fzf
        fzf --fish | source
    end
end

if contains -- "$FISH_ENABLE_ATUIN" 1 yes true on
    if command -q atuin
        # Keep Up-arrow integration, but hand Ctrl-R to a later explicit bind.
        atuin init fish --disable-ctrl-r | source
    end
end

if contains -- "$FISH_ENABLE_FNM" 1 yes true on
    if command -q fnm
        fnm env --use-on-cd --shell fish | source
    end
end

if contains -- "$FISH_ENABLE_MISE" 1 yes true on
    if command -q mise
        mise activate fish | source
    end
end

if contains -- "$FISH_ENABLE_PYENV" 1 yes true on
    set -q PYENV_ROOT; or set -gx PYENV_ROOT ~/.pyenv

    if test -d "$PYENV_ROOT/bin"
        fish_add_path $PYENV_ROOT/bin
    end

    if command -q pyenv
        pyenv init - fish | source
    end
end

if contains -- "$FISH_ENABLE_CARAPACE" 1 yes true on
    if command -q carapace
        carapace _carapace | source
    end
end

if command -q dnf
    if contains -- "$FISH_ENABLE_AUTO_SUDO_DNF" 1 yes true on
        function dnf --wraps dnf
            if test (id -u) -eq 0
                command dnf $argv
            else
                command sudo dnf $argv
            end
        end
    end
end

if command -q dnf5
    if contains -- "$FISH_ENABLE_AUTO_SUDO_DNF" 1 yes true on
        function dnf5 --wraps dnf5
            if test (id -u) -eq 0
                command dnf5 $argv
            else
                command sudo dnf5 $argv
            end
        end
    end
end

if contains -- "$FISH_ENABLE_STARSHIP" 1 yes true on
    if command -q starship
        # Keep this last so prompt replacement happens after the rest of the shell setup.
        starship init fish | source
    end
end
