if [ -f "$HOME/.commonrc" ]; then 
    . "$HOME/.commonrc"
fi

# Load alias definitions
if [ -f "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"
fi

git_branch_info() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

        if [[ -d .git/rebase-merge || -d .git/rebase-apply || -f .git/MERGE_HEAD ]]; then
            echo -e "\033[31m[$branch|MERGING]\033[0m"
        elif [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
            echo -e "\033[33m[$branch*]\033[0m"
        else
            echo -e "\033[32m[$branch]\033[0m"
        fi
    fi
}

PROMPT_COMMAND='GIT_BRANCH=$(git_branch_info)'
PS1='\[\e[1;38;5;27m\]\u\[\e[0m\] \w${GIT_BRANCH:+ ${GIT_BRANCH}} \$ '

if [ -f "$HOME/.bashrc.local" ]; then
    . "$HOME/.bashrc.local"
fi
