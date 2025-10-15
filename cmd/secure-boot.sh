#!/bin/bash

(( EUID == 0 )) || { echo "This script needs to be run as root"; exit 1; }

if [[ -d /run/archiso ]]; then
    echo -e "\e[31mSecure Boot should be set up post-install\e[0m"
    sbctl status | grep -q "Setup Mode:.*Enabled" && echo -e "\e[31mSetup Mode may need to be re-enabled after reboot\e[0m"
    exit 1
fi

if sbctl status | grep -q "Setup Mode:.*Enabled"; then
    sbctl create-keys
    sbctl enroll-keys --tpm-eventlog
    sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
else
    echo -e "\e[33mSkipping Secure Boot as it is not in Setup Mode\e[0m"
fi
