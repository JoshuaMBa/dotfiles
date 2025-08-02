#!/usr/bin/env bash
# setup.sh — Symlink dotfiles from ~/dotfiles to $HOME

DOTFILES_DIR="$(pwd)"

link_file() {
    src="$1"
    dest="$2"

    mkdir -p "$(dirname "$dest")" 
 
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ "$(readlink -- "$dest")" != "$src" ]; then
            mv "$dest" "$dest.backup"
            echo "Backed up $dest → $dest.backup"
        fi
    fi

    ln -sf "$src" "$dest"
    echo "Linked $dest → $src"
}

echo "🔗 Linking dotfiles from $DOTFILES_DIR to $HOME..."

if [ -f "$DOTFILES_DIR/.bashrc" ]; then
    link_file "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc" 
fi

if [ "$(basename "$SHELL")" = "zsh" ]; then
    ln -sf "$HOME/.bashrc" "$HOME/.zshrc"
    echo "Linked ~/.zshrc → ~/.bashrc"
fi

[ -f "$DOTFILES_DIR/.bash_aliases" ] && link_file "$DOTFILES_DIR/.bash_aliases" "$HOME/.bash_aliases"
[ -f "$DOTFILES_DIR/.gitconfig" ] && link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
[ -f "$DOTFILES_DIR/.vimrc" ] && link_file "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
[ -f "$DOTFILES_DIR/.tmux.conf" ] && link_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

if [ -d "$DOTFILES_DIR/.vscode" ]; then
    case "$(uname -s)" in
        Linux)
            VSCODE_USER_DIR="$HOME/.config/Code/User"
            ;;
        Darwin)
            VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            VSCODE_USER_DIR="$(cygpath $APPDATA)/Code/User"
            ;;
        *)
            echo "⚠️ Unknown OS: $(uname -s), skipping VSCode configs."
            VSCODE_USER_DIR=""
            ;;
    esac

    if [ -n "$VSCODE_USER_DIR" ]; then
        link_file "$DOTFILES_DIR/.vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
        link_file "$DOTFILES_DIR/.vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
    fi
fi

if [ -f "$DOTFILES_DIR/update.sh" ]; then 
    source "$DOTFILES_DIR/update.sh"
fi

echo "✅ Done. Your dotfiles are now active."
