# Zenixark's Arch Linux Setup
**My KISS privacy and performance focused Arch installation fully reproducible in one command**

---

NixOS and Ansible seem pretty cool... but the former is not Arch and the latter is absurd scope creep, so I decided to make my setup reproducible with a loosely based version of them in bash. Good luck using this setup if you aren't me... this (ESPECIALLY the custom kernel) is *not* intended to be reused by others as it assumes you're using the same machine as me and can suffer being this level of monk. That all said, fork and destroy it however you want for all I care.

```
                  -`                     user@zenixark
                 .o+`                    -------------
                `ooo/                    OS: Arch Linux x86_64
               `+oooo:                   Host: Z790 AORUS ELITE AX DDR4
              `+oooooo:                  Kernel: Linux 6.17.8-1-zenixark
              -+oooooo+:                 Uptime: -1 hours, 0 mins
            `/:-:++oooo+:                Packages: 411 (pacman)
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
.`                                 `/    Disk (/): 2.29 GiB / 931.00 GiB (0%) - btrfs
```

## Repo Layout
```pacmanconf
.
├── kernel
│   ├── config                              ## Uses the BORE scheduler, CachyOS patchsets, O3, ThinLTO, -march=native,
│   │                                       ## and eventually AutoFDO and Propeller PGO. Sets BBR + FQ as the default
│   │                                       ## TCP control, PREEMPT (low-latency desktop) on, 1000Hz timer, and other
│   │                                       ## little things that count. Also strips EVERY unnecessary subsystem and
│   │                                       ## driver EXCEPT the bare minimum required for my desktop to work
│   └── PKGBUILD                            ## Compiles and packages my custom kernel + NVIDIA drivers
├── lists
│   ├── packages.txt                        ## Declarative list of pacman packages
│   ├── services.txt                        ## Declarative list of systemd services
│   └── timers.txt                          ## Declarative list of systemd timers
├── rootfs
│   ├── etc
│   │   ├── iwd
│   │   │   └── main.conf                   ## Allows iwd to configure the network
│   │   ├── mkinitcpio.d
│   │   │   ├── cmdline                     ## Root partition flags
│   │   │   └── linux-zenixark.preset       ## A Unified Kernel Image preset
│   │   ├── pam.d
│   │   │   └── login                       ## TTY autologin (password)
│   │   ├── sysctl.d
│   │   │   └── 99-performance.conf         ## Currently just disables split_lock_mitigate
│   │   ├── systemd
│   │   │   ├── coredump.conf.d
│   │   │   │   └── disable.conf
│   │   │   └── system
│   │   │       ├── getty@tty1.service.d    ## TTY autologin (user)
│   │   │       │   └── autologin.conf
│   │   │       ├── overclock.service       ## Applies my NVIDIA overclocks on startup
│   │   │       ├── rgb.service             ## Applies my static blues on startup
│   │   │       └── wireguard.service       ## Connects to a random VPN config on startup
│   │   ├── doas.conf
│   │   ├── mkinitcpio.conf                 ## The minimum hooks required to boot my custom kernel
│   │   ├── nftables.conf                   ## Strict default-deny firewall rules
│   │   └── pacman.conf                     ## Adds CachyOS repos for the extra optimization (and librewolf)
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
│   │       ├── .librewolf
│   │       │   ├── user
│   │       │   │   └── user.js             ## Extra ui, performance, and hardening tweaks over librewolf's defaults
│   │       │   ├── installs.ini
│   │       │   └── profiles.ini
│   │       ├── .bash_profile               ## Autostarts Hyprland
│   │       ├── .bashrc                     ## Numerous useful aliases for file management and system maintenance
│   │       └── .gitconfig                  ## A few nice aliases for git
│   ├── usr
│   │   └── local
│   │       └── bin
│   │           └── overclock               ## Ran by overclock.service to set my NVIDIA overclocks via NVML
│   └── var
│       └── lib
│           └── private
│               └── adguardhome
│                   └── AdGuardHome.yaml    ## A REALLY heavy handed DNS sinkhole config
├── utils
│   ├── bugfixes.sh                         ## Some minor patches for random things
│   └── overclock.c                         ## Source of the overclock binary
└── zarchinstall                            ## The backbone of this project, it can do a full disk install from
                                            ## a live ISO and be ran over and over again post-install to
                                            ## idempotently reapply the repo's state
```

## Usage

Quite literally just:

1. Boot into an Arch ISO
2. `pacman-key --init && pacman -Sy git`
3. `git clone https://zenixark.com/projects/zenixarch.git`
4. `DISK=<disk, like nvme0n1> PASS=<a strong pass> ./*/z*`
5. `reboot`

This is the only right way to install this setup... If you're stupid enough to clone this repo and run it unchanged on an existing install, welp your installation is in the hands of God now. :)

---

Licensed as [MIT](./LICENSE.md) because I could never care about what anyone does with this.
