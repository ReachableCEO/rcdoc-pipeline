#!/bin/bash

INPUT_FILE="$1"
OUTPUT_FILE="$(echo $INPUT_FILE|awk -F '.' '{print $1}').pdf"
METADATA_FILE="$2"
TEMPLATE="eisvogel"
PANDOC_OPTIONS="--listings"

# Setup proper boilerplate to handle cmd line options , check args etc...

pandoc \
$INPUT_FILE \
-o $OUTPUT_FILE \
--template $TEMPLATE \
--metadata-file=$METADATA_FILE \
--from markdown \
$PANDOC_OPTIONS