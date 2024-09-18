#!/usr/bin/env bash
unset LD_LIBRARY_PATH

# Config - Change to suite your scanner & paperless instance
scanner="Fujitsu, Ltd ScanSnap S1300i"
driver="epjitsu:libusb"
paperless_dir="/mnt/the_new_annex/appdata/paperless/consume/"

if [[ "$1" == "-h" ]]; then
    echo "scan.sh - a simple scanner script to produce pdf and pass them off to paperless"
    echo ""
    echo "OPTIONS"
    echo "  b - batch; keep scanning pages until you tell me to quit."
    echo "      Default scan only the pages currently in the hopper."
    echo "  c - color; default is bw."
    echo "  d - duplex; default is simplex."
    echo "  l - landscape; default is portrait."
    exit
fi

# Find the scanner
# We're using lsusb because scanimage -L is very slow
output=$(jc lsusb  | jq --arg SCANNER "$scanner" -c '.[] | select(.description==$SCANNER)')
if [ -z "$output" ] ; then
    echo "Scanner not found for query: $scanner"
    exit 1
fi

bus=$(echo $output | jq '.bus' | sed 's/"//g')
device=$(echo $output | jq '.device'| sed 's/"//g')

scan_device=$(printf "%s:%s:%s" $driver $bus $device)
echo "Using Scanner: $scan_device"

# Parse the Args
batch=false
if [[ "$1" == *b* ]]; then
    batch=true
fi

mode="Lineart"
if [[ "$1" == *c* ]]; then
    mode="Color"
fi

source="ADF Front"
if [[ "$1" == *d* ]]; then
    source="ADF Duplex"
fi

rotate=""
if [[ "$1" == *l* ]]; then
    rotate="-rotate 90"
fi

echo "Batch: $batch, Scanning mode: $mode, source: $source, and rotation: $rotate"

# Make a tempdir & filename
date="$(date --iso-8601=seconds)"
filename="Scan $date.pdf"
tmpdir="$(mktemp -d)"
pushd "$tmpdir"

scan=true
while [ $scan == true ] ; do
    scanadf --start-count `ls image* | wc -l` --device $scan_device --source "$source" --no-overwrite --mode $mode --resolution 200dpi
    scan=false
    if [ $batch == true ] ; then
        echo "Continue Scanning"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) scan=true; break;;
                * ) break;;
            esac
        done
    fi
done

if [[ $mode != "Color" ]]; then
    for img in image*; do mogrify -normalize -level 10%,90% -sharpen 0x1 $img; done
fi

# Convert any PNM images produced by the scan into a PDF with the date as a name
convert $rotate -fuzz 2% -trim +repage image* -density 200 "$filename"
chmod 0666 "$filename"

# Remove temporary PNM images
rm --verbose image*

# Atomic move converted PDF to destination directory
cp -pv "$filename" $paperless_dir/"$filename".tmp &&
    mv $paperless_dir/"$filename".tmp $paperless_dir/"$filename" &&
rm "$filename"

popd
rm -r "$tmpdir"
