#!/bin/sh
echo "[smtp.gmail.com]:587 ${GmailU}@gmail.com:${GmailP}" > /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd
postmap hash:/etc/postfix/sasl_passwd
/usr/sbin/postfix start
/config/bootstrap.sh
