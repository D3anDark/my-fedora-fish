status is-interactive; or return

function __abbr_last_history_item
    echo $history[1]
end

abbr --add bangbang --position anywhere --regex '^!!$' --function __abbr_last_history_item

abbr --add c clear
abbr --add q exit
abbr --add .. 'cd ..'
abbr --add ... 'cd ../..'
abbr --add md 'mkdir -p'
abbr --add rd 'rmdir'

abbr --add g git
abbr --add gs 'git status'
abbr --add ga 'git add'
abbr --add gaa 'git add -A'
abbr --add gc 'git commit'
abbr --add gca 'git commit --amend'
abbr --add gp 'git push'
abbr --add gl 'git pull'
abbr --add gb 'git branch'
abbr --add gco 'git checkout'
abbr --add gsw 'git switch'
abbr --add gd 'git diff'
abbr --add glog 'git log --oneline --graph --decorate -n 20'

if command -q dnf
    abbr --add up 'dnf upgrade --refresh'
    abbr --add inst 'dnf install'
    abbr --add rmf 'dnf remove'
    abbr --add se 'dnf search'
    abbr --add copri 'dnf copr enable'
end

if command -q eza
    abbr --add l 'eza --icons=auto'
    abbr --add la 'eza -a --icons=auto'
    abbr --add ll 'eza -lah --group-directories-first --icons=auto'
    abbr --add lt 'eza --tree --level=2 --icons=auto'
else if command -q lsd
    abbr --add l 'lsd --icon=auto'
    abbr --add la 'lsd -a --icon=auto'
    abbr --add ll 'lsd -lah --group-dirs=first --icon=auto'
    abbr --add lt 'lsd --tree --depth=2 --icon=auto'
else
    abbr --add l 'ls'
    abbr --add la 'ls -a'
    abbr --add ll 'ls -lah'
end

if contains -- "$FISH_ENABLE_BAT_CAT" 1 yes true on
    if command -q bat
        abbr --add cat 'bat --style=plain --paging=never'
    else if command -q batcat
        abbr --add cat 'batcat --style=plain --paging=never'
    end
end

if contains -- "$FISH_ENABLE_ABBR_CONTAINERS" 1 yes true on
    if command -q docker
        abbr --add d docker
        abbr --add dc 'docker compose'
        abbr --add dcu 'docker compose up'
        abbr --add dcd 'docker compose down'
        abbr --add dcb 'docker compose build'
        abbr --add dps 'docker ps'
        abbr --add di 'docker images'
        abbr --add dex 'docker exec -it'
    end

    if command -q podman
        abbr --add p podman
        abbr --add pc 'podman compose'
        abbr --add pps 'podman ps'
        abbr --add pi 'podman images'
        abbr --add pex 'podman exec -it'
    end
end

if contains -- "$FISH_ENABLE_ABBR_SYSTEMD" 1 yes true on
    if command -q systemctl
        abbr --add sc systemctl
        abbr --add scs 'systemctl status'
        abbr --add scr 'systemctl restart'
        abbr --add scst 'systemctl start'
        abbr --add scsp 'systemctl stop'
        abbr --add sce 'systemctl enable --now'
        abbr --add scu 'systemctl --user'
    end

    if command -q journalctl
        abbr --add j journalctl
        abbr --add ju 'journalctl -u'
        abbr --add juf --set-cursor 'journalctl -u % --follow'
        abbr --add jb 'journalctl -b'
    end
end

if contains -- "$FISH_ENABLE_ABBR_JS" 1 yes true on
    if command -q pnpm
        abbr --add pn pnpm
        abbr --add pni 'pnpm install'
        abbr --add pna 'pnpm add'
        abbr --add pnd 'pnpm add -D'
        abbr --add pnr 'pnpm run'
        abbr --add pnt 'pnpm test'
        abbr --add pnx 'pnpm dlx'
    end

    if command -q npm
        abbr --add ni 'npm install'
        abbr --add nid 'npm install --save-dev'
        abbr --add nr 'npm run'
        abbr --add nt 'npm test'
        abbr --add nx npx
    end

    if command -q bun
        abbr --add b bun
        abbr --add bi 'bun install'
        abbr --add ba 'bun add'
        abbr --add br 'bun run'
        abbr --add bt 'bun test'
        abbr --add bx 'bun x'
    end
end

if contains -- "$FISH_ENABLE_ABBR_PYTHON" 1 yes true on
    if command -q uv
        abbr --add uva 'uv add'
        abbr --add uvr 'uv run'
        abbr --add uvs 'uv sync'
        abbr --add uvx 'uvx'
        abbr --add uvv 'uv venv'
    end

    if command -q python3
        abbr --add py python3
        abbr --add pym 'python3 -m'
        abbr --add pyi 'python3 -m pip install'
        abbr --add pyv 'python3 -m venv .venv'
    else if command -q python
        abbr --add py python
        abbr --add pym 'python -m'
        abbr --add pyi 'python -m pip install'
        abbr --add pyv 'python -m venv .venv'
    end

    if command -q pip3
        abbr --add ppi 'pip3 install'
        abbr --add ppu 'pip3 uninstall'
        abbr --add ppl 'pip3 list'
    else if command -q pip
        abbr --add ppi 'pip install'
        abbr --add ppu 'pip uninstall'
        abbr --add ppl 'pip list'
    end
end
