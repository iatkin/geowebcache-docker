#!/usr/bin/env bash

cat <<EOF
FROM jetty:$JETTY_VERSION
MAINTAINER PDOK

ENV DEBIAN_FRONTEND noninteractive
ENV _POSIX2_VERSION 199209

RUN wget -O /tmp/geowebcache.zip https://sourceforge.net/projects/geowebcache/files/geowebcache/$GWC_VERSION/geowebcache-$GWC_VERSION-war.zip/download \
    && unzip /tmp/geowebcache.zip -d /tmp/ \
    && unzip /tmp/geowebcache.war -d /opt/geowebcache \
    && rm /tmp/geowebcache.zip && rm /tmp/geowebcache.war

ADD geowebcache_context.xml /var/lib/jetty/webapps/geowebcache.xml

# SET geowebcache.xml location to /config
RUN mkdir /config && chmod a+rw /config \
    && sed -i.bak "1,20 s/<constructor-arg ref=\"gwcDefaultStorageFinder\" \/>/<constructor-arg value=\"\/config\" \/>/g" /opt/geowebcache/WEB-INF/geowebcache-core-context.xml

# SET CACHE_DIR
RUN mkdir /cache && chmod a+rw /cache
ENV GEOWEBCACHE_CACHE_DIR /cache

VOLUME /config /cache

EOF