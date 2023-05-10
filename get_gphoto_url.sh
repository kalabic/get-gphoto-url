#!/usr/local/bin/bash

# This script will try to create direct permanent link to public shared image on
# Google Photos (in its original size).
# Open Google Photos in your browser, go to photo, click 'Share' button, select
# 'Create link to share' and provide given link as an argument to this script.
# On rare occasions parsing response can fail. Just try again and good luck!


if ! [[ "$1" =~ ^"https://photos.app.goo.gl/" ]]; then
    echo "Error: Expecting argument in format of shared Google Photos URL: https://photos.app.goo.gl/..." 1>&2
    exit 1
fi

page=$(wget --no-cookies -qO- $1)
result=$?
if [ $result -ne 0 ]; then
    echo "Error: Download from provided URL failed." 1>&2
    exit 1
fi

if ! [[ "$page" =~ ^"<!doctype html>" ]]; then
    echo "Error: HTML format not recognized, unsupported response from server." 1>&2
    exit 1
fi

link=$(echo -n $page | grep -o "content=\"https://lh3.googleusercontent.com/[A-Za-z0-9\/=_-]*\"" | sed 's![^=]*$!!' | sed 's/[^"]*"//' | sed 's/$/w0/')
if [[ "$link" =~ ^"https://lh3.googleusercontent.com/" ]]; then
    echo "$link"
else
    echo "Error: Sorry, gphoto URL not found in response. Trying again can fix the issue." 1>&2
    exit 1
fi
