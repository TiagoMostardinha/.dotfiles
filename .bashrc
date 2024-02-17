#!/bin/bash

# Symbols
untracked_symbol="-"
staged_symbol="+"
committed_symbol="^"

# Colors
reset_color="\e[0m"
placeholder_color="\e[1;90m"
user_color="\e[1;32m"
directory_color="\e[1;34m"

# Helper function to check if a command exists
command_exists() {
    type "$1" >/dev/null 2>&1
}

# Focus on project
toggle_focus_on_project() {
    if [ -z "$focus_on_project" ]; then
        focus_on_project=$PWD
    else
        focus_on_project=""
    fi
}

set_working_directory() {
    if [ -n "$focus_on_project" ] && [[ ! $PWD == $focus_on_project/* ]]; then
        cd "$focus_on_project" || exit
    fi
}

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

# Virtual ENV
parse_virtual_env() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "$(basename "$VIRTUAL_ENV") "
    fi
}

# Placeholder
parse_placeholder() {
    local info=""

    info+=$(parse_virtual_env)

    if git status &>/dev/null; then
        info+=$(parse_git_branch)
    fi

    if [ -z "$info" ]; then
        return
    fi

    echo -n "$placeholder_color$info$reset_color"
    info_length=${#info}
    tput cub $info_length

}

# Main function
init() {
    PS1="$user_color\u$reset_color"

    PS1+=" $directory_color["
    if [ -n "$focus_on_project" ]; then
        PS1+=":/$(basename "$focus_on_project")${PWD#$focus_on_project}"
    else
        PS1+="\w"
    fi
    PS1+="]$reset_color\$ "

    local placeholder=$(parse_placeholder)
    if [ -n "$placeholder" ]; then
        PS1+="$placeholder"
    fi
}

clear_prompt() {
    sleep 1
    tput el
}

# Calling functions each time
PROMPT_COMMAND="set_working_directory;init;(clear_prompt &);"

# Aliases
