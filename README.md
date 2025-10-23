# Zenixark's Arch Linux Setup
**My minimalist privacy, security, and performance focused Arch system fully reproducible with one command**

I didn't want to give up Arch but I liked the idea of NixOS and Ansible, so I decided to make my install reproducible with [`zarchinstall`](./zarchinstall), which can do a full disk install from a live ISO and be re-ran over and over post install to apply the repo's state. This is *not* intended to be reused by others as it assumes my hardware and philosophy, but you can fork and change it however you want for all I care.

This setup worships the almighty **KISS** principle as it naturally begets privacy through avoiding enshittification (I know... *herculean difficulty* for some people for some esoteric reason), and security as how does one attack that which has no bytes (or electromagnetic waves)?

## Whats in here
A ***lot***. Seriously... [cmdline](./configs/kernel/cmdline) and [sysctl](./configs/sysctl.d/99-hardening.conf) hardening, CachyOS' kernel and [repos](./configs/pacman.conf), hardcore [Nftables rules](./configs/nftables.conf), a [bootloader-less UKI](./configs/mkinitcpio.d/linux-cachyos-bore-lto.preset) setup, custom Secure Boot Keys, paranoia-grade FDE settings, optimized Btrfs subvolumes, NVIDIA [overclocking](./configs/systemd/system/overclock.service), dotfiles, [Adguard Home](./configs/adguardhome.yaml), [WireGuard](./configs/systemd/system/wireguard.service), extra [Librewolf hardening](./dotfiles/.librewolf/user/user.js)... I might just be hyping up uninteresting things, but ***I*** *FIND IT COOL*, so just take a look around if you care.

## How do I use it

> [!NOTE]
> In a live ISO, `sbctl enroll-keys --tpm-eventlog` can't detect a TPM so Setup Mode should be enabled AFTER `reboot` BEFORE booting the fresh install, then do step 5. I personally have to use that flag or else I get no boot video and an un-accelerated framebuffer after boot as my GPU's GOP driver fails to init. Remove the flag or use `--microsoft` (*if you want to make Secure Boot useless...*) to set up everything in one run.

A full installation is *technically* optional but `configuration()` assumes one was done. If you're stupid enough to clone this repo and run it unchanged on an existing install, well your installation is in the hands of God now.

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

## 4. After rebooting, this can be run repeatedly to apply the repo's state idempotently
doas ~/.zenixarch/zarchinstall
```
