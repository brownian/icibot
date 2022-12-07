#!/usr/bin/env bash

set -e
set -o pipefail

if [ ! -f /data/etc/icinga2/conf.d/icingaweb-api-user.conf ]; then
  sed "s/\$ICINGAWEB_ICINGA2_API_USER_PASSWORD/${ICINGAWEB_ICINGA2_API_USER_PASSWORD:-icingaweb}/" /config/icingaweb-api-user.conf >/data/etc/icinga2/conf.d/icingaweb-api-user.conf
fi

if [ ! -f /data/etc/icinga2/features-enabled/icingadb.conf ]; then
  mkdir -p /data/etc/icinga2/features-enabled
  cat /config/icingadb.conf >/data/etc/icinga2/features-enabled/icingadb.conf
fi

sed -ie '/^apply Service "ssh"/,/^}/d'       /etc/icinga2/conf.d/services.conf
sed -ie '/^apply Service for (http/,/^}/d'   /etc/icinga2/conf.d/services.conf

sed -ie '/^object ServiceGroup "http"/,/^}/d' /etc/icinga2/conf.d/groups.conf
sed -ie '/^object HostGroup "windows-/,/^}/d' /etc/icinga2/conf.d/groups.conf
