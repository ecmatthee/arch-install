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
	config_repo="git@github.com:ecmatthee/dotfiles.git"
}

package_install() {
	sed -e "/^#/d" -e "s/#.*//" "${package_list}" | sudo pacman -S --needed -
	sed -e "/^#/d" -e "s/#.*//" "${aur_list}" | paru -S --needed -
}

system_setup() {
	for file in "${script_dir}"/setup_scripts/*.sh; do
		chmod +x "${file}"
		bash "${file}"
		chmod -x "${file}"
	done
}

get_config() {
	git clone "${config_repo}" 
}

finish() {
	echo "done"
}

main
