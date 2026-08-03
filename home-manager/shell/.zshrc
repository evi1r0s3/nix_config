# https://github.com/zsh-users/zsh-autosuggestions/issues/511
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)

alias ls='lsd'
alias tree='lsd --tree'
alias se='sudo -E'

bindkey -e

eval "$(starship init zsh)"
# atuin init
eval "$(atuin init zsh --disable-ctrl-r)"
# hook direnv
eval "$(direnv hook zsh)"
