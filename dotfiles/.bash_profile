#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -z $DISPLAY && $(tty) == /dev/tty1 && $HYPRLAND != y ]] && hyprland && export HYPRLAND=y
