#!/usr/bin/env bash
set -e
CONFIG_PATH="$HOME/.config/mpd" # should be the same as in setup-mpd.sh

install_fzf() { # underscore for posix compliance
	if command -v sudo >/dev/null 2>&1; then
		cmd="sudo"
	elif command -v doas >/dev/null 2>&1; then
		cmd="doas"
	else
		echo "No sudo nor doas found, running as current user."
	fi

	if command -v emerge >/dev/null 2>&1; then
		echo "Portage detected (Gentoo-Based)"
		$cmd emerge fzf
	elif command -v apt >/dev/null 2>&1; then
		echo "APT detected (Debian-Based)"
		$cmd apt update
		$cmd apt install -y fzf
	elif command -v dnf >/dev/null 2>&1; then
		echo "DNF detected (RHEL)"
		$cmd dnf install -y fzf
	elif command -v pacman >/dev/null 2>&1; then
		echo "Pacman detected (Arch-Based)"
		$cmd pacman -Syu --noconfirm fzf
	elif command -v zypper >/dev/null 2>&1; then
		echo "Zypper detected (openSUSE)"
		$cmd zypper install -y fzf
	else
		echo "Unsupported package manager, install fzf manually"
		echo "and remove this part of the script."
		exit 1
	fi
}

if [[ -n "$1" ]]; then
	choice="$1"
else
	list=()
	for conf in "$CONFIG_PATH"/mpd.conf.*; do 
		list+=("$(head -n1 "$conf" | tr -d ' #')")
	done

	if ! command -v fzf >/dev/null 2>&1; then
		echo "fzf not found, installing fzf..."
		install_fzf
	fi
	choice=$(printf "%s\n" "${list[@]}" | fzf --prompt="Choose config: ")
fi

if [[ -f "$CONFIG_PATH"/mpd.conf."$choice" ]]; then
	echo "Enabling $choice config..."
	extension=$(head -n1 "$CONFIG_PATH"/mpd.conf | tr -d ' #')
	mv "$CONFIG_PATH"/mpd.conf "$CONFIG_PATH"/mpd.conf."$extension"
	mv "$CONFIG_PATH"/mpd.conf."$choice" "$CONFIG_PATH"/mpd.conf
else
	echo "Configuration file not found, please add it to $CONFIG_PATH."
	echo "Switching failed."
	exit 1
fi

echo "Succesfully switched to $choice config"
