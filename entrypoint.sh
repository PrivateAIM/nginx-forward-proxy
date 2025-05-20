#!/bin/sh

# SC2016 states that variables are not expanded in single quotes, but this is intended here.
# shellcheck disable=SC2016
envsubst '${PROXY_ADDRESS}' < /usr/local/nginx/conf/nginx.conf | tee /tmp/nginx.conf >/dev/null && \
    mv /tmp/nginx.conf /usr/local/nginx/conf/nginx.conf

exec /usr/sbin/nginx "${@}"
