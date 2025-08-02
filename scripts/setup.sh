# setup.sh — Symlink dotfiles from ~/dotfiles to $HOME

source "$(dirname "$0")/common.sh"

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

link_file() {
    src="$1"
    dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ "$(readlink "$dest" 2>/dev/null || true)" != "$src" ]; then
            backup="$dest.backup.$(date +%s)"
            mv "$dest" "$backup"
            echo -e "${YELLOW}Backed up${NC} $dest → $backup"
        fi
    fi

    ln -sf "$src" "$dest"
    echo -e "${GREEN}Linked${NC} $dest → $src"
}

if [[ "$(uname)" == "Darwin" ]]; then  
    echo -e "${MAGENTA}🍏 Running macOS defaults setup${NC}"    
    if [[ -f $DOTFILES_DIR/.com.apple.Terminal.plist ]]; then
        echo -e "${BLUE}📦 Importing Terminal.app preferences... (restart Terminal to view changes)${NC}"
        defaults import com.apple.Terminal "$DOTFILES_DIR/.com.apple.Terminal.plist" 
    else
        echo -e "${YELLOW}⚠️  No Terminal.app preferences found in ~/dotfiles.${NC}"
    fi

    # Allow repeated keystrokes (used for VSCodeVim)
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false 
fi

echo -e "${BLUE}🔗 Linking dotfiles from $DOTFILES_DIR to $HOME...${NC}"

## Shell setup
user_shell="$(detect_shell)"
echo -e "${BOLD}Detected shell for setup:${NC} ${MAGENTA}$user_shell${NC}" 

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
    echo -e "${YELLOW}⚠️  Unsupported shell:${NC} $user_shell. Skipping shell config linking."
fi

## Git setup
[ -f "$DOTFILES_DIR/.gitconfig" ] && link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
git_name="$(git config user.name)"
git_email="$(git config user.email)"

GITCONFIG_LOCAL="$HOME/.gitconfig.local"

if [ -n "$git_name" ] && [ -n "$git_email" ]; then
    echo -e "${GREEN}✔ Git user info already set:${NC}"
    echo -e "   Name : $git_name"
    echo -e "   Email: $git_email"
else
    echo -e "${YELLOW}⚠ Git user.name and/or user.email not set.${NC}"
    printf "Enter your Git user name: "
    read git_name
    printf "Enter your Git email: "
    read git_email
fi

if ! grep -q "^\[user\]" "$GITCONFIG_LOCAL" 2>/dev/null; then
    cat >> "$GITCONFIG_LOCAL" <<EOF

[user]
    name = $git_name
    email = $git_email
EOF
    echo -e "${GREEN}✔ Git user info saved to${NC} $GITCONFIG_LOCAL"
else
    echo -e "${BLUE}ℹ [user] section already exists in${NC} $GITCONFIG_LOCAL — skipping."
fi

## vim and tmux setup
[ -f "$DOTFILES_DIR/.vimrc" ] && link_file "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
[ -f "$DOTFILES_DIR/.tmux.conf" ] && link_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
[ -f "$DOTFILES_DIR/.jb_name_ascii_art" ] && link_file "$DOTFILES_DIR/.jb_name_ascii_art" "$HOME/.jb_name_ascii_art"

## VSCode Setup
if [ -d "$DOTFILES_DIR/.vscode" ]; then
    case "$(uname -s)" in
        Linux)
            VSCODE_USER_DIR="$HOME/.config/Code/User"
            ;;
        Darwin)
            VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            VSCODE_USER_DIR="$(cygpath "$APPDATA")/Code/User"
            ;;
        *)
            echo -e "${YELLOW}⚠️  Unknown OS:$(uname -s), skipping VSCode configs.${NC}"
            VSCODE_USER_DIR=""
            ;;
    esac

    if [ -n "$VSCODE_USER_DIR" ]; then
        [ -f "$DOTFILES_DIR/.vscode/settings.json" ] && link_file "$DOTFILES_DIR/.vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
        [ -f "$DOTFILES_DIR/.vscode/keybindings.json" ] && link_file "$DOTFILES_DIR/.vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
    else 
        echo -e "${YELLOW}⚠️  $VSCODE_USER_DIR not found, skipping VSCode configs${NC}"
    fi
fi

if [ -f "$DOTFILES_DIR/scripts/update.sh" ]; then 
    source "$DOTFILES_DIR/scripts/update.sh"
fi

echo -e "${GREEN}✅ Done. Your dotfiles are now active.${NC}"
