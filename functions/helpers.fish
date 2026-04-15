# Shared helper functions loaded by config.fish.

function fish_mode_prompt
end

function __prompt_has_nerd_font
    contains -- "$FISH_USE_NERD_FONT" 1 yes true on
end

function __prompt_git_icon
    if __prompt_has_nerd_font
        echo ""
    else
        echo "git"
    end
end

function __prompt_pkg_icon
    if __prompt_has_nerd_font
        echo "📦"
    else
        echo "pkg"
    end
end

function __prompt_arrow
    if __prompt_has_nerd_font
        echo "❯"
    else
        echo ">"
    end
end

function __prompt_is_ssh
    test -n "$SSH_CONNECTION"
end

function __prompt_context_host
    if __prompt_is_ssh
        echo (prompt_hostname)
    end
end

function __prompt_pwd_display
    string replace -r '^'"$HOME" '~' -- $PWD
end

function __prompt_is_git_repo
    command git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
end

function __prompt_git_branch
    command git branch --show-current 2>/dev/null
end

function __prompt_git_dirty
    command git diff --no-ext-diff --quiet --exit-code 2>/dev/null
    set -l unstaged_status $status

    command git diff --cached --no-ext-diff --quiet --exit-code 2>/dev/null
    set -l staged_status $status

    if test $unstaged_status -ne 0 -o $staged_status -ne 0
        return 0
    end

    set -l untracked (command git ls-files --others --exclude-standard 2>/dev/null)[1]
    if test -n "$untracked"
        return 0
    end

    return 1
end

function __prompt_in_virtualenv
    if set -q VIRTUAL_ENV
        echo (basename "$VIRTUAL_ENV")
        return
    end

    if set -q CONDA_DEFAULT_ENV
        echo "$CONDA_DEFAULT_ENV"
        return
    end
end

function __prompt_detect_js_pm
    if test -f pnpm-lock.yaml
        echo pnpm
        return
    end

    if test -f yarn.lock
        echo yarn
        return
    end

    if test -f package-lock.json
        echo npm
        return
    end

    if test -f bun.lockb -o -f bun.lock
        echo bun
        return
    end
end

function __prompt_detect_python_tool
    if test -f uv.lock
        echo uv
        return
    end

    if test -f poetry.lock
        echo poetry
        return
    end

    if test -f Pipfile.lock
        echo pipenv
        return
    end
end

function __prompt_project_version
    if test -f package.json
        if command -q jq
            set -l version (jq -r '.version // empty' package.json 2>/dev/null)
            if test -n "$version"
                echo $version
                return
            end
        else
            set -l line (string match -r '"version"[[:space:]]*:[[:space:]]*"[^"]+"' < package.json)
            set -l version (string replace -r '.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*' '$1' -- $line)
            if test -n "$version"
                echo $version
                return
            end
        end
    end

    if test -f pyproject.toml
        set -l line (string match -r '^[[:space:]]*version[[:space:]]*=[[:space:]]*"[^"]+"' < pyproject.toml)
        set -l version (string replace -r '.*"([^"]+)".*' '$1' -- $line)
        if test -n "$version"
            echo $version
            return
        end
    end

    if test -f Cargo.toml
        set -l line (string match -r '^[[:space:]]*version[[:space:]]*=[[:space:]]*"[^"]+"' < Cargo.toml)
        set -l version (string replace -r '.*"([^"]+)".*' '$1' -- $line)
        if test -n "$version"
            echo $version
            return
        end
    end

    if test -f composer.json
        if command -q jq
            set -l version (jq -r '.version // empty' composer.json 2>/dev/null)
            if test -n "$version"
                echo $version
                return
            end
        else
            set -l line (string match -r '"version"[[:space:]]*:[[:space:]]*"[^"]+"' < composer.json)
            set -l version (string replace -r '.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*' '$1' -- $line)
            if test -n "$version"
                echo $version
                return
            end
        end
    end
end

function __prompt_project_stack
    set -l out

    if test -f package.json -o -f .nvmrc -o -f .node-version
        if command -q node
            set -a out "node "(string trim -- (node -v 2>/dev/null))
        end

        set -l pm (__prompt_detect_js_pm)
        if test -n "$pm"
            switch $pm
                case npm
                    if command -q npm
                        set -a out "npm "(string trim -- (npm -v 2>/dev/null))
                    end
                case pnpm
                    if command -q pnpm
                        set -a out "pnpm "(string trim -- (pnpm -v 2>/dev/null))
                    end
                case yarn
                    if command -q yarn
                        set -a out "yarn "(string trim -- (yarn -v 2>/dev/null))
                    end
                case bun
                    if command -q bun
                        set -a out "bun "(string trim -- (bun --version 2>/dev/null))
                    end
            end
        end
    end

    if test -f deno.json -o -f deno.jsonc
        if command -q deno
            set -l deno_info (deno --version 2>/dev/null)
            if test (count $deno_info) -ge 1
                set -l deno_parts (string split ' ' -- $deno_info[1])
                set -a out "deno "$deno_parts[-1]
            end
        end
    end

    if test -f pyproject.toml -o -f requirements.txt -o -f requirements-dev.txt -o -f .python-version -o -d .venv -o -d venv
        if command -q python3
            set -l python_info (string split ' ' -- (python3 --version 2>/dev/null))
            set -a out "python "$python_info[-1]
        end

        set -l pytool (__prompt_detect_python_tool)
        if test -n "$pytool"
            switch $pytool
                case uv
                    if command -q uv
                        set -l uv_info (string split ' ' -- (uv --version 2>/dev/null))
                        set -a out "uv "$uv_info[-1]
                    end
                case poetry
                    if command -q poetry
                        set -l poetry_info (string split ' ' -- (poetry --version 2>/dev/null))
                        set -a out "poetry "$poetry_info[-1]
                    end
                case pipenv
                    if command -q pipenv
                        set -l pipenv_info (string split ' ' -- (pipenv --version 2>/dev/null))
                        set -a out "pipenv "$pipenv_info[-1]
                    end
            end
        end
    end

    if test -f Cargo.toml
        if command -q rustc
            set -l rustc_info (string split ' ' -- (rustc --version 2>/dev/null))
            set -a out "rust "$rustc_info[-1]
        end

        if command -q cargo
            set -l cargo_info (string split ' ' -- (cargo --version 2>/dev/null))
            set -a out "cargo "$cargo_info[-1]
        end
    end

    if test -f go.mod
        if command -q go
            set -l go_info (string split ' ' -- (go version 2>/dev/null))
            set -a out "go "(string replace 'go' '' -- $go_info[-1])
        end
    end

    if test -f composer.json
        if command -q php
            set -a out "php "(php -r 'echo PHP_VERSION;' 2>/dev/null)
        end

        if command -q composer
            set -l composer_info (composer --version 2>/dev/null)
            if test (count $composer_info) -ge 1
                set -l composer_version (string match -r '[0-9]+(\.[0-9]+)+' -- $composer_info[1])
                if test -n "$composer_version"
                    set -a out "composer "$composer_version
                end
            end
        end
    end

    printf '%s\n' $out
end

function mkcd
    if test (count $argv) -eq 0
        echo "Usage: mkcd <directory>"
        return 1
    end

    mkdir -p -- $argv[1]; and cd -- $argv[1]
end

function extract
    if test (count $argv) -eq 0
        echo "Usage: extract <archive>"
        return 1
    end

    set -l file $argv[1]

    if not test -f "$file"
        echo "File not found: $file"
        return 1
    end

    switch $file
        case '*.tar.bz2' '*.tbz2'
            tar xjf $file
        case '*.tar.gz' '*.tgz'
            tar xzf $file
        case '*.tar.xz' '*.txz'
            tar xJf $file
        case '*.tar.zst'
            tar --zstd -xf $file
        case '*.tar'
            tar xf $file
        case '*.zip'
            unzip $file
        case '*.gz'
            gunzip $file
        case '*.bz2'
            bunzip2 $file
        case '*.xz'
            unxz $file
        case '*.7z'
            7z x $file
        case '*'
            echo "Unsupported archive: $file"
            return 1
    end
end

function croot
    if __prompt_is_git_repo
        cd -- (command git rev-parse --show-toplevel 2>/dev/null)
    else
        echo "Not inside a git repository"
        return 1
    end
end

function gcleanbranches
    command git branch --merged 2>/dev/null | string trim | string match -rv '^(main|master|\*)$'
end

function venv
    if test -f .venv/bin/activate.fish
        source .venv/bin/activate.fish
        return
    end

    if test -f venv/bin/activate.fish
        source venv/bin/activate.fish
        return
    end

    echo "No fish virtualenv found in .venv/ or venv/"
    return 1
end
