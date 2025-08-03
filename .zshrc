if [ -f "$HOME/.commonrc" ]; then 
    . "$HOME/.commonrc"
fi

if [ -f "$HOME/.zsh_aliases" ]; then
    . "$HOME/.zsh_aliases"
fi

setopt PROMPT_SUBST

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '[%b]'
zstyle ':vcs_info:git:*' actionformats '[%b|%a]'

precmd() {
    vcs_info
    if [[ -n ${vcs_info_msg_0_} ]]; then
        if [[ -d .git/rebase-merge || -d .git/rebase-apply || -f .git/MERGE_HEAD ]]; then
            vcs_info_msg_0_="%F{red}${vcs_info_msg_0_}%f"
        elif [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
            branch_with_star="${vcs_info_msg_0_/%]/*]}"
            vcs_info_msg_0_="%F{yellow}${branch_with_star}%f"
        else
            vcs_info_msg_0_="%F{green}${vcs_info_msg_0_}%f"
        fi
    fi
}

PROMPT='%B%F{27}%n%f%b %~${vcs_info_msg_0_:+ ${vcs_info_msg_0_}} $ '

if [ -f "$HOME/.zshrc.local" ]; then
    . "$HOME/.zshrc.local"
fi
