: '@(#)Updatemanuals.sh 22.1 03/24/08 1999-2000 '
# 
#
# Copyright (C) 2015  Stanford University
# 
# You may distribute under the terms of either the GNU General Public
# License or the Apache License, as specified in the README file.
# 
# For more information, see the README file.
# 
#
: /bin/sh
DefaultDestination="/vcommon/online"

Source="denali:/export/manuals"
Mount="/manuals"

  echo 
  echo
  echo "This script assumes that '$Source' is mounted on '$Mount'"
  echo "Continue? [y]: \c"
  read answer

  if [ x$answer = "x" ]
  then
     answer="y"
  fi
  if [ x$answer != "xy" ]
  then
     exit
  fi

echo "Enter destination [$DefaultDestination]: \c"
read answer
if [ x$answer = "x" ]
then
   destination=$DefaultDestination
else
   destinaton=$answer
fi

if [ -d $destination ]
then
   echo "'$destination' exists, overwrite? [y]: \c"
   read answer
   if [ x$answer = "x" ]
   then
      answer="y"
   fi
   if [ x$answer != "xy" ]
   then
      exit
   fi
   rm -rf $destination/*
fi


x=`date +%H:%M:%S`
h=`echo $x | cut -c1-2`
m=`echo $x | cut -c4-5`
s=`echo $x | cut -c7-8`
start=`expr $h \* 3600 + $m \* 60 + $s`

mkdir -p $destination/masterlist

echo "Copying the masterlist"
cd $Mount/manuals_CD/CD/masterlist
tar cf - *.pdf vn_* | (cd $destination/masterlist; tar xvf - )

echo "Copying system links"
cd $Mount/manuals_CD/CD/
tar cf - * | (cd $destination; tar xvf - )

x=`date +%H:%M:%S`
h=`echo $x | cut -c1-2`
m=`echo $x | cut -c4-5`
s=`echo $x | cut -c7-8`
stop=`expr $h \* 3600 + $m \* 60 + $s`

cd $destination
size=`du -sk | awk 'BEGIN { FS = " " } { print $1 }'`
time=`expr $stop - $start`
persec=`expr $size / $time`

find $destination -name %* -exec rm {} \;

echo ${size}K in $time seconds [${persec}K per/sec]

echo "All Done !"

