: '@(#)cmpwsccs.sh 22.1 03/24/08 1991-1996 '
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
: compare given name with the lastest version of same in sccs
:
set +x

cmd=`basename $0`
#
# Change to proper name for whatsccs, keys off capital J,S or D for appropriate sccs dir
#
if [ $cmd = "cmpwsccs" ]
then
  cmd="Scmpwsccs"
fi
wrksccsdir=`whatsccs $cmd`
#
# make the appropriate links if requested
#
if test $# -eq 1
then
   if [ x$1 = "xmakelinks" ]
   then
      ln -s cmpwsccs Scmpwsccs
      ln -s cmpwsccs Jcmpwsccs
      ln -s cmpwsccs Dcmpwsccs
      exit 0
  fi
fi

#
# check to see if 3rd arg is a directory not a file, if directory
# then assume it's the sccs directory to use, this is ultized by
# Sdelta, Jdelta, Ddelta scripts
#
if [ $# -eq 3 ]
then
   if [ -d $3 ]
   then
      wrksccsdir=$3
    fi
fi

if test $# -lt 2
then
   echo "usage -- $cmd category filename"
   echo categories are:
   ls -C $wrksccsdir
else
   category="$1"
   shift
   if (test -d $wrksccsdir/$category/SCCS)
   then
#set -x
    for file
    do
#     does file exist in SCCS
      if test ! -r $wrksccsdir/$category/SCCS/s.$file 
         then
            echo file \'$file\' does not exist in sccs
         else
	    date=`date +%y%m%d.%H:%M`
	    mv $file $file.org2cmp.$date
	    sccs -d$wrksccsdir/$category get $file
	    diff -b $file $file.org2cmp.$date > $file.${date}.dif &
            kid=$!
#	not openwindows or CDE
            if (test x$WINDOW_PARENT = "x" -a x$DTAPPSEARCHPATH = "x")
	    then 
	       sdiff -w 120 -l -o $file.${date}.sdif $file $file.org2cmp.$date
	    else
	       shelltool -Wp 0 0 -Ws 1152 860 sdiff -w 120 -l -o $file.${date}.sdif $file $file.org2cmp.$date
	    fi
#	    echo return code = $?
	    wait $kid
	    rm -f $file
            mv $file.org2cmp.$date $file
	    echo "Summary of Changes in: $file.${date}.dif"
#	    more $file.dif
        fi
     done
    else
      echo "'$category' is not a valid sccs category"
      echo categories are:
      ls -C $wrksccsdir
    fi
fi
