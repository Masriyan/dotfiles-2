local ret_status="%(?:%{$fg_bold[green]%}>:%{$fg_bold[red]%}>)"

KUBE_PS1_PREFIX=""
KUBE_PS1_SYMBOL_PADDING=false
KUBE_PS1_SYMBOL_DEFAULT="k8s"
KUBE_PS1_SEPARATOR=':'
KUBE_PS1_SUFFIX=' '

KUBE_PS1_SYMBOL_COLOR="39"
KUBE_PS1_CTX_COLOR="196"

PROMPT='$(kube_ps1)$(git_prompt_info)%{$fg[cyan]%}$(shrink_path -t -l)${ret_status} %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%} %{$fg[yellow]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}"
