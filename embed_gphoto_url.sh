#!/usr/local/bin/bash

# Create code for embedding Google Photos image into HTML page. Width and height for
# preview image need to be given and will be encoded into URL in a way supported by
# Google servers.
#
# Arguments:
# 1. Image URL.
# 2. Width.
# 3. Height.
# 4. (Optional) CSS class attribute for 'img' element.


if ! [[ "$1" =~ ^"https://lh3.googleusercontent.com/" ]]; then
    echo "Expecting argument in format of shared Google Photos URL: https://lh3.googleusercontent.com/..."
    exit 1
fi

re='^[0-9]+$'
if ! [[ $2 =~ $re ]] ; then
   echo "error: Second argument not a number" >&2
   exit 1
fi

if ! [[ $3 =~ $re ]] ; then
   echo "error: Third argument not a number" >&2
   exit 1
fi

base_url=$(echo -n $1 | sed 's![^=]*$!!')
if ! [[ "$base_url" =~ ^"https://lh3.googleusercontent.com/" ]]; then
    echo "Sorry, creating embed code failed."
    exit 1
fi

large_url="${base_url}w2400"
image_url+="${base_url}w${2}-h${3}-p-k"

if [ -z "$4" ]; then
    code="<a href=\"${large_url}\"> <img src=\"${image_url}\"/> </a>"
else
    code="<a href=\"${large_url}\"> <img class=\"${4}\" src=\"${image_url}\"/> </a>"
fi

echo "$code"

exit 0
