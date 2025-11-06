#
# ~/.bashrc
#

{ (( EUID == 0 )) || [[ $- != *i* ]]; } && return

## ========== OPTIONS ==========

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

shopt -s histappend cdspell autocd cmdhist histverify

export FUNCNEST=100

export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000

export MAKEFLAGS="-j$(nproc)"

## ========== EXTERNAL SSD ==========

alias mssd='su bash -c "cryptsetup open /dev/sda3 cryptext && mount /dev/mapper/cryptext /mnt"'
alias ussd='su bash -c "umount -R /mnt && cryptsetup close cryptext"'

## ========== MAINTENANCE ==========

alias update='su bash -c "pacman -Sy archlinux-keyring && pacman -Su"'
alias orphans='su pacman -Rcns $(pacman -Qttdq)'
alias circular='su pacman -Rsu --print $(pacman -Qqd)'
alias clean='su bash -c "yes | pacman -Scc"'
alias prune='tac ~/.bash_history | awk "!seen[\$0]++" | tac > ~/.bash_history.new && command mv ~/.bash_history.new ~/.bash_history'

## ========== SANE DEFAULTS ==========

alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias ls='ls -lha --color=always --group-directories-first'
alias grep='grep --color=always'
alias diff='diff --color=always'
alias sudo='su'
alias doas='su'

cd() { builtin cd "$@" && ls; }
su() { command su -p -c "$(printf '%q ' "$@")"; }

## ========== UTILITIES ==========

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.gz)    tar xvzf "$1" ;;
            *.tgz)       tar xvzf "$1" ;;
            *.tar.xz)    tar xvJf "$1" ;;
            *.tar)       tar xvf "$1" ;;
            *.zip)       su bash -c "pacman -S --noconfirm unzip && unzip $1 && pacman -Rcns --noconfirm unzip" ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    fi
}
