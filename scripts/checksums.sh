#!/bin/bash
# Maciej Aleksandrowicz 2022
# REQs: xclip tput

# Terminal text colours
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;32m'
NC='\033[0m'


echo -e "> ${YELLOW}SHA-256, SHA-1 & MD5 checksums validation${NC}"


if [[ -z "${1}" ]]; then
    echo -e "> ${RED}Missing 1st argument (file path)${NC}"
    exit 2
fi
FILE=$1
echo -e "> Selected file: $FILE"

if [[ -z "${2}" ]]; then
    echo -e "> Missing 2nd argument (checksum), accessing clipboard"
    SUM=$(xclip -selection c -o)
else
    SUM=$2
fi
SUM=$(echo "$SUM" | tr '[:upper:]' '[:lower:]')
echo -e "> Input checksum: $SUM"


IFS=' '
CHECKSUMS=("sha256sum" "sha1sum" "md5sum")

for CHECKSUM in "${CHECKSUMS[@]}"; do
    RESULT=$($CHECKSUM "$FILE")
    read -ra RESULT <<< "$RESULT"
    RESULT_STR="${RESULT[0]}"

    if [ "$SUM" == "$RESULT_STR" ]; then
        echo -e "> [$CHECKSUM] \t [${GREEN}MATCH${NC}]"
        exit 0
    else
        echo -e "> [$CHECKSUM] \t [${RED}MISMATCH${NC}] SUM: $RESULT_STR"
    fi
done

echo -e "> ${RED}FAILED TO VERIFY THE FILE!${NC}"
exit 1
