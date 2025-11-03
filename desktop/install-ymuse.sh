#!/usr/bin/env bash
set -e

if command -v sudo >/dev/null 2>&1; then
	cmd="sudo"
elif command -v doas >/dev/null 2>&1; then
	cmd="doas"
else
	echo "No sudo/doas found, running as regular user."
fi

echo "Installing flatpak..."
if command -v emerge >/dev/null 2>&1; then
    echo "Portage detected (Gentoo-Based)"
    $cmd emerge flatpak
elif command -v apt >/dev/null 2>&1; then
    echo "APT detected (Debian-Based)"
    $cmd apt update
    $cmd apt install -y flatpak 
elif command -v dnf >/dev/null 2>&1; then
    echo "DNF detected (RHEL)"
    $cmd dnf install -y flatpak
elif command -v pacman >/dev/null 2>&1; then
    echo "Pacman detected (Arch-Based)"
    $cmd pacman -Syu --noconfirm flatpak
elif command -v zypper >/dev/null 2>&1; then
    echo "Zypper detected (openSUSE)"
    $cmd zypper install -y flatpak 
else
    echo "Unsupported package manager, install flatpak manually"
		echo "and remove this part of the script."
    exit 1
fi

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
$cmd flatpak install com.yktoo.ymuse
$cmd cp run-ymuse.sh /usr/local/bin/ymuse
