#!/usr/bin/env bash
#
# Shrink oversized project images and strip their metadata, in place.
#
# Only images that actually need it are rewritten: anything already within
# MAX_DIM px with no embedded profiles is left byte-identical, so re-running
# this doesn't show up as a pile of modified files in git.
#
# Requires ImageMagick: brew install imagemagick
#
# Usage (from anywhere):
#   bin/resize-and-strip.sh                  # every assets/<project>/ folder
#   bin/resize-and-strip.sh assets/arcade    # only the folders given
#   MAX_DIM=1600 bin/resize-and-strip.sh     # different size cap
#   DRY_RUN=1 bin/resize-and-strip.sh        # report, change nothing

set -uo pipefail

MAX_DIM="${MAX_DIM:-1280}"
DRY_RUN="${DRY_RUN:-}"

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if command -v magick >/dev/null 2>&1; then
  im_identify() { magick identify "$@"; }
  im_mogrify() { magick mogrify "$@"; }
elif command -v mogrify >/dev/null 2>&1; then
  im_identify() { identify "$@"; }
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

resized=0
stripped=0
skipped=0

for dir in "${dirs[@]}"; do
  [ -d "$dir" ] || { echo "not a directory, skipping: $dir" >&2; continue; }

  while IFS= read -r -d '' file; do
    # %[profiles] warns instead of printing nothing when there are none
    read -r width height profiles < <(
      im_identify -format '%w %h %[profiles]\n' "$file[0]" 2>/dev/null
    )
    if [ -z "${width:-}" ]; then
      echo "could not read, skipping: ${file#$root/}" >&2
      continue
    fi

    args=()
    reason=()
    if [ "$width" -gt "$MAX_DIM" ] || [ "$height" -gt "$MAX_DIM" ]; then
      args+=(-resize "${MAX_DIM}>x${MAX_DIM}>")
      reason+=("${width}x${height} -> max ${MAX_DIM}")
      resized=$((resized + 1))
    fi
    if [ -n "${profiles:-}" ]; then
      args+=(-strip)
      reason+=("strip ${profiles}")
      stripped=$((stripped + 1))
    fi

    if [ "${#args[@]}" -eq 0 ]; then
      skipped=$((skipped + 1))
      continue
    fi

    printf '%s: %s\n' "${file#$root/}" "$(IFS=', '; echo "${reason[*]}")"
    [ -n "$DRY_RUN" ] || im_mogrify "${args[@]}" "$file"
  done < <(
    find "$dir" -maxdepth 1 -type f \
      \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -print0
  )
done

printf '\n%s%d resized, %d stripped, %d already fine\n' \
  "${DRY_RUN:+[dry run] }" "$resized" "$stripped" "$skipped"
