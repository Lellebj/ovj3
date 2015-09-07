: '@(#)vnmrplot.old.sh 22.1 03/24/08 1991-1996 '
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
#  vnmrplot
#
#  General purpose plot shell for the VNMR system
#
#  Usage  vnmrplot filename [plotterType]
#
#  If no plotterType is enter, the laser will be the default
#
if [ $# = 1 ]   #  No plotterType given, use default
   then
      lpr -h -s -r -Plaser $1
else
   if [ $# = 2 ]  # if plotterType given, find out which one
      then
	 lpr -h -s -r -P$2 $1
   else
      echo vnmrplot error: Usage --  vnmrplot filename \[plotterType\]
   fi
fi
