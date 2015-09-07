#!/bin/csh -f
#
# '@(#)Make_WORM_FS_Vnmr.sh 22.1 03/24/08 1991-1996 '
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
#
#" create Vnmr release partion in a partition (/scratch) to be placed on worm drive "
#
# e.g. newfs -f 2048 /dev/rrf0h
#      tunefs -a 40 -d 0 /dev/rrf0h	( use only for rimfire SMDs )
#
date
echo -n "Enter partition for worm backup (note: must have fragment size of 2048):"
set part = $<
#set verbose
cd		# make sure we are not in the partition
set partinfo = `df | fgrep $part`
echo " "
echo "Partition: $partinfo"
# "e.g.  partinfo = /dev/rf0h 164726 136592 11660 92% /mnt"

set bdev = `echo $partinfo[1]:t`
set rdev = "/dev/r$bdev"

echo " "
echo " "
echo "If the partition being used ($partinfo[2]K) is much larger than "
echo "the data (~138000K), then to avoid wasted space on the WORM disk,"
echo "one can Use newfs (erases data) with"
echo "the -s option specifing sector size close to data size"
echo "this prevents wasting space, and does not really effect the real"
echo "partition size. "
echo "One might run this script once to determine size actually needed, then"
echo "again after manually running newfs -s sector_size -f 2048. "
echo "To restore partition to its full size just run newfs again."
echo "This will erase all data of course."
echo " "
echo " "
echo "Suggest to Wipe Clean partition by umount and create a new file system."
echo "Will, "
echo " umount $part"
echo " newfs -f 2048 $rdev"
# echo " tunefs -a 40 -d 0 $rdev"
echo " mount $partinfo[1] $part"
echo " "
echo "WARNING: this removes all data from entire partition \!\!\!"
echo " "
echo "This may take several minutes depending on size of partition."
echo " "
date
echo " "
echo "If you do NOT want this to be done, just Press Return at password request."
echo -n "Enter Root Password: "
# 2048 $rdev; tunefs -a 40 -d 0 $rdev; mount  ( excerpt from line below )
su -c "umount $part; newfs -f 2048 $rdev; mount $partinfo[1] $part; chmod 777 $part" >& ./nfslog
if ($status != 0) then
  echo " "
  echo "An incorrect password, no password was entered."
  echo " "
  echo "------------------------------------------------------------"
  echo "Output Log: "
  echo " "
  echo "------------------------------------------------------------"
else
  echo " "
  echo " "
  echo "------------------------------------------------------------"
  echo "Output Log: "
  cat ./nfslog
  echo " "
  echo "------------------------------------------------------------"
  echo " "
  echo "If $part was busy or can't mkfs then find who is in $part."
  echo "Remove them and try again..., Abort script by Control C."
  echo "To continue press return."
  set ans = $<
endif
rm -f ./nfslog
echo " "
echo " "

cd $part
set partinfo = `df | fgrep $part`
echo "Partition: $partinfo"
# "e.g.  partinfo = /dev/rf0h 164726 136592 11660 92% /mnt"
if ($partinfo[2] < 138000) then		# size of partition
  echo "$part is too small."
  exit
endif
if ($partinfo[4] < 138000) then		# free space
  echo "$part needs to be cleaned out, has $partinfo[4] free needs > 138000 KB."
  exit
endif


echo "Will be taring sccs sun3obj sun4obj common and releases to partition: $part"
echo -n "Hit Return to Continue, Control C to abort"
set ans = $<

echo "Taring sccs 		`date`"
echo "cd /sccs; tar -cf - sccs | (cd $part; tar -xfBp - )"
cd /sccs;  tar -cf - sccs | (cd $part; tar -xfBp - );
cd ${part}/sccs
rm -rf lost+found
echo " "

echo "Taring sun4obj 		`date`"
echo "cd /sun4obj; cd ..; tar -cf - sun4obj | (cd $part; tar -xfBp - )"
cd /sun4obj; cd ..;  tar -cf - sun4obj | (cd $part; tar -xfBp - );
echo " "
date

echo "Remove dbx, profiling, SourceBrowser, and link files in ${part}/sun4obj/proglib"
cd ${part}/sun4obj
rm -rf lost+found
echo "Symbolic links: 			`date`"
find proglib -type l -print -exec rm {} \;
echo " "
echo " "
echo "DBX files: 			`date`"
find proglib -name "*dbx*" -print -exec rm {} \;
echo " "
echo " "
echo "Profiling files:			`date`"
find proglib -name "*prof*" -print -exec rm {} \;
find proglib -name "*_p.*" -print -exec rm {} \;
find proglib -name "*_p" -print -exec rm {} \;
echo " "
echo " "
echo "Remove Image/proglib & Image/seqlib, seqlib ${part}/sun4obj/"
date
rm -rf Image/proglib Image/seqlib
rm -rf seqlib
echo " "
echo " "
echo "Source Browser files: 		`date`"
find . -name ".sb" -prune -exec du -s {} \; -exec rm -rf {} \;
echo " "
echo " "
echo " "

echo "Taring sun3obj		`date`"
echo "cd /sun3obj; cd ..; tar -cf - sun3obj | (cd $part; tar -xfBp - )"
cd /sun3obj; cd ..; tar -cf - sun3obj | (cd $part; tar -xfBp - );
echo " "

echo "Remove dbx, profiling, SourceBrowser, and link files in ${part}/sun3obj/proglib"
cd ${part}/sun3obj
rm -rf lost+found
echo "Symbolic links: 			`date`"
find proglib -type l -print -exec rm {} \;
echo " "
echo " "
echo "DBX files:			`date`"
find proglib -name "*dbx*" -print -exec rm {} \;
echo " "
echo " "
echo "Profiling files: 			`date`"
find proglib -name "*prof*" -print -exec rm {} \;
find proglib -name "*_p.*" -print -exec rm {} \;
find proglib -name "*_p" -print -exec rm {} \;
echo " "
echo " "
echo "Remove Image/proglib & Image/seqlib, seqlib ${part}/sun3obj/"
date
rm -rf Image/proglib Image/seqlib
rm -rf seqlib
echo " "
echo " "
echo "Source Browser files: 		`date`"
find . -name ".sb" -prune -exec du -s {} \; -exec rm -rf {} \;
echo " "
echo " "
echo " "

echo "Taring common			`date`"
echo "cd /common; cd ..; tar -cf - common | (cd $part; tar -xfBp - )"
cd /common; cd ..; tar -cf - common | (cd $part; tar -xfBp - );
cd ${part}/common
rm -rf lost+found
echo " "
echo " "
echo " "
echo "Taring releases 		`date`"
echo "cd /sccs; tar -cf - releases | (cd $part; tar -xfBp - )"
cd /sccs;  tar -cf - releases | (cd $part; tar -xfBp - );
cd ${part}/releases
rm -rf lost+found
echo " "
echo " "
echo " "
echo "Directory Listing of $part.		`date`"
ls -lgF $part 
echo " "
echo " "
cd $part
set size = `du -s common`
echo -n "Common: $size[1],  "
set size = `du -s sccs`
echo -n "Sccs: $size[1], "
set size = `du -s sun4obj`
echo -n "Sun4obj: $size[1], "
set size = `du -s sun3obj`
echo "Sun3obj: $size[1],"
set size = `du -s releases`
echo -n "Releases: $size[1]. "
echo " "
echo " "
date
