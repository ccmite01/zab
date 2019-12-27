FROM zabbix/zabbix-web-nginx-mysql:alpine-3.0.29
LABEL maintainer="ccmite"
WORKDIR /
COPY start.sh /

RUN : "add package" && \
    apk --update add postfix rsyslog && \
    rm -rf /var/cache/apk/* && \
    cp /etc/postfix/main.cf /etc/postfix/main.cf.org && \
    sed -i 's/#myhostname = host.domain.tld/myhostname = ccmite.com/g' /etc/postfix/main.cf && \
    sed -i 's/#mydomain = domain.tld/mydomain = ccmite.com/g' /etc/postfix/main.cf && \
    sed -i 's/#myorigin = $mydomain/myorigin = $mydomain/g' /etc/postfix/main.cf && \
    sed -i 's/#mynetworks_style = subnet/mynetworks_style = subnet/g' /etc/postfix/main.cf && \
    sed -i 's/#mynetworks = 168.100.189.0\/28, 127.0.0.0\/8/mynetworks = 172.0.0.0\/8, 127.0.0.0\/8, 192.168.0.0\/24/g' /etc/postfix/main.cf && \
    sed -i 's/#mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain,/mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain, ccmite.com/g' /etc/postfix/main.cf && \
    sed -i 's/#inet_interfaces = all/inet_interfaces = all/g' /etc/postfix/main.cf && \
    sed -i 's/#relayhost = uucphost/relayhost = [smtp.gmail.com]:587/g' /etc/postfix/main.cf && \
    echo "smtp_sasl_auth_enable = yes" >> /etc/postfix/main.cf && \
    echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" >> /etc/postfix/main.cf && \
    echo "smtp_sasl_security_options = noanonymous" >> /etc/postfix/main.cf && \
    echo "smtp_sasl_mechanism_filter = plain" >> /etc/postfix/main.cf && \
    echo "smtp_use_tls = yes" >> /etc/postfix/main.cf && \
    echo "[smtp.gmail.com]:587 ${GmailU}@gmail.com:${GmailP}" > /etc/postfix/sasl_passwd && \
    chmod 600 /etc/postfix/sasl_passwd && \
    postmap hash:/etc/postfix/sasl_passwd && \
    chmod +x /start.sh

EXPOSE 80/TCP 10051/TCP

ENTRYPOINT ["/start.sh"]
