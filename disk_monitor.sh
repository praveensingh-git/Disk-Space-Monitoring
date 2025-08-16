#!/bin/bash
# ===========================
TO="example@gmail.com"  
FROM="test@gmail.com"                
THRESHOLD=80                           
# ===========================

REPORT=$(df -H -x tmpfs -x devtmpfs)

MAX_USAGE=$(echo "$REPORT" | awk 'NR>1 {gsub("%","",$5); print $5}' | sort -n | tail -1)
DATE=$(date)

# Build HTML message depending on usage
if [[ $MAX_USAGE -ge $THRESHOLD ]]; then
    SUBJECT="🚨 Disk Space Alert on $(hostname) 🚨"
    MESSAGE="
    <html>
    <body style='font-family: Arial, sans-serif;'>
        <h2 style='color:red;'>⚠ WARNING!</h2>
        <p><b>Hostname:</b> $(hostname)</p>
        <p><b>Date:</b> $DATE</p>
        <p><b>Disk usage is critical:</b> <span style='color:red;'>$MAX_USAGE%</span></p>
        <h3>📊 Disk Usage Report:</h3>
        <pre style='background:#f4f4f4;padding:10px;border:1px solid #ccc;'>$REPORT</pre>
    </body>
    </html>
    "
else
    SUBJECT="✅ Disk Space Status OK on $(hostname)"
    MESSAGE="
    <html>
    <body style='font-family: Arial, sans-serif;'>
        <h2 style='color:green;'>✅ All Good</h2>
        <p><b>Hostname:</b> $(hostname)</p>
        <p><b>Date:</b> $DATE</p>
        <p><b>Disk usage is healthy:</b> <span style='color:green;'>$MAX_USAGE%</span></p>
        <h3>📊 Disk Usage Report:</h3>
        <pre style='background:#f4f4f4;padding:10px;border:1px solid #ccc;'>$REPORT</pre>
    </body>
    </html>
    "
fi


echo "$MESSAGE" | mail -a "From:$FROM" -a "Content-Type: text/html" -s "$SUBJECT" "$TO"

