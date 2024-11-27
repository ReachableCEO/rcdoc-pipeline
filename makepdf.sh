#!/bin/bash

INPUT_FILE="$1"
OUTPUT_FILE="$(basename $INPUT_FILE).pdf"
METADATA_FILE="~/bin/rcdoc/metadata/daily-stakeholder-report.yml"

pandoc \
$INPUT_FILE \
-o $OUTPUT_FILE \
--from markdown \
--template eisvogel \
--listings \
--metadata-file=~$METADATA_FILE