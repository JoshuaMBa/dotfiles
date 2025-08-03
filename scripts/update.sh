# update.sh — Reload dotfiles without relinking

source "$(dirname "$0")/common.sh"

echo -e "${BLUE}🔄 Reloading configs where possible...${NC}"

user_shell="$(detect_shell)"
echo -e "${BOLD}Detected shell for update:${NC} ${MAGENTA}$user_shell${NC}"

if [ "$user_shell" = "bash" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
        echo -e "${GREEN}✔ Reloaded${NC} ~/.bashrc"
    else
        echo -e "${YELLOW}⚠ ~/.bashrc not found${NC}"
    fi
elif [ "$user_shell" = "zsh" ]; then
    if [ -f "$HOME/.zshrc" ]; then
        source "$HOME/.zshrc"
        echo -e "${GREEN}✔ Reloaded${NC} ~/.zshrc"
    else
        echo -e "${YELLOW}⚠ ~/.zshrc not found${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Unsupported shell:${NC} $user_shell — skipping shell config reloading."
fi

if { command -v tmux >/dev/null; } && [ -f "$HOME/.tmux.conf" ]; then
    tmux source-file "$HOME/.tmux.conf" 2>/dev/null && \
    echo -e "${GREEN}✔ Reloaded${NC} ~/.tmux.conf"
fi

echo -e "${GREEN}✅ Reload complete.${NC}"

