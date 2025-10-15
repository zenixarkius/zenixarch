#!/bin/bash
set -euo pipefail

(( EUID == 0 )) || { echo "This script needs to be run as root"; exit 1; }
[[ ! -d /run/archiso ]] && echo -e "\e[31mNot in an Arch Linux live ISO\e[0m" && exit 1

: "$DISK:?" "$PASS:?"

read -rp $'\e[31mThis will wipe every little thing on your disk and reformat\n\e[31mAlso, you should know EVERYTHING this does before running it\n\e[31mType "IK" to continue: \e[0m' CONFIRM
[[ "$CONFIRM" != "IK" ]] && echo -e "\e[31mYou didn't confirm you knew\e[0m" && exit 1

umount -R /mnt || true && umount -R /mnt/* || true && cryptsetup close cryptroot || true

nvme id-ns -H "/dev/$DISK" | grep -q "LBA Format  1.*Data Size: 4096" && nvme format --lbaf=1 --force "/dev/$DISK"

sgdisk --zap-all "/dev/$DISK"
sgdisk -g "/dev/$DISK"
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" "/dev/$DISK"
sgdisk -n 2:0:0 -t 2:8300 -c 2:"Linux filesystem" "/dev/$DISK"

[[ "$DISK" =~ [0-9]$ ]] && DISK="${DISK}p"

mkfs.fat -F 32 "/dev/${DISK}1"

echo "$PASS" | cryptsetup -q luksFormat -h sha512 -i 5000 -s 512 "/dev/${DISK}2"
echo "$PASS" | cryptsetup open "/dev/${DISK}2" cryptroot

mkfs.btrfs -f /dev/mapper/cryptroot

mount /dev/mapper/cryptroot /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@var_log
btrfs su cr /mnt/@var_cache
btrfs su cr /mnt/@var_lib_libvirt_images
chattr +C /mnt/@var_{log,cache,lib_libvirt_images}
umount /mnt

mkdir -p /mnt/{host,template}

mount -o defaults,compress-force=zstd,noatime,subvol=@ /dev/mapper/cryptroot /mnt/host
mkdir -p /mnt/host/{boot,home,var/{log,cache,lib/libvirt/images}}
mount -o defaults,nodev,nosuid,noexec,umask=0077 "/dev/${DISK}1" /mnt/host/boot
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,subvol=@home /dev/mapper/cryptroot /mnt/host/home
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec,subvol=@var_log /dev/mapper/cryptroot /mnt/host/var/log
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec,subvol=@var_cache /dev/mapper/cryptroot /mnt/host/var/cache
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec,subvol=@var_lib_libvirt_images /dev/mapper/cryptroot /mnt/host/var/lib/libvirt/images

reflector -c US -p https -a 12 -l 20 -f 5 --sort rate --save /etc/pacman.d/mirrorlist
sed -i 's/^#\(ParallelDownloads = 5\)/\1/' /etc/pacman.conf
pacman -Sy --noconfirm archlinux-keyring qemu-img

pacstrap /mnt/host - < "$SCRIPTDIR"/00_host/packages.txt

mv /mnt/host/boot/vmlinuz-linux /mnt/host/usr/lib/modules/vmlinuz
rm -rf /mnt/host/boot/*
mkdir -p /mnt/host/boot/EFI/BOOT

genfstab -U /mnt/host >> /mnt/host/etc/fstab

echo "zenixark" > /mnt/host/etc/hostname

sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /mnt/host/etc/locale.gen
echo "LANG=en_US.UTF-8" > /mnt/host/etc/locale.conf

arch-chroot /mnt/host bash -e << HOST
ln -sf "/usr/share/zoneinfo/America/New_York" /etc/localtime

hwclock --systohc

locale-gen

useradd -m user
chpasswd <<< "root:$PASS"$'\n'"user:$PASS"
passwd --lock root
HOST

mapfile -t files < <(find "$SCRIPTDIR"/00_host/{etc,home} -type f)
for src in "${files[@]}"; do
    cmp -s "$src" "/mnt/host/${src#"$SCRIPTDIR"/00_host/}" || install -Dm644 "$src" "/mnt/host/${src#"$SCRIPTDIR"/00_host/}"
done

sed -i "s|\${UUID}|$(blkid -s UUID -o value "$(cryptsetup status cryptroot | awk '/device:/ {print $2}')")|g" /mnt/host/etc/kernel/cmdline

mapfile -t services << 'SERVICES'
btrfs-scrub@-.timer
getty@.service
libvirtd.service
fstrim.timer
SERVICES

for svc in "${services[@]}"; do
    systemctl enable --root=/mnt/host "$svc"
done

for svc in $(systemctl list-unit-files --root=/mnt/host --type=service --state=enabled --no-legend | awk '{print $1}'); do
    [[ "${services[*]}" =~ $svc ]] || systemctl disable --root=/mnt/host "$svc"
done

systemctl mask --root=/mnt/host systemd-boot-random-seed.service

for opt in "$SCRIPTDIR"/00_host/optional/*; do
    cp "$opt" /mnt/host
    arch-chroot /mnt/host bash "/${opt#"$SCRIPTDIR"/00_host/optional/}"
    rm "/mnt/host/${opt#"$SCRIPTDIR"/00_host/optional/}"
done

arch-chroot /mnt/host bash -e << HOST
ln -sfn /tmp /home/user/.cache
ln -sfn /tmp /home/user/.local

chown -R user:user /home/user

mkinitcpio -p linux
HOST

modprobe nbd

qemu-img create -f qcow2 /mnt/host/var/lib/libvirt/images/template.qcow2 16G
qemu-img create -f qcow2 /mnt/host/var/lib/libvirt/images/home.qcow2 800G

qemu-nbd --connect=/dev/nbd0 /mnt/host/var/lib/libvirt/images/template.qcow2
qemu-nbd --connect=/dev/nbd1 /mnt/host/var/lib/libvirt/images/home.qcow2

sgdisk --zap-all /dev/nbd0
sgdisk -g /dev/nbd0
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" /dev/nbd0
sgdisk -n 2:0:0 -t 2:8300 -c 2:"Linux filesystem" /dev/nbd0

sgdisk --zap-all /dev/nbd1
sgdisk -g /dev/nbd1
sgdisk -n 1:0:0 -t 1:8300 -c 1:"Linux filesystem" /dev/nbd1

mkfs.fat -F 32 /dev/nbd0p1
mkfs.btrfs -f /dev/nbd0p2
mkfs.btrfs -f /dev/nbd1p1

mount /dev/nbd0p2 /mnt/template
btrfs su cr /mnt/template/@
btrfs su cr /mnt/template/@var_log
btrfs su cr /mnt/template/@var_cache
chattr +C /mnt/template/@var_{log,cache}
umount /mnt/template

mount -o defaults,compress-force=zstd,noatime,subvol=@ /dev/nbd0p2 /mnt/template
mkdir -p /mnt/template/{boot,home,var/{log,cache}}
mount -o defaults,nodev,nosuid,noexec,umask=0077 /dev/nbd0p1 /mnt/template/boot
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec /dev/nbd1p1 /mnt/template/home
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec,subvol=@var_log /dev/nbd0p2 /mnt/template/var/log
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec,subvol=@var_cache /dev/nbd0p2 /mnt/template/var/cache

pacstrap /mnt/template - < "$SCRIPTDIR"/01_template/packages.txt

mv /mnt/template/boot/vmlinuz-linux /mnt/template/usr/lib/modules/vmlinuz
rm -rf /mnt/template/boot/*
mkdir -p /mnt/template/boot/EFI/BOOT

genfstab -U /mnt/template >> /mnt/template/etc/fstab

echo "archlinux" > /mnt/template/etc/hostname

sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /mnt/template/etc/locale.gen
echo "LANG=en_US.UTF-8" > /mnt/template/etc/locale.conf

arch-chroot /mnt/template bash -e << TEMPLATE
ln -sf "/usr/share/zoneinfo/America/New_York" /etc/localtime

hwclock --systohc

locale-gen

useradd -m user
chpasswd <<< "root:$PASS"$'\n'"user:$PASS"
passwd --lock root
TEMPLATE

mapfile -t files < <(find "$SCRIPTDIR"/01_template/{etc,home,var} -type f)
for src in "${files[@]}"; do
    cmp -s "$src" "/mnt/template/${src#"$SCRIPTDIR"/01_template/}" || install -Dm644 "$src" "/mnt/template/${src#"$SCRIPTDIR"/01_template/}"
done

sed -i "s|\${UUID}|$(blkid -s UUID -o value /dev/nbd0p2)|g" /mnt/template/etc/kernel/cmdline

for svc in $(systemctl list-unit-files --root=/mnt/template --type=service --state=enabled --no-legend | awk '{print $1}'); do
    [[ "getty@.service" == "$svc" ]] || systemctl disable --root=/mnt/template "$svc"
done

systemctl mask --root=/mnt/template systemd-boot-random-seed.service

arch-chroot /mnt/template bash -e << 'TEMPLATE'
ln -sfn /tmp /home/user/.cache
ln -sfn /tmp /home/user/.local

chown -R user:user /home/user

mkinitcpio -p linux
TEMPLATE

umount -R /mnt/template
sleep 5
qemu-nbd --disconnect /dev/nbd0
qemu-nbd --disconnect /dev/nbd1

arch-chroot /mnt/host bash -e << 'HOST'
qemu-img create -f qcow2 -b /var/lib/libvirt/images/template.qcow2 -F qcow2 /var/lib/libvirt/images/user.qcow2
qemu-img create -f qcow2 -b /var/lib/libvirt/images/template.qcow2 -F qcow2 /var/lib/libvirt/images/proxy.qcow2
qemu-img create -f qcow2 -b /var/lib/libvirt/images/template.qcow2 -F qcow2 /var/lib/libvirt/images/firewall.qcow2
qemu-img create -f qcow2 -b /var/lib/libvirt/images/template.qcow2 -F qcow2 /var/lib/libvirt/images/network.qcow2

qemu-nbd --connect=/dev/nbd2 /var/lib/libvirt/images/proxy.qcow2
qemu-nbd --connect=/dev/nbd3 /var/lib/libvirt/images/firewall.qcow2
qemu-nbd --connect=/dev/nbd4 /var/lib/libvirt/images/network.qcow2
sleep 5

mkdir /mnt/{2,3,4}

mount -o defaults,compress-force=zstd,noatime,subvol=@ /dev/nbd2p2 /mnt/2
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec,subvol=@var_log /dev/nbd2p2 /mnt/2/var/log
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec,subvol=@var_cache /dev/nbd2p2 /mnt/2/var/cache
systemctl enable --root=/mnt/2 adguardhome wireguard

mount -o defaults,compress-force=zstd,noatime,subvol=@ /dev/nbd3p2 /mnt/3
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec,subvol=@var_log /dev/nbd3p2 /mnt/3/var/log
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec,subvol=@var_cache /dev/nbd3p2 /mnt/3/var/cache
systemctl enable --root=/mnt/3 nftables

mount -o defaults,compress-force=zstd,noatime,subvol=@ /dev/nbd4p2 /mnt/4
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec,subvol=@var_log /dev/nbd4p2 /mnt/4/var/log
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec,subvol=@var_cache /dev/nbd4p2 /mnt/4/var/cache
systemctl enable --root=/mnt/4 iwd systemd-timesyncd

umount -R /mnt/*
rmdir /mnt/*

sleep 5
qemu-nbd --disconnect /dev/nbd2
qemu-nbd --disconnect /dev/nbd3
qemu-nbd --disconnect /dev/nbd4
HOST

modprobe -r nbd

echo -e "\e[32mDone!\e[0m"
