@echo off

REM First, unzip a portable copy of ImageMagick into /ImageMagick
REM All files can be deleted except mogrify.exe (and the license)

REM The following commands are run against each subdirectory of "..\assets\*"
REM     - mogrify -strip -resize "1280>x1280>" '*.*'
REM         - Removes all data from the source images and resizes to max 1280px
REM     - mkdir "thumbs"
REM     - mogrify -path thumbs -thumbnail 250x250 '*.*'
REM         - Creates thumbnails up to a maximum height of 250px

FOR /D %%d IN ("..\assets\*") DO (
    "ImageMagick\mogrify.exe" -strip -resize "1280>x1280>" "%%d\*.*"
    mkdir "%%d\thumbs"
    "ImageMagick\mogrify.exe" -path "%%d\thumbs" -thumbnail 250x250 "%%d\*.*"
)