#! /bin/sh
# 
# Varian,Inc. All Rights Reserved.
# This software contains proprietary and confidential
# information of Varian, Inc. and its contributors.
# Use, disclosure and reproduction is prohibited without
# prior consent.
#
#set -x
basedir=`pwd`
n=`basename ${basedir}`
if [ x$n != "xapt" ]
then
   javadir=`dirname ${basedir}`
   basedir=${basedir}/"apt"
   dashodir=${javadir}"/3rdParty/DashO/"
   # javadir=${javadir}"/3rdParty/jdk1.6.0_01"
   # java is the symlink to java version in use
   javadir=${javadir}"/3rdParty/java"
else
   # basedir = basedir
   javadir=`dirname ${basedir}`
   javadir=`dirname ${javadir}`
   dashodir=${javadir}"/3rdParty/DashO/"
   # javadir=${javadir}"/3rdParty/jdk1.6.0_01"
   javadir=${javadir}"/3rdParty/java"
fi
echo $basedir
echo $javadir

if [ ! -d $basedir/dasho ]
then
  mkdir -p $basedir/dasho
fi
( cd $basedir/dasho ; rm -rf *.jar *.class )
date
set -x
cp=${basedir}:${dashodir}/DashOPro_3.3/DashoPro.jar
dashojars=`ls ${dashodir}/DashOPro_3.3/lib/*.jar`
for dj in $dashojars;do
   cp=$cp:$dj
done
CLASSPATH=$cp:${javadir}/lib:${javadir}/jre/lib
echo $CLASSPATH
cd $basedir
echo `pwd`
echo "starting Dasho..."
${javadir}/bin/java -Xmx64000000 -classpath $CLASSPATH DashoPro -f -v $basedir/Apt.dox
date
fileext="`date '+%Y_%m_%d'`"
mv apt.map apt.map.$fileext
mv apt.log apt.log.$fileext
(  datetime="`date '+%B %e, %Y %T %Z'`";			 \
   echo "Implementation-Version: 1.0  $datetime" > Manifest.mf; \
   echo "Main-Class: Main" >> Manifest.mf;			 \
)
cd $basedir/dasho
jar -cvmf ../Manifest.mf apt.jar.dasho *
mv apt.jar.dasho ../

