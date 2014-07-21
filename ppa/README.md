Provides much better font rendering.

Note: This ppa only updates for last LTS/release (14.04).

# How

This ppa is built via:
https://github.com/achaphiv/ppa-fonts/blob/master/ppa/build_packages.sh

## Distribution <= 13.04:
Applies infinality patches (currently 2013-05-15) against freetype.  
See: http://www.infinality.net/

## Distribution >= 14.04:
Applies bohoomil's variant.  
See: https://github.com/bohoomil/fontconfig-ultimate/blob/pkgbuild/01_freetype2-iu/infinality-2.5.3.patch

# Java
https://launchpad.net/~no1wantdthisname/+archive/openjdk-fontfix

# Install
```
sudo add-apt-repository ppa:no1wantdthisname/ppa
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install fontconfig-infinality
```

# Uninstall
```
sudo apt-get remove --purge fontconfig-infinality
sudo apt-get install ppa-purge
sudo ppa-purge ppa:no1wantdthisname/ppa
```

# Tweaking font rendering (optional)
1. Adjust fontconfig files
   ```
   cd /etc/fonts/infinality/
   sudo bash infctl.sh setstyle
   # modify conf.d/*
   ```

2. Change infinality environment variables
   ```
   sudo gedit /etc/profile.d/infinality-settings.sh
   # Modify this to your liking.
   # E.G. towards the bottom of the file, there's USE_STYLE.
   # Logout/Login to take effect
   ```

3. Change hinting/antialiasing
   ```
   sudo apt-get install gnome-tweak-tool
   gnome-tweak-tool
   # Go to "Fonts"
   # I prefer Full/Rgba
   ```

# Troubleshooting

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
