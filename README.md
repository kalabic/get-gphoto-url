## get_gphoto_url.sh
This script will try to create direct permanent link to public shared image on Google Photos (in its original size).
```
Usage: Open Google Photos in your browser, go to photo, click 'Share' button,
select 'Create link to share' and provide given link as an argument to this script.

./get_gphoto_url.sh https://photos.app.goo.gl/pXqnZZXzzMwJkQ5C7
```

## embed_gphoto_url.sh
Create code for embedding Google Photos image into HTML page. Width and height for preview image need to be given and will be encoded into URL in a way supported by Google servers.
```
Usage: Provide image URL (for example, URL created by "get_gphoto_url.sh"),
width and height as an argument to this script. Redirect output to a file.

./embed_gphoto_url.sh https://lh3.googleusercontent.com/(your URL...) 1024 1024 > embedded_photo.txt
```