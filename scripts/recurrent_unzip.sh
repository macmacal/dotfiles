#!/bin/bash

find . -iname '*.zip' -type f -exec bash -c '
    zip="$1"
    unzip -o -q "$zip" -d "$(dirname "$zip")"
' _ {} \;
