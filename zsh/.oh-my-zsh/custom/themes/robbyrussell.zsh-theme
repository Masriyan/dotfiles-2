local ret_status="%(?:%{$fg_bold[green]%}>:%{$fg_bold[red]%}>)"
PROMPT='$(git_prompt_info)%{$fg[cyan]%}$(shrink_path -t -l)${ret_status} %{$reset_color%}'
PROMPT='$(kube_ps1)'$PROMPT

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%} %{$fg[yellow]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}"
