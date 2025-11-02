#!/usr/bin/env bash
#!/usr/bin/env bash
set -e

if command -v sudo >/dev/null 2>&1; then
	cmd="sudo"
elif command -v doas >/dev/null 2>&1; then
	cmd="doas"
else
	echo "No sudo/doas found, running as regular user."
fi

echo "Installing python and pip..."

if command -v emerge >/dev/null 2>&1; then
    echo "Portage detected (Gentoo-Based)"
    $cmd emerge python pip
elif command -v apt >/dev/null 2>&1; then
    echo "APT detected (Debian-Based)"
    $cmd apt update
    $cmd apt install -y python python-pip
elif command -v dnf >/dev/null 2>&1; then
    echo "DNF detected (RHEL)"
    $cmd dnf install -y python python-pip
elif command -v pacman >/dev/null 2>&1; then
    echo "Pacman detected (Arch-Based)"
    $cmd pacman -Syu --noconfirm python python-pip
elif command -v zypper >/dev/null 2>&1; then
    echo "Zypper detected (openSUSE)"
    $cmd zypper install -y python python-pip
else
    echo "Unsupported package manager, install python and pip manually,"
		echo "and remove this part of the script."
    exit 1
fi

pip install --upgrade setuptools
pip install spotdl
