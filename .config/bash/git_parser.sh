# Git Symbols
untracked_symbol="-"
staged_symbol="+"
committed_symbol="^"

# Git
parse_git_dirty() {
    local status_output=$(git status -sb --porcelain)
    local info=""

    local untracked_count=$(echo "$status_output" | grep -c '^??')
    local staged_count=$(echo "$status_output" | grep -c '^A\|^M\|^D')
    local committed_count=$(echo "$status_output" | grep -oP '\[\K[^\]]+' | grep -oP 'ahead \K\d+' | awk '{print $1}')

    if ((untracked_count > 0)); then
        info+="$untracked_symbol$untracked_count"
    fi
    if ((staged_count > 0)); then
        info+="$staged_symbol$staged_count"
    fi
    if ((committed_count > 0)); then
        info+="$committed_symbol$committed_count"
    fi

    echo "$info"
}

parse_git_branch() {
    local branch=$(git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ \1$(parse_git_dirty)/")
    echo ${branch:-}
}