#!/bin/sh
/usr/sbin/postfix start
ZBX_TYPE=server
docker-entrypoint.sh
