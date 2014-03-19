Provides much better font rendering.

* Applies infinality patches (currently 2013-05-15) against freetype.
  See: http://www.infinality.net/

This ppa is built via:
https://github.com/achaphiv/ppa-fonts/blob/master/ppa/build_packages.sh

Note: This ppa only updates for last LTS & release (12.04/13.10).
======================================================================
For java:
https://launchpad.net/~no1wantdthisname/+archive/openjdk-fontfix
======================================================================
Install:
   $ sudo add-apt-repository ppa:no1wantdthisname/ppa
   $ sudo apt-get update
   $ sudo apt-get upgrade
   $ sudo apt-get install fontconfig-infinality

Uninstall:
   $ sudo apt-get remove --purge fontconfig-infinality
   $ sudo apt-get install ppa-purge
   $ sudo ppa-purge ppa:no1wantdthisname/ppa

Tweaking font rendering (optional):
1. Adjust fontconfig files
   $ cd /etc/fonts/infinality/
   $ sudo bash infctl.sh setstyle
   $ # modify conf.d/*

2. Change infinality environment variables
   $ sudo gedit /etc/profile.d/infinality-settings.sh
   $ # Modify this to your liking.
     # E.G. towards the bottom of the file, there's USE_STYLE.
   $ # Logout/Login to take effect

3. Change hinting/antialiasing.
   $ sudo apt-get install gnome-tweak-tool
   $ gnome-tweak-tool
   $ # Go to "Fonts"
   $ # I prefer Full/Rgba
