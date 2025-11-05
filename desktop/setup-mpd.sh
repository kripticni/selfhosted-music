#!/usr/bin/env bash
set -e

if command -v sudo >/dev/null 2>&1; then
	cmd="sudo"
elif command -v doas >/dev/null 2>&1; then
	cmd="doas"
else
	echo "No sudo nor doas found, running as current user."
fi

echo "Installing mpd and mpc..."

if command -v emerge >/dev/null 2>&1; then
    echo "Portage detected (Gentoo-Based)"
    $cmd emerge media-sound/mpd media-sound/mpc
elif command -v apt >/dev/null 2>&1; then
    echo "APT detected (Debian-Based)"
    $cmd apt update
    $cmd apt install -y mpd mpc
elif command -v dnf >/dev/null 2>&1; then
    echo "DNF detected (RHEL)"
    $cmd dnf install -y mpd mpc
elif command -v pacman >/dev/null 2>&1; then
    echo "Pacman detected (Arch-Based)"
    $cmd pacman -Syu --noconfirm mpd mpc
elif command -v zypper >/dev/null 2>&1; then
    echo "Zypper detected (openSUSE)"
    $cmd zypper install -y mpd mpc
else
    echo "Unsupported package manager, install mpd and mpc manually"
		echo "and remove this part of the script."
    exit 1
fi

echo "Installation complete."

echo "Configuring the mpd server..."
CONFIG_PATH="$HOME/.config/mpd"
MUSIC_DIR="$HOME/Music"
mkdir -p "$CONFIG_PATH"
touch "$CONFIG_PATH/mpd.conf"
touch "$CONFIG_PATH/pid"
mkdir -p "$CONFIG_PATH/playlists"

cat > "$CONFIG_PATH/mpd.conf" << EOF
#client
music_directory	"$MUSIC_DIR"
playlist_directory "$CONFIG_PATH/playlists"
db_file "$CONFIG_PATH/database"
log_file "$CONFIG_PATH/log"
pid_file "$CONFIG_PATH/pid"
state_file "$CONFIG_PATH/state"

audio_output {
	type "pulse"
	name "dummy"
	mixer_type "software"
}

bind_to_address "0.0.0.0"
port "6600"

# It's recommended to put a password
# the syntax is password <password> <ip addresses>
# if you are connecting from an outside network
# or have a dynamic ip address, you should
# probably allow every address with *
# password "insert_password_here" "*"
EOF

cat > "$CONFIG_PATH/mpd.conf.both" << EOF
#both
music_directory	"$MUSIC_DIR"
playlist_directory "$CONFIG_PATH/playlists"
db_file "$CONFIG_PATH/database"
log_file "$CONFIG_PATH/log"
pid_file "$CONFIG_PATH/pid"
state_file "$CONFIG_PATH/state"

audio_output {
	type	"httpd"
	name	"http server"
	encoder	"flac" # fully lossless
	port	"8000"
	bitrate	"320"
	format	"96000:24:5" # highest possible but often not needed
													# would be 384000:64:7
	buffer_time "1000000"
}

audio_output {
	type "pulse"
	name "dummy"
	mixer_type "software"
}

bind_to_address "0.0.0.0"
port "6600"

# It's recommended to put a password
# the syntax is password <password> <ip addresses>
# if you are connecting from an outside network
# or have a dynamic ip address, you should
# probably allow every address with *
# password "insert_password_here" "*"
EOF

cat > "$CONFIG_PATH/mpd.conf.server" << EOF
#server
music_directory	"$MUSIC_DIR"
playlist_directory "$CONFIG_PATH/playlists"
db_file "$CONFIG_PATH/database"
log_file "$CONFIG_PATH/log"
pid_file "$CONFIG_PATH/pid"
state_file "$CONFIG_PATH/state"

audio_output {
	type	"httpd"
	name	"http server"
	encoder	"flac" # fully lossless
	port	"8000"
	bitrate	"320"
	format	"96000:24:5" # highest possible but often not needed
													# would be 384000:64:7
	buffer_time "1000000"
}

bind_to_address "0.0.0.0"
port "6600"

# It's recommended to put a password
# the syntax is password <password> <ip addresses>
# if you are connecting from an outside network
# or have a dynamic ip address, you should
# probably allow every address with *
# password "insert_password_here" "*"
EOF

echo "Adding mpdswp script to /usr/local/bin..."
cp ./mpdswp.sh /usr/local/bin/mpdswp

echo "Starting mpd server..."
echo "(to stop use mpd --kill)"

mpd

echo "Started mpd server, you can use mpc to play locally, or use another client."
echo "To connect from another device use <your-desktop-private/public-ip>:6600"
