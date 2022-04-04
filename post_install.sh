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
	config_repo="git@github.com:ecmatthee/dotfiles.git"
}

package_install() {
	cat "${script_dir}"/package_lists/system/* | sed -e "/^#/d" -e "s/#.*//" - | sudo pacman -S --needed -
	cat "${script_dir}"/package_lists/aur/* | sed -e "/^#/d" -e "s/#.*//" - | paru -S --needed -
}

system_setup() {
	for file in "${script_dir}"/setup_scripts/*.sh; do
		chmod +x "${file}"
		bash "${file}"
		chmod -x "${file}"
	done
}

get_config() {
	mkdir ~/.config
	cd ~/.config
	git clone "${config_repo}" 
}

finish() {
	echo "done"
}

main
