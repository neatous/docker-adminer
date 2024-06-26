FROM alpine:edge

ENV ADMINER_DG_VERION=1.33.0
ENV MEMORY=256M
ENV UPLOAD=2048M

RUN apk update && apk upgrade && \
    apk add \
        wget \
        ca-certificates \
        php83 \
        php83-session \
        php83-mysqli \
        php83-pgsql \
        php83-json && \
    wget https://github.com/dg/adminer-custom/archive/v$ADMINER_DG_VERION.tar.gz -O /srv/adminer.tgz && \
    tar zxvf /srv/adminer.tgz --strip-components=1 -C /srv && \
    rm /srv/adminer.tgz && \
    apk del wget ca-certificates && \
    rm -rf /var/cache/apk/*

WORKDIR srv
EXPOSE 80

CMD /usr/bin/php83 \
    -d memory_limit=$MEMORY \
    -d upload_max_filesize=$UPLOAD \
    -d post_max_size=$UPLOAD \
    -S 0.0.0.0:80
