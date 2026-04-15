#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
script_path="$script_dir/$(basename -- "${BASH_SOURCE[0]}")"
target_dir="${XDG_CONFIG_HOME:-$HOME/.config}/fish"
timestamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="${target_dir}.backup.${timestamp}"
same_target=0
generated_local="$target_dir/config.local.fish"

if [[ "$script_dir" == "$target_dir" ]]; then
    same_target=1
fi

preserve_file() {
    local source_path="$1"
    local target_path="$2"

    if [[ -f "$source_path" ]]; then
        cp -f "$source_path" "$target_path"
    fi
}

set_relaunch_cmd_from_desktop() {
    local command_string="$1"
    local desktop_terminal
    local desktop_reader
    local -a desktop_cmd
    local desktop_bin

    if [[ "${XDG_CURRENT_DESKTOP:-}" != *KDE* ]]; then
        return 1
    fi

    if command -v kreadconfig6 >/dev/null 2>&1; then
        desktop_reader=kreadconfig6
    elif command -v kreadconfig5 >/dev/null 2>&1; then
        desktop_reader=kreadconfig5
    else
        return 1
    fi

    desktop_terminal="$($desktop_reader --file kdeglobals --group General --key TerminalApplication 2>/dev/null || true)"

    if [[ -z "$desktop_terminal" ]]; then
        return 1
    fi

    read -r -a desktop_cmd <<< "$desktop_terminal"

    if [[ ${#desktop_cmd[@]} -eq 0 ]]; then
        return 1
    fi

    desktop_bin="$(basename -- "${desktop_cmd[0]}")"

    case "$desktop_bin" in
        ghostty)
            relaunch_cmd=("${desktop_cmd[@]}" -e bash -lc "$command_string" "$script_path")
            ;;
        konsole)
            relaunch_cmd=("${desktop_cmd[@]}" -e bash -lc "$command_string" "$script_path")
            ;;
        gnome-terminal)
            relaunch_cmd=("${desktop_cmd[@]}" -- bash -lc "$command_string" "$script_path")
            ;;
        kitty)
            relaunch_cmd=("${desktop_cmd[@]}" --hold bash -lc "$command_string" "$script_path")
            ;;
        alacritty)
            relaunch_cmd=("${desktop_cmd[@]}" -e bash -lc "$command_string" "$script_path")
            ;;
        wezterm)
            relaunch_cmd=("${desktop_cmd[@]}" start --always-new-process -- bash -lc "$command_string" "$script_path")
            ;;
        xfce4-terminal)
            relaunch_cmd=("${desktop_cmd[@]}" --hold -x bash -lc "$command_string" "$script_path")
            ;;
        x-terminal-emulator)
            relaunch_cmd=("${desktop_cmd[@]}" -e bash -lc "$command_string" "$script_path")
            ;;
        *)
            return 1
            ;;
    esac
}

set_relaunch_cmd() {
    local terminal_name="$1"
    local command_string="$2"

    case "$terminal_name" in
        ghostty)
            command -v ghostty >/dev/null 2>&1 || return 1
            relaunch_cmd=(ghostty -e bash -lc "$command_string" "$script_path")
            ;;
        x-terminal-emulator)
            command -v x-terminal-emulator >/dev/null 2>&1 || return 1
            relaunch_cmd=(x-terminal-emulator -e bash -lc "$command_string" "$script_path")
            ;;
        gnome-terminal)
            command -v gnome-terminal >/dev/null 2>&1 || return 1
            relaunch_cmd=(gnome-terminal -- bash -lc "$command_string" "$script_path")
            ;;
        konsole)
            command -v konsole >/dev/null 2>&1 || return 1
            relaunch_cmd=(konsole -e bash -lc "$command_string" "$script_path")
            ;;
        xfce4-terminal)
            command -v xfce4-terminal >/dev/null 2>&1 || return 1
            relaunch_cmd=(xfce4-terminal --hold -x bash -lc "$command_string" "$script_path")
            ;;
        kitty)
            command -v kitty >/dev/null 2>&1 || return 1
            relaunch_cmd=(kitty --hold bash -lc "$command_string" "$script_path")
            ;;
        alacritty)
            command -v alacritty >/dev/null 2>&1 || return 1
            relaunch_cmd=(alacritty -e bash -lc "$command_string" "$script_path")
            ;;
        wezterm)
            command -v wezterm >/dev/null 2>&1 || return 1
            relaunch_cmd=(wezterm start --always-new-process -- bash -lc "$command_string" "$script_path")
            ;;
        *)
            return 1
            ;;
    esac
}

ensure_terminal() {
    local command_string
    local -a relaunch_cmd

    if [[ "${INSTALL_SH_SKIP_TTY_CHECK:-}" == "1" ]]; then
        return
    fi

    if [[ -t 0 && -t 1 ]]; then
        return
    fi

    if [[ -n "${INSTALL_SH_TERMINAL_REEXEC:-}" ]]; then
        printf 'This installer requires an interactive terminal.\n' >&2
        exit 1
    fi

    if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
        printf 'This installer needs a terminal window for interactive questions.\n' >&2
        printf 'Run it from a terminal with: bash "%s"\n' "$script_path" >&2
        exit 1
    fi

    command_string='INSTALL_SH_TERMINAL_REEXEC=1 "$0" "$@"; status=$?; printf "\nPress Enter to close this window..."; IFS= read -r; exit "$status"'

    if [[ -n "${INSTALL_TERMINAL:-}" ]]; then
        set_relaunch_cmd "$INSTALL_TERMINAL" "$command_string" || {
            printf 'Requested terminal is not supported or not installed: %s\n' "$INSTALL_TERMINAL" >&2
            exit 1
        }
    elif set_relaunch_cmd_from_desktop "$command_string"; then
        :
    elif [[ "${TERM_PROGRAM:-}" == "ghostty" ]]; then
        set_relaunch_cmd ghostty "$command_string" || true
    fi

    if [[ ${#relaunch_cmd[@]} -eq 0 ]]; then
        for terminal_name in ghostty x-terminal-emulator gnome-terminal konsole xfce4-terminal kitty alacritty wezterm; do
            if set_relaunch_cmd "$terminal_name" "$command_string"; then
                break
            fi
        done
    fi

    if [[ ${#relaunch_cmd[@]} -eq 0 ]]; then
        printf 'Could not find a supported terminal emulator automatically.\n' >&2
        printf 'Run it from a terminal with: bash "%s"\n' "$script_path" >&2
        exit 1
    fi

    "${relaunch_cmd[@]}" "$@"
    exit 0
}

print_section() {
    printf '\n%s\n' "============================================================"
    printf '%s\n' "$1"
    printf '%s\n\n' "============================================================"
}

ask_yes_no() {
    local var_name="$1"
    local default_value="$2"
    local title="$3"
    local description="$4"
    local reply
    local chosen

    print_section "$var_name"
    printf '%s\n\n' "$title"
    printf '%s\n\n' "$description"

    while true; do
        if [[ "$default_value" == "1" ]]; then
            printf 'Enable %s? [y/n] (default: y): ' "$var_name"
        else
            printf 'Enable %s? [y/n] (default: n): ' "$var_name"
        fi

        IFS= read -r reply || reply=''
        reply="${reply,,}"

        if [[ -z "$reply" ]]; then
            chosen="$default_value"
            break
        fi

        case "$reply" in
            y|yes)
                chosen=1
                break
                ;;
            n|no)
                chosen=0
                break
                ;;
            *)
                printf 'Please answer with y or n.\n\n'
                ;;
        esac
    done

    printf -v "$var_name" '%s' "$chosen"
}

write_config_local() {
    cat > "$generated_local" <<EOF
# Local Fish overrides generated by install.sh on ${timestamp}.
# Edit this file later if you want to change any defaults.

# Visual defaults
set -g FISH_USE_NERD_FONT $FISH_USE_NERD_FONT

# Conservative shell behavior
set -g FISH_ENABLE_FASTFETCH $FISH_ENABLE_FASTFETCH
set -g FISH_ENABLE_AUTO_SUDO_DNF $FISH_ENABLE_AUTO_SUDO_DNF
set -g FISH_ENABLE_BAT_CAT $FISH_ENABLE_BAT_CAT

# Optional interactive tools
set -g FISH_ENABLE_FZF_BINDINGS $FISH_ENABLE_FZF_BINDINGS
set -g FISH_ENABLE_ATUIN $FISH_ENABLE_ATUIN
set -g FISH_ENABLE_STARSHIP $FISH_ENABLE_STARSHIP
set -g FISH_ENABLE_CARAPACE $FISH_ENABLE_CARAPACE

# Optional version managers
set -g FISH_ENABLE_FNM $FISH_ENABLE_FNM
set -g FISH_ENABLE_MISE $FISH_ENABLE_MISE
set -g FISH_ENABLE_PYENV $FISH_ENABLE_PYENV

# Optional abbreviation packs
set -g FISH_ENABLE_ABBR_CONTAINERS $FISH_ENABLE_ABBR_CONTAINERS
set -g FISH_ENABLE_ABBR_SYSTEMD $FISH_ENABLE_ABBR_SYSTEMD
set -g FISH_ENABLE_ABBR_JS $FISH_ENABLE_ABBR_JS
set -g FISH_ENABLE_ABBR_PYTHON $FISH_ENABLE_ABBR_PYTHON
EOF
}

run_questionnaire() {
    print_section "Fish Config Setup"
    printf '%s\n' 'This installer will ask about every optional feature flag.'
    printf '%s\n' 'Press Enter to accept the recommended default for each question.'

    ask_yes_no \
        FISH_USE_NERD_FONT \
        1 \
        'Use Nerd Font symbols in the prompt.' \
        'This enables icons like the git branch symbol and the prompt arrow in your Fish prompt. Turn this on if your terminal font is a Nerd Font. If your font does not support these symbols, leave it off to keep the prompt fully ASCII and safe.'

    ask_yes_no \
        FISH_ENABLE_FASTFETCH \
        0 \
        'Show system information when an interactive Fish shell starts.' \
        'When enabled, Fish runs fastfetch on local interactive startup. This gives you a system summary every time a shell opens. It is intentionally off by default because it adds startup noise and is usually not wanted in minimal workflows.'

    ask_yes_no \
        FISH_ENABLE_AUTO_SUDO_DNF \
        0 \
        'Automatically wrap dnf and dnf5 with sudo for non-root users.' \
        'When enabled, typing dnf or dnf5 as a normal user automatically runs the command through sudo. This is convenient on Fedora, but it changes normal command behavior, so the default stays off.'

    ask_yes_no \
        FISH_ENABLE_BAT_CAT \
        0 \
        'Replace cat with bat or batcat through an abbreviation.' \
        'When enabled, typing cat expands to bat --style=plain --paging=never or batcat if available. This gives syntax highlighting and nicer output, but it changes a very common command, so the default is off.'

    ask_yes_no \
        FISH_ENABLE_FZF_BINDINGS \
        1 \
        'Enable fzf shell key bindings if fzf is installed.' \
        'This loads fzf integration for Fish. It gives you shortcuts like Ctrl-T for inserting files and Alt-C for jumping into directories. This is a safe quality-of-life feature, so it is enabled by default if fzf exists on the system.'

    ask_yes_no \
        FISH_ENABLE_ATUIN \
        0 \
        'Enable Atuin shell integration if atuin is installed.' \
        'This loads Atuin history integration for Fish and gives Ctrl-R to Atuin history search. It is powerful, but it adds another history system and external dependency, so the default is off.'

    ask_yes_no \
        FISH_ENABLE_STARSHIP \
        0 \
        'Use Starship instead of the built-in custom Fish prompt.' \
        'When enabled, Starship replaces the prompt at shell startup. The repo already includes a custom prompt that works without extra dependencies, so Starship stays off unless you explicitly want it.'

    ask_yes_no \
        FISH_ENABLE_CARAPACE \
        0 \
        'Enable Carapace global completions if carapace is installed.' \
        'This loads a completion bridge that can add completions for many external commands. It is useful, but it is still an extra layer of shell behavior, so the default remains off.'

    ask_yes_no \
        FISH_ENABLE_FNM \
        0 \
        'Enable fnm automatic Node.js environment loading if fnm is installed.' \
        'This runs fnm env --use-on-cd so Node versions switch automatically when you enter projects with .node-version or .nvmrc files. It is very handy if you use fnm, but unnecessary otherwise.'

    ask_yes_no \
        FISH_ENABLE_MISE \
        0 \
        'Enable mise shell activation if mise is installed.' \
        'This activates mise for the interactive shell so tools and environment variables can change automatically per project. It can overlap with fnm or pyenv, so it is off by default and should be enabled on purpose.'

    ask_yes_no \
        FISH_ENABLE_PYENV \
        0 \
        'Enable pyenv shell initialization if pyenv is installed.' \
        'This sets PYENV_ROOT, adds pyenv to PATH, and loads pyenv init for shims and completions. It is useful if you actually manage Python through pyenv, but it is not needed on every machine.'

    ask_yes_no \
        FISH_ENABLE_ABBR_CONTAINERS \
        0 \
        'Enable container abbreviations for docker and podman.' \
        'This adds short commands like d, dc, dps, p, pc, and pps. They only work when the underlying tools are installed, but they still add many extra abbreviations, so the default is off.'

    ask_yes_no \
        FISH_ENABLE_ABBR_SYSTEMD \
        0 \
        'Enable systemd abbreviations for systemctl and journalctl.' \
        'This adds shortcuts like scs for systemctl status, scr for restart, and ju for journalctl -u. It is helpful on Fedora or other systemd systems, but it is optional so it stays off by default.'

    ask_yes_no \
        FISH_ENABLE_ABBR_JS \
        0 \
        'Enable JavaScript abbreviations for pnpm, npm, and bun.' \
        'This adds developer shortcuts like pni, nr, and br. These are useful if you work in JS or TS projects often, but they are not universal enough to enable for everyone by default.'

    ask_yes_no \
        FISH_ENABLE_ABBR_PYTHON \
        0 \
        'Enable Python abbreviations for uv, python, and pip.' \
        'This adds shortcuts like uvr, py, pym, pyi, and pyv. These are useful in Python workflows, but they are optional and remain off until you opt in.'
}

show_summary() {
    print_section "Chosen Settings"
    printf 'FISH_USE_NERD_FONT=%s\n' "$FISH_USE_NERD_FONT"
    printf 'FISH_ENABLE_FASTFETCH=%s\n' "$FISH_ENABLE_FASTFETCH"
    printf 'FISH_ENABLE_AUTO_SUDO_DNF=%s\n' "$FISH_ENABLE_AUTO_SUDO_DNF"
    printf 'FISH_ENABLE_BAT_CAT=%s\n' "$FISH_ENABLE_BAT_CAT"
    printf 'FISH_ENABLE_FZF_BINDINGS=%s\n' "$FISH_ENABLE_FZF_BINDINGS"
    printf 'FISH_ENABLE_ATUIN=%s\n' "$FISH_ENABLE_ATUIN"
    printf 'FISH_ENABLE_STARSHIP=%s\n' "$FISH_ENABLE_STARSHIP"
    printf 'FISH_ENABLE_CARAPACE=%s\n' "$FISH_ENABLE_CARAPACE"
    printf 'FISH_ENABLE_FNM=%s\n' "$FISH_ENABLE_FNM"
    printf 'FISH_ENABLE_MISE=%s\n' "$FISH_ENABLE_MISE"
    printf 'FISH_ENABLE_PYENV=%s\n' "$FISH_ENABLE_PYENV"
    printf 'FISH_ENABLE_ABBR_CONTAINERS=%s\n' "$FISH_ENABLE_ABBR_CONTAINERS"
    printf 'FISH_ENABLE_ABBR_SYSTEMD=%s\n' "$FISH_ENABLE_ABBR_SYSTEMD"
    printf 'FISH_ENABLE_ABBR_JS=%s\n' "$FISH_ENABLE_ABBR_JS"
    printf 'FISH_ENABLE_ABBR_PYTHON=%s\n' "$FISH_ENABLE_ABBR_PYTHON"
}

ensure_terminal "$@"

printf 'Installing Fish config into %s\n' "$target_dir"

if [[ $same_target -eq 0 && -e "$target_dir" ]]; then
    printf 'Backing up existing Fish config to %s\n' "$backup_dir"
    mv "$target_dir" "$backup_dir"
fi

if [[ $same_target -eq 0 ]]; then
    mkdir -p "$target_dir/conf.d" "$target_dir/functions" "$target_dir/completions"

    cp -f "$script_dir/config.fish" "$target_dir/config.fish"
    cp -f "$script_dir/conf.d/"*.fish "$target_dir/conf.d/"
    cp -f "$script_dir/functions/"*.fish "$target_dir/functions/"

    if compgen -G "$script_dir/completions/*.fish" >/dev/null; then
        cp -f "$script_dir/completions/"*.fish "$target_dir/completions/"
    fi

    if [[ -d "$backup_dir" ]]; then
        preserve_file "$backup_dir/fish_variables" "$target_dir/fish_variables"
    fi
else
    printf 'Source directory already matches target; runtime files already live in place.\n'

    if [[ -f "$generated_local" ]]; then
        preserve_file "$generated_local" "$generated_local.backup.${timestamp}"
        printf 'Backed up existing config.local.fish to %s\n' "$generated_local.backup.${timestamp}"
    fi
fi

run_questionnaire
write_config_local
show_summary

printf '\nInstall finished.\n'
printf 'Generated local overrides: %s\n' "$generated_local"

if [[ -d "$backup_dir" ]]; then
    printf 'Backup kept at: %s\n' "$backup_dir"
fi

if command -v fish >/dev/null 2>&1; then
    printf 'Start Fish now with: exec fish\n'
    printf 'Make Fish your default shell with: chsh -s %s\n' "$(command -v fish)"
else
    printf 'Fish is not installed yet. Install it first, then run this script again if needed.\n'
fi
