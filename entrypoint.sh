#!/bin/sh
envsubst < /usr/local/nginx/conf/nginx.conf | tee /tmp/nginx.conf >/dev/null && \
    mv /tmp/nginx.conf /usr/local/nginx/conf/nginx.conf

exec /usr/sbin/nginx "${@}"
