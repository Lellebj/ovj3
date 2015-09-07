: '@(#)solpatchupdate.sh 22.1 03/24/08 1991-2001 '
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
:
# solpatchupdate - Auto updating patches for Solaris 2.6 and 7 and 8

# Operating System
# Note that Solaris (on sun hardware) calls itself SunOS
# use OS revision to distinguish between the two
# This sould be Solaris ONLY

OS_NAME=`uname -s`
if [ ! $OS_NAME = "SunOS" ]
then
   echo "$0 suitable for Sun-based systems only"
   echo "$0 exits"
   exit 1
fi

case `uname -r` in
           5.7 ) patchOS="Solaris27" ;;
           5.8 ) patchOS="Solaris28" ;;
	   5.9 ) patchOS="Solaris29" ;;
             * ) ;;
esac

#src_code_dir="/rdvnmr/.cdromVJ03.15/code"
#src_dir=`dirname $src_code_dir`

src_dir=$1

patch_src_dir=${src_dir}/patch          #ex: /rdvnmr/.cdrom12.06/patch
os_patch_dir=${patch_src_dir}/${patchOS}
system_patch_logdir="/var/sadm/patch"
vnmr_adm_base_dir="/var/tmp"

patch_order_list=`cat ${os_patch_dir}/patch_order`
# cut avoids the too many fields error for pathes with extensive Obsoletes: lists and Incompatibles: list
# that awk has.  gmb 4/22/02
patch_exist_list=`/usr/bin/showrev -p | /usr/bin/cut -d' ' -f2 | sort`
#patch_exist_list=`/usr/bin/showrev -p | awk '{print $2}' | sort`
# patch_exist_name_list=`/usr/bin/showrev -p | awk '{print $2}' | sort | sed -e 's/-/ /' | awk '{print $1}'`
# patch_exist_rev_list=`/usr/bin/showrev -p | awk '{print $2}' | sort | sed -e 's/-/ /' | awk '{print $2}'`

LOGFILE=${vnmr_adm_base_dir}/vnmr_solPatch_log
ERR_LOG_FILE=${vnmr_adm_base_dir}/vnmr_solPatch_errlog
failed_list=
_date=`date`

if [ ! -f $LOGFILE ]
then
   touch $LOGFILE
fi

echo "($_date)\n" >> $LOGFILE

for _patch in $patch_order_list
do
   p_exist="NO"
   for e_patch in $patch_exist_list
   do
       if [ x$_patch = x$e_patch ]
       then 
           p_exist="YES"
           break
       fi
   done

   if [ x$p_exist = x"NO" ]
   then
       echo "\n   Installing  patch $_patch  Patch_src_dir:${os_patch_dir}" >> $LOGFILE
       #(cd ${os_patch_dir}; ./installpatch .)
       #(cd ${os_patch_dir} ./install_cluster )
        
       cd ${os_patch_dir}
       echo "  Installing patch ${_patch} ." | tee -a $LOGFILE
       /usr/sbin/patchadd ${_patch} >> $LOGFILE   2>$ERR_LOG_FILE

       rtcode=$?
       if [ ${rtcode} -eq 0 ]
       then
         echo "  ----------- DONE." | tee -a $LOGFILE
       else
        if [ ${rtcode} -eq 2 ]
        then
          echo "  ----------- Patch has already been applied." | tee -a $LOGFILE
        else
         if [ ${rtcode} -eq 5 ]
         then
           echo "  ----------- Later version of patch is already installed." | tee -a $LOGFILE
         else
          if [ ${rtcode} -eq 6 ]
          then
            echo "  ----------- Patch is obsoleted." | tee -a $LOGFILE
          else
           if [ ${rtcode} -eq 8 ]
           then
             echo "  ----------- Patch is for an uninstalled package." | tee -a $LOGFILE
           else
            if [ ${rtcode} -eq 24 ]
            then
              echo "  ----------- An incompatible patch has been applied." | tee -a $LOGFILE
            else
             if [ ${rtcode} -eq 25 ]
             then
               echo "  ----------- A required patch has not been applied." | tee -a $LOGFILE
             else
               echo "  ----------- Returned code ${rtcode} ." | tee -a $LOGFILE
               failed_list="${failed_list} ${_patch}"
             fi
            fi
           fi
          fi
         fi
        fi
       fi
   else
       echo "Patch $_patch already exists." | tee -a $LOGFILE 
   fi
done

echo "Solaris patches updated." | tee -a $LOGFILE 
echo "\n#---------------------------------------------------\n" >> $LOGFILE 
