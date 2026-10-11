#!/usr/bin/env bash
#
# Generate gallery thumbnails into assets/<project>/thumbs/.
#
# By default only missing thumbnails are written, so existing ones are left
# byte-identical and re-running this is a no-op. That matters because
# thumbnail output is not stable across ImageMagick versions: rebuilding a
# thumbnail that already looks right still rewrites it, which shows up as
# churn in git. Use STALE=1 after replacing a source image, or FORCE=1 to
# rebuild everything deliberately.
#
# Requires ImageMagick: brew install imagemagick
#
# Usage (from anywhere):
#   bin/create-thumbnails.sh                  # every assets/<project>/ folder
#   bin/create-thumbnails.sh assets/arcade    # only the folders given
#   STALE=1 bin/create-thumbnails.sh          # also rebuild thumbs older than their source
#   FORCE=1 bin/create-thumbnails.sh          # rebuild every thumbnail
#   THUMB_SIZE=400 bin/create-thumbnails.sh   # different thumbnail box
#   DRY_RUN=1 bin/create-thumbnails.sh        # report, change nothing

set -uo pipefail

THUMB_SIZE="${THUMB_SIZE:-250}"
STALE="${STALE:-}"
FORCE="${FORCE:-}"
DRY_RUN="${DRY_RUN:-}"

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if command -v magick >/dev/null 2>&1; then
  im_mogrify() { magick mogrify "$@"; }
elif command -v mogrify >/dev/null 2>&1; then
  im_mogrify() { mogrify "$@"; }
else
  echo "ImageMagick not found. Install it with: brew install imagemagick" >&2
  exit 1
fi

if [ "$#" -gt 0 ]; then
  dirs=("$@")
else
  dirs=("$root"/assets/*/)
fi

written=0
kept=0
orphans=()

for dir in "${dirs[@]}"; do
  dir="${dir%/}"
  [ -d "$dir" ] || { echo "not a directory, skipping: $dir" >&2; continue; }

  todo=()
  while IFS= read -r -d '' file; do
    thumb="$dir/thumbs/$(basename "$file")"
    if [ ! -f "$thumb" ]; then
      reason="missing"
    elif [ -n "$FORCE" ]; then
      reason="forced"
    elif [ -n "$STALE" ] && [ "$file" -nt "$thumb" ]; then
      reason="source is newer"
    else
      kept=$((kept + 1))
      continue
    fi
    todo+=("$file")
    printf '%s (%s)\n' "${thumb#$root/}" "$reason"
  done < <(
    find "$dir" -maxdepth 1 -type f \
      \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -print0
  )

  # thumbnails whose source image is gone, so galleries can be tidied up
  if [ -d "$dir/thumbs" ]; then
    while IFS= read -r -d '' thumb; do
      [ -f "$dir/$(basename "$thumb")" ] || orphans+=("${thumb#$root/}")
    done < <(find "$dir/thumbs" -maxdepth 1 -type f -print0)
  fi

  [ "${#todo[@]}" -eq 0 ] && continue
  written=$((written + ${#todo[@]}))

  if [ -z "$DRY_RUN" ]; then
    mkdir -p "$dir/thumbs"
    im_mogrify -path "$dir/thumbs" -thumbnail "${THUMB_SIZE}x${THUMB_SIZE}" "${todo[@]}"
  fi
done

printf '\n%s%d thumbnails written, %d left alone\n' \
  "${DRY_RUN:+[dry run] }" "$written" "$kept"

if [ "${#orphans[@]}" -gt 0 ]; then
  printf '\n%d thumbnails have no source image:\n' "${#orphans[@]}"
  printf '  %s\n' "${orphans[@]}"
fi
