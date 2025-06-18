#!/bin/bash

SPATH=/usr/local/bin/status

# Clear old file
STAMP=$(date +"%a, %b %d, %Y - %R")
echo $STAMP > $SPATH/status.txt
echo -e "  \033[0;90m..:: $STAMP ::..\033[0m"

ITGFUNCTION (){
  # set good status
  ITGU="All Systems Operational"
  ## get the status file
  wget -qO $SPATH/itg.out https://status.itglue.com/
  ## Add Header
ITGH="
  \033[0;94mIT Glue:\033[0m"
echo $ITGH >> $SPATH/status.txt
echo -e "$ITGH"
  ## get actual status put in status file
  ITGS=$(grep -EA3 'class="page-status' $SPATH/itg.out | grep -vE '^\s+<' | cut -c13-)
  echo $ITGS >> $SPATH/status.txt && rm $SPATH/itg.out
  if [[ "$ITGU" = "$ITGS" ]]; then
    echo "    ✅  $ITGS"
  else
    echo "    ❌  $ITGS"
  fi
}

MCTFUNCTION () {
  # Mimecast
  # set good status
  MCU="All Services Are Operating Normally"
  ## get the status file
  wget -qO $SPATH/mc.out https://status.mimecast.com/
  ## get actual status put in status file
  MCH="
  \033[0;94mMimecast:\033[0m"
  echo $MCH >> $SPATH/status.txt
  echo -e "$MCH"
  MCS=$(grep -Eo 'statusbar_text">[A-Za-z0-9 ]*' $SPATH/mc.out | cut -c17-)
  echo $MCS >> $SPATH/status.txt && rm $SPATH/mc.out
  if [[ "$MCU" = "$MCS" ]]; then
    echo "    ✅  $MCS"
  else
    echo "    ❌  $MCS"
  fi
  #grep -Eo 'updated_ago">[A-Za-z0-9 ]*' $SPATH/mc.out | cut -c14- | head -n1 >> $SPATH/status.txt
}


AXFUNCTION () {
  # Axcient
  # set good status
  AXU="All Systems Operational"
  ## get the status file
  wget -qO $SPATH/ax.out https://status.axcient.com/
  ## get actual status put in status file
  AXH="
  \033[0;94mAxcient:\033[0m"
  echo $AXH >> $SPATH/status.txt
  echo -e "$AXH"
  AXS=$(grep -A1 'status font-large' $SPATH/ax.out | tail -n1 | cut -c13-)
  AXB=$(grep -E 'whitespace-pre-wrap">' $SPATH/ax.out | head -n1 | awk -F'>' '{print $4}' | awk -F'<' '{print $1}')
  echo $AXS >> $SPATH/status.txt && rm $SPATH/ax.out
  if [[ "$AXU" = "$AXS" ]]; then
    echo "    ✅  $AXS"
  else
    echo "    ❌  $AXB"
  fi
}

MSOFUHNCTION () {
  # Office
  # set good status
  MSU="Everything is up and running"
  ## get the status file
  wget -qO $SPATH/ms.out https://portal.office.com/servicestatus
  ## get actual status put in status file
  MSH="
  \033[0;94mOffice:\033[0m"
  echo $MSH >> $SPATH/status.txt
  echo -e "$MSH"
  MSS=$(grep -EA1 'div ng-if' $SPATH/ms.out | grep -Eo 'p>[A-Za-z0-9 ]*' | head -n1 | cut -c3-)
  echo $MSS >> $SPATH/status.txt && rm $SPATH/ms.out
  if [[ "$MSU" = "$MSS" ]]; then
    echo "    ✅  $MSS"
  else
    echo "    ❌  $MSS"
  fi
}

DUOFUNCTION () {
  # Duo
  # set good status
  DUU="Operational"
  ## get the status file
  wget -qO $SPATH/duo.out https://status.duo.com/
  ## get actual status put in status file
  DUH="
  \033[0;94mDuo55:\033[0m"
  #echo $DUH >> $SPATH/status.txt
  echo -e "$DUH"
  DUS=$(grep -EA10 '^\s*DUO55' $SPATH/duo.out | tail -n1 | cut -c5-)
  if [[ "$DUU" = "$DUS" ]]; then
    echo "    ✅  $DUS
"
  else
    DUS=$(grep -EA10 '^\s+DUO55' $SPATH/duo.out | tail -n1 | cut -c5-)
    echo "    ❌  $DUS
"
  fi
  echo $DUS >> $SPATH/status.txt && rm $SPATH/duo.out
}

# Run some functions
ITGFUNCTION
MCTFUNCTION
AXFUNCTION
#MSOFUHNCTION
DUOFUNCTION
