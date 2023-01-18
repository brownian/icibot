#!/usr/bin/env bash
#
#

convertsecs() {
 ((d=${1}/3600/24))
 ((h=${1}/3600%24))
 ((m=(${1}%3600)/60))
 ((s=${1}%60))
 if [ $d -eq 0 ] ; then
   printf "%02d:%02d:%02d\n" $h $m $s
 else
   printf "%2dd %02d:%02d:%02d\n" $d $h $m $s
 fi
}

NOW=`TZ=UTC date +"%s"`

STATEFILE="/tmp/${HOSTNAME}_lastnotif_time"

# if [ "$USERNAME" = "dor" ] ; then
        if [ -f $STATEFILE ] ; then
                SAVEDTIME=`cat ${STATEFILE}`
                LAST_DURATION="У попередньому стані: $(convertsecs $((${NOW} - ${SAVEDTIME})))"
        else
                LAST_DURATION="У попередньому стані: (?)"
        fi
# fi

echo $NOW > $STATEFILE

if [ "$NOTIFICATIONTYPE" = "RECOVERY" ] ; then
        NOTIFICATIONTYPE="СЛАВА УКРАЇНІ!!"
else
        NOTIFICATIONTYPE="СМЕРТЬ ВОРОГАМ!"
fi


message=$(/bin/cat <<DATA
$NOTIFICATIONTYPE
$HOSTDISPLAYNAME is *$HOSTSTATE*
DATA
)

if [ "$HIDE_IP" = "1" ]; then
    message=$(/bin/cat <<DATA
${message}
Дата/час: $LONGDATETIME
$LAST_DURATION

$HOSTOUTPUT
DATA
)
else
    message=$(/bin/cat <<DATA
${message}
Адреса: $HOSTADDRESS
Дата/час: $LONGDATETIME
$LAST_DURATION

$HOSTOUTPUT
DATA
)
fi

if [ -n "$NOTIFICATIONCOMMENT" ]; then
    message=$(/bin/cat <<DATA
${message}

Коментар від $NOTIFICATIONAUTHORNAME:
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
