Provides much better font rendering.

https://launchpad.net/~no1wantdthisname/+archive/ubuntu/ppa

# Java
https://launchpad.net/~no1wantdthisname/+archive/openjdk-fontfix

# Install
```
sudo add-apt-repository ppa:no1wantdthisname/ppa
sudo apt-get update
sudo apt-get install libfreetype6
```

# Uninstall
```
sudo apt-get install ppa-purge
sudo ppa-purge ppa:no1wantdthisname/ppa
```

# Tweaking font rendering (optional)
1. Change hinting/antialiasing
   ```
   sudo apt-get install gnome-tweak-tool
   gnome-tweak-tool
   # Go to "Fonts"
   # I prefer Full/Rgba
   ```

# Troubleshooting

## Wine applications crash/don't work

Grab the normal libfreetype6 from http://archive.ubuntu.com/ubuntu/pool/main/f/freetype/

Unpack the shared library to $SOME_FOLDER.

Then run your application with that folder preferred.

E.G.

```
#!/bin/sh
export LD_LIBRARY_PATH=$SOME_FOLDER
run_some_app "$@"
```

## My display manager stopped working

Ubuntu:

```
sudo update-rc.d -f lightdm remove
sudo update-rc.d lightdm defaults
```

Linux Mint:

```
sudo update-rc.d -f mdm remove
sudo update-rc.d mdm defaults
```

http://askubuntu.com/questions/287606/fontconfig-infinality-causes-13-04-boot-failure

# How

This ppa is built via this [build script](build-all).

For build dependencies:

```
sudo apt-get install dpkg-dev devscripts debhelper
```

## Distribution <= 13.04:
Applies infinality patches (currently 2013-05-15) against freetype.  
See: http://www.infinality.net/

## Distribution <= 15.10:
Applies bohoomil's variant.  
See: https://github.com/bohoomil/fontconfig-ultimate

## Distribution >= 16.04:
Sets freetype 2.6.4+ new option `TT_CONFIG_OPTION_SUBPIXEL_HINTING=2`.
This is experimental for now. I may end up switching to back to bohoomil's patches.
See: https://sourceforge.net/projects/freetype/files/freetype2/2.6.4/

# Alternatives

https://github.com/bohoomil/fontconfig-ultimate
