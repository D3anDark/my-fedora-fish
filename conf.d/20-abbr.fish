status is-interactive; or return

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
