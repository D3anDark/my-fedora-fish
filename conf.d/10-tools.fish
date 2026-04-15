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
