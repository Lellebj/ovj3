#!/bin/csh -f
# '@(#)cron_ufsdump.sh 22.1 03/24/08 1999-2001 '
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
#  cron script for ufs dumping the server files to the DLT tape drive
#  running on Enterprise  using Solaris 2.6
#
#
#set filename="/opt/dumptoc/dumpinfo"

# set mail_list = "greg.brissey@varianinc.com"
set mail_list = "greg.brissey@varianinc.com chin.pham@varianinc.com frits.vosman@varianinc.com"

#
# directory location of the ufsdump logs and the dumpinfo files
# which controls the action of the dump
#

set workdir="/export/t5/SysDumpLogs"
set filename="/export/t5/SysDumpLogs/dumpinfo"

#
#echo $filename
#
# dumpinfo 3 values 1st startIndex, 2nd dumplevel, 3rd week number
# e.g.
# >cat dumpinfo
# 0
# 0
# 1
#

#
# extract info from dumpinfo file
#
set tapeloc="`cat $filename`"
echo $tapeloc

#
# index - the dump record number about to be put on the tape.
# each dump on the tape, Unixs treats as a seperate file on the tape
# and we need this inof to get back to the correct dump file to recover
# files if needed
#

@ index = $tapeloc[1]

#
# dump level 0 or 5 in our case, 1st an epic (0) then updates (5)
#   0uaf or 5uaf, to verify write 0uvaf (this fails since we dump while the
#   file system is active, there is no way to umount dump then remount since the
#   file system is always busy and there is no way to force it's unmounting
#   at least not with 2.6
#

@ dumplevel = $tapeloc[2]

set dumpopt = ${dumplevel}uaf

#
# the week number which corresponds to the tape being used.
#
set weeknum = $tapeloc[3]

#
#
# generate name with dates for the log and toc files
#  e.g. set nname=`date '+%a_%b_%d_%Y'` gives "Thru_Mar_02_2000"
#
set nname=`date '+%a_%b_%d_%Y'`
set lname=`date '+%a_%b_%d'`

# set logname = /export/t5/SysDumpLogs/Dump$nname.log
set logname = $workdir/Dump$nname.log

#
# this file is to look at the log and check for failures
#
# set grepname = /export/t5/SysDumpLogs/grepfile.tmp
set grepname = $workdir/grepfile.tmp

# echo $logname
# get full name of day of week
#set theday = `date '+%A'` gives "Thursday"
#

set theday = `date '+%A'`

echo $theday
echo startIndex $index
echo dumplevel $dumplevel
echo dumpopt $dumpopt
echo week week$weeknum

switch($theday)
  case Saturday:
	exit
	breaksw
  case Sunday:
	exit
	breaksw
  default:
	breaksw
endsw

date > $logname

#
# if dump level zero, then clear out this weeks files
#

if ($dumplevel == 0) then
   echo rm -rf $workdir/week$weeknum > $logname
   rm -rf $workdir/week$weeknum
   echo mkdir $workdir/week$weeknum >> $logname
   mkdir $workdir/week$weeknum
endif

#
#
# ------------------------ UFSDUMP 0 /export/t4  /usr26 --------------------------
#
#

date >> $logname
#
# /export/t4 home
#

set tocname = $workdir/toc_${dumplevel}_${index}_t4_${lname}
echo /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /dev/rdsk/c2t0d0s6 >> $logname

/usr/bin/time /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /dev/rdsk/c2t0d0s6 >>& $logname


#
#
# ------------------------ UFSDUMP 1 /export/t6  /usr25 --------------------------
#
#
#

@ index += 1
set tocname = $workdir/toc_${dumplevel}_${index}_t6_${lname}
date >> $logname
echo /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /dev/rdsk/c2t2d0s6 >> $logname

/usr/bin/time /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /dev/rdsk/c2t2d0s6 >>& $logname


#
#
# ------------------------ UFSDUMP 2 /export/t2  only vsccs vsccs.mercuryVx   -------------
#
#

@ index += 1
set tocname = $workdir/toc_${dumplevel}_${index}_t2_${lname}
date >> $logname
# echo /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /dev/rdsk/c0t2d0s6 >> $logname
#/usr/bin/time /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /dev/rdsk/c0t2d0s6 >>& $logname
echo /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /export/t2/vsccs >> $logname

/usr/bin/time /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /export/t2/vsccs >>& $logname

#
#
# ------------------------ UFSDUMP 3 /export/t2  only vsccs vsccs.mercuryVx   -------------
#
#
#
# /export/t2   vsccs.mercuryVx
#

@ index += 1
set tocname = $workdir/toc_${dumplevel}_${index}_t2_${lname}
date >> $logname
echo /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /export/t2/vsccs.mercuryVx >> $logname

/usr/bin/time /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /export/t2/vsccs.mercuryVx >>& $logname


#
#
# ------------------------ UFSDUMP 4 /export/t3  only vcommon -------------
#
#
#

@ index += 1
set tocname = $workdir/toc_${dumplevel}_${index}_t3_${lname}
date >> $logname
#echo /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /dev/rdsk/c0t3d0s6 >> $logname
#/usr/bin/time /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /dev/rdsk/c0t3d0s6 >>& $logname
echo /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /export/t3/vcommon >> $logname

/usr/bin/time /usr/sbin/ufsdump $dumpopt $tocname /dev/rmt/0hn /export/t3/vcommon >>& $logname
date >> $logname

@ index += 1


#
#  check for aborted messages in log file
#  grepfile will have size if aborted is present
#
rm -f $workdir/tmpmsge
/usr/bin/rm -f $grepname
/usr/bin/grep aborted $logname > $grepname
set errsize = `/usr/bin/wc -w $grepname`

# 
# if grep file is blank then mail the OK message
# otherwise mail the Bad News message
#
if ( $errsize[1] < 2 ) then
  /usr/bin/cat $workdir/okmsge $logname > $workdir/tmpmsge
  /usr/bin/mail greg.brissey@varianinc.com < $workdir/tmpmsge
  /usr/bin/mail $mail_list < $workdir/tmpmsge
  echo no error
else
  /usr/bin/cat $workdir/failmsge $logname > $workdir/tmpmsge
  /usr/bin/mail $mail_list < $workdir/tmpmsge
  echo error
endif

#
# Determine which day it is, 
#
# for Thursday rewind tape and unmount it
#	       reset index and dump level back to 0
#	       increment the week number 1 thru 6, then back to 1
#	     write this out to the dumpinfo file
#
# other Days,
#           present index, dump level of 5, and the present week
#	    are written to the dumpinfo file
#
switch($theday)
  case Thursday:
	echo /usr/bin/mt -f /dev/rmt/0 rewoffl >> $logname
	/usr/bin/mt -f /dev/rmt/0 rewoffl
	date >> $logname
	echo "cd $workdir" >> $logname
	cd $workdir 
	echo "mv logs  and tocs" >> $logname
	mv *.log toc_* week$weeknum
	echo 0 > $filename
	echo 0 >> $filename
        if ($weeknum >= 6) then
          @ weeknum = 1
        else
	  @ weeknum += 1
	endif
	echo $weeknum >> $filename
	breaksw

  default:
	echo $index > $filename
	echo 5 >> $filename
        echo $weeknum >> $filename
	breaksw
endsw

