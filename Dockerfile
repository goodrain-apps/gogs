FROM alpine:3.3
MAINTAINER zhouyq@goodrain.com

ENV GOGS_CUSTOM /data/gogs
ENV GOSU_VERSION 1.7
ENV LANG C.UTF-8



# change timezone to Asia/Shanghai
RUN apk add --no-cache tzdata && \
    cp  /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime && \
    echo "Asia/Shanghai" >  /etc/timezone && \
    apk del --no-cache tzdata

# add bash and libc6-compat
RUN apk add --no-cache bash libc6-compat && \
    ln -s /lib /lib64 && \
    sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd

# install gosu
RUN set -x \
    && apk add --no-cache --virtual .gosu-deps \
        dpkg \
        gnupg \
        openssl \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps

# add git user and group (addgroup -g 200 -S git)
RUN sed -i -r 's/nofiles/git/' /etc/group && \
    adduser -u 200 -D -S -G gti git

RUN apk --no-cache --no-progress add ca-certificates  git linux-pam s6 curl openssh

COPY docker-entrypoint.sh /

WORKDIR /app/gogs/

VOLUME ["/data"]

EXPOSE 22 3000

ENTRYPOINT ["/docker-entrypoint.sh"]
