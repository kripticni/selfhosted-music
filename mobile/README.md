# Instructions

## Termux

You first want to download [termux](https://github.com/termux/termux-app) on your phone,
preferably from github, but app stores are fine 
as well.

## Cloning the repository

For the next steps its preferable to clone the
repository, and traverse to the `./mobile` directory.
As well as secure yourself a text editor.

```bash
pkg update
pkg upgrade
pkg install git nano
git clone https://github.com/kripticni/selfhosted-music
cd selfhosted-music/mobile
```

If you leave your terminal, in the process and the 
working directory is reset, traverse back again with:
```bash
cd selfhosted-music/mobile
```

## mpd

Then you can change the `setup-mpd.sh` script to
your liking with `nano setup-mpd.sh`. Mainly by setting a password in the
config file (recommended), and changing the paths (optional),
and configuring on which address/port you want to open the server (optional).

Make your changes:
```bash
nano setup-mpd.sh
```

Then you can run the script by doing:
```bash
./setup-mpd.sh
```

## spotdl

If you want to use spotdl to download music, 
traverse to the mobile directory if you aren't
there already and run:
```bash
./install-spotdl.sh
```
To use spotdl the syntax is.
```bash
spotdl "spotify_link/url_here" --output "/path/to/your/music/dir"
# by default that would ~/Music
```

## malp

You can get a release of [malp from their gitlab](https://gitlab.com/gateship-one/malp),
or maybe more preferably from the [F-Droid](https://f-droid.org/en/) catalogue.
Setting it up is simple, create a new profile and put in 
the same address and port you did in your mpd.conf.
This is by default 0.0.0.0:6600.

Disclaimer: malp is not easily obtainable on iOS, 
you can use an alternatives from the app store:
- MPD Pilot
- Maximum MPD
- MPD Player

## servers

If you want to connect to other servers rather
than the server on your device, you need to 
connect to the http stream which is on
that server's address on port 8000 by default.
You can do this in your web browser, but I 
would recommend using [VLC](https://code.videolan.org/videolan/vlc) simply because it's assured
to support all frequencies and codecs while being insanely performant.
