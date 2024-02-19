#!/bin/bash

# Colors
reset_color=""
placeholder_color=""
user_color=""
directory_color=""

# Import scripts
SCRIPTS="$HOME/.dotfiles/.config/bash"

source "$SCRIPTS/default_bash.sh"
source "$SCRIPTS/focus_on_project.sh"
source "$SCRIPTS/git_parser.sh"
source "$SCRIPTS/venv_parser.sh"

############################

# Helper function to check if a command exists
command_exists() {
    type "$1" >/dev/null 2>&1
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

    local info_length=${#info}
    echo -n "$placeholder_color$info$reset_color"
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
}

show_placeholder() {
    parse_placeholder
    sleep 1
    tput ed
}

# Calling functions each time
PROMPT_COMMAND="set_working_directory;init;(show_placeholder &);"

############################

# Aliases

# Shortcuts
