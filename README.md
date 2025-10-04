# Zenixark's Arch Linux Setup
**My entire minimalist privacy, security, and performance focused Arch system reproducible in one command**

This repo contains every tweak I have made to Arch Linux. I like the idea of declarative/idempotent systems such as NixOS and Ansible, but I don't want to give up Arch so why not make my Arch installation reproducible too?

## Core Features

- **An idempotent installer, [**`zarchinstall`**](./zarchinstall)** that can do a full disk install from a live ISO and be re-ran again post-install to apply changes to this repository.
- **Unified Kernel Image without a bootloader**. No `systemd-boot` or `grub` overhead, just the entire ESP in a single `/boot/EFI/BOOT/BOOTX64.EFI` directly booted by the EFI.
- **FDE + `btrfs` with subvolumes** optimized for I/O performance, security, and snapshots.
- **Custom Secure Boot keys** using `sbctl` to sign the UKI, this ensures that your initramfs has not been tampered with.
- **Minimalist alternatives** such as `iwd` for Wi-Fi instead of `systemd-networkd` or `networkmanager` and `doas` instead of `sudo`.
- **Default-deny `ip(6)tables` rules** including `:OUTPUT DROP [0:0]`, excepting common ports.
- **Self-hosted `adguardhome` DNS sinkhole** only accessible on `127.0.0.1` with a LOT of blocklists including GAFAM ones.

WireGuard, NVIDIA tuning, declarative packages & services, applying my [firefox-hardening](https://zenixark.com/zenixark/firefox-hardening)... this is already getting too long... there is a LOT, it might be better to just take a look around the repository.

## Usage
> [!WARNING]
> This is a REALLY ***REALLY*** opinionated setup that assumes my hardware and philosophy.  
> It's *not* intended to be reused by others, but if you do then I would very much recommend changing almost everything.

A full installation is *technically* optional as `zarchinstall` will skip one outside a live Arch ISO, but `configuration()` **HEAVILY** assumes the configuration of one, such as `/home/user` and `/etc/kernel/cmdline`. Otherwise, this repo can just be cloned to `~/.zenixarch` and installed at your own risk as there will 100% be breakage without manual changes.

From a live Arch ISO:
```cf

## NOTE: Due to --tpm-eventlog in the sbctl section of zarchinstall, Setup Mode should be enabled after installation before booting into the new install, then run Step 5 to set up SB properly. Removing the flag or using --microsoft (if you want to make secure boot useless) will avoid needing to do this.

## 1. Connect to the internet
iwctl --passphrase <wifi password> station <wifi interface> connect <wifi name>

## 2. Install git
pacman -Sy git

## 3. Clone the repo
git clone https://zenixark.com/zenixark/zenixarch.git

## 4. Run the installer
cd zenixarch
DISK=<e.g sda or nvme0n1> PASS=<a strong password> ./zarchinstall

## 5. After rebooting, this can be run repeatedly to apply new changes idempotently
doas ./zarchinstall
```
