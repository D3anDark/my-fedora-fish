function fish_prompt
    set -l cwd (__prompt_pwd_display)
    set -l host_ctx (__prompt_context_host)

    if test -n "$host_ctx"
        set_color red
        echo -n $host_ctx

        set_color brblack
        echo -n " "
    end

    set_color brblue
    echo -n $cwd

    if __prompt_is_git_repo
        set_color normal
        echo -n " on "

        set_color magenta
        echo -n (__prompt_git_icon)" "(__prompt_git_branch)

        if __prompt_git_dirty
            set_color yellow
            echo -n " [*]"
        end

        set -l detected_project_version (__prompt_project_version)
        if test -n "$detected_project_version"
            set_color normal
            echo -n " is "

            set_color yellow
            echo -n (__prompt_pkg_icon)" v$detected_project_version"
        end

        set -l stack (__prompt_project_stack)
        if test -n "$stack"
            set_color normal
            echo -n " via "

            set -l first 1
            for line in $stack
                set -l parts (string split ' ' -- $line)
                set -l tool $parts[1]
                set -l version $parts[2]

                if test $first -eq 0
                    set_color brblack
                    echo -n " · "
                end

                switch $tool
                    case node
                        set_color green
                        echo -n "node $version"
                    case npm
                        set_color brred
                        echo -n "npm v$version"
                    case pnpm
                        set_color brmagenta
                        echo -n "pnpm v$version"
                    case yarn
                        set_color yellow
                        echo -n "yarn v$version"
                    case bun
                        set_color yellow
                        echo -n "bun v$version"
                    case deno
                        set_color cyan
                        echo -n "deno v$version"
                    case python
                        set_color blue
                        echo -n "python v$version"
                    case uv
                        set_color brblue
                        echo -n "uv v$version"
                    case poetry
                        set_color magenta
                        echo -n "poetry v$version"
                    case pipenv
                        set_color bryellow
                        echo -n "pipenv v$version"
                    case rust
                        set_color red
                        echo -n "rust v$version"
                    case cargo
                        set_color brred
                        echo -n "cargo v$version"
                    case go
                        set_color cyan
                        echo -n "go v$version"
                    case php
                        set_color magenta
                        echo -n "php v$version"
                    case composer
                        set_color brmagenta
                        echo -n "composer v$version"
                    case '*'
                        set_color white
                        echo -n "$tool v$version"
                end

                set first 0
            end
        end
    end

    if test -n "$CMD_DURATION"
        if test $CMD_DURATION -gt 1000
            set -l seconds (math --scale=1 "$CMD_DURATION / 1000")
            set_color normal
            echo -n " took "

            set_color brblack
            echo -n "$seconds"s
        end
    end

    echo

    set_color brmagenta
    echo -n (__prompt_arrow)" "
    set_color normal
end
