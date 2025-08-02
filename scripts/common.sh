GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
MAGENTA="\033[0;35m"
BOLD="\033[1m"
NC="\033[0m" 

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
