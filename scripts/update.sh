#!/usr/bin/env bash
# update.sh — Reload dotfiles without relinking

source "$(dirname "$0")/common.sh"

echo "🔄 Reloading configs where possible..."

user_shell="$(detect_shell)"
echo "Detected shell for setup: $user_shell" 

if [ "$user_shell" = "bash" ]; then
    source "$HOME/.bashrc"
    echo "Reloaded ~/.bashrc"
elif [ "$user_shell" = "zsh" ]; then
    source "$HOME/.zshrc"
    echo "Reloaded ~/.zshrc"
else
    echo "⚠️  Unsupported shell: $user_shell. Skipping shell config reloading."
fi

if command -v tmux >/dev/null && [ -f "$HOME/.tmux.conf" ]; then
    tmux source-file "$HOME/.tmux.conf" 2>/dev/null && \
    echo "Reloaded ~/.tmux.conf"
fi

echo "✅ Reload complete."

