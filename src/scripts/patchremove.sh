: '@(#)patchremove.sh 22.1 03/24/08 1991-1994 '
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
#!/usr/bin/sh

vnmrsystem=/vnmr

#-----------------------------------------------------------
# remove_jumbo_patch <patchname> <patch_adm_dir>
#-----------------------------------------------------------
remove_jumbo_patch () {

   jumbo_saved_dir=$2/$1

   if [ -d "$jumbo_saved_dir" ]
   then
       removed_patches=`ls "$jumbo_saved_dir"`
   else
       echo "\n$0:  $1 is not a valid patch number to remove\n"
       return 1
   fi

   echo "\nRemoving patch $1 -----"

   for Patch in $removed_patches
   do
      patch_category=`echo "$Patch" | cut -c5-7`
      remove_small_patch $Patch "$jumbo_saved_dir"
   done

   cd "$vnmrsystem"
   rm -r "$jumbo_saved_dir"

   echo "patch $1 removed -----"
   return 0
}


#-----------------------------------------------------------
# remove_small_patch <patchname> <patch_adm_dir>
#-----------------------------------------------------------
remove_small_patch () {

   saved_dir=$2/$1

   if [ -d "$saved_dir" ]
   then
       echo "---Removing patch $1"
       chmod 777 "$saved_dir"/p_remove
       "$saved_dir"/p_remove "$saved_dir"
   else
       echo "\n$0:  $1 is not a valid patch number to remove\n"
       return 1
   fi
   case "$patch_category" in

           "acq" )  reboot=1
                    ;;
           "psg" )  fix_psg=1
                    ;;
           "all" )  #Do not know whats to do yet
                    ;;
               * )  #Do nothing I guess
                    ;;
   esac

   return 0
}


#-----------------------------------------------------------
#
#                Main
#-----------------------------------------------------------

if [ $# -ne 1 ]
then
    echo "\nUsage:   $0 \"patched filename\" "
    echo "Ex.:  $0 5.3BacqSOLino101\n"
    exit 1
fi

# Verify that the current user is vnmr1
# Remove the below #s when ready
os_name=`uname -s`
if [ $os_name = "SunOS" ]
then
    case `uname -r` in
	4*) user=`whoami`
	    ;;
	5*) user=`id | sed -e 's/[^(]*[(]\([^)]*\)[)].*/\1/'`
	    ;;
    esac
else
    user=`whoami`
fi

vnmradmuser=`ls -l /vnmr/bin/Vnmrbg | awk '{ print $3 }'`
if [ "$user" != "$vnmradmuser" ]
then
   echo "\nPlease login as $vnmradmuser, then rerun $0\n"
   exit 1
fi


patch_adm_dir="$vnmrsystem"/adm/patch
patch_category=`echo "$1" | cut -c5-7`

if [ "$patch_category" = "gen" ]
then
    remove_jumbo_patch $1 "$patch_adm_dir"
    if [ $? -ne 0 ]
    then
        exit 1
    fi
else
    remove_small_patch $1 "$patch_adm_dir"
    if [ $? -ne 0 ]
    then
        exit 1
    fi
fi

if [ $fix_psg ]
then
    "$vnmrsystem"/bin/fixpsg
fi

#msg_id=`basename $1 | sed  's/.tar.Z//'`

if [ $reboot ]
then
    echo "\nPlease, login as root and run $vnmrsystem/bin/setacq before rebooting the console"
    echo "\nYou must reboot the VNMR console"
    echo "for the changes to take effect\n"
fi

#echo "\n----- patch  $msg_id  removed -----\n"
