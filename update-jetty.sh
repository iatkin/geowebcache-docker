#!/usr/bin/env bash

cd "$(dirname "$0")"
set -e

# gwc-version,jetty-version
versions=(
    1.8.3,9.3-jre8
)

for v in "${versions[@]}"
do IFS=","; set $v

   targetdir=$1-jetty-$2

   mkdir -p $targetdir

   java_current_version=
   jetty_current_version=
   [[ -f $targetdir/JAVA_VERSION ]] && java_current_version=$(cat $targetdir/JAVA_VERSION)
   [[ -f $targetdir/JETTY_VERSION ]] && jetty_current_version=$(cat $targetdir/JETTY_VERSION)

   #get java version
   docker pull jetty:$2
   export $(docker inspect --type image --format='{{range .Config.Env }}{{println .}}{{end}}'  jetty:$2 | grep "^JAVA_VERSION")

   gwc_current_version=
   [[ -f $targetdir/GWC_VERSION ]] && gwc_current_version=$(cat $targetdir/GWC_VERSION)

   # Only generate when versions are updated
   if [[ $java_current_version != $JAVA_VERSION || $jetty_current_version != $2 || $gwc_current_version != $1 ]]; then

       echo "Updating $1,$2 to $JAVA_VERSION"

       touch $targetdir/GENERATED_DO_NOT_EDIT

       printf "$JAVA_VERSION" > $targetdir/JAVA_VERSION
       printf "$1" > $targetdir/GWC_VERSION
       printf "$2" > $targetdir/JETTY_VERSION

       cp jetty_geowebcache_context.xml $targetdir/geowebcache_context.xml

       generate_script=generate-jetty-dockerfile.sh
       if [[ $1 == *"alpine"* ]]; then
           generate_script=generate-jetty-dockerfile.sh
       fi

       GWC_VERSION=$1 JETTY_VERSION=$2 ./$generate_script > $targetdir/Dockerfile
   fi
done