# pdns-sqlite

Docker image for PowerDNS Authoritative Server with SQLite3 backend.

PowerDNS actually have official Docker images ([powerdns](https://hub.docker.com/r/powerdns)) but they are lacking builds for ARM based platforms.

Images are availabe at Docker Hub ([dcagatay/pdns-sqlite](https://hub.docker.com/r/dcagatay/pdns-sqlite/)] built for *linux/amd64* and *linux/arm/v7* platforms.

## Available Tags

- `latest`, `4.4.1`

## Environment variables

* `API_KEY`: Your API key, Default: `changeme`
* `MASTER`: Is your instance a master, Default: `yes`
* `SLAVE`: Is your instance a slave, it can't be both master and slave, Default: `no`
* `DEFAULT_TTL`: TTL to use when no one is provided, default value `3600`
* `SLAVE_CYCLE_INTERVAL`: https://doc.powerdns.com/md/authoritative/settings/#slave-cycle-interval, Default: `60`
* `ALLOW_AXFR_IPS`: https://doc.powerdns.com/md/authoritative/settings/#allow-axfr-ips, Default: `0.0.0.0/0,::/0`
* `WEBSERVER_ALLOW_IPS`: https://doc.powerdns.com/md/authoritative/settings/#webserver-allow-ips, Default: `0.0.0.0/0,::/0`
* `GSQLITE3_PRAGMA_SYNCHRONOUS`: Set this to `0` to disable synchronous write to the SQLite DB, Default: `1`

* `DEFAULT_SOA_NAME`: https://doc.powerdns.com/md/authoritative/settings/#default-soa-name, Default: `$(hostname -f)`
* `ALSO_NOTIFY`: https://doc.powerdns.com/md/authoritative/settings/#also-notify
* `ALLOW_NOTIFY_FROM`: Allow AXFR NOTIFY from these IP ranges. Setting this to an empty string will drop all incoming notifies.


## docker-compose Example

```
version: "3"
services:

  pdns:
    image: dcagatay/pdns-sqlite:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "8081:8081"
    volumes:
      - /your/data/path:/data
    environment:
      API_KEY: "changeme"
      DEFAULT_TTL: "60"
      DEFAULT_SOA_NAME: "ns1.yourdomain.com"
      ALLOW_AXFR_IPS: "10.10.10.10"
      ALSO_NOTIFY: "10.10.10.10"
    restart: "unless-stopped"
```
