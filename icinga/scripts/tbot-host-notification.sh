#!/usr/bin/env bash
#
#

message=$(/bin/cat <<DATA
$NOTIFICATIONTYPE
$HOSTDISPLAYNAME is *$HOSTSTATE*
DATA
)

if [ "$HIDE_IP" = "1" ]; then
    message=$(/bin/cat <<DATA
${message}
Date/Time: $LONGDATETIME

$HOSTOUTPUT
DATA
)
else
    message=$(/bin/cat <<DATA
${message}
Address: $HOSTADDRESS
Date/Time: $LONGDATETIME

$HOSTOUTPUT
DATA
)
fi

if [ -n "$NOTIFICATIONCOMMENT" ]; then
    message=$(/bin/cat <<DATA
${message}

Comment by $NOTIFICATIONAUTHORNAME:
$NOTIFICATIONCOMMENT
DATA
)
fi

data=$(/bin/cat <<DATA
    {
        "text": "${message}",
        "chat_id": "${tbot_ChatID}"
    }
DATA
)

curl -X POST \
     -H 'Content-Type: application/json' \
     -d "${data}" \
     https://api.telegram.org/bot${TBOT_AUTHTOKEN}/sendMessage

