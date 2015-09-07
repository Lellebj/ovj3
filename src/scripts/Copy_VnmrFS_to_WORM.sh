: '@(#)Copy_VnmrFS_to_WORM.sh 22.1 03/24/08 1991-1996 '
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
#" create a mountable partition on Delta Micros WORM drive "
#
# e.g. newfs -f 2048 /dev/rrf0h
#      tunefs -a 40 -d 0 /dev/rrf0h
#
#set verbose

set user = `whoami`

echo " "
echo " "
echo -n "Enter partition to be copied to WORM Drive: "
set part = $<
cd		# make sure we are not in the partition


# "e.g.  partinfo = /dev/rf0h 164726 136592 11660 92% /mnt"
set partinfo = `df | fgrep $part`
if ($#partinfo == 0) then
  echo " Partition $part is not mounted."
  echo " Aborting."
  exit
endif
echo " "
echo " "
echo "Partition: $partinfo"
@ partsize = $partinfo[3]
@ partsize = $partsize / 1000		# disk partition usage in MB
set bdev = `echo $partinfo[1]:t`	# rf0h
set rdev = "/dev/r$bdev"		# /dev/rrf0h

echo " "
echo "Need to unmount the partition $part, "
echo " and give read permission to the raw device $rdev ."
echo "Will, "
echo " umount $part"
echo " chmod o+r $rdev"
echo " "
echo -n "Enter Root Password: "
su -c "umount $part; chmod o+r $rdev" >& ./nfslog
if ($status != 0) then
  echo " "
  echo "An incorrect password, no password was entered."
  echo " "
else
  echo " "
  echo " "
  echo "------------------------------------------------------------"
  echo "Output Log: "
  cat ./nfslog
  echo " "
  echo "------------------------------------------------------------"
  echo " "
  echo "If $part was busy (see Log above) then find who is in $part."
  echo "Remove them and try again..., Abort script by Control C."
  echo "To continue press return."
  set ans = $<
endif
rm -f ./nfslog
echo " "

echo "odt load		# spin disk upto speed if not already."
echo " "
odt load
echo " "
echo "Check for odt directory on WORM Disc."
odt ckdisk
set ok = `odt ckdisk`
# set isok = "Optical diskette contains an 'odt' directory."
if ($#ok != 6) then
  echo " "
  echo "WORM Disc does not contain an odt directory."
  echo "Create one by odt mkdir?, Press Return to Make one, control C to abort."
  set tmp = $<
  odt mkdir
endif


echo " "
echo "WORM Partition Allocation List: "
odt tell
echo " "
echo " "
echo -n "Select a partition that is free (a,b,c,d,f,g): "
set wpart = $<
echo "WORM Partition will be /dev/rsod0$wpart"
setenv OPT_DISK_RDEV /dev/rsod0$wpart
echo " "
echo "odt all		# allocate the selected partition (/dev/rsod0a) to $user."
odt all
echo " "
set result = `odt tell | fgrep "$OPT_DISK_RDEV" | fgrep "$user" `
if ($#result == 0) then
  echo "Failed to allocate $OPT_DISK_RDEV to $user"
  echo "Correct and run $0 again."
  echo "Aborting $0"
  exit
endif
echo " "

echo "Please Standby, Checking Free Space on WORM Disc."
set tmpstr = `odt du`
set tmpsiz = ${#tmpstr}
@ i = 1
while ( $i < $tmpsiz )
  if ( "$tmpstr[$i]" == "available:" ) then
   @ i += 1
   @ wormfreespace = $tmpstr[$i]
  endif
  @ i += 1
end
@ wormfreespace = $wormfreespace / 512 + 1
if ($wormfreespace <= $partsize) then
  echo " "
  echo "Not Enough Space on WORM disc, $wormfreespace MB Free" 
  echo "Partition $part uses $partsize MB"
  echo "Flip WORM Disc Over or get a New Disc."
  echo " "
  exit
else
  echo "WORM disc has $wormfreespace MB Free." 
endif

echo " "
echo "Present List of Contents or WORM Disc: "
echo " "
echo "-------------------------------------------------------------------------"
echo " "
odt ls -l
echo " "
echo "-------------------------------------------------------------------------"
echo " "
echo -n "Give the file name to use. (e.g. Vnmr4.1A_fs): "
set filename = $<
echo " "
echo "Give descriptive text to be include in Directory listing, "
echo " (E.G. BSD Filesystem of sccs common sun3obj sun4obj for Vnmr), "
echo -n ": "
set dtext = $<

echo " "
echo " "
echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
echo " "
echo "We are now going to create the directory entry for file: ${filename}"
echo "With a Description of: $dtext"
echo " "
echo "Copy the hard disk partition: $part via its raw device: $rdev ,"
echo "to the WORM disc via its raw device $OPT_DISK_RDEV."
echo " "
echo "The following commands will be executed: "
echo " "
echo "odt newf $filename -l $dtext"
echo "dd if=$rdev of=$OPT_DISK_RDEV ibs=4b obs=124b conv=sync"
echo " "
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
echo " "
echo "If this is NOT Correct Abort by Control C NOW \!\!\!"
echo  -n "Otherwise just press return."
set tmp = $<
echo " "
echo " "
echo "You have elected to WRITE to the WORM."
@ time = $partsize / 108 + 1		# MB / 30KB/sec * 3600sec = hr
echo "Writing $partsize MB will take approx. $time hour(s)."
echo " "
echo "One more chance to ABORT.."
echo  -n "Otherwise just press return."
set tmp = $<
echo " "
echo " "
echo "Writing to WORM, Please standby: "
echo " "

#---- so far so good now here is where we start to write to the WORM drive
date
echo "odt newf $filename -l $dtext"
odt newf "$filename" -l "$dtext"

echo " "
date
echo "dd if=$rdev of=$OPT_DISK_RDEV ibs=4b obs=124b conv=sync"
dd if=$rdev of=$OPT_DISK_RDEV ibs=4b obs=124b conv=sync
echo " "
date

echo "Completed."
echo " "
echo "odt pos $filename"
odt pos "$filename"
echo " "
echo " "
echo "To mount the WORM $OPT_DISK_RDEV $filename file system."
echo "Issue the follow commands: "
echo "odt pos $filename"
echo "mount -r $OPT_DISK_RDEV /mnt	# (must be root for this one.)"
echo "any other appropriate mount point can also be used."
echo " "
echo " "
echo "Need to remount the partition $part, "
echo " and take read permission away the raw device $rdev ."
echo "Will, "
echo " mount $part"
echo " chmod o-r $rdev"
echo " "
echo -n "Enter Root Password: "
su -c "mount $part; chmod o-r $rdev" >& ./nfslog
echo " "
