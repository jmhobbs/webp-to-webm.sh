#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

function mustExist {
  if ! command -v "$1" &> /dev/null
  then
      echo "$1 not found"
      exit 1
  fi
}

function usage {
  echo "error: $1"
  echo "usage: $0 <input.webp> <output.webm>"
  exit 1
}

mustExist "webpmux"
mustExist "ffmpeg"
mustExist "seq"
mustExist "printf"
mustExist "mktemp"
mustExist "grep"
mustExist "awk"

[ "$#" -eq 2 ] || usage "required arguments missing"

[ -f "$1" ] || usage "input file not found"
[ -e "$2" ] && usage "output file exists"

FRAME_COUNT="$(webpmux -info "$1" | grep 'Number of frames:' | awk '{print $4}')"
DURATION="$(webpmux -info "$1" | grep '1:' | head -n 1 | awk '{print $7}')"
FRAME_RATE=$((1000/DURATION))

TEMP_DIR="$(mktemp --directory)"
function cleanupTemp {
  rm -rf "$TEMP_DIR"
}
trap cleanupTemp EXIT

echo "-> Extracting $FRAME_COUNT frames from $1"

for FRAME in $(seq 1 "$FRAME_COUNT")
do
  webpmux -get frame "$FRAME" "$1" -o "$TEMP_DIR/$(printf "%010d" "$FRAME").webp"
done

echo "-> Converting to webm"

ffmpeg -framerate "$FRAME_RATE" -i "$TEMP_DIR/%010d.webp" -c:v libvpx-vp9 -pix_fmt yuva420p "$2"
