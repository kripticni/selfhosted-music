#!/usr/bin/env bash
set -e

if command -v sudo >/dev/null 2>&1; then
	cmd="sudo"
elif command -v doas >/dev/null 2>&1; then
	cmd="doas"
else
	echo "No sudo/doas found, running as regular user."
fi

echo "Installing ncmpcpp..."

if command -v emerge >/dev/null 2>&1; then
    echo "Portage detected (Gentoo-Based)"
    $cmd emerge ncmpcpp
elif command -v apt >/dev/null 2>&1; then
    echo "APT detected (Debian-Based)"
    $cmd apt update
    $cmd apt install -y ncmpcpp 
elif command -v dnf >/dev/null 2>&1; then
    echo "DNF detected (RHEL)"
    $cmd dnf install -y ncmpcpp
elif command -v pacman >/dev/null 2>&1; then
    echo "Pacman detected (Arch-Based)"
    $cmd pacman -Syu --noconfirm ncmpcpp
elif command -v zypper >/dev/null 2>&1; then
    echo "Zypper detected (openSUSE)"
    $cmd zypper install -y ncmpcpp
else
    echo "Unsupported package manager, install ncmpcpp manually."
    exit 1
fi
