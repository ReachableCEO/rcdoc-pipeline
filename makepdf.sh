#!/bin/bash

INPUT_FILE="$1"
OUTPUT_FILE="$(echo $INPUT_FILE|awk -F '.' '{print $1}').pdf"
METADATA_FILE="$2"
TEMPLATE="eisvogel"

#Recommendation for production : proper error handling / arg checking etc (as we do in our SAAS paid version of this)

pandoc \
$INPUT_FILE \
-o $OUTPUT_FILE \
--template $TEMPLATE \
--metadata-file=$METADATA_FILE \
--from markdown \
$PANDOC_OPTIONS