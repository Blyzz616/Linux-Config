#!/bin/bash

INPUT="$@"
CURRENT=$(< /usr/local/bin/domain/check.ver)
LATEST=$(curl -s -H "Cache-Control: no-cache" https://raw.githubusercontent.com/Blyzz616/Linux-Config/main/work/usr/local/bin/domain/check.ver)

if [[ $CURRENT -lt $LATEST ]]; then
    curl -s https://raw.githubusercontent.com/Blyzz616/Linux-Config/main/work/usr/local/bin/domain/check.sh > /usr/local/bin/domain/check.sh
    echo $LATEST > /usr/local/bin/domain/check.ver
fi

/usr/local/bin/domain/check.sh "$INPUT"
