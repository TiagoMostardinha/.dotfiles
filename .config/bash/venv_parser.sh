# Virtual ENV
parse_virtual_env() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "$(basename "$VIRTUAL_ENV") "
    fi
}