#!/bin/bash

#################################################################
## Script to provide transcoding support to non-mp3 songs
## for Tonido Jukebox.
##
## Author: Codelathe LLC
##
#################################################################

export LD_LIBRARY_PATH=.
DIRNAME=`dirname $0`
SONGPATH="$1"
BITRATE=$2
if [[ ! -f $SONGPATH ]]; then
	echo "Invalid Song Path"
	exit 1	
fi
if [[ -z $BITRATE ]]; then
	echo "Invalid Bitrate"
	exit 1	
fi

#Find sampling rate
SAMPLERATE=`$DIRNAME/ffmpeg.exe -i $SONGPATH 2>&1 | grep Stream| sed -e 's/Hz.*$//g' | sed -e 's/^.*, //g' `
if [[ -z $SAMPLERATE ]]; then
	SAMPLERATE="44100"
fi

#Transcode
$DIRNAME/ffmpeg.exe -i "$SONGPATH" -f wav - | $DIRNAME/shineenc.exe  -q -b $BITRATE - -
pkill -9 ffmpeg.exe
exit 0
