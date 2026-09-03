#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "Usage: $0 <hair.png> <nose.png> <mouth.png> <output.png>" >&2
  exit 64
fi

hair="$1"
nose="$2"
mouth="$3"
output="$4"
root="$(cd "$(dirname "$0")/.." && pwd)"
base="$root/assets/avatars/girl/base/face-01.png"
eyes="$root/assets/avatars/girl/eyes/eyes-01.png"

for asset in "$base" "$eyes" "$hair" "$nose" "$mouth"; do
  [[ -f "$asset" ]] || { echo "Missing asset: $asset" >&2; exit 66; }
  [[ "$(identify -format '%w:%h:%[channels]' "$asset")" == 1254:1254:srgba* ]] || {
    echo "Expected a 1254x1254 PNG with alpha: $asset" >&2
    exit 65
  }
done

mkdir -p "$(dirname "$output")"
magick -size 1254x1254 xc:none \
  "$base" -compose over -composite \
  "$eyes" -compose over -composite \
  "$nose" -compose over -composite \
  "$mouth" -compose over -composite \
  "$hair" -compose over -composite \
  "$output"
