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