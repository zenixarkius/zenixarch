#!/bin/bash

(( EUID == 0 )) || { echo "This script needs to be run as root"; exit 1; }

[[ ! $(pacman -Q openrgb | awk '{print $2}') == "1.0rc1-2" ]] && pacman -S --noconfirm --needed openrgb

cat > /etc/systemd/system/rgb.service << 'SERVICE'
[Unit]
Description=Set OpenRGB lighting

[Service]
WorkingDirectory=/tmp
ExecStart=/bin/bash -c 'openrgb --mode static --color 1f13d4 --brightness 100 && sleep 1 && openrgb --mode static --color 1f13d4 --brightness 100'

[Install]
WantedBy=multi-user.target
SERVICE

systemctl enable $NOW rgb
