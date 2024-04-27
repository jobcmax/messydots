export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="dollar"
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias bashupl="curl bashupload.com -T"
alias k="kill"
alias kall="killall"
alias fetch="minfetch"
alias music="mpd && ncmpcpp"
alias l="exa -l"
alias ls="exa"
alias subfind="subfinder -d"
alias cl="clear"
alias v="nvim"
alias hc="history -c"
alias wrp="warp-cli"
alias dl="aria2c"

ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[alias]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=yellow,bold
ZSH_HIGHLIGHT_STYLES[assign]=none

if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P0101419
  \e]P1e05f65
  \e]P278dba9
  \e]P3f1cf8a
  \e]P470a5eb
  \e]P5c68aee
  \e]P674bee9
  \e]P7dee1e6
  \e]P81f2328
  \e]P9e5646a
  \e]PA94f7c5
  \e]PBf6d48f
  \e]PC75aaf0
  \e]PDcb8ff3
  \e]PE79c3ee
  \e]PFe3e6eb
  "
  clear
fi


calc() {
	echo "scale=5; $*" | bc
}

command_not_found_handler() {
	echo -e "\e[37mwhar:\e[0m $0"
	return 1
}

export SUDO_PROMPT=$'pass for \033[1;36;48m%u\033[1;37;0m: '

export NPM_CONFIG_PREFIX=~/.npm-global
