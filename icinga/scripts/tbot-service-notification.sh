#!/usr/bin/env bash
#
#

message=$(/bin/cat <<DATA
$NOTIFICATIONTYPE
$SERVICEDISPLAYNAME at $HOSTDISPLAYNAME is *$SERVICESTATE*
Address: $HOSTADDRESS
Date/Time: $LONGDATETIME

${SERVICEOUTPUT}
DATA
)

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