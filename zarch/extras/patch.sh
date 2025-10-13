#!/bin/bash

## Extras should only be ran by zarchinstall
## This is where I put optional `sed` patches for random things

(( EUID == 0 )) || { echo "This script needs to be run as root"; exit 1; }

## Fix Steam creating .pulse-cookie
sed -i 's|^;.*cookie-file =.*|cookie-file = /tmp/.pulse-cookie|' /etc/pulse/client.conf

## Fix `which` not found by pass otp
sed -i "s|OATH=\$(which oathtool)|OATH=\$(command -v oathtool)|g" /usr/lib/password-store/extensions/otp.bash
