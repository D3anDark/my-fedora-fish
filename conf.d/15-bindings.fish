status is-interactive; or return

if contains -- "$FISH_ENABLE_ATUIN" 1 yes true on
    if functions -q _atuin_search
        bind \cr _atuin_search
        bind -M insert \cr _atuin_search
    end
end
