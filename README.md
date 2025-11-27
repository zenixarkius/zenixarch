# Zenixark's Arch Linux Setup
**My KISS privacy and performance focused Arch installation fully reproducible in one command**

---

NixOS and Ansible seem pretty cool... but the former is not Arch and the latter is absurd scope creep, so I decided to make my setup reproducible with a loosely based version of them in bash. Good luck using this setup if you aren't me... this (ESPECIALLY the custom kernel) is *not* intended to be reused by others as it assumes you're using the same machine as me and can suffer being this level of monk. That all said, fork and destroy it however you want for all I care.

```
                  -`                     user@zenixark
                 .o+`                    -------------
                `ooo/                    OS: Arch Linux x86_64
               `+oooo:                   Host: Z790 AORUS ELITE AX DDR4
              `+oooooo:                  Kernel: Linux 6.17.9-1-zenixark
              -+oooooo+:                 Uptime: -1 hours, 0 mins
            `/:-:++oooo+:                Packages: 376 (pacman)
           `/++++/+++++++:               Shell: bash 5.3.3
          `/++++++++++++++:              Display (M34WQ): 3440x1440 in 34", 144 Hz [External]
         `/+++ooooooooooooo/`            Display (LG ULTRAGEAR): 1920x1080 in 24", 144 Hz [External]
        ./ooosssso++osssssso+`           WM: Hyprland 0.52.1 (Wayland)
       .oossssso-````/ossssss+`          Cursor: Adwaita
      -osssssso.      :ssssssso.         Terminal: foot 1.25.0
     :osssssss/        osssso+++.        Terminal Font: monospace (8pt)
    /ossssssss/        +ssssooo/-        CPU: 13th Gen Intel(R) Core(TM) i7-13700K (24) @ 5.80 GHz
  `/ossssso+/:-        -:/+osssso+-      GPU 1: NVIDIA GeForce RTX 4070 [Discrete]
 `+sso+:-`                 `.-/+oso:     GPU 2: Intel UHD Graphics 770 @ 1.60 GHz [Integrated]
`++:.                           `-/+/    Memory: 1.45 GiB / 31.11 GiB (5%)
.`                                 `/    Disk (/): 2.22 GiB / 931.00 GiB (0%) - btrfs
```

## Repo Layout
```pacmanconf
.
├── kernel
│   ├── config                              ## Uses the BORE scheduler, CachyOS patchsets, O3, ThinLTO, -march=native,
│   │                                       ## and eventually AutoFDO and Propeller PGO. Sets BBR3 as the default TCP
│   │                                       ## control, PREEMPT (low-latency desktop) on, 1000Hz timer, and other
│   │                                       ## little things that count. Also strips EVERY unnecessary subsystem and
│   │                                       ## driver EXCEPT the bare minimum required for my desktop to work
│   └── PKGBUILD                            ## Compiles and packages the custom kernel + NVIDIA drivers
├── misc
│   ├── hotfixes.sh                         ## Some fixes for bugs in other software
│   ├── overclock.c                         ## Source of the overclock binary
│   └── ublock.json                         ## A REALLY heavy handed uBlock config, this has to be manually imported
├── rootfs
│   ├── etc
│   │   ├── iwd
│   │   │   └── main.conf                   ## Allows iwd to configure the network
│   │   ├── mkinitcpio.d
│   │   │   └── linux-zenixark.preset       ## Unified Kernel Image preset
│   │   ├── systemd
│   │   │   └── system
│   │   │       ├── getty@.service.d
│   │   │       │   └── autologin.conf      ## TTY autologin
│   │   │       ├── misc.service            ## Applies NVIDIA overclocks and static blue RGB on startup
│   │   │       └── wireguard.service       ## Connects to a random VPN config on startup
│   │   ├── mkinitcpio.conf                 ## The minimum hooks required to boot the custom kernel
│   │   ├── nftables.conf                   ## Strict default-deny firewall rules
│   │   └── pacman.conf                     ## Adds CachyOS repos for the extra optimization
│   ├── home
│   │   └── user
│   │       ├── .config
│   │       │   ├── hypr
│   │       │   │   ├── hyprland.conf       ## Mostly stock minus some minor aesthetic changes
│   │       │   │   ├── hyprpaper.conf      ## Applies the 2 wallpapers below
│   │       │   │   ├── sigiluw.png
│   │       │   │   └── sigilw.png
│   │       │   └── nvim
│   │       │       ├── init.lua            ## Lazy plugins setup + useful options
│   │       │       └── lazy-lock.json
│   │       ├── .librewolf
│   │       │   ├── user
│   │       │   │   └── user.js             ## Extra ui, performance, and hardening tweaks over librewolf's defaults
│   │       │   ├── installs.ini
│   │       │   └── profiles.ini
│   │       ├── .bash_profile               ## Autostart Hyprland
│   │       ├── .bashrc                     ## Some useful aliases for system maintenance
│   │       └── .gitconfig
│   ├── usr
│   │   └── local
│   │       └── bin
│   │           └── overclock               ## Ran by overclock.service to set overclocks via NVML
│   └── var
│       └── lib
│           └── private
│               └── adguardhome
│                   └── AdGuardHome.yaml    ## A REALLY heavy handed DNS sinkhole config
└── zarchinstall                            ## The backbone of this project, it can do a full disk install from
                                            ## a live ISO and be ran over and over again post-install to
                                            ## idempotently reapply the repo's state
```

## Usage

Quite literally just:

1. Boot into an Arch ISO and connect to the internet
2. `pacman -Sy git`
3. `git clone https://zenixark.com/projects/zenixarch.git`
4. `DISK='<disk, like nvme0n1>' PASS='<a strong pass>' ./*/z*`
5. `reboot`

This is the only right way to install this setup... If you're stupid enough to clone this repo and run it unchanged on an existing install, welp your installation is in the hands of God now. :)

---

Licensed as [MIT](./LICENSE.md) because I could never care about what anyone does with this.
