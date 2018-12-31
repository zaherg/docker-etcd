FROM alpine:3.8

ARG BUILD_DATE
ARG VCS_REF
ARG IMAGE_NAME
ARG DOCKER_REPO
ENV COMPOSER_ALLOW_SUPERUSER 1

LABEL Maintainer="Mhd Zaher Ghaibeh <z@zah.me>" \
      org.label-schema.name="$DOCKER_REPO:latest" \
      org.label-schema.description="Lightweight container with Nginx 1.12 & PHP-FPM 7.2 based on Alpine Linux." \
      org.label-schema.url="https://www.zah.me" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/linuxjuggler/php-and-nginx.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0"

ENV VERSION=3.3.10

RUN apk add --update ca-certificates openssl tar tini && \
	wget https://github.com/etcd-io/etcd/releases/download/v$VERSION/etcd-v$VERSION-linux-amd64.tar.gz && \
	tar xzvf etcd-v$VERSION-linux-amd64.tar.gz && \
	mv etcd-v$VERSION-linux-amd64/etcd* /bin/ && \
	apk del --purge tar openssl && \
    rm -Rf etcd-v$VERSION-linux-amd64* /var/cache/apk/*


VOLUME      /etcd-data

EXPOSE      2379 2380

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["etcd"]