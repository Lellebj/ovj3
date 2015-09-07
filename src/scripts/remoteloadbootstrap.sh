: /bin/sh
# '@(#)remoteloadbootstrap.sh 22.1 03/24/08 1991-1996 '
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
# the remote incantation to load the loadvnmr,etc scripts over the network.
#
echo
echo "This script does a remote read of the Vnmr load scripts"
echo
echo -n "Enter hostname of remote tape drive: "
read REMOTE_HOST
echo ""
echo -n "Login name for $REMOTE_HOST [vnmr1]: "
read REMOTE_LOG
if [ x$REMOTE_LOG = "x" ]
then
   REMOTE_LOG=vnmr1
fi
REMOTE=1
PARAMS="$PARAMS -r$REMOTE_HOST"
echo ""
echo -n "Checking access to host: "
rsh -l $REMOTE_LOG -n  $REMOTE_HOST "echo 0 > /dev/null"
if [ "$?" -ne 0 ]
then
  echo "$0 : Problem with reaching remote host $REMOTE_HOST"
  exit 1
fi
echo "OK."

echo ""
echo "Reading files from remote tape."
echo ""
rsh -l $REMOTE_LOG -n $REMOTE_HOST dd if=/dev/rst8 bs=20b | tar xBvfb - 20

echo ""
echo "Complete"
echo ""
echo "Run loadvnmr to install Vnmr."
echo ""

#Output should resemble the following:
# x loadvnmr, 6041 bytes, 12 tape blocks
# x installdecomp, 3246 bytes, 7 tape blocks
# x finish_load, 5356 bytes, 11 tape blocks
# x makevnmr1, 2491 bytes, 5 tape blocks
# x makevnmr2, 2468 bytes, 5 tape blocks
# 3+0 records in
# 3+0 records out
