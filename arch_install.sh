#!/bin/env bash

main() {
    shell_settings
    declare_globals
}

shell_settings() {
    set -euo pipefail
    trap finish EXIT
    IFS=$'\n\t'
}

declare_globals() {
    region="Africa"
    city="Johannesburg"
    locale="en_US.UTF-8"
    hostname=""
    #$(curl https://ipapi.co/timezone)
}

network_setup() {
    timedatectl set-ntp true
}

partition() {	
    uefi=$( ls /sys/firmware/efi/ | grep -ic efivars )
    if [ "$uefi" == 1 ]
    then
        echo "System booted in UEFI Mode"
    else
        echo "System booted in BIOS or CSM Mode"
    fi
}

install_sys() {
	# Pre-install setup
    reflector --verbose --latest 20 ---protocol https -sort rate --save /etc/pacman.d/mirrorlist

	# Pacstrap
    pacstrap /mnt base linux linuxfirmware

	# Fstab
    genfstab -U /mnt >> /mnt/etc/fstab

	# Timezone
    arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/${region}/${city} /etc/localtime"
    arch-chroot /mnt /bin/bash -c "hwclock --systohc"

	# Locale
    echo "${locale} UTF-8" > /mnt/etc/locale.gen
    arch-chroot /mnt /bin/bash -c "locale-gen"
    echo "LANG=${locale}" > /mnt/etc/locale.conf

	# Hostname
    echo "${hostname}" > /mnt/etc/hostname
}

finish() {
   echo "done"
}

main
