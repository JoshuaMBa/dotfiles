detect_shell() { 
    if [ -n "$BASH_VERSION" ]; then
        echo "bash"
        return
    fi
 
    if [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
        return
    fi

    echo "$(basename "$SHELL")"
}
