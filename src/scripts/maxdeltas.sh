: '@(#)maxdeltas.sh 22.1 03/24/08 1991-1996 '
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
#
#  obtain the maximum delta level for all categories specified
#  Author  Greg Brissey  4/9/90


echo " "
echo " Obtains the Maximum deltas for specified categories."
echo " "
echo "Date: `date`"
echo " "

# test for tmp directory ---------------------------------
if (test -d maxrel_tmp)
then
  echo "Directory maxrel_tmp exits."
  echo "Directory contains:"
  ls -C maxrel_tmp
  echo "Delete Direcory (y, n): "
  read ans
  if (test ! "x$ans" = "xy")
  then
    echo "Move to another directory and restart."
    exit 1
  else
    rm -rf maxrel_tmp
  fi
fi
echo Making tmp directory maxrel_tmp.
mkdir maxrel_tmp
cd maxrel_tmp


relmdir="/sccs"
datestamp="`date +'%a %h %d 19%y  (%m/%d/%y)`"

if test $# -lt 1
then 
 echo Categories are:
 ls -C $sccsdir
 echo -n "Category for updating, or all: "
 read answer
else
 answer=$1
 shift 1
fi

if (test ! "x$answer" = "xall")
then
   chosen_categories=$answer
else
   chosen_categories=`ls $sccsdir`
fi

tfiles=0
tlines=0
for category in $chosen_categories
do
   echo " "
   echo "Category: $category"

   if (test -d$sccsdir/$category )
   then
# ------ extract all files from SCCS category ------------------
    sccs  -d$sccsdir/$category get -s SCCS/	# get all files
    filelist=`ls *`
    filecnt=`ls * | wc -w`
    echo " "
    echo "$filecnt SCCS files extracted: "
    ls -C .
    echo " "
    srclines=`cat $filelist | wc -l`
    echo "$srclines Source Lines present."

    tfiles=`expr $tfiles + $filecnt`
    tlines=`expr $tlines + $srclines`

# ------  determine maximum delta present  ----------------
    if (test ! "x$filelist" = "x")
    then
     maxdelta=`what $filelist | awk '$2 > max { max = $2 }; END { print max }'`

     echo " "
     echo "Maximum Delta for Category $category is $maxdelta"
     rm -f *
    else
     echo "No files present in Category $category"
    fi
   else
    echo "Category: $category is not present."
   fi
  echo " "
done
echo " "
echo "$tfiles Total SCCS files extracted."
echo " "
echo "$tlines Total Source Lines present."
cd ..
echo " "
echo "Removing temporary directory: maxrel_tmp."
rm -rf maxrel_tmp		# remove tmp directory
echo " "
echo "Date: `date`"
echo " "
