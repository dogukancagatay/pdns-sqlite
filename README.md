# pdns-sqlite
PowerDNS instance using SQLite3

## Usage

### Environment variables

* `SQLITE_DBPATH`: SQLite DB path, default value `/data/pdns.sqlite`
* `API_KEY`: Your API key, default value `genericapikey`
* `MASTER`:Is your instance a master ${MASTER:-yes}
* `SLAVE`:is your instance a slave, it can't be both master and slave ${SLAVE:-no}
* `SLAVE_CYCLE_INTERVAL`: Check powerdns documentation (https://doc.powerdns.com/md/authoritative/settings/#slave-cycle-interval), default value ${SLAVE_CYCLE_INTERVAL:-60}
* `DEFAULT_TTL`: TTL to use when no one is provided, default value `3600`
* `DEFAULT_SOA_NAME`: https://doc.powerdns.com/md/authoritative/settings/#default-soa-name, default `$(hostname -f)`
* `DEFAULT_SOA_MAIL`: https://doc.powerdns.com/md/authoritative/settings/#default-soa-mail
* `ALLOW_AXFR_IPS`: https://doc.powerdns.com/md/authoritative/settings/#allow-axfr-ips, default value `127.0.0.0/8`
* `ALSO_NOTIFY`: https://doc.powerdns.com/md/authoritative/settings/#also-notify
* `ALLOW_NOTIFY_FROM`: Allow AXFR NOTIFY from these IP ranges. Setting this to an empty string will drop all incoming notifies.
* `GSQLITE3_PRAGMA_SYNCHRONOUS`: Set this to `0` to disable synchronous write to the SQLite DB, to `1` enable synchronous write

### Docker compose example

```
version: "3"
services:
  pdns:
    image: notuscloud/pdns-sqlite
    restart: "unless-stopped"
    ports:
      - "8081:8081"
      - "53:53/tcp"
      - "53:53/udp"
    volumes:
      - /your/data/path:/data
    environment:
      - API_KEY=someapikey
      - DEFAULT_TTL=60
      - DEFAULT_SOA_NAME=ns1.yourdomain.com
      - DEFAULT_SOA_MAIL=somepoorops@yourdomain.com
      - ALLOW_AXFR_IPS=10.10.10.10
      - ALSO_NOTIFY=10.10.10.10
```
