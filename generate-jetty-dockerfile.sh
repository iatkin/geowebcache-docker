#!/usr/bin/env bash

cat <<EOF
FROM jetty:$JETTY_VERSION
MAINTAINER PDOK

#ADD geowebcache_context.xml /var/lib/jetty/webapps/geowebcache.xml

RUN wget -O /tmp/geowebcache.zip https://sourceforge.net/projects/geowebcache/files/geowebcache/$GWC_VERSION/geowebcache-$GWC_VERSION-war.zip/download \
    && unzip /tmp/geowebcache.zip -d /tmp/ \
    && unzip /tmp/geowebcache.war -d /var/lib/jetty/webapps/geowebcache \
    && rm /tmp/geowebcache.zip && rm /tmp/geowebcache.war
EOF