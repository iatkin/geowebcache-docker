#!/usr/bin/env bash

cd "$(dirname "$0")"
set -e

# gwc-version,tomcat-version
versions=(
    1.8.3,8.5-jre8
)

for v in "${versions[@]}"
do IFS=","; set $v

   targetdir=$1-tomcat-$2

   mkdir -p $targetdir

   java_current_version=
   tomcat_current_version=
   [[ -f $targetdir/JAVA_VERSION ]] && java_current_version=$(cat $targetdir/JAVA_VERSION)
   [[ -f $targetdir/TOMCAT_VERSION ]] && tomcat_current_version=$(cat $targetdir/TOMCAT_VERSION)

   #get java version
   docker pull tomcat:$2
   export $(docker inspect --type image --format='{{range .Config.Env }}{{println .}}{{end}}'  tomcat:$2 | grep "^JAVA_VERSION")

   gwc_current_version=
   [[ -f $targetdir/GWC_VERSION ]] && gwc_current_version=$(cat $targetdir/GWC_VERSION)

   # Only generate when versions are updated
   if [[ $java_current_version != $JAVA_VERSION || $tomcat_current_version != $2 || $gwc_current_version != $1 ]]; then

       echo "Updating $1,$2 to $JAVA_VERSION"

       touch $targetdir/GENERATED_DO_NOT_EDIT

       printf "$JAVA_VERSION" > $targetdir/JAVA_VERSION
       printf "$1" > $targetdir/GWC_VERSION
       printf "$2" > $targetdir/TOMCAT_VERSION

       cp tomcat_geowebcache_context.xml $targetdir/geowebcache_context.xml

       generate_script=generate-tomcat-dockerfile.sh
       if [[ $1 == *"alpine"* ]]; then
           generate_script=generate-tomcat-dockerfile.sh
       fi

       GWC_VERSION=$1 TOMCAT_VERSION=$2 ./$generate_script > $targetdir/Dockerfile
   fi
done