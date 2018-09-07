#!/usr/bin/env bash
set -eo pipefail

if [ $# -lt 1 ] ; then
	echo "usage: $0 <input> [<size@1x>] [<output>]"
  exit
fi

if [ ! -f $1 ] ; then
	echo "file doesn't exist"
	exit 1
fi

## include common processing

source $(dirname $0)/generate-image-assets.include.sh

## generate assets

APP_NAME=$(find $PWD/ios -name '*.xcodeproj' -exec basename {} .xcodeproj \;)

target_dir="${PWD}/ios/${APP_NAME}/Images.xcassets/${output}.imageset"

mkdir -p $target_dir

cat > "${target_dir}/Contents.json" <<EOL
{
  "images": [
    {
      "idiom": "universal",
      "filename": "$output@1.png",
      "scale": "1x"
    },
    {
      "idiom": "universal",
      "filename": "$output@2x.png",
      "scale": "2x"
    },
    {
      "idiom": "universal",
      "filename": "$output@3x.png",
      "scale": "3x"
    }
  ],
  "info": {
    "version": 1,
    "author": "xcode"
  }
}
EOL

function image_name () {
  echo "${target_dir}/${output}@${scale}x.png";
}

scale=1 generate_image

scale=2 generate_image

scale=3 generate_image
