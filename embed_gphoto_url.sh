#!/usr/bin/env bash

# Create code for embedding Google Photos image into HTML page. Width and height for
# preview image need to be given and will be encoded into URL in a way supported by
# Google servers.
#
# Arguments:
# 1. Image URL.
# 2. Width.
# 3. Height.
# 4. (Optional) CSS class attribute for 'img' element.

# 'get_gphoto_url.sh' is in the same/current folder or scripts are in dir that is in your PATH? TODO: Automate this?
get_gphoto_url_sh="get_gphoto_url.sh"
# get_gphoto_url_sh="./get_gphoto_url.sh"

echoerr() { printf "%s\n" "$*" >&2; }

gphoto_url=$1

if [[ "$gphoto_url" =~ ^"https://photos.app.goo.gl/" ]]; then
    gphoto_url=$($get_gphoto_url_sh $gphoto_url)
    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

if ! [[ "$gphoto_url" =~ ^"https://lh3.googleusercontent.com/" ]]; then
    echoerr "Error: Expecting argument in format of shared Google Photos URL: https://lh3.googleusercontent.com/..."
    exit 1
fi

re='^[0-9]+$'
if ! [[ $2 =~ $re ]] ; then
   echoerr "Error: Second argument not a number"
   exit 1
fi

if ! [[ $3 =~ $re ]] ; then
   echoerr "Error: Third argument not a number"
   exit 1
fi

base_url=$(echo -n $gphoto_url | sed 's![^=]*$!!')
if ! [[ "$base_url" =~ ^"https://lh3.googleusercontent.com/" ]]; then
    echoerr "Error: Sorry, creating embed code failed."
    exit 1
fi

large_url="${base_url}w2400"
image_url+="${base_url}w${2}-h${3}-p-k"

if [ -z "$4" ]; then
    code="<a href=\"${large_url}\"> <img src=\"${image_url}\"> </a>"
else
    code="  <a href=
  \"${large_url}\">
  <img class=\"${4}\" src=
  \"${image_url}\">
  </a>"
fi

echo "$code"
