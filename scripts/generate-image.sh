#!/usr/bin/env bash
set -eo pipefail

if [ $# -lt 1 ] ; then
	set +x

  cat <<EOL

    usage: $0 <input> [<size@1x>] [<output>]

      Generates native image assets.
        <input>    path for input file, could be:
                     - SVG file
                     - PNG file with 4x size

        <size@1x>  optionnal target size
                     - <width> => <width>x<width>
                     - <width>x => <width>x<calculated_height>
                     - x<height> => <calculated_width>x<height>

        <output>   optional target name

EOL

  exit
fi

if [ ! -f $1 ] ; then
	echo "file doesn't exist"
	exit 1
fi

## include common processing

source $(dirname $0)/generate-image-assets.include.sh

## generate assets

target_dir="${PWD}/assets"


function image_name () {
  echo "${target_dir}/${output}.png";
}

scale=1 generate_image
