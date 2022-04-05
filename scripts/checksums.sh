#!/bin/bash
# Maciej Aleksandrowicz 2022
# REQs: xclip tput

# Terminal text colours
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;32m' 
NC='\033[0m'


echo -e "> ${YELLOW}SHA-256, SHA-1 & MD5 checksum checker${NC}"
echo -e "# # # # # # # # # #"



if [[ -z "${1}" ]]; then
	echo -e "> ${RED}Missing 1st argument (file path)${NC}"
	exit
fi
FILE=$1
echo -e "> Selected file: $FILE"

if [[ -z "${2}" ]]; then
	echo -e "> Missing 2nd argument (checksum), accesing clipboard"
	SUM=$(xclip -selection c -o)
else
	SUM=$2
fi
SUM=$(echo "$SUM" | tr 'A-Z' 'a-z')
echo -e "> Input checksum: $SUM"
echo -e "# # # # # # # # # #"



IFS=' '
CHECKSUMS=("sha256sum" "sha1sum" "md5sum")

for CHECKSUM in "${CHECKSUMS[@]}"; do
	CURRSUM=$($CHECKSUM $FILE)
	read -ra CURRSUM <<< "$CURRSUM"
	CURRSUM="${CURRSUM[0]}"

	if [ "$SUM" == "$CURRSUM" ]; then
		echo -e "> $CHECKSUM checksums ${GREEN}MATCH${NC}"
		exit
	else
		echo -e "> $CHECKSUM checksums ${RED}MISSMATCH${NC}"
		echo -e "$CURRSUM"
		echo -e "> ***"
	fi
done

echo -e "> ${RED}FAILED TO VERIFY THE FILE!${NC}"
