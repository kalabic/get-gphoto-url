## get_gphoto_url.sh
This script will try to create direct permanent link to public shared image on Google Photos (in its original size).
```
Usage: Open Google Photos in your browser, go to photo, click 'Share' button,
select 'Create link to share' and provide given link as an argument to this script.

./get_gphoto_url.sh https://photos.app.goo.gl/pXqnZZXzzMwJkQ5C7
```

## embed_gphoto_url.sh
Create code for embedding Google Photos image into HTML page.

Script accepts both shared links created by user on Google Photos web page and already created permanent links to image (so, both `photos.app.goo.gl` and `lh3.googleusercontent.com` URLs). It will invoke `get_gphoto_url.sh` script if needed.

Syntax: `embed_gphoto_url.sh <URL> <width> <height> [optional: <CSS class for img>]`
- Width and height for preview image must be provided and will be encoded into URL in a way supported by Google servers.
- CSS class is optional and is added into `img` element as `class` attribute: `<img class="CSS class" ...`
```
Usage: Provide image URL, width, height and redirect output to a file.

./embed_gphoto_url.sh https://photos.app.goo.gl/(your URL...) 1024 1024 > embedded_photo.txt
```
