#!/bin/sh
/usr/sbin/postfix start
ZBX_TYPE=frontend
docker-entrypoint.sh
ZBX_TYPE=server
docker-entrypoint.sh
