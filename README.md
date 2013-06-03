Scripts/Tools/Utils for B2G

b2g-audio.sh is a script which allow user to put a ringtone on Gaia (Firefox OS) on his device.
Currently it only accept mono audio files (mp3, ogg, opus), see [Bug 878807](https://bugzilla.mozilla.org/show_bug.cgi?id=878807).

This script needs [jq](https://github.com/stedolan/jq), [zenity](https://live.gnome.org/Zenity) and [adb](http://developer.android.com/tools/help/adb.html) installed and available in the user path.

Tested on Ubuntu 12.10 & Windows 8 (with [MinGW MSYS](http://www.mingw.org/)) with Geeksphone Peak.
