# the idea of this theme is to contain a lot of info in a small string, by
# compressing some parts and colorcoding, which bring useful visual cues,
# while limiting the amount of colors and such to keep it easy on the eyes.
# When a command exited >0, the timestamp will be in red and the exit code
# will be on the right edge.
# The exit code visual cues will only display once.
# (i.e. they will be reset, even if you hit enter a few times on empty command prompts)

typeset -A host_repr

btip="➤ "
tip="❯"

# local time, color coded by last return code
arrow_enabled="%(?.%{$FG[008]%}.%{$fg[red]%})$tip%{$reset_color%}"
arrow_disabled="%{$FG[008]%}$tip%{$reset_color%}"
arrow=$arrow_enabled

# Compacted $PWD
local pwd="%{$fg[blue]%}%c%{$reset_color%}"

PROMPT='${arrow} ${pwd} $(git_prompt_info)'

# i would prefer 1 icon that shows the "most drastic" deviation from HEAD,
# but lets see how this works out
ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[012]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[cyan]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# elaborate exitcode on the right when >0
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
