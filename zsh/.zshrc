# language environment
export LANG=en_US.UTF-8

# path to oh-my-zsh installation.
export ZSH="/Users/eeshaan/.oh-my-zsh"
ZSH_THEME="spaceship" # https://github.com/denysdovhan/spaceship-prompt

# plugins
plugins=(git zsh-autosuggestions zsh-completions)

# scripts
source $ZSH/oh-my-zsh.sh
source $(dirname $(gem which colorls))/tab_complete.sh

# preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

# aliases
eval $(thefuck --alias)
alias pro="cd ~/Desktop/_programming"
alias lc="colorls -A --sd"

# (foot) bindings
bindkey '^ ' autosuggest-accept
bindkey '[C' forward-word
bindkey '[D' backward-word
