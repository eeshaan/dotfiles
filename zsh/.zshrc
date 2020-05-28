# language environment
export LANG=en_US.UTF-8

# path to oh-my-zsh installation.
export ZSH="/Users/eeshaan/.oh-my-zsh"
ZSH_THEME="spaceship" # https://github.com/denysdovhan/spaceship-prompt

# plugins
plugins=(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting)

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
alias pipes="pipes.sh -c 1234567"

# (foot) bindings
bindkey '^ ' autosuggest-accept
bindkey '[C' forward-word
bindkey '[D' backward-word

get_uptime() {
  s=$(sysctl -n kern.boottime)

  # Extract the uptime in seconds from the following output:
  # [...] { sec = 1271934886, usec = 667779 } Thu Apr 22 12:14:46 2010
  s=${s#*=}
  s=${s%,*}

  # The uptime format from 'sysctl' needs to be subtracted from
  # the current time in seconds.
  s=$(($(date +%s) - s))

  # Convert the uptime from seconds into days, hours and minutes.
  d=$((s / 60 / 60 / 24))
  h=$((s / 60 / 60 % 24))
  m=$((s / 60 % 60))

  # Only append days, hours and minutes if they're non-zero.
  [ "$d" = 0 ] || uptime="${uptime}${d}d "
  [ "$h" = 0 ] || uptime="${uptime}${h}h "
  [ "$m" = 0 ] || uptime="${uptime}${m}m "

  printf "\n\033[32;1muptime\033[0m ${uptime}"
}

get_memory() {
  mem_full=$(($(sysctl -n hw.memsize) / 1024 / 1024))

  # Parse the 'vmstat' file splitting on ':' and '.'.
  # The format of the file is 'key:   000.' and an additional
  # split is used on '.' to filter it out.
  while IFS=:. read -r key val; do
    case $key in
      *' wired'*|*' active'*|*' occupied'*)
        mem_used=$((mem_used + ${val:-0}))
      ;;
    esac

  # Using '<<-EOF' is the only way to loop over a command's
  # output without the use of a pipe ('|').
  # are still accessible in the script.
  done <<-EOF
    $(vm_stat)
	EOF

  mem_used=$((mem_used * 4 / 1024))

  printf "\n\033[32;1mmemory\033[0m ${mem_used:-?}MB / ${mem_full:-?}MB"
}

# call the functions — based on https://github.com/dylanaraps/pfetch/blob/master/pfetch#L381
get_uptime
get_memory
