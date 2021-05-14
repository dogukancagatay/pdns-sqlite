FROM debian:buster-slim

# Build date (format 2020-02-12T23:12:43Z)
ARG BUILD_DATE=""
ARG APP_VERSION="4.4.1"
ARG PDNS_VERSION="4.4.1-1pdns.buster"

LABEL maintainer="Doğukan Çağatay <dcagatay@gmail.com>"
LABEL org.opencontainers.image.authors="Doğukan Çağatay"
LABEL org.opencontainers.image.title="pdns-updater"
LABEL org.opencontainers.image.description="Dynamic PowerDNS DNS updater for Docker Containers"
LABEL org.opencontainers.image.vendor="Doğukan Çağatay"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.version="${APP_VERSION}"

ENV API_KEY "changeme"
ENV MASTER "yes"
ENV SLAVE "no"
ENV DEFAULT_TTL "3600"
ENV ALLOW_AXFR_IPS "0.0.0.0/0,::/0"
ENV WEBSERVER_ALLOW_IPS "0.0.0.0/0,::/0"
ENV GSQLITE3_PRAGMA_SYNCHRONOUS "1"
ENV SLAVE_CYCLE_INTERVAL "60"
ENV SQLITE_DBPATH "/data/pdns.sqlite"
# ENV ALSO_NOTIFY
# ENV ALLOW_NOTIFY_FROM

RUN apt-get update && apt-get install --yes \
    curl \
    gnupg2

RUN echo 'deb [arch=amd64] http://repo.powerdns.com/debian buster-auth-44 main' > /etc/apt/sources.list.d/pdns.list && \
    echo 'Package: pdns-*\n\
    Pin: origin repo.powerdns.com\n\
    Pin-Priority: 600\n' > /etc/apt/preferences.d/pdns && \
    cat /etc/apt/preferences.d/pdns && \
    curl https://repo.powerdns.com/FD380FBB-pub.asc | apt-key add -

RUN apt-get update && apt-get install --yes \
    sqlite3 \
    pdns-server=${PDNS_VERSION} \
    pdns-backend-sqlite3=${PDNS_VERSION} && \
    rm -rf /etc/powerdns/pdns.d/bind.conf && \
    apt-get autoremove -y && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh ./init.sql /
WORKDIR /data

VOLUME ["/data"]
EXPOSE 53/udp 53/tcp 8081/tcp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/pdns_server"]
