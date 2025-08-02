#!/usr/bin/env bash
# setup.sh — Symlink dotfiles from ~/dotfiles to $HOME

DOTFILES_DIR="$(pwd)"

source "$DOTFILES_DIR/scripts/common.sh"

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

if [[ "$(uname)" == "Darwin" ]]; then  
    echo "🍏 Running macOS defaults setup"    
    if [[ -f $DOTFILES_DIR/com.apple.Terminal.plist ]]; then
        echo "📦 Importing Terminal.app preferences...(restart Terminal to view changes)"
        defaults import com.apple.Terminal $DOTFILES_DIR/.com.apple.Terminal.plist 
    else
        echo "⚠️  No Terminal.app preferences found in ~/dotfiles."
    fi

    # Allow repeated keystrokes (used for VSCodeVim)
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false 
fi

echo "🔗 Linking dotfiles from $DOTFILES_DIR to $HOME..."

user_shell="$(detect_shell)"
echo "Detected shell for setup: $user_shell" 

if [ "$user_shell" = "bash" ]; then
    [ -f "$DOTFILES_DIR/.bashrc" ] && link_file "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
    [ -f "$DOTFILES_DIR/.bash_aliases" ] && link_file "$DOTFILES_DIR/.bash_aliases" "$HOME/.bash_aliases"
    [ -f "$DOTFILES_DIR/.common_aliases" ] && link_file "$DOTFILES_DIR/.common_aliases" "$HOME/.common_aliases"
    [ -f "$DOTFILES_DIR/.commonrc" ] && link_file "$DOTFILES_DIR/.commonrc" "$HOME/.commonrc"
elif [ "$user_shell" = "zsh" ]; then
    [ -f "$DOTFILES_DIR/.zshrc" ] && link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    [ -f "$DOTFILES_DIR/.zsh_aliases" ] && link_file "$DOTFILES_DIR/.zsh_aliases" "$HOME/.zsh_aliases"
    [ -f "$DOTFILES_DIR/.common_aliases" ] && link_file "$DOTFILES_DIR/.common_aliases" "$HOME/.common_aliases"
    [ -f "$DOTFILES_DIR/.commonrc" ] && link_file "$DOTFILES_DIR/.commonrc" "$HOME/.commonrc"
else
    echo "⚠️  Unsupported shell: $user_shell. Skipping shell config linking."
fi

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
            echo "⚠️  Unknown OS: $(uname -s), skipping VSCode configs."
            VSCODE_USER_DIR=""
            ;;
    esac

    if [ -n "$VSCODE_USER_DIR" ]; then
        link_file "$DOTFILES_DIR/.vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
        link_file "$DOTFILES_DIR/.vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
    else 
            echo "⚠️  $VSCODE_USER_DIR not found, skipping VSCode configs"
    fi
fi

if [ -f "$DOTFILES_DIR/scripts/update.sh" ]; then 
    source "$DOTFILES_DIR/scripts/update.sh"
fi

echo "✅ Done. Your dotfiles are now active."
