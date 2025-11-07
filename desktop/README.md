# Instructions

## Cloning the repository

For the next steps its preferable to clone the
repository, and traverse to the `./desktop` directory.
As well as secure yourself a text editor.

```bash
# install git and your text editor of choice 
# with your package manager
git clone https://github.com/kripticni/selfhosted-music
cd selfhosted-music/desktop
```

If you leave your terminal, in the process and the 
working directory is reset, traverse back again with:
```bash
cd selfhosted-music/desktop
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
traverse to the desktop directory if you aren't
there already and run:
```bash
./install-spotdl.sh
```
To use spotdl the syntax is.
```bash
spotdl "spotify_link/url_here" --output "/path/to/your/music/dir"
# by default that would ~/Music
```

## ymuse

This is a user friendly GUI mpd client.
And I would recommend it for most people.
To get it simply run:
```bash
./install-ymuse.sh
```

## ncmpcpp

A advanced CLI mpd client.
For vim users and shell wizards, if you
are choosing this client, you likely
already have it.
For people using it for the first time,
this [cheatsheet](https://pkgbuild.com/~jelle/ncmpcpp/) is very useful.
