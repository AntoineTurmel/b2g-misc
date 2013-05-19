#!/bin/bash

# Check the OS
case $OSTYPE in
  linux*)   osname='linux' ;;
  msys*)    osname='windows' ;;
  darwin*)  osname='macosx' ;;
  solaris*) osname='solaris' ;;
  bsd*)     osname='bsd' ;;
  *)        osname='unknown' ;;
esac

# Define temp folder
tempfolder='/tmp'
# Define the audio type
audiotype='ringtones'
# Define folder where audio files are
mediafolder='fxos-mod/shared/resources/media/ringtones/'

#Test jq utils
if jq --version
  then echo 'jq is here'
else 
  echo 'Please install jq'
fi

# Start ADB Server
if [ "$osname" == "windows" ]; then
  adb start-server
else
  sudo adb start-server
fi

# Start ADB Server (graphical)
# gksudo adb start-server

# Open Zenity with file selection
myaudiofile=$(zenity --file-selection \
--title="Select a mono audio file (ogg, mp3, opus)" \
--text="" \
);
if [ $? = 1 ];
  then exit
fi

# Get the audio file name
myaudiofilename=`basename ${myaudiofile}`

# Go to temp folder
cd $tempfolder

# Remove the application.zip if existing
rm application.zip

# Remove if existing the working folder
rm fxos-mod -rf

# Make a working folder
mkdir fxos-mod

# Retrieve application.zip from settings
adb pull system/b2g/webapps/settings.gaiamobile.org/application.zip

# Backup our application.zip
cp application.zip application.bak.zip

# Unzip all files from application.zip
unzip application.zip -d fxos-mod

# Copy my ringtone in the right folder
cp $myaudiofile fxos-mod/shared/resources/media/ringtones

# Modify the ringtones list to add our new file
cat ${mediafolder}list.json | jq ' .["'$myaudiofilename'"] = "" ' > ${mediafolder}newlist.json

# Remove the old json list
rm ${mediafolder}list.json

# Rename our new list
mv ${mediafolder}newlist.json ${mediafolder}list.json

cd fxos-mod

# Zip all files into a application.zip
zip -r -9 ../application.new.zip *

cd ..

# Remove the current application.zip and replace it by the new one
rm application.zip
mv application.new.zip application.zip

# Remount to get write access
adb remount

# Push the new application to the device
adb push application.zip system/b2g/webapps/settings.gaiamobile.org/
