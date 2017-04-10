typeset -A host_repr

tip="❯"

# tip is red when exit code > 0
arrow_enabled="%(?.%{$FG[008]%}.%{$fg[red]%})$tip%{$reset_color%}"
arrow_disabled="%{$FG[008]%}$tip%{$reset_color%}"
arrow=$arrow_enabled

# current folder name
local pwd="%{$fg[blue]%}%c"

# (folder) (remote) (branch) (dirty) (>)
PROMPT='${pwd}$(git_remote_status)%{$FG[012]%}$(git_current_branch)$(parse_git_dirty) ${arrow} %{$reset_color%}'

# simple asterix when dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[014]%}∗"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# arrow pointing up/down depending on remote status
ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE=" "
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" %{$FG[010]%}↑ "
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=" %{$FG[009]%}↓ "
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE=" %{$FG[013]%}× "

# display exit code on the right
return_code_enabled="%(?..%{$fg[red]%}%? ↵%{$reset_color%})%{$reset_color%}"
return_code_disabled=
return_code=$return_code_enabled

RPS1='${return_code}'

function accept-line-or-clear-warning () {
        if [[ -z $BUFFER ]]; then
                arrow=$arrow_disabled
                return_code=$return_code_disabled
        else
                arrow=$arrow_enabled
                return_code=$return_code_enabled
        fi
        zle accept-line
}

precmd () {
    echo -ne "\e]1;$PWD\a"
}

zle -N accept-line-or-clear-warning
bindkey '^M' accept-line-or-clear-warning
