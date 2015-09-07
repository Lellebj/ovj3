: '@(#)solsetup.sh 22.1 03/24/08 1999-2002 '
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
# @(#) solsetup.sh22.103/24/08
#-------------------------------------------------
#  MAIN Main main
#-------------------------------------------------
# get base_dir first so we have it at all times
#
firstchar=`echo $0 | cut -c1-1`
if [ x$firstchar = "x/" ]  #absolute path
then
   base_dir=`dirname $0`
else
   if [ x$firstchar = "x." ]  #relative path
   then
       if [ x`dirname $0` = "x." ]
       then
           base_dir=`pwd`
       else
           base_dir=`pwd`/`dirname $0 | sed 's/.\///'`
       fi
   else
      base_dir=`pwd`/`dirname $0`
   fi
fi

#
# Login the user as a root user
# Use the "su" command to ask for password and run the installer
#

notroot=0
userId=`/bin/id | awk 'BEGIN { FS = " " } { print $1 }'`
if [ $userId != "uid=0(root)" ]; then
  notroot=1
  echo
  echo "To install Solaris patches you will need to be the system's root user."
  echo "Or type cntrl-C to exit.\n"
  echo
  s=1
  t=3
  while [ $s = 1 -a ! $t = 0 ]; do
     echo "Please enter this system's root user password \n"
     su root -c "$base_dir/load.patches $*";
     s=$?
     t=`expr $t - 1`
     echo " "
  done
  if [ $t = 0 ]; then
      echo "Access denied. Type cntrl-C to exit this window."
      echo "Type $0 to start the installation program again \n"
  fi
  exit
fi

#
# User is now root.
#

patch_dir=${base_dir}/patch 

#
# solpatchupdate 
#
auto_reboot="n"
now_reboot="n"

echo " "
echo " "
echo "VNMRJ requires installation of Solaris patches."
echo "Solaris patch installation should NOT be interrupted."
echo "Start checking and updating Solaris patches? [y] \c"
read yy
firstyychar=`echo $yy | cut -c1-1`
if [ x$firstyychar = "xn" ]
then
    echo "\nWARNING: Skipping Solaris patch installation."
else
    echo " "
    echo " "
    echo "After loading these Solaris patches you should reboot the computer"
    echo "Do you want to reboot automatically? [y] \c"
    read auto_reboot
    ${patch_dir}/solpatchupdate $base_dir

    if [ x$auto_reboot = "xy" -o x$auto_reboot = "x" ]
    then 
        reboot
    else
        echo " "
        echo " "
        echo "After loading the Solaris patches you should reboot the computer"
        echo "Do you want to reboot now? [y] \c"
        read now_reboot
        if [ x$now_reboot = "xy" -o x$now_reboot = "x" ]
        then
            reboot
        else
            echo \n\n
            echo "Your computer was not rebooted. You should reboot the"
            echo "computer now or soon after loading the Solaris patches"
        fi
    fi
fi

echo " "
echo " "
echo " Done"
echo " "
echo " Type cntl-C to close this window"
echo " Then type "eject cdrom" in another window"
echo " "
