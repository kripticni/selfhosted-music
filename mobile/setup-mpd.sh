#!/usr/bin/env bash
set -e

echo "Updating package repositories..."
pkg update -y

echo "Installing mpd and mpc..."
pkg install -y mpd mpc

echo "Installing pulseaudio for the software mixer..."
pkg install -y pulseaudio

echo "Asking for device storage permission..."
sleep 2
termux-setup-storage

echo "Configuring the mpd server..."
CONFIG_PATH="$HOME/.config/mpd"
MUSIC_DIR="$HOME/Music"
mkdir -p "$CONFIG_PATH"
mkdir -p "$HOME/Music"
touch "$CONFIG_PATH/mpd.conf"
mkdir -p "$CONFIG_PATH/playlists"

cat > "$CONFIG_PATH/mpd.conf" << EOF
music_directory	"$MUSIC_DIR"
playlist_directory "$CONFIG_PATH/playlists"
db_file "$CONFIG_PATH/database"
log_file "$CONFIG_PATH/log"
pid_file "$CONFIG_PATH/pid"
state_file "$CONFIG_PATH/state"

audio_output {
	type "pulse"
	name "dummy"
	mixer "software"
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

echo "Starting mpd server..."
echo "(to stop use mpd --kill)"

mpd

echo "Started mpd server, you can use mpc to play locally, or use another client."
echo "To connect from another device use <your-phone-private/public-ip>:6600"
