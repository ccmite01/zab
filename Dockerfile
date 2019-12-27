FROM monitoringartist/dockbix-xxl:3.4.14
LABEL maintainer="ccmite"
WORKDIR /
COPY start.sh /

RUN : "add package" && \
    yum -y update && yum -y install postfix rsyslog && \
    rm -rf /var/cache/yum/* && \
    yum clean all && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
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
    chmod +x /start.sh
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

EXPOSE 80/TCP 162/UDP 10051/TCP 10052/TCP

ENTRYPOINT ["/start.sh"]
