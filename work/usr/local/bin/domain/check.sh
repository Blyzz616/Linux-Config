#!/bin/bash

INPUT="$*"
UPDATE="July 2025"
ARGS(){
echo -e "  \e[1mNAME\n\n
      \e[0mdomain - print pertinent information about a domain name for phishing
      investivgation.\n\n
  \e[1mSYNOPSIS\n
      \e[1mdomain\e[0m [\e[4mOPTION\e[0m]
      \e[1mdomain\e[0m [-h|--help]
      \e[1mdomain\e[0m [-v|--version]\n\n
  \e[1mDESCRIPTION\n
      \e[0mDisplay the Registration date and last update of the domain from 
      whois.com as well as Nameserver and Mailserver information from dig.\n
      \e[1m-h\e[0m, \e[1m--help\e[0m
            displays this help and exit\n
      \e[1m-v\e[0m, \e[1m--version\e[0m
            output version information and exit\n\n
  \e[1mEXAMPLES\n
      \e[0mShow the information for blyzz.com\n
            $ \e[1mdomain \e[0mblyzz.com\n
      It will also eliminate the '[' and ']' brackets as they are often
      copied to the clipbaord\n
            $ \e[1mdomain \e[0mblyzz[.]com\n
      You can even copy an email address\n
            $ \e[1mdomain \e[0mjim@blyzz.com\n\n
  \e[1mAUTHOR\n
      \e[0mWritten by Jim Sher.\n\n
  \e[1mCOPYRIGHT\n
      \e[0mCopyright © 2025 Free Software Foundation, Inc.  License GPLv3+:
      GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
      This is free software: you are free to change and redistribute it.
      There is NO WARRANTY, to the extent permitted by law\n\n.
  $UPDATE\n"
exit 0
}

VER(){
  VNUM=$(</usr/local/bin/domain/check.ver)
  echo -e " Current version: $VNUM
  $UPDATE\n"
}

# Strip brackets if present
STRIP(){
  if [[ "$INPUT" =~ [\<\[]([^>\]]+)[\>\]] ]]; then
    INPUT="${BASH_REMATCH[1]}"
  fi
}

# Function to extract domain components: DNAME, DTLD, DOMAIN
BREAKDOWN() {
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

if [[ $INPUT =~ -v|--version ]]; then
  VER
  exit 0
fi

[[ -z $1 ]] && echo -e "\n  Usage: domain [OPTION]...\n  Where: [OPTION] is a domain name - example: blyzz.com\nExample: domain blyzz.com\n" && exit 1
[[ $INPUT =~ ^-h$|^--help$ ]] && ARGS
[[ $INPUT =~ ^-v$|^--version$ ]] && ARGS

if [[ $INPUT =~ ^[a-zA-Z0-9]+@[a-zA-Z0-9\.]+$ ]]; then
  FORMATGOOD=1
  SENDERNAME=$(echo $INPUT | awk -F@ '{print $1}')
fi

STRIP
BREAKDOWN "$INPUT"

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

if [[ $FORMATGOOD -eq 1 ]]
  echo -e "Sender: ${SENDERNAME}@${DNAME}[.]${DTLD}\nSubject: \n"
else
  echo -e "Sender: \nSubject: \n"
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
