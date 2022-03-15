#!/bin/bash

main() {
	shell_settings
	declare_globals
	system_setup
}

shell_settings() {
	set -euo pipefail
	trap finish EXIT
	IFS=$'\n\t'
}

declare_globals() {
	script_dir="$(dirname "$(readlink -f "$0")")"
	package_list="$script_dir/list/package_list"
	aur_list="$script_dir/list/aur_list"
}

package_install() {
	sed -e "/^#/d" -e "s/#.*//" "${package_list}" | pacman -S --needed -
	sed -e "/^#/d" -e "s/#.*//" "${aur_list}" | paru -S --needed -
}

system_setup() {
	systemctl --user enable pipewire.service
    systemctl --user enable pipewire-pulse.service
}

finish() {
	echo "done"
}

main
