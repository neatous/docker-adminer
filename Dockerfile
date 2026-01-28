FROM alpine:edge

ENV ADMINER_DG_VERION=3.3.1
ENV MEMORY=256M
ENV UPLOAD=2048M

RUN apk update && apk upgrade && \
    apk add \
        wget \
        ca-certificates \
        php85 \
        php85-session \
        php85-mysqli \
        php85-pgsql \
        php85-json && \
    wget https://github.com/dg/adminer-custom/archive/v$ADMINER_DG_VERION.tar.gz -O /srv/adminer.tgz && \
    tar zxvf /srv/adminer.tgz --strip-components=1 -C /srv && \
    rm /srv/adminer.tgz && \
    apk del wget ca-certificates && \
    rm -rf /var/cache/apk/*

WORKDIR /srv
EXPOSE 80

CMD ["/bin/sh", "-c", "/usr/bin/php85 -d memory_limit=$MEMORY -d upload_max_filesize=$UPLOAD -d post_max_size=$UPLOAD -S 0.0.0.0:80"]
