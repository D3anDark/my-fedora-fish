function fish_right_prompt
    set -l shown 0

    set -l venv_name (__prompt_in_virtualenv)
    if test -n "$venv_name"
        set_color blue
        echo -n "[$venv_name]"
        set shown 1
    end

    if __prompt_is_ssh
        if test $shown -eq 1
            echo -n " "
        end

        set_color red
        echo -n "[SSH]"
    end

    set_color normal
end
