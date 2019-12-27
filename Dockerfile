FROM zabbix/zabbix-web-nginx-mysql:alpine-3.0.29
LABEL maintainer="ccmite"
WORKDIR /

RUN : "add package" && \
    apk --update add postfix rsyslog && \
    rm -rf /var/cache/apk/* && \
    cp /etc/postfix/main.cf /etc/postfix/main.cf.org

EXPOSE 80/TCP 10051/TCP

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/docker-entrypoint.sh"]
