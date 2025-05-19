#!/bin/sh
envsubst < /usr/local/nginx/conf/nginx.conf | tee /usr/local/nginx/conf/nginx.conf >/dev/null
exec /usr/sbin/nginx "${@}"
