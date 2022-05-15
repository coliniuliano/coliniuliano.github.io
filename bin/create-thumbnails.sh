#!/bin/bash

# There seems to be a problem with this script causing all JPG files to
# be detected as changed even when they are not!

# Imagemagick needs to be installed:  `brew install imagemagick`
# Run from project root directory: `./bin/resize-and-strip.sh`

for f in ./assets/*/ ; do
    echo "$f"
    mkdir "$f/thumbs"
    mogrify -path "$f/thumbs" -thumbnail 250x250 "$f/*.jpg" "$f/*.png"
done