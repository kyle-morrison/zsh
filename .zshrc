alias ls='ls --color=auto'
autoload -Uz promptinit
promptinit
prompt adam1
#For dynamic displaying of prompt
setopt prompt_subst

#Enable colors
autoload -U colors
colors

bindkey -v 
bindkey jk vi-cmd-mode
bindkey -M vicmd ',d' vi-end-of-line 
bindkey -M vicmd ',s' vi-beginning-of-line 
bindkey -M vicmd ',a' vi-add-eol
bindkey -M vicmd ',f' vi-find-prev-char
bindkey -M vicmd ',w' vi-find-prev-char-skip
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward
bindkey -M vicmd "k" history-beginning-search-backward 
bindkey -M vicmd "j" history-beginning-search-forward

#updates when mode changes
#Code for mode indicator persisting over multline zsh prompt found from:
#http://pawelgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/comment-page-1/
vim_ins_mode="%{$fg[yellow]%}[INSERT]%{$reset_color%}"
vim_cmd_mode="%{$fg[red]%}[NORMAL]%{$reset_color%}"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish

# Fix a bug when you C-c in CMD mode and you'd be prompted with CMD mode indicator, while in fact you would be in INS mode
# Fixed by catching SIGINT (C-c), set vim_mode to INS and then repropagate the SIGINT, so if anything else depends on it, we will not break it
function TRAPINT() {
  vim_mode=$vim_ins_mode
  return $(( 128 + $1 ))
} 
RPROMPT='${vim_mode}'

#Source fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
