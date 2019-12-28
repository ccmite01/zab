FROM monitoringartist/dockbix-xxl:3.4.14
LABEL maintainer="ccmite"
WORKDIR /
COPY start.sh /

RUN : "add package" && \
    yum -y update && yum -y install rsyslog && \
    rm -rf /var/cache/yum/* && \
    yum clean all && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
    sed -i 's/pm.max_children = 10/pm.max_children = 50/g' /etc/php-fpm.d/www.conf && \
    chmod +x /start.sh
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

EXPOSE 80/TCP 162/UDP 10051/TCP 10052/TCP

ENTRYPOINT ["/start.sh"]
