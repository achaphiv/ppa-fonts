Better font rendering for java. Particularly for swing applications.

https://launchpad.net/~no1wantdthisname/+archive/ubuntu/openjdk-fontfix

Note: This ppa only updates for last LTS & release (14.04).

Best if combined with infinality patched freetype:
https://launchpad.net/~no1wantdthisname/+archive/ppa

To show how close it can get to native rendering (font is Consolas):

| application   | screenshot                     |
| ------------- | ------------------------------ |
| idea (before) | http://i.imgur.com/c2Vnahz.png |
| idea (after)  | http://i.imgur.com/E9XVSa9.png |
| eclipse       | http://i.imgur.com/GmG5Ip3.png |

Intellij Idea 12 before (oracle jdk 1.7): http://i.imgur.com/wzVVm.png

After (this repo's openjdk and various infinality options):

| fontconfig | env vars   | result                       |
| ---------- | ---------- | ---------------------------- |
| default    | infinality | http://i.imgur.com/BwVk4.png |
| infinality | win7       | http://i.imgur.com/Duhev.png |
| win7       | win7       | http://i.imgur.com/04YZr.png | 

(etc., there's too many combinations to list them all)

# Install

```
sudo add-apt-repository ppa:no1wantdthisname/openjdk-fontfix
sudo apt-get update
sudo apt-get install openjdk-7-jdk
```

## Prefer this repository (optional)

By default, security updates are preferred over this repository's packages.
This is intentional.

If you are willing to accept the possible security risk, you can always prefer this repository by adding this file.

```
$ cat /etc/apt/preferences.d/openjdk-fontfix
Package: *
Pin: release o=LP-PPA-no1wantdthisname-openjdk-fontfix
Pin-Priority: 600
```

# Uninstall

```
sudo apt-get install ppa-purge
sudo ppa-purge ppa:no1wantdthisname/openjdk-fontfix
```

# Usage

Run your program with this patched jdk.

E.G. For Intellij Idea, use this script:

```
#!/bin/sh

# change to your location
IDEA_HOME=$HOME/.local/opt/idea

export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64

# Note: Can modify $IDEA_HOME/bin/idea{,64}.vmoptions
#       instead of setting here.
# "-Dawt.useSystemAAFontSettings=on" seems worse to me
# "-Dsun.java2d.xrender=true" makes fonts darker
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd \
                      -Dsun.java2d.xrender=true"

# Having this set makes menu font size smaller (wtf?)
export GNOME_DESKTOP_SESSION_ID=this-is-deprecated
# unset GNOME_DESKTOP_SESSION_ID

exec $IDEA_HOME/bin/idea.sh "$@"
```

# How
Turns on `--enable-infinality` flag.

This ppa is built via [build_packages.sh](build_packages.sh)

For build dependencies:

```
sudo add-get install dpkg-dev devscripts devhelper
```
