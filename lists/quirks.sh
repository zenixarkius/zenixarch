# shellcheck shell=bash
set -euo pipefail
(( EUID == 0 ))

# TODO: Replace UUIDs entirely with FS labels for LUKS unlocking
UUID=$(blkid -s UUID -o value /dev/"$(basename /sys/class/block/"$(readlink /dev/mapper/cryptroot | cut -c4-)"/slaves/*)")
if ! grep -q "${UUID}" /etc/kernel/cmdline; then
  sed -i "s|name=.*=cryptroot|name=${UUID}=cryptroot|" /etc/kernel/cmdline
  mkinitcpio -P
fi

# OpenRGB is completely broken for me after this version for some reason
if ! [[ $(pacman -Q openrgb | awk '{print $2}') == 1.0rc1-2 ]]; then
  pacman -Rcns --noconfirm openrgb || :
  pacman -U --noconfirm https://archive.archlinux.org/repos/2025/08/31/extra/os/x86_64/openrgb-1.0rc1-2-x86_64.pkg.tar.zst
fi

# Fixes Steam (and I assume other chromium/electron web apps) creating ~/.pulse-cookie
sed -i 's|^;.*cookie-file.*|cookie-file = /tmp/.pulse-cookie|' /etc/pulse/client.conf

# Fixes 'which not found' when using pass otp
sed -i 's|which|command -v|' /usr/lib/password-store/extensions/otp.bash

# Stops systemd from creating a random seed file in /boot as systemd-boot isn't being used anyways
systemctl mask systemd-boot-random-seed.service
