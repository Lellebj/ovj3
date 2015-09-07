#!/bin/csh -f
# '@(#)versions.sh 22.1 03/24/08 1991-1996 '
# 
#
# Copyright (C) 2015  University of Oregon
# 
# You may distribute under the terms of either the GNU General Public
# License or the Apache License, as specified in the README file.
# 
# For more information, see the README file.
# 
#
# save source file sccs version numbers
# extract the sccs delta from file using the key @(#)
# then reformat output so that delta number is first to
# ease its usage in reconstructing a release from the deltas.
# Author:  Greg Brissey
# 2/26/92 changed output file to be one directory above the present to avoid
# recursive reading & writing of output file (maclib bug)
#
# Altered to use the sccs command what instead of the awk scripts
#
set argn = ${#argv}
if ( $argn > 3 ) then
  echo "Usage:  $0 file_name sccsdir "
  exit
else
  set  filename = "$1"
  set  SCCSDIR = "$2"
  set  dir = `pwd`
  set  date = `date +%y%m%d.%H:%M`
  echo " extracting files from $SCCSDIR/$filename "
  sccs  -d$SCCSDIR/$filename get -s SCCS/
    echo "   Versions: creating $dir/${filename}_deltas_${date}"
    echo `date` > ${filename}_deltas_${date}
    rm -f tmpfile

    what * >> tmpfile

    nawk  -f - tmpfile > tmpfile2 << THEEND
    BEGIN {
    }
    {    if ( \$0 ~ /:/ )
         { next; }
         printf("%8s   %20s   %10s\n",\$2,\$1,\$3)
    }
THEEND

   sort  -b -d -f +1 -2 tmpfile2 | uniq >> ${filename}_deltas_${date}

   rm -f tmpfile tmpfile2

endif
