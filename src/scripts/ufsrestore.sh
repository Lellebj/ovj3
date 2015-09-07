#!/bin/csh -f
# '@(#)ufsrestore.sh 22.1 03/24/08 1999-2001 '
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
#  cron script for restore files from a ufs dump 
#  This script is used in conjuction with the cron_ufsdump that dumps files
#  from the server to the DLT tape 
#  running on Enterprise  using Solaris 2.6
#
#

# Each day of dumps was 4 dump files on the DLT tape
# this has change to 5 dump files per day.
# variable reflects the number of dumps per day which is determined
# by the cron_ufsdump script
#
@ dumps_per_day = 5

#
# directory location of the ufsdump logs and the dumpinfo files
# which controls the action of the dump
#

set workdir="/export/t5/SysDumpLogs"
set filename="/export/t5/SysDumpLogs/dumpinfo"

#
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
#
@ dumplevel = $tapeloc[2]

#
# the week number which corresponds to the tape being used.
#
set weeknum = $tapeloc[3]


#
#
#  1st set of files is the epic series of dumps
#
# calc number of incrementals present on tape so far
#
@ nepic = 1 
# @ nincr = $index - 4
# @ nincr = $nincr / 4
@ nincr = $index - $dumps_per_day
@ nincr = $nincr / $dumps_per_day

echo "restore from DLL tape, enterprise. "
echo "Active Tape is for Week $weeknum "
echo "This tape has $nepic Epic and $nincr Incremental Dumps"
echo " "
echo " Each Epic and/or Incremental Consist of these file system dumps."
echo " 1st /usr26 "
echo " 2nd /usr25 "
echo " 3rd /vsccs "
echo " 4th /vsccs.mercuryVx "
echo " 5th /vcommon"
echo " "
echo "Please Select which Dump, 0 - Epic,  1 - 1st incremental, 2 - 2nd incremental, etc... "
@ whichdump = $<
echo "Selected Dump $whichdump"
if ($whichdump > $nincr) then
   echo "Selected Dump is beyond what's on the tape, maximum is $nincr"
   exit 0
endif
echo " "
echo "Please Select which Filesystem: "
echo "    1 - /usr26"
echo "    2 - /usr25"
echo "    3 - /vsccs"
echo "    4 - /vsccs.mercuryVx"
echo "    5 - /vcommon"
echo ": "
@ whichfilesys = $<
echo "Selected Filesystem $whichfilesys"
if ($whichfilesys > 4) then
   echo "Selection must be 1, 2, 3, 4, or 5"
   exit 0
endif

#  @ skipnum = ( $whichdump * 4 ) + $whichfilesys - 1
@ skipnum = ( $whichdump * $dumps_per_day ) + $whichfilesys - 1

echo " "
echo "You have specified to restore from the $whichfilesys Filesystem"
echo " from the $nincr Dump"
echo " "
echo "The tape will now be rewound, and positioned for the proper filesystem"
echo "and Dump increment."
echo " The ufsretore program will be run on this dump in Interactive Mode. "
echo " add files or directories to be restored, the command extract will start the"
echo " recovery from the tape, this can take some time. When done use the quit command"
echo " "
echo "Note: if requested to 'Specify next volume #:' use '1' as the answer."
echo " "
echo "Press Carriage Return to proceed, else a control C"
echo " "
set ans = $<

echo " "
echo "Rewinding Tape, Standby..."
echo "mt rewind /dev/rmt/0"
/usr/bin/mt rewind /dev/rmt/0

echo " "
echo "Moving Tape to Proper Position, Standby..."
echo "mt fsf $skipnum /dev/rmt/0hn"
/usr/bin/mt fsf $skipnum /dev/rmt/0hn

echo " "
echo "Starting interactive ufsrestore.."

/usr/sbin/ufsrestore -if /dev/rmt/0hn


echo "ufsrestore Completed.."
echo " "
echo "Repositioning tape for next evening dump."
echo " "
echo "Rewinding Tape, Standby..." 
echo "mt rewind /dev/rmt/0"
/usr/bin/mt rewind /dev/rmt/0
echo " "
echo "Moving Tape to Proper Dump Position, Standby..."
echo "mt fsf $index /dev/rmt/0hn"
/usr/bin/mt fsf $index /dev/rmt/0hn
echo " "
echo "Finished...."



exit 0
