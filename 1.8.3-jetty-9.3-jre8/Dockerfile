FROM jetty:9.3-jre8
MAINTAINER Raymond Kroon <raymond@k3n.nl>

#ADD geowebcache_context.xml /var/lib/jetty/webapps/geowebcache.xml

RUN wget -O /tmp/geowebcache.zip https://sourceforge.net/projects/geowebcache/files/geowebcache/1.8.3/geowebcache-1.8.3-war.zip/download     && unzip /tmp/geowebcache.zip -d /tmp/     && unzip /tmp/geowebcache.war -d /var/lib/jetty/webapps/geowebcache     && rm /tmp/geowebcache.zip && rm /tmp/geowebcache.war
