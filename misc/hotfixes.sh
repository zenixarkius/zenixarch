#!/bin/bash

(( EUID == 0 )) || { echo This script needs to be run as root; exit 1; }

## Fix Steam creating ~/.pulse-cookie
sed -i "s|^;.*cookie-file =.*|cookie-file = /tmp/.pulse-cookie|" /etc/pulse/client.conf

## Fix `which` not found by pass otp
sed -i 's|which oathtool|command -v oathtool|' /usr/lib/password-store/extensions/otp.bash

## Openrgb is completely broken for me after this version
[[ $(pacman -Q openrgb | awk '{print $2}') == "1.0rc1-2" ]] || { curl https://archive.archlinux.org/repos/2025/08/31/extra/os/x86_64/openrgb-1.0rc1-2-x86_64.pkg.tar.zst -o /tmp/openrgb.pkg.tar.zst && pacman -U --noconfirm /tmp/openrgb.pkg.tar.zst; }
