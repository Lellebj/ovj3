: '@(#)dv.sh 22.1 03/24/08 1999-2000 '
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

#dv.sh -- to start the VNMR Document Viewer

if [ x$docdir = x"" ]
then
    echo "\n Please set the environmental variable \"docdir\" to an appropriate directory.\n"
    exit
fi

if [ ! -d $docdir ]
then
    echo "\n The directory $docdir does not exist.\n"
    exit
fi

fcd=`domainname | grep deltaquadrant`

if [ ! "x$fcd" = "x" ]
then
   doceditdir="/pa/sw_pa/docs"
else
   doceditdir="$docdir"
fi

java  -classpath /sw/vbin/DocViewer.jar -Ddocdir=$docdir -Ddoceditdir=$doceditdir -Dtasks=yes DocViewer &

#for testing only
#java  -Ddocdir=$docdir DocViewer $1
