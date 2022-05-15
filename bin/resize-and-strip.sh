#!/bin/bash

# There seems to be a problem with this script causing all JPG files to
# be detected as changed even when they are not!

# Imagemagick needs to be installed:  `brew install imagemagick`
# Run from project root directory: `./bin/resize-and-strip.sh`

for f in ./assets/*/ ; do
    echo "$f"
    mogrify -strip -resize "1280>x1280>" "$f/*.jpg" "$f/*.png"
done