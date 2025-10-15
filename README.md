# Zenixark's Arch Linux Setup
**My minimalist privacy, security, and performance focused Arch system fully reproducible with one command, inspired by NixOS and Ansible**

I didn't want to give up Arch, so I decided to make my REALLY ***REALLY*** opinionated install reproducible in `bash`. This is *not* intended to be reused by others as it assumes my hardware and philosophy.

## Core Features

- An [idempotent installer](./zarchinstall) that can do a full disk install from a live ISO and be re-ran again post-install to apply any modifications.
- The entire ESP is a `/boot/EFI/BOOT/BOOTX64.EFI` Unified Kernel Image that's directly booted by the EFI without any `systemd-boot` or `grub` overhead.
- FDE + `btrfs` subvolumes optimized for I/O performance, security, and snapshots.
- Custom Secure Boot keys using `sbctl` to sign the UKI to ensure that the initramfs has not been tampered with.
- Minimalist alternatives such as `iwd` for Wi-Fi instead of `systemd-networkd` or `networkmanager` and `doas` instead of `sudo`.
- Default-deny `nftables` rules including drop output, except for common ports.
- Self-hosted DNS Sinkhole with `adguardhome` (only accessible to `127.0.0.1`) with a LOT of blocklists including GAFAM ones.
- [WireGuard](./etc/systemd/system/wireguard.service), [NVIDIA overclocking](./etc/systemd/system/overclock.service)..., this is already getting too long... it might be better to just take a look around the repository.

## Usage

> [!NOTE]
> In a live ISO, `sbctl enroll-keys --tpm-eventlog` can't detect a TPM so Setup Mode should be enabled AFTER `reboot` BEFORE booting the fresh install, then do step 5. I personally have to use that flag or else I get no boot video and an un-accelerated framebuffer after boot as my GPU's GOP driver fails to init. Remove the flag or use `--microsoft` (*if you want to make Secure Boot useless...*) to set up everything in one run.

A full installation is *technically* optional but `configuration()` assumes one was done, especially anything `btrfs` related such as `/etc/kernel/cmdline`. Otherwise, just `git clone` this repository into `~/.zenixarch` and skip to step 5. Note that `zarchinstall` will overwrite relevant configs with the ones in the repository without backing anything up, you have been warned.

*From a live Arch ISO:*
```cf
## 1. Connect to the internet
iwctl --passphrase <wifi password> station <wifi interface> connect <wifi name>

## 2. Install git and clone the repo
pacman -Sy git
git clone https://zenixark.com/zenixark/zenixarch.git

## 3. Run the installer
DISK=<e.g sda or nvme0n1> PASS=<a strong password> ./zenixarch/zarchinstall
reboot

## 4. After rebooting, this can be run repeatedly from the repository directory to apply new changes idempotently
doas ./zarchinstall
```
