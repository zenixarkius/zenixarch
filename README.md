<div align="center">

# Zenixark's Arch Linux Desktop Setup
**My KISS privacy and performance focused Arch installation fully reproducible in one command**

NixOS is cool, but it's not Arch... Ansible is cool, but it's scope creep... so I decided to write a bash script loosely based on them to make my setup reproducible.

</div>
<br />

```
                  -`                     user@zenixark
                 .o+`                    -------------
                `ooo/                    OS: Arch Linux x86_64
               `+oooo:                   Host: Z790 AORUS ELITE AX DDR4
              `+oooooo:                  Kernel: Linux 6.18.1-1-zenixark
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
.`                                 `/    Disk (/): 1.97 GiB / 931.00 GiB (0%) - btrfs
```

---

```pacmanconf
.
├── etc
│   ├── iwd
│   │   └── main.conf               # Allows iwd to configure the network
│   ├── systemd
│   │   └── system
│   │       ├── getty@.service.d
│   │       │   └── autologin.conf  # TTY autologin
│   │       ├── overclock.bin
│   │       ├── overclock.service   # Applies NVIDIA overclocks via NVML on startup
│   │       ├── rgb.service         # Sets my static blues on startup
│   │       └── wireguard.service   # Connects to a random VPN config on startup
│   ├── nftables.conf               # Default-deny firewall rules
│   └── resolv.conf                 # Just sets the DNS server
├── home
│   └── user
│       ├── .config
│       │   ├── hypr
│       │   │   ├── hyprland.conf   # Mostly stock minus some minor aesthetic changes
│       │   │   ├── hyprpaper.conf  # Applies the 2 wallpapers below
│       │   │   ├── sigiluw.png
│       │   │   └── sigilw.png
│       │   └── nvim
│       │       └── init.lua        # Lazy plugins setup + useful options
│       ├── .mullvad
│       │   └── mullvadbrowser
│       │       ├── user
│       │       │   └── user.js     # Better defaults for the Mullvad and Tor Browsers
│       │       ├── installs.ini
│       │       └── profiles.ini
│       ├── .bashrc                 # Useful defaults and a few functions/aliases for system maintenance
│       └── .gitconfig
├── kernel
│   ├── config                      # My custom kernel config. It's compiled with llvm/clang, -O3, Full LTO,
│   │                               # optimized for my 13700k, and eventually will use FDO/PGO. It uses the
│   │                               # BORE cpu scheduler, CachyOS patchsets, PREEMPT, BBR3 for TCP congestion
│   │                               # control, 1000Hz tick rate, and other little things that count. It strips
│   │                               # EVERY unnecessary subsystem and driver EXCEPT the bare minimum required
│   │                               # for my desktop to work
│   ├── linux-zenixark.preset       # UKI preset with the minimum hooks required to boot the custom kernel
│   └── PKGBUILD                    # Compiles and packages the custom kernel + NVIDIA drivers
├── misc
│   └── overclock.c                 # Source of the overclock binary
└── zarchinstall                    # The backbone of this project, it can do a full disk install from
                                    # a live ISO and be ran over and over again post-install to
                                    # idempotently reapply the repo's state
```

---

This really should *not* be reused by others as it assumes you're using the same machine as me and can suffer being this level of monk.

Don't care? Quite literally just:

1. Boot into an Arch ISO and connect to the internet
2. `pacman -Sy git`
3. `git clone https://zenixark.com/projects/zenixarch.git`
4. `DISK='<disk, like nvme0n1>' PASS='<a strong pass>' ./*/z*`
5. `reboot`

This is the only right way to install this setup... you *could* `git clone` and run zarchinstall on an existing installation, but I don't recommend it.

---

Licensed as [MIT](./LICENSE.md) so you can fork and destroy it however you want for all I care.
