Geowebcache docker
==================

Geowebcache docker images, meant to be used with configurations/ambassadors.

Work in progress

###Data volume
Create a data volume to access the data:
```docker create -v /cache --name=gwc-data busybox /bin/true```

Now if you want to do something with the data (delete it, backup, copy, ...) start a (temporary) container to do your stuff.
```docker run --rm -ti --volumes-from=gwc-data ubuntu? /bin/bash```

### Jetty
Getting native JAI to work on jetty is difficult (impossible?) so we dont.
```docker run -d --volumes-from=gwc-data -v $(pwd)/config:/config --name=gwc pdok/geowebcache:1.8.3-jetty-9.3-jre8```

Jetty runs normally as jetty user (999), which might cause difficulties if the tiles are created with another user. To fix start with:
```-e JAVA_OPTIONS="-Djetty.setuid.userName=username"``` and maybe do the same for ```jetty.setuid.groupName```

The cache is configured at ```/cache```  and _geowebcache.xml_ should be in ```/config/```. If you don't set a config volume, a default is generated (GWC defaults). 

### Tomcat
Native JAI on tomcat does work. It might be faster, it might be not.
```
docker run -d --volumes-from=gwc-data -v $(pwd)/config:/config --name=gwc pdok/geowebcache:1.8.3-tomcat-8.5-jre8
```
```
docker run -d --volumes-from=gwc-data -v $(pwd)/config:/config --name=gwc mwengren/geowebcache:1.12-beta-tomcat-8.5-jre8
```

The cache is also configured at ```/cache```  and _geowebcache.xml_ should be in ```/config/``` 

### Build
From top dir:
```
docker build --rm -t pdok/geowebcache:1.8.3-jetty-9.3-jre8 1.8.3-jetty-9.3-jre8
```
```
docker build --rm -t pdok/geowebcache:1.8.3-tomcat-8.5-jre8 1.8.3-tomcat-8.5-jre8
```