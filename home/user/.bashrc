#
# ~/.bashrc
#

[[ $- != *i* ]] && return
[[ "$(whoami)" = "root" ]] && return
[[ -z "$FUNCNEST" ]] && export FUNCNEST=100

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

shopt -s histappend cdspell autocd cmdhist histverify

export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000

alias mssd='doas bash -c "cryptsetup open /dev/sda3 cryptext && mount /dev/mapper/cryptext /mnt"'
alias ussd='doas bash -c "umount -R /mnt && cryptsetup close cryptext"'

alias update='doas bash -c "pacman -Sy --needed archlinux-keyring && pacman -Su"'
alias orphans='doas pacman -Rcns $(pacman -Qttdq)'
alias clean='yes | doas pacman -Scc'

alias sudo='doas'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias ls='ls -lha --color=auto --group-directories-first'
alias grep='grep --color=auto'

cd() { builtin cd "$@" && ls; }

prune() { tac ~/.bash_history | awk '!seen[$0]++' | tac > ~/.bash_history.new && command mv ~/.bash_history.new ~/.bash_history; }

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.gz)    tar xvzf "$1" ;;
            *.tgz)       tar xvzf "$1" ;;
            *.tar.xz)    tar xvJf "$1" ;;
            *.tar)       tar xvf "$1" ;;
            *.zip)       doas pacman -S --noconfirm unzip && unzip "$1" && doas pacman -Rcns --noconfirm unzip ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    fi
}
