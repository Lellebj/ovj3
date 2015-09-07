# !/bin/sh
#
# Copyright (C) 2015  Stanford University
# 
# You may distribute under the terms of either the GNU General Public
# License or the Apache License, as specified in the README file.
# 
# For more information, see the README file.
# 
#

if test $# -gt 0
then
   ostype=`uname -s`
   if [ x$ostype = "xDarwin" ]
   then
     open $1 &
   else
     firefox $1  >& /dev/null &
   fi
fi
