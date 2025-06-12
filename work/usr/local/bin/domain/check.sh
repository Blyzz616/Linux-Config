#!/bin/bash
#version=0.1

INPUT="$@"
#echo "INPUT: $@"

[[ -z $1 ]] && echo -e "\n  Usage: domain [OPTION]...\n  Where: [OPTION] is a domain name - example: blyzz.com\nExample: domain blyzz.com\n" && exit 1

if [[ "$INPUT" =~ \<([^>]+)\> ]]; then
    INPUT="${BASH_REMATCH[1]}"
fi

INPUT="${INPUT##*@}"
INPUT="${INPUT#*://}"
INPUT="${INPUT%%/*}"
INPUT="${INPUT%%:*}"
DOMAIN=$(echo "$INPUT" | awk -F. '{if (NF>1) print $(NF-1)"."$NF; else print $0}')

DNAME=$(echo $DOMAIN | awk -F'.' '{print $1}')
DTLD=$(echo $DOMAIN | awk -F'.' '{$1=""; print $0}' | cut -c2-)

DPATH="/usr/local/bin/domain"
mkdir -p "$DPATH"

wget -q -O "$DPATH/$DOMAIN.whois" "https://www.whois.com/whois/$DOMAIN"

date > "$DPATH/$DOMAIN.out"
echo "Domain: $DNAME[.]$DTLD"  >> "$DPATH/$DOMAIN.out"

grep -Eo 'Registered On.{39}' "$DPATH/$DOMAIN.whois" | sed 's/<\/div><div class="df-value">/ /' >> "$DPATH/$DOMAIN.out"
grep -Eo 'Updated On.{39}' "$DPATH/$DOMAIN.whois" | sed 's/<\/div><div class="df-value">/ /' >> "$DPATH/$DOMAIN.out"
grep -Eo 'Registrar:.{28}[a-zA-Z0-9\. ]*' "$DPATH/$DOMAIN.whois" | sed 's/<\/div><div class="df-value">/ /' >> "$DPATH/$DOMAIN.out"
grep -Eo 'Status:.{260}' "$DPATH/$DOMAIN.whois" | sed 's/<\/div><div class="df-value">/ /' | sed 's/<\/div>/=/' | awk -F'=' '{print $1}' | sed 's/<br>/\n  /g' | sed 's/: /:\n  /' >> "$DPATH/$DOMAIN.out"

rm "$DPATH/$DOMAIN.whois"

cat "$DPATH/$DOMAIN.out"
