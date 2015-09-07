#!/bin/csh -f
# @(#)deltalogmake.sh 22.1 03/24/08 1991-1998 
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
# generate Category delta DBM files where each line contains: 
# Category:Filename:User:Rel:Level:Date:LineInserted:LineDeleted:LineUnchanged:Comment
#  acqproc:msgehandler.c:greg:6:4:91/08/08:23:0:781:added QUEQUERY case, to allow ... 
#  acqproc:msgehandler.c:dan:6:3:91/05/29:10:2:771:uses new setHALtimer  ......
#  if there are blank lines in the comments this method breaks down!!
#
#  the dbm call deltadmb is placed in $sccsdir/category
#  e.g. for acqi then /vsccs/sccs/acqi/deltadbm is created.
#
#set verbose
if ($#argv < 1) then
  echo "Categories are: "
  ls -C $sccsdir
  echo -n "Category(s) for updating, or all: "
  set answer = $<
  @ noecho = 0
else
  set answer = $*
  @ noecho = 1
endif

if ( "$answer" == "all") then
   set catlist = `ls $sccsdir`
else
   set catlist = "$answer"
endif

if ( $noecho == 0 ) then
  echo " "
  echo " "
  echo " "
endif

foreach cat ($catlist)

if ( $noecho == 0 ) then
   echo -n "Category: $cat, "
endif

# ------ determine max & min delta of SCCS category ------------------
set maxdelta = `/usr/ccs/bin/prs -e -d":R:" $sccsdir/${cat}/SCCS | awk 'BEGIN { maxrel = 0; minrel = 9999; files = 0;} { if ($1 > maxrel) { maxrel = $1; } if ($1 < minrel) { minrel = $1; } files += 1; } END { printf("%s %s %s",maxrel,minrel,files); }'`

# Create database 2 years prior to present year
# was +y, changed to +Y to get 2000, then -2 for 1998, -1900 to get 98
# -2000 to get 01
@ yr = `date '+%Y'`
@ yr -= 2
set year = $yr
@ yr -= 1900
if ( $yr > 99) then
 @ yr -= 100
endif

echo maxdelta $maxdelta

if ( $noecho == 0 ) then
  echo " $maxdelta[3] Files,  Max & Min Delta Levels: $maxdelta[1]   $maxdelta[2]"
  echo "Extracting Delta Information after $year"
endif


( /usr/ccs/bin/prs -l -c${yr} -d":M: :P: :R: :L: :D: :Li: :Ld: :Lu: :C:" \
  $sccsdir/${cat}/SCCS | \
  awk 'BEGIN { RS = "" } \
       {  printf("'$cat':%s:%s:%d:%d:%s:%d:%d:%d:",$1,$2,$3,$4,$5,$6,$7,$8) \
	  for (i=9; i<= NF; i = i + 1) { printf("%s ",$i); } \
	  printf("\n") \
       }' > ${sccsdir}/${cat}/deltadbm ) >& /dev/null


# --- if there are delta level of 1 these new files were missed above ---
# so we will get them here
if ($maxdelta[2] == 1) then	# new sccs file for this level
# --- get the name delta level pairs ---
  
  /usr/ccs/bin/prs -d":M: :R:" $sccsdir/${cat}/SCCS > /tmp/deltalogtmpQ
  @ nname = `cat /tmp/deltalogtmpQ | wc -l`
#  echo nname = $nname
  if ($nname > 512) then
     split -l 512 /tmp/deltalogtmpQ /tmp/deltalogtmpQ
     set filelist = `ls /tmp/deltalogtmpQ??`
  else
    set filelist = "/tmp/deltalogtmpQ"
  endif
     
#  echo filelist = $filelist

  foreach  file ($filelist)

#  echo file = $file

    set names = `cat $file`
    @ i = 2
    @ nname = $#names
    while ($i <= $nname) 	# iterate to find delta level 1 and pull deltas
      @ imo = $i - 1
#     echo "$names[$imo] $names[$i]"
      if ($names[$i] == 1) then
        /usr/ccs/bin/prs -l -r1.1 -d":M: :P: :R: :L: :D: :Li: :Ld: :Lu: :C:" \
          $sccsdir/${cat}/SCCS/s.${names[${imo}]} | \
          awk 'BEGIN { RS = "" } \
             {  printf("'$cat':%s:%s:%d:%d:%s:%d:%d:%d:",$1,$2,$3,$4,$5,$6,$7,$8) \
	        for (i=9; i<= NF; i = i + 1) { printf("%s ",$i); } \
	        printf("\n") \
             }' >> ${sccsdir}/${cat}/deltadbm
      endif
     @ i += 2;
    end
  end
  rm -f /tmp/deltalogtmpQ*
endif
chmod -f 666 ${sccsdir}/${cat}/deltadbm
if ( $noecho == 0 ) then
  echo " "
endif
end
# sort user category file delta 
#sort -t: +2 -3 +0 -1 +1 -2 +3 -4rn +4 -5rn tmpf | \
#awk -f deltabyname  > byname
# sort category file delta 
#sort -t: +0 -1 +1 -2 +3 -4rn +4 -5rn tmpf | \
#awk -f deltabycat  > bycat
