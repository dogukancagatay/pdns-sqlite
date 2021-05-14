#!/bin/bash

DEFAULT_SOA_NAME=${DEFAULT_SOA_NAME:-`hostname -f`}

rm -rf /etc/powerdns/pdns.d/my.conf

function add_to_conf() {
  echo "$1" >> /etc/powerdns/pdns.d/my.conf
}

# add_to_conf "loglevel=6"
add_to_conf "api=yes"
add_to_conf "api-key=${API_KEY}"
add_to_conf "webserver=yes"
add_to_conf "webserver-address=0.0.0.0"
add_to_conf "webserver-allow-from=${WEBSERVER_ALLOW_IPS}"
add_to_conf "default-soa-content=${DEFAULT_SOA_NAME} hostmaster.@ 0 10800 3600 604800 3600"
add_to_conf "launch=gsqlite3"
add_to_conf "gsqlite3-database=${SQLITE_DBPATH}"
add_to_conf "gsqlite3-pragma-foreign-keys"
add_to_conf "gsqlite3-dnssec"
add_to_conf "gsqlite3-pragma-synchronous=${GSQLITE3_PRAGMA_SYNCHRONOUS}"
add_to_conf "default-ttl=${DEFAULT_TTL}"
add_to_conf "allow-axfr-ips=${ALLOW_AXFR_IPS}"
add_to_conf "slave-cycle-interval=${SLAVE_CYCLE_INTERVAL}"

# Master/Slave management
if [[ ${SLAVE} == "yes" ]]
then
  add_to_conf "slave=${SLAVE}"

  # ALLOW_NOTIFY_FROM must be set
  if [[ -z ${ALLOW_NOTIFY_FROM} ]]; then
    echo "ALLOW_NOTIFY_FROM is not set, please configure this when to turn slave mode on."
    exit 1
  fi

  add_to_conf "allow-notify-from=${ALLOW_NOTIFY_FROM}"

elif [[ ${MASTER} == "yes" ]]
then
  add_to_conf "master=${MASTER}"
else
  echo "Error, PowerDNS must be configured in either master or slave mode"
  exit 1
fi

# also-notify
if [[ -n ${ALSO_NOTIFY} ]]
then
  add_to_conf "also-notify=${ALSO_NOTIFY}"
fi

# Init the sqlite db if it does not exist
if [[ ! -e ${SQLITE_DBPATH} ]]
then
  cat /init.sql | sqlite3 ${SQLITE_DBPATH}
else
  echo "Database exist and some tables were found."
  echo "Assuming this is not the first launch"
fi

# Set correct permissions
chown -Rv pdns:pdns /data

exec "$@"
