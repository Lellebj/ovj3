: '@(#)vnmr_singleline.sh 22.1 03/24/08 1991-1996 '
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

# singleline
#  extract a single line from fitspec.outpar and put it into
#  a new file fitspec.singleline
#
#  replace BSD tr command with sed equivalent
#  sed will work on IBM, Solaris, etc.  10/1993

sed 's/*/ /g' < $1/fitspec.outpar |
awk '
BEGIN { FS=","
}
{
   if (NR=="'$2'") {
       printf "%12g, %12g, %12g, %12g\n", $1, $2, $3, $4
      }
}' > $1/fitspec.singleline

