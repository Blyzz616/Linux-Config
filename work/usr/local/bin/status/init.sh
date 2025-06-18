#!/bin/bash

CURRENT=$(< /usr/local/bin/status/scrape.ver)
LATEST=$(curl -s -H "Cache-Control: no-cache" https://raw.githubusercontent.com/Blyzz616/Linux-Config/main/work/usr/local/bin/status/scrape.ver)

if [[ $CURRENT -lt $LATEST ]]; then
    curl -s https://raw.githubusercontent.com/Blyzz616/Linux-Config/main/work/usr/local/bin/status/scrape.sh > /usr/local/bin/status/scrape.sh
    echo $LATEST > /usr/local/bin/status/scrape.ver
fi

/usr/local/bin/status/scrape.sh
