
input=$PWD/$1

size=$2

output=${3:-$1}
output=$(basename $output .png)
output=$(basename $output .svg)

FORMAT=$(identify -format '%m' "$input")

WIDTH=$(identify -format '%w' "$input")
HEIGHT=$(identify -format '%h' "$input")
DENSITY=$(identify -format '%[resolution.x]' "$input")

if [ "$FORMAT" = 'SVG' ] ; then
  DENSITY=96
fi

# width=
# height=
# density=

function preapre_image () {

  if [ -n "$size" ] ; then

    [ -z "$width" ] && width=${size/x*/}
    [ -z "$height" ] && height=${size/*x/}

    if [ -z "$width" ] && [ -z "$height" ] ; then
      width=$WIDTH
      height=$HEIGHT
    elif [ -z "$width" ] ; then
      width=$(echo $WIDTH*$height/$HEIGHT | bc)
    elif [ -n "$width" ] ; then
      height=$(echo $HEIGHT*$width/$WIDTH | bc)
    fi

  else

    [ -z "$width" ] && width=$WIDTH
    [ -z "$height" ] && height=$HEIGHT

  fi

  density=$(echo $DENSITY*$width/$WIDTH | bc)

  # when input is not PNG, assume input is 4x
  if [ "$FORMAT" = 'PNG' ] ; then
    width=$(echo $width/4 | bc)
    height=$(echo $height/4 | bc)
    density=$(echo $density/4 | bc)
  fi

  echo "$FORMAT ${WIDTH}x${HEIGHT}:${DENSITY} => PNG ${width}x${height}:${density}@${scale} |> $(image_name)"

}

function image_name () {
  echo "$PWD/assets/output.png";
}

function generate_image () {
  preapre_image
  mogrify -write $(image_name) -format png -background none -density "$(echo $density*$scale | bc)" -resize "$(echo $width*$scale | bc)x$(echo $height*$scale | bc)" "$input"
}
