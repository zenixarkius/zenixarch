<div align="center">

# Zenixark's Arch Linux Desktop Setup
**My KISS privacy and performance focused Arch installation fully reproducible in one command**

NixOS is cool, but it's not Arch... Ansible is cool, but it's scope creep... so I decided to write a bash script loosely based on them to make my setup portable and reproducible.

</div>
<br />

```
                  -`                     user@zenixark
                 .o+`                    -------------
                `ooo/                    OS: Arch Linux x86_64
               `+oooo:                   Host: Z790 AORUS ELITE AX DDR4
              `+oooooo:                  Kernel: Linux 6.18.2-1-zenixark
              -+oooooo+:                 Uptime: -1 hours, 0 mins
            `/:-:++oooo+:                Packages: 402 (pacman)
           `/++++/+++++++:               Shell: bash 5.3.8
          `/++++++++++++++:              Display (M34WQ): 3440x1440 in 34", 144 Hz [External]
         `/+++ooooooooooooo/`            Display (LG ULTRAGEAR): 1920x1080 in 24", 144 Hz [External]
        ./ooosssso++osssssso+`           WM: Hyprland 0.52.2 (Wayland)
       .oossssso-````/ossssss+`          Cursor: Adwaita
      -osssssso.      :ssssssso.         Terminal: foot 1.25.0
     :osssssss/        osssso+++.        Terminal Font: monospace (8pt)
    /ossssssss/        +ssssooo/-        CPU: 13th Gen Intel(R) Core(TM) i7-13700K (24) @ 5.80 GHz
  `/ossssso+/:-        -:/+osssso+-      GPU 1: NVIDIA GeForce RTX 4070 [Discrete]
 `+sso+:-`                 `.-/+oso:     GPU 2: Intel UHD Graphics 770 @ 1.60 GHz [Integrated]
`++:.                           `-/+/    Memory: 1.45 GiB / 31.11 GiB (5%)
.`                                 `/    Disk (/): 1.94 GiB / 931.00 GiB (0%) - btrfs
```
---
```pacmanconf

.
├── kernel
│   ├── PKGBUILD                          # Compiles and packages the custom kernel
│   ├── config                            # An optimized minmal custom kernel config that assumes my desktop
│   └── linux-zenixark.preset             # Unified Kernel Preset with minimal initrd hooks
├── rootfs
│   ├── etc
│   │   ├── iwd
│   │   │   └── main.conf                 # Allows iwd to do DHCP
│   │   ├── modprobe.d
│   │   │   └── nvidia.conf               # Performance enhancing nvidia module options
│   │   ├── systemd
│   │   │   └── system
│   │   │       ├── getty@.service.d
│   │   │       │   └── autologin.conf    # TTY Autologin
│   │   │       ├── nvclock.bin           # Sets NVIDIA GPU overclocks via NVML
│   │   │       ├── nvclock.service       # Runs above on startup
│   │   │       ├── rgb.service           # Sets my static blues on startup
│   │   │       └── wireguard.service     # Selects a random wireguard config on startup
│   │   ├── locale.conf                   # Locale
│   │   ├── locale.gen                    # Locale
│   │   ├── localtime.link                # Timezone
│   │   ├── nftables.conf                 # Firewall rules
│   │   ├── pacman.conf                   # Includes CachyOS repos for the added optimization
│   │   └── resolv.conf                   # Mullvad VPN's DNS servers (TODO: somehow have an encrypted DNS fallback)
│   └── home
│       └── user
│           ├── .config
│           │   ├── hypr
│           │   │   ├── hyprland.conf     # Mostly stock with some minor aesthetic tweaks
│           │   │   ├── hyprpaper.conf    # Applies the 2 wallpapers below
│           │   │   ├── sigiluw.png
│           │   │   └── sigilw.png
│           │   └── nvim
│           │       ├── init.lua          # Sets up Lazy and the nvim-tree, bufferline, and lualine plugins
│           │       └── lazy-lock.json    # Reproducibility
│           ├── .mullvad
│           │   └── mullvadbrowser
│           │       ├── user
│           │       │   └── user.js       # Better defaults for the Mullvad and Tor browsers
│           │       ├── installs.ini      # Reproducibility
│           │       └── profiles.ini      # Reproducibility
│           ├── .bashrc                   # A swath of useful bash aliases, options, and functions
│           ├── .cache.link               # To wipe cache on shutdown
│           ├── .gitconfig                # Git identity
│           └── .local.link               # To wipe this stuff on shutdown (I know, I'm insane)
└── zarchinstall                          # The crown jewel idempotent installer script of this repository
```
> The source of the `nvclock` binary can be found [here](https://zenixark.com/projects/nvclock).

## Installation

> [!WARNING]
> This probably should *not* be reused by others as it assumes you can suffer being this level of monk. The custom kernel config in particular absolutely cannot be reused unmodified, as it assumes my exact hardware. It doesn't even work in a VM.
>
> It also assumes you are a Mullvad VPN user (for now). Otherwise `/etc/resolv.conf` needs to have general purpose DNS servers and the killswitch in `/etc/nftables.conf` would have to be removed to gain internet access again.

Don't care? First, read what everything in this repository does, then just boot into an Arch ISO, connect to the internet, and:

```sh
pacman -Sy git

git clone https://zenixark.com/projects/zenixarch.git
# or
git clone https://github.com/zenixarkius/zenixarch.git

# DISK and PASS only matter on a full install, they can be omitted post-install
DISK=<disk, like nvme0n1> PASS='<a strong pass>' ./zenixarch/zarchinstall

reboot
```

`zarchinstall` can then be ran over and over post-install to reapply the repo's state.

You *could* `git clone` and just run it on an existing installation, but I don't recommend it mostly because `user` is hardcoded in various places, this is easily changeable though.

## License

Licensed as [MIT](./LICENSE.md) so you can fork and destroy it however you want for all I care.
