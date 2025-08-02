#!/usr/bin/env bash
# update.sh — Reload dotfiles without relinking

echo "🔄 Reloading configs where possible..."

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
    echo "Reloaded ~/.bashrc"
elif [ -n "$ZSH_VERSION" ] && [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc"
    echo "Reloaded ~/.zshrc"
fi

if [ -f "$HOME/.bash_aliases" ]; then
    source "$HOME/.bash_aliases"
    echo "Reloaded ~/.bash_aliases"
fi

if command -v tmux >/dev/null && [ -f "$HOME/.tmux.conf" ]; then
    tmux source-file "$HOME/.tmux.conf" 2>/dev/null && \
    echo "Reloaded ~/.tmux.conf"
fi

echo "✅ Reload complete."

