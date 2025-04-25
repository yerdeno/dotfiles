# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

export TERM=tmux-256color

set -o vi

PS1="\[\e[35m\]\u\[\e[0m\]@\[\e[36m\]\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ "

command -v thefuck >/dev/null && eval "$(thefuck --alias)"

HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=10000

export EDITOR=vim
export VISUAL=vim

# Функция для замены sudo vim на sudoedit только для файлов, требующих root
function sudo() {
    if [ "$1" = "vim" ]; then
        shift
        if [ -w "$1" ]; then
            command vim "$@"
        else
            command sudoedit "$@"
        fi
    else
        command sudo "$@"
    fi
}

export CLICOLOR=1
alias ls='ls --color=auto -h'
alias ll='ls -lh'
alias la='ls -la'

alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color'

# Basic navigation and system commands
alias q='exit'
alias c='clear'
alias h='history'
alias cs='clear;ls'
alias t='time'
alias k='kill'

# Directory navigation
alias home='cd ~'
alias root='cd /'
alias ..='cd ..'
alias ...='cd ..; cd ..'
alias ....='cd ..; cd ..; cd ..'

# Git aliases
alias g='git'
alias gst='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git commit -m'
alias gpl='git pull'
alias gps='git push'
alias gd='git diff'
alias gds='git diff --staged'
alias glog='git log --oneline --graph --decorate'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Process management
alias ps='ps auxf'
alias top='htop'  # If htop is installed
alias kill9='kill -9'

# Network related
alias myip='curl http://ipecho.net/plain; echo'
alias ports='netstat -tulanp'
alias ping='ping -c 5'
alias header='curl -I'

# Archive handling
alias untar='tar -zxvf'
alias tarup='tar -zcvf'
alias zipup='zip -r'

# Docker aliases
alias d='sudo docker'
alias dc='sudo docker compose'
alias dps='sudo docker ps'
alias dex='sudo docker exec -it'
alias dco='sudo docker compose'
alias dcb='sudo docker compose build'
alias dce='sudo docker compose exec'
alias dcl='sudo docker compose logs'
alias dcp='sudo docker compose ps'
alias dcr='sudo docker compose run'
alias dcs='sudo docker compose start'
alias dct='sudo docker compose stop'

# Python virtual environment
alias venv='python3 -m venv .venv'
alias activate='source .venv/bin/activate'

# Useful functions
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

function findf() {
    find . -type f -name "*$1*"
}

function backup() {
    cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
}

function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Security settings
umask 022

# Enable bash completion if available
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Add custom completion for common commands
complete -F _ssh s
complete -F _scp scp
complete -F _rsync rsync

# Language-specific settings
export PYTHONPATH="${PYTHONPATH}:${HOME}/.local/lib/python3.8/site-packages"
export GOPATH="${HOME}/go"
export PATH="${PATH}:${GOPATH}/bin"

# Add color to man pages
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\e[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\e[0m'        # end mode
export LESS_TERMCAP_se=$'\e[0m'        # end stand-out
export LESS_TERMCAP_so=$'\e[01;33m'    # begin stand-out
export LESS_TERMCAP_ue=$'\e[0m'        # end underline
export LESS_TERMCAP_us=$'\e[1;32m'     # begin underline
