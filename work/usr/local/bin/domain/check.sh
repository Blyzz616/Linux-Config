#! /bin/bash

[[ -z $1 ]] && echo -e "\n  Usage: domain [OPTION]...\n  Where: [OPTION] is a domain name - example: blyzz.com\nExample: domain blyzz.com\n" && exit 1

DNAME=$(echo $1 | awk -F'.' '{print $1}')
DTLD=$(echo $1 | awk -F'.' '{$1="";print $0}' | cut -c2-)

DPATH=/usr/local/bin/domain

wget -q -O $DPATH/$1.whois https://www.whois.com/whois/$1

date > $DPATH/$1.out
#echo "DNAME=$DNAME"
#echo "DTLD=$DTLD"
echo "Domain: $DNAME[.]$DTLD"  >> $DPATH/$1.out
grep -Eo 'Registered On.{39}' $DPATH/$1.whois | sed 's/<\/div><div class="df-value">/ /' >> $DPATH/$1.out
grep -Eo 'Updated On.{39}' $DPATH/$1.whois | sed 's/<\/div><div class="df-value">/ /' >> $DPATH/$1.out
grep -Eo 'Registrar:.{28}[a-ZA-Z0-9\. ]*' $DPATH/$1.whois | sed 's/<\/div><div class="df-value">/ /' >> $DPATH/$1.out
#grep -Eo 'Status:.{160}' $DPATH/$1.whois  | sed 's/<\/div><div class="df-value">/ /' | awk -F'</div>' '{print $2}' >> $DPATH/$1.out
grep -Eo 'Status:.{260}' $DPATH/$1.whois | sed 's/<\/div><div class="df-value">/ /' | sed 's/<\/div>/=/' | awk -F'=' '{print $1}' | sed 's/<br>/\n  /g' | sed 's/: /:\n  /' >> $DPATH/$1.out
rm $DPATH/$1.whois

cat $DPATH/$1.out
