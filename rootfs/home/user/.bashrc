#
# ~/.bashrc
#

{ (( EUID == 0 )) || [[ $- != *i* ]]; } && return

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

shopt -s histappend cdspell autocd cmdhist histverify

export FUNCNEST=100

export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000

export MAKEFLAGS=-j$(nproc)
export PACMAN_AUTH=pkexec

alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias ls='ls -lha --color=always --group-directories-first'
alias grep='grep --color=always'
alias diff='diff --color=always'

alias orphans='sudo bash -c "pacman -Rcns \$(pacman -Qttdq); pacman -Runs \$(pacman -Qqd)"'
alias prune='tac ~/.bash_history | awk "!seen[\$0]++" | tac > ~/.bash_history.new && command mv ~/.bash_history.new ~/.bash_history'

alias mssd='sudo bash -c "cryptsetup open /dev/sda3 cryptext && mount /dev/mapper/cryptext /mnt"'
alias ussd='sudo bash -c "umount -R /mnt && cryptsetup close cryptext"'

cd() { builtin cd "$@" && ls; }

search() { sudo find / \( -path /proc -o -path /sys -o -path /dev -o -path /run -o -path /tmp \) -prune -o -iname "*$**" -print; }

leftovers() {
    case "$1" in
        -p) for f in "${filters[@]}"; do [[ -e $f ]] || echo "$f"; done ;;
        *)  find ~{,/.config} /etc /var/{lib,cache,log} -maxdepth 1 | while read -r lo; do
                [[ "${filters[*]}" =~ $lo ]] || du -sh "$lo" 2> /dev/null
            done ;;
    esac
}

sudo() { su -p -c "$(printf '%q ' "$@")"; }

filters=(
    /home/user/.bash_logout
    /home/user/.bash_history
    /home/user/.bash_profile
    /home/user/.bashrc
    /home/user/.cache
    /home/user/.config
    /home/user/.gitconfig
    /home/user/.gnupg
    /home/user/.password-store
    /home/user/.local
    /home/user/.config/chromium
    /home/user/.config/dconf
    /home/user/.config/hypr
    /home/user/.config/gtk-3.0
    /home/user/.config/nvim
    /home/user/.config/Signal
    /etc/adjtime
    /etc/alsa
    /etc/arch-release
    /etc/arptables.conf
    /etc/audisp
    /etc/audit
    /etc/avahi
    /etc/bash.bash_logout
    /etc/bash.bashrc
    /etc/bash_completion.d
    /etc/bindresvport.blacklist
    /etc/ca-certificates
    /etc/conf.d
    /etc/credstore
    /etc/credstore.encrypted
    /etc/crypttab
    /etc/dconf
    /etc/debuginfod
    /etc/default
    /etc/e2scrub.conf
    /etc/ebtables.conf
    /etc/environment
    /etc/ethertypes
    /etc/fonts
    /etc/fstab
    /etc/gai.conf
    /etc/gnutls
    /etc/gprofng.rc
    /etc/group
    /etc/group-
    /etc/gshadow
    /etc/gshadow-
    /etc/gtk-3.0
    /etc/healthd.conf
    /etc/host.conf
    /etc/hosts
    /etc/initcpio
    /etc/inputrc
    /etc/iptables
    /etc/issue
    /etc/iwd
    /etc/kernel
    /etc/krb5.conf
    /etc/ld.so.cache
    /etc/ld.so.conf
    /etc/libaudit.conf
    /etc/libnl
    /etc/libva.conf
    /etc/locale.conf
    /etc/locale.gen
    /etc/localtime
    /etc/login.defs
    /etc/machine-id
    /etc/makepkg.conf
    /etc/makepkg.conf.d
    /etc/mke2fs.conf
    /etc/mkinitcpio.conf
    /etc/mkinitcpio.d
    /etc/modules-load.d
    /etc/mtab
    /etc/netconfig
    /etc/nftables.conf
    /etc/nsswitch.conf
    /etc/nvidia
    /etc/openldap
    /etc/openrgb
    /etc/os-release
    /etc/pacman.conf
    /etc/pacman.d
    /etc/pam.d
    /etc/passwd
    /etc/passwd-
    /etc/pipewire
    /etc/pkcs11
    /etc/polkit-1
    /etc/profile
    /etc/profile.d
    /etc/protocols
    /etc/pulse
    /etc/.pwd.lock
    /etc/request-key.conf
    /etc/resolv.conf
    /etc/rpc
    /etc/securetty
    /etc/security
    /etc/sensors3.conf
    /etc/services
    /etc/shadow
    /etc/shadow-
    /etc/shells
    /etc/skel
    /etc/ssh
    /etc/ssl
    /etc/subgid
    /etc/subgid-
    /etc/subuid
    /etc/subuid-
    /etc/systemd
    /etc/tpm2-tss
    /etc/ts.conf
    /etc/udev
    /etc/.updated
    /etc/userdb
    /etc/vconsole.conf
    /etc/wireguard
    /etc/X11
    /etc/xattr.conf
    /etc/xdg
    /var/cache/fontconfig
    /var/cache/ldconfig
    /var/cache/private
    /var/lib/dbus
    /var/lib/iwd
    /var/lib/krb5kdc
    /var/lib/lastlog
    /var/lib/libuuid
    /var/lib/libvirt
    /var/lib/machines
    /var/lib/pacman
    /var/lib/portables
    /var/lib/private
    /var/lib/sbctl
    /var/lib/systemd
    /var/lib/tpm2-tss
    /var/lib/xkb
    /var/log/audit
    /var/log/btmp
    /var/log/lastlog
    /var/log/old
    /var/log/pacman.log
    /var/log/private
    /var/log/README
    /var/log/wtmp
)
