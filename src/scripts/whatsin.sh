: '@(#)whatsin.sh 22.1 03/24/08 1991-1996 '
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
:
logdir=$sourcedir/complogs/

if test ! -d $sourcedir
  then
    echo""
    echo "Your system is not properly mounting!!!"
    echo "Please, recheck your system, then try again ."
  else

    if test $# != 1
      then
        echo""
        echo 'usage -- whatsin  filename -- One of the below filename'
        echo log-files are:
        ls -C $logdir
        echo ""
      else
        echo $logdir$1
        echo "$1"
        grep -s ERROR ${logdir}$1
        grep -s Fatal ${logdir}$1 
        grep -s  warning ${logdir}$1 
        echo ""
        echo "In $logdir$1 there are : "
        echo "   Total of  `grep -c ERROR ${logdir}$1`  ERRORS ."
        echo "             `grep -c Fatal ${logdir}$1`  Fatal errors ."
        echo "             `grep -c warning ${logdir}$1`  warnings ."
        echo ""
    fi
fi
