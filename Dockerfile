# alpine:3.21.3
FROM alpine@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c AS builder

ARG zlib_version=1.3.1
ARG nginx_version=1.27.1
ARG nginx_proxy_version=0.0.7
ARG nginx_proxy_connect_patch_file=proxy_connect_rewrite_102101.patch

RUN apk add alpine-sdk git wget pcre-dev

RUN git clone https://github.com/chobits/ngx_http_proxy_connect_module.git --branch v${nginx_proxy_version} --single-branch ngx_http_proxy_connect_module
RUN git clone https://github.com/madler/zlib.git --branch v${zlib_version} --single-branch zlib

RUN wget https://nginx.org/download/nginx-${nginx_version}.tar.gz && \
    tar -xzvf nginx-${nginx_version}.tar.gz && \
    cd nginx-${nginx_version}/ && \
    patch -p1 < ../ngx_http_proxy_connect_module/patch/${nginx_proxy_connect_patch_file} && \
    ./configure --add-module=../ngx_http_proxy_connect_module --sbin-path=/usr/sbin/nginx --with-cc-opt=-static --with-ld-opt=-static --with-zlib=../zlib && \
    make -j $(nproc) && \
    make install

FROM alpine@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c

ENV PROXY_ADDRESS="http://localhost:8080"

RUN apk add gettext

COPY --from=builder /usr/local/nginx /usr/local/nginx
COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
