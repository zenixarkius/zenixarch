# shellcheck shell=bash disable=2046,2155,2329

[[ -z ${DISPLAY} && $(tty) == /dev/tty1 && ${HYPRLAND} != y ]] && start-hyprland && export HYPRLAND=y
{ (( EUID == 0 )) || [[ $- != *i* ]]; } && return

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

shopt -s histappend cdspell autocd cmdhist histverify

export PS1='\[\e[94m\]\[\e[1m\]\u\[\e[0m\]@\h \[\e[1m\]\w\[\e[0m\] \$ '
export FUNCNEST=100

export EDITOR=nvim
export VISUAL=nvim

export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=2000
export HISTSIZE=2000
export PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND}"

alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -iv'
alias mkdir='mkdir -p'
alias ls='ls -lha --color=always --group-directories-first'
alias grep='grep --color=always'
alias diff='diff --color=always'
alias fwd='cd ${OLDPWD}'

cd() { builtin cd "$@" && ls; }

sudo() { su -p -c "$(printf '%q ' "$@")"; }
export -f sudo

mssd() { sudo bash -c "cryptsetup open /dev/sd*3 cryptext && mount /dev/mapper/cryptext /mnt"; }
ussd() { sudo bash -c "umount -R /mnt && cryptsetup close cryptext"; }

disk() { sudo du -h -d1 --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/run --exclude=/tmp --exclude=/mnt /; }
ztop() { watch -t -n 0.25 "uptime; free -h; cat /proc/cpuinfo | grep MHz; nvidia-smi -q | grep MHz"; }

search() { sudo find / \( -path /proc -o -path /sys -o -path /dev -o -path /run -o -path /tmp \) -prune -o -iname "*$**" -print; }

clean() {
  _cache() { yes | pacman -Scc; }
  _logs() { journalctl --rotate && journalctl --vacuum-time=1s; }
  _orphans() { pacman -Rcns $(pacman -Qttdq); pacman -Runs $(pacman -Qqd); }
  _history() { tac ~/.bash_history | awk '!seen[$0]++' | tac > ~/.bash_history.new && command mv ~/.bash_history.new ~/.bash_history; }
  export -f _cache _logs _orphans

  case "$1" in
    -c|--cache) sudo bash -c _cache ;;
    -l|--logs) sudo bash -c _logs ;;
    -o|--orphans) sudo bash -c _orphans ;;
    -h|--history) _history ;;
    -a|--all) sudo bash -c '_cache; _logs; _orphans'; _history ;;
  esac

  unset -f _cache _logs _orphans
}

vpn() {
  case "$1" in
    set) sudo bash -c "ln -sf '/etc/wireguard/configs/$2.conf' /etc/wireguard/wg0.conf && wg-quick down wg0 && wg-quick up wg0" ;;
    shuffle) sudo bash -c 'wg show &>/dev/null && wg-quick down wg0; ln -sf "$(find /etc/wireguard/configs -name "*.conf" -print | shuf -n 1)" /etc/wireguard/wg0.conf && wg-quick up wg0' ;;
  esac
  curl -s https://am.i.mullvad.net/connected
}

leftovers() {
  local filters=(/home/user/{.bash_logout,.bash_history,.bash_profile,.bashrc,.cache,.config,.gitconfig,.gnupg,.password-store,.local,.mullvad,.config/{dconf,hypr,gtk-3.0,nvim,Signal}} /etc/{adjtime,alsa,arch-release,arptables.conf,audisp,audit,avahi,bash.bash_logout,bash.bashrc,bash_completion.d,bindresvport.blacklist,ca-certificates,conf.d,credstore,credstore.encrypted,crypttab,dconf,debuginfod,default,e2scrub.conf,ebtables.conf,environment,ethertypes,fonts,fstab,gai.conf,gnutls,gprofng.rc,group,group-,gshadow,gshadow-,gtk-3.0,healthd.conf,host.conf,hosts,initcpio,inputrc,iptables,issue,iwd,krb5.conf,ld.so.cache,ld.so.conf,libaudit.conf,libnl,libva.conf,locale.conf,locale.gen,localtime,login.defs,machine-id,mailcap,makepkg.conf,makepkg.conf.d,mime.types,mke2fs.conf,mkinitcpio.conf,mkinitcpio.d,modprobe.d,mtab,netconfig,nftables.conf,nginx,nsswitch.conf,nvidia,openldap,openrgb,os-release,pacman.conf,pacman.d,pam.d,passwd,passwd-,pipewire,pkcs11,polkit-1,profile,profile.d,protocols,pulse,.pwd.lock,rc_keymaps,rc_maps.cfg,request-key.conf,resolv.conf,rpc,securetty,security,sensors3.conf,services,shadow,shadow-,shells,skel,ssh,ssl,subgid,subgid-,subuid,subuid-,systemd,tpm2-tss,ts.conf,udev,.updated,userdb,vconsole.conf,vdpau_wrapper.cfg,wireguard,X11,xattr.conf,xdg} /var/{cache/{fontconfig,ldconfig,private},lib/{dbus,iwd,krb5kdc,lastlog,libuuid,libvirt,machines,pacman,portables,private,sbctl,systemd,tpm2-tss,xkb},log/{audit,btmp,lastlog,old,pacman.log,private,README,wtmp}})

  echo LEFTOVER FILES:
  find ~{,/.config} /etc /var/{lib,cache,log} -maxdepth 1 | while read -r f; do
    [[ ${filters[*]} == *${f}* ]] || du -sh "${f}" 2>/dev/null
  done

  echo LEFTOVER FILTERS:
  for f in "${filters[@]}"; do
    [[ -e ${f} ]] || echo "${f}"
  done
}
