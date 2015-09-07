#! /bin/sh
# 
# Varian,Inc. All Rights Reserved.
# This software contains proprietary and confidential
# information of Varian, Inc. and its contributors.
# Use, disclosure and reproduction is prohibited without
# prior consent.
#
#set +x
basedir=`pwd`
n=`basename ${basedir}`
if [ x$n != "xvnmrj" ]
then
   javadir=`dirname ${basedir}`
   basedir=${basedir}/"vnmrj"
   dashodir=${javadir}"/3rdParty/DashO/"
   # javadir=${javadir}"/3rdParty/jdk1.6.0_01"
   # java is a symlink to java version being used
   javadir=${javadir}"/3rdParty/java"
else
   # basedir = basedir
   javadir=`dirname ${basedir}`
   javadir=`dirname ${javadir}`
   dashodir=${javadir}"/3rdParty/DashO/"
   # javadir=${javadir}"/3rdParty/jdk1.6.0_01"
   # java is a symlink to java version being used
   javadir=${javadir}"/3rdParty/java"
fi
echo VNMRJ BASENAME: $basedir
echo $javadir


if [ ! -d ${basedir}/vnmrj ]
then
  mkdir -p ${basedir}/vnmrj
fi
if [ ! -h ${basedir}/vnmrj/com ]
then
    ( cd ${basedir}/vnmrj; ln -s ../classes/com . )
fi
if [ ! -h ${basedir}/vnmrj/org ]
then
( cd ${basedir}/vnmrj; ln -s ../classes/org . )
fi
if [ ! -h ${basedir}/vnmrj/sunw ]
then
    ( cd ${basedir}/vnmrj; ln -s ../classes/sunw . )
fi
if [ ! -h ${basedir}/vnmrj/javax ]
then
    ( cd ${basedir}/vnmrj; ln -s ../classes/javax . )
fi
( cd $basedir/vnmrj ; rm -rf *.jar *.class postgresql vnmr )
cp=${basedir}:${dashodir}/DashOPro_3.3/DashoPro.jar
dashojars=`ls ${dashodir}/DashOPro_3.3/lib/*.jar`
for dj in $dashojars;do
   cp=$cp:$dj
done
CLASSPATH=$cp:${javadir}/lib:${javadir}/jre/lib
echo $CLASSPATH
echo "starting Dasho..."
cd ${basedir}
/usr/bin/time ${javadir}/jre/bin/java -mx128m -classpath $CLASSPATH DashoPro -f -v $basedir/VnmrJ.dox
fileext="`date '+%Y_%m_%d'`"
mv vnmrj.map vnmrj.map.$fileext
mv vnmrj.log vnmrj.log.$fileext
cd $basedir/vnmrj
jar -cvf vnmrj.jar.dasho *
mv vnmrj.jar.dasho ../
