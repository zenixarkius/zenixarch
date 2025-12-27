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
.`                                 `/    Disk (/): 1.97 GiB / 931.00 GiB (0%) - btrfs
```

---

```pacmanconf

.
├── build
│   ├── linux-zenixark
│   │   ├── PKGBUILD
│   │   ├── config
│   │   └── linux-zenixark.preset
│   └── overclock
│       ├── PKGBUILD
│       ├── overclock.c
│       └── overclock.service
├── lists
│   ├── packages.list
│   ├── quirks.sh
│   └── services.list
├── rootfs
│   ├── etc
│   │   ├── iwd
│   │   │   └── main.conf
│   │   ├── kernel
│   │   │   └── cmdline
│   │   ├── systemd
│   │   │   └── system
│   │   │       ├── getty@.service.d
│   │   │       │   └── autologin.conf
│   │   │       ├── rgb.service
│   │   │       └── wireguard.service
│   │   ├── locale.conf
│   │   ├── locale.gen
│   │   ├── localtime.link
│   │   ├── nftables.conf
│   │   ├── pacman.conf
│   │   └── resolv.conf
│   └── home
│       └── user
│           ├── .config
│           │   ├── hypr
│           │   │   ├── hyprland.conf
│           │   │   ├── hyprpaper.conf
│           │   │   ├── sigiluw.png
│           │   │   └── sigilw.png
│           │   └── nvim
│           │       ├── init.lua
│           │       └── lazy-lock.json
│           ├── .mullvad
│           │   └── mullvadbrowser
│           │       ├── user
│           │       │   └── user.js
│           │       ├── installs.ini
│           │       └── profiles.ini
│           ├── .bashrc
│           ├── .cache.link
│           ├── .gitconfig
│           └── .local.link
└── zarchinstall
```

---

This really should *not* be reused by others as it assumes you're using the same machine as me and can suffer being this level of monk.

Don't care? Quite literally just:

1. Boot into an Arch ISO and connect to the internet
2. `pacman -Sy git`
3. `git clone https://zenixark.com/projects/zenixarch.git` or `git clone https://github.com/zenixarkius/zenixarch.git`
4. `DISK=<disk, like nvme0n1> PASS='<a strong pass>' ./*/z*`
5. `reboot`

(DISK and PASS only matter on a full install, they can be omitted post-install)

This is the only right way to install this setup... you *could* `git clone` and just run `./zarchinstall` on an existing installation, but I don't recommend it.

---

Licensed as [MIT](./LICENSE.md) so you can fork and destroy it however you want for all I care.
