<div align="center">

# Zenixark's Arch Linux Desktop Setup
**My KISS privacy and performance focused Gentoo installation fully reproducible in one command**

</div>
<br />

```
         -/oyddmdhs+:.                 user@zenixark
     -odNMMMMMMMMNNmhy+-`              ------------
   -yNMMMMMMMMMMMNNNmmdhy+-            OS: Gentoo Linux x86_64
 `omMMMMMMMMMMMMNmdmmmmddhhy/`         Host: Z790 AORUS ELITE AX DDR4
 omMMMMMMMMMMMNhhyyyohmdddhhhdo`       Kernel: Linux 6.18.4-1-zenixark
.ydMMMMMMMMMMdhs++so/smdddhhhhdm+`     Uptime: -1 hours, -1 mins
 oyhdmNMMMMMMMNdyooydmddddhhhhyhNd.    Packages: ??? (emerge)
  :oyhhdNNMMMMMMMNNNmmdddhhhhhyymMh    Shell: bash 5.3.9
    .:+sydNMMMMMNNNmmmdddhhhhhhmMmy    Display (M34WQ): 3440x1440 in 34", 144 Hz [External]
       /mMMMMMMNNNmmmdddhhhhhmMNhs:    Display (LG ULTRAGEAR): 1920x1080 in 24", 144 Hz [External]
    `oNMMMMMMMNNNmmmddddhhdmMNhs+`     WM: Hyprland 0.53.1 (Wayland)
  `sNMMMMMMMMNNNmmmdddddmNMmhs/.       Terminal: foot 1.25.0
 /NMMMMMMMMNNNNmmmdddmNMNdso:`         Terminal Font: monospace (8pt)
+MMMMMMMNNNNNmmmmdmNMNdso/-            CPU: 13th Gen Intel(R) Core(TM) i7-13700K (24) @ 5.80 GHz
yMMNNNNNNNmmmmmNNMmhs+/-`              GPU 1: NVIDIA GeForce RTX 4070 [Discrete]
/hMMNNNNNNNNMNdhs++/-`                 GPU 2: Intel UHD Graphics 770 @ 1.60 GHz [Integrated]
`/ohdmmddhys+++/:.`                    Memory: 1.45 GiB / 31.11 GiB (5%)
  `-//////:--.                         Disk (/): 1.94 GiB / 931.00 GiB (0%) - btrfs
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
---
Licensed as [MIT](./LICENSE.md) so you can fork and destroy it however you want for all I care.
