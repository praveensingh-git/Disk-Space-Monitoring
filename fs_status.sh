#!/bin/bash
# Disk Monitor & Email Alert Script
# =========================================
# Author: NedStark (Kali Linux)
# Description: Sends an email report of disk usage
# =========================================
: <<'END_COMMENT'


                
END_COMMENT
TO="praveensuryavanshi021@gmail.com"

# Disk usage
THRESHOLD=80

#hostname & date
HOST=$(hostname)
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# ignoring tmpfs
REPORT=$(df -h --output=source,size,used,avail,pcent,target | egrep -v "tmpfs|udev|overlay")

MAX_USAGE=$(echo "$REPORT" | awk 'NR>1 {gsub("%","",$5); print $5}' | sort -n | tail -1)

if [[ $MAX_USAGE -ge $THRESHOLD ]]; then
    STATUS="⚠️ WARNING: High Disk Usage Detected!"
else
    STATUS="✅ All is Well: Disk Usage Normal"
fi

BODY=$(cat <<EOF
Disk Utilization Report by the Great $HOST
Date: $DATE

$STATUS

Filesystem Details:
--------------------------------------------------
$REPORT
--------------------------------------------------

Threshold: ${THRESHOLD}%
Highest usage: ${MAX_USAGE}%

Regards,
Disk Monitor Bot Chitti 🤖
EOF
)

echo "$BODY" | mail -s "[$HOST] Disk Report - $STATUS" "$TO"

#print to terminal (for testing/logs)
echo "$BODY"

