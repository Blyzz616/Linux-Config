#!/bin/bash

INPUT="$*"
[[ -z $1 ]] && echo -e "\n  Usage: domain [OPTION]...\n  Where: [OPTION] is a domain name - example: blyzz.com\nExample: domain blyzz.com\n" && exit 1

# Strip brackets if present
if [[ "$INPUT" =~ [\<\[]([^>\]]+)[\>\]] ]]; then
    INPUT="${BASH_REMATCH[1]}"
fi

# Function to extract domain components: DNAME, DTLD, DOMAIN
extract_domain_parts() {
    local full="$1"

    # Clean URL to just the domain part
    full="${full##*@}"
    full="${full#*://}"
    full="${full%%/*}"
    full="${full%%:*}"

    # Match known multi-part TLDs
    if [[ "$full" =~ ([^.]+)\.(com\.[a-z]+)$ ]]; then
        DNAME="${BASH_REMATCH[1]}"
        DTLD="${BASH_REMATCH[2]}"
    elif [[ "$full" =~ ([^.]+)\.([a-z]{2,3}\.a[cetufgilmorsz](pa)?)$ ]]; then
        DNAME="${BASH_REMATCH[1]}"
        DTLD="${BASH_REMATCH[2]}"
    elif [[ "$full" =~ ([^.]+)\.([a-z]{2,3}\.b[abhidjmnstwz])$ ]]; then
        DNAME="${BASH_REMATCH[1]}"
        DTLD="${BASH_REMATCH[2]}"
    elif [[ "$full" =~ ([^.]+)\.([a-z]+\.aero)$ ]]; then
        DNAME="${BASH_REMATCH[1]}"
        DTLD="${BASH_REMATCH[2]}"
    elif [[ "$full" =~ ([^.]+)\.([a-z]{2,3}\.c[ilmnruvw])$ ]]; then
        DNAME="${BASH_REMATCH[1]}"
        DTLD="${BASH_REMATCH[2]}"
    elif [[ "$full" =~ ([^.]+)\.([a-z]{2,3}\.z[amw])$ ]]; then
        DNAME="${BASH_REMATCH[1]}"
        DTLD="${BASH_REMATCH[2]}"
    elif [[ "$full" =~ ([^.]+)\.([^.]+\.[a-z]{2})$ ]]; then
        DNAME="${BASH_REMATCH[1]}"
        DTLD="${BASH_REMATCH[2]}"
    else
        # Default fallback to last 2 domain parts
        IFS='.' read -ra PARTS <<< "$full"
        local nparts=${#PARTS[@]}
        DNAME="${PARTS[nparts-2]}"
        DTLD="${PARTS[nparts-1]}"
    fi

    DOMAIN="${DNAME}.${DTLD}"
}

# Run domain extraction
extract_domain_parts "$INPUT"

DPATH="/usr/local/bin/domain"
mkdir -p "$DPATH"

wget -q -O "$DPATH/$DOMAIN.whois" "https://www.whois.com/whois/$DOMAIN"

#date > "$DPATH/$DOMAIN.out"
if [[ "$DNAME" == *"[" ]]; then
  DNAME=$(echo $DNAME | rev | cut -c2- | rev)
fi
if [[ "$DTLD" == "]"* ]]; then
  DTLD=$(echo $DTLD | cut -c2-)
fi

echo "Domain: ${DNAME}""[.]""${DTLD}" > "$DPATH/${DOMAIN}.out"

NS=$(dig "${DNAME}.${DTLD}" NS | grep -E '\sNS\s' | awk '{print "  " $NF}' | sed 's/.$//')
MX=$(dig "${DNAME}.${DTLD}" MX | grep -E '\sMX\s' | awk '{print "  " $NF}' | sed 's/.$//')
{
  grep -Eo 'Registered On.{39}' "$DPATH/$DOMAIN.whois" | sed 's/<\/div><div class="df-value">/ /'
  grep -Eo 'Updated On.{39}' "$DPATH/$DOMAIN.whois" | sed 's/<\/div><div class="df-value">/ /'
  grep -Eo 'Registrar:.{28}[a-zA-Z0-9\. ]*' "$DPATH/$DOMAIN.whois" | sed 's/<\/div><div class="df-value">/ /'
  grep -Eo 'Status:.{260}' "$DPATH/$DOMAIN.whois" \
    | sed 's/<\/div><div class="df-value">/ /' \
    | sed 's/<\/div>/=/' \
    | awk -F'=' '{print $1}' \
    | sed 's/<br>/\n  /g' \
    | sed 's/: /:\n  /'
  [[ -n $NS ]] && echo -e "Nameservers:\n$NS"
  [[ -n $MX ]] && echo -e "Mailservers:\n$MX"
} >> "$DPATH/$DOMAIN.out"

rm "$DPATH/$DOMAIN.whois"

cat "$DPATH/$DOMAIN.out"
