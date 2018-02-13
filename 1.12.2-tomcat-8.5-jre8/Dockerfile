FROM tomcat:8.5-jre8
MAINTAINER Micah Wengren <mwengren@github>

ENV DEBIAN_FRONTEND noninteractive
ENV _POSIX2_VERSION 199209

# Uncomment to use APT cache (requires apt-cacher-ng on host)
RUN echo "Acquire::http { Proxy \"http://`/sbin/ip route|awk '/default/ { print $3 }'`:3142\"; };" > /etc/apt/apt.conf.d/71-apt-cacher-ng


RUN  echo "deb http://httpredir.debian.org/debian jessie non-free" >> /etc/apt/sources.list \
&& apt-get update \
&& apt-get install -y apt-utils \
&& apt-get install -y libjai-core-java libjai-imageio-core-java \
&& rm -rf /var/lib/apt/lists/

# jai + imageio:
RUN ln -s /usr/share/java/jai_core.jar /usr/local/tomcat/lib/jai_core.jar \
&& ln -s /usr/share/java/jai_codec.jar /usr/local/tomcat/lib/jai_codec.jar \
&& ln -s /usr/share/java/mlibwrapper_jai.jar /usr/local/tomcat/lib/mlibwrapper_jai.jar \
&& ln -s /usr/share/java/jai_imageio.jar /usr/local/tomcat/lib/jai_imageio.jar \
&& ln -s /usr/share/java/clibwrapper_jiio.jar /usr/local/tomcat/lib/clibwrapper_jiio.jar

# download GeoWebCache version:
RUN wget -O /tmp/geowebcache.zip https://sourceforge.net/projects/geowebcache/files/geowebcache/1.12.2/geowebcache-1.12.2-war.zip/download \
&& unzip /tmp/geowebcache.zip -d /tmp/ \
&& unzip /tmp/geowebcache.war -d /opt/geowebcache \
&& rm /tmp/geowebcache.zip \
&& rm /tmp/geowebcache.war

ADD geowebcache_context.xml /usr/local/tomcat/conf/Catalina/localhost/geowebcache.xml

# SET geowebcache.xml location to /config
RUN mkdir /config && chmod a+rw /config \
&& sed -i.bak "1,20 s/<constructor-arg ref=\"gwcDefaultStorageFinder\" \/>/<constructor-arg value=\"\/config\" \/>/g" /opt/geowebcache/WEB-INF/geowebcache-core-context.xml

# fullWMS enable:
RUN sed '/<property name="fullWMS">/!b;n;c\\t\t\t<value>TRUE</value>' /opt/geowebcache/WEB-INF/geowebcache-wmsservice-context.xml

# SET CACHE_DIR
RUN mkdir /cache && chmod a+rw /cache
ENV GEOWEBCACHE_CACHE_DIR /cache

VOLUME /config /cache


# Tomcat/Java environment tuning for GWC.  See: http://geowebcache.org/docs/current/production/index.html
ENV CATALINA_OPTS "-DGWC_SEED_RETRY_COUNT=5 -DGWC_SEED_RETRY_WAIT=10000 \
    -Xms1024m -Xmx1560m "

# Modify geowebcache.xml for futher production tuning settings:
#  NIO file locking
#  this should be done in geowebcache.xml that is mounted to /config.
