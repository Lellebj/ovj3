: '@(#)i_vnmr.3j.sh 22.1 03/24/08 1991-1994 '
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
#i_vnmr.3j.sh

#-----------------------------------------------
nnl_echo() {
    if test x$sysV = "x"
    then
        echo "error in echo-no-new-line: sysV not defined"
        exit 1
    fi

    if test $sysV = "y"
    then
        if test $# -lt 1
        then
            echo
        else
            echo "$*\c"
        fi
    else
        if test $# -lt 1
        then
            echo
        else
            echo -n $*
        fi
    fi
}

#-----------------------------------------------
update_user_group() {

   test_file="/tmp/testfile_willberemoved"
   touch $test_file
   chgrp $nmr_group $test_file 2>/dev/null
   if [ $? -ne 0 ]
   then
       add_to_group
   fi

   #Only copy the passwd file if there is no nmr_adm account

   chown $nmr_adm $test_file 2>/dev/null
   if [ $? -ne 0 ]
   then
       add_to_passwd
   fi
   rm -f $test_file

   #special stuff for Solaris

   if [ x$ostype = "xSOLARIS" ]
   then
       if touch /etc/shadow
       then
           if grep -s $nmr_adm /etc/shadow >/dev/null
           then
               :
           else
               echo "$nmr_adm:::0:::::" >>/etc/shadow
           fi
       else
           echo "Cannot add $name to the shadow file"
       fi
   fi
}

#-----------------------------------------------
add_to_passwd() {

# make backup copy of password file
# scan password file for largest user-id
# add one to that user-id to obtain id for vnmr1
# insert before last line in password file
# keep user-id number within bounds of positive 16-bit numbers,
#  that is, less than 32768

   echo "add_to_passwd() ---"

   awk '
      BEGIN { N=0
              AlreadyExists=0
              NewUser="'$nmr_adm'"
              FS=":"
      }

      {
        if ($3>N && $3<32768) N=$3
        if ($1==NewUser) AlreadyExists=1
      }

      END { if (AlreadyExists==0)
            printf "%s::%d:'$nmr_group_no':%s:'$nmr_home'/%s:/bin/csh\n",NewUser,N+1,NewUser,NewUser
      }
   ' < /etc/passwd >/tmp/newuser

   #Insert new entry before the last line in the password file

   if [ -s /tmp/newuser ]
   then
      echo "add_to_passwd():add new entry ----"
      cp /etc/passwd /etc/passwd.bk
      read stuff </tmp/newuser
      (sed '$i\
'"$stuff"'' /etc/passwd >/tmp/newpasswd)
      mv /tmp/newpasswd /etc/passwd
      rm /tmp/newuser
   fi
}

#-----------------------------------------------
add_to_group() {

   echo "add_to_group()"

   cp /etc/group /etc/group.bk
   if [ x$ostype = "xAIX" ]
   then
      (sed '$i\
'"$nmr_group"':!:'"$nmr_group_no"':'"$nmr_adm"'' /etc/group >/tmp/newgroup)
   else
      (sed '$i\
'"$nmr_group"':*:'"$nmr_group_no"':'"$nmr_adm"'' /etc/group >/tmp/newgroup)
   fi

   mv /tmp/newgroup /etc/group
}

#-----------------------------------------------
change_procpar() {
  for proc in $nproc
  do
    cp $proc /tmp/proc_tmp
    cat /tmp/proc_tmp | sed 's/4 "a" "n" "s" "y"/2 "n" "y"/' | \
    sed 's/9 "c" "f" "g" "m" "p" "r" "u" "w" "x"/5 "c" "f" "n" "p" "w"/' > $proc
  done
  rm /tmp/proc_tmp 
}
 
#ch_mod() {
#    if [ x$ostype = "xIRIX" -o x$ostype = "xIRIX64" ]
#    then
#	find $* -exec chmod 644 {} \;
#    else
#	chmod -R 644 $*
#    fi
#    chmod 755 $*
#}

#ch_xmod() {
#    if [ x$ostype = "xIRIX" -o x$ostype = "xIRIX64" ]
#    then
#	find $* -exec chmod 755 {} \;
#    else
#	chmod -R 755 $*
#    fi
#}

#-----------------------------------------------
echo_send() {

   $src_code_dir/send.$os_version $pipe_id "$1" $2
}

#-----------------------------------------------
domanuals()
{
   dir_now=`pwd`
   dir_from=$source_dir/$1
   if [ $2 -eq 1 ]
   then
      dir_from=`dirname $dir_from`/imaging
   fi
   if [ ! -d $dest_dir/acrobat ]
   then
      (su $nmr_adm -c "mkdir $dest_dir/acrobat")
   fi
   cd $dest_dir/acrobat
   if [ -d online ]
   then
      rm -rf online
   fi
   if [ x$man_link = "xyes" ]
   then
      if test ! "x$nmr_adm" = "x"
      then
         (su $nmr_adm -c "ln -s $src_code_dir/acrobat/online online")
      else
         ln -s $src_code_dir/acrobat/online online
      fi
   else
      if [ ! -d online ]
      then
         (su $nmr_adm -c "mkdir online")
      fi
      if test ! "x$nmr_adm" = "x"
      then
         (su $nmr_adm -c "cp -rp  $dir_from/*  online")
      else
         cp -rp $dir_from online
      fi
   fi
   if [ x$ostype = "xIRIX" -o x$ostype = "xIRIX64" ]
   then
      (cd $dest_dir/acrobat;		\
      chown -R $nmr_adm    online/;	\
      chgrp -R $nmr_group  online/)
   fi

   cd $dir_now
}

#-----------------------------------------------
doacrobat()
{
   PAGER=cat
   export PAGER
   if [ x$ostype = "xIRIX" -o x$ostype = "xIRIX64" ]
   then
      destdir=$dest_dir/acrobat/sgi
   else
      if [ x$ostype = "xAIX" ]
      then
         destdir=$dest_dir/acrobat/ibm
      else
         destdir=$dest_dir/acrobat/sol
      fi
   fi

   export destdir
   if [ -d $destdir ]
   then
$src_code_dir/acrobat/acrobat/install > /dev/null 2> /dev/null << +++
y
accept
$destdir
+++
   else
$src_code_dir/acrobat/acrobat/install > /dev/null 2> /dev/null << +++
y
accept
$destdir
y
+++
   fi
   (cd $destdir/..;					\
    chown -R $nmr_adm     `basename $destdir`;		\
    chgrp -R $nmr_group   `basename $destdir`)
}

#-----------------------------------------------
load_pw_option()
{
   i=0
   n_pass=`expr $# / 2`
   load_type=${cons_type}.opt

   #console=`basename $console $opt_dir`opt
   tmp_size=0
   while [ $i -lt $n_pass ]
   do
       cat $src_code_dir/$os_version/$load_type | (while read line
      do
         b=`echo $line | awk 'BEGIN { FS = " " } { print $1 }'`
         if [ x$b = x$1 ]
         then
            size=`echo $line | awk 'BEGIN { FS = " " } { print $2 }'`
            c=`echo $line | awk 'BEGIN { FS = " " } { print $3 }'`
            #echo  $c $tmp_size
            #tmp_size=$size
            if [ "x$nmr_adm" != "x" ] #have to recheck this part, nmr_adm always set
            then
               echo "\n  Extracting:  \"$1\"  $c"
               (cd $dest_dir; $src_code_dir/decode.$os_version $2 < $source_dir/$c > tmp.tar )
               (cd $dest_dir;su $nmr_adm -c "tar xpf tmp.tar" )

               if [ $? -eq 0 ]
               then
                  echo "  DONE: $size"
               else
                  echo "    PASSWORD for $1 incorrect. "
                  echo "      If you have the correct password"
                  echo "      you can load the option separately"
                  echo "      when this install is complete."
                  echo "      Run load.nmr again, and only select $1"
                  echo "  SKIPPED: $size"
               fi
               rm -f $dest_dir/tmp.tar

            else
               (cd $dest_dir;$src_code_dir/decode.$os_version $2 < $source_dir/$c > tmp.tar )
               (cd $dest_dir;tar xpf tmp.tar )
               if [ $? -eq 0 ]
               then
                  echo "  DONE: $size"
               else
                  echo "    Password for $1 incorrect "
                  echo "      If you have the correct password"
                  echo "      you can load the option separately"
                  echo "      when this install is complete."
                  echo "      Run load.nmr again, and only select $1"
                  echo "  SKIPPED: $size"
               fi
               rm -f $dest_dir/tmp.tar

            fi
         fi   
      done
      #echo " " $tmp_size
      )

      i=`expr $i + 1`
      shift; shift
   done
   echo " "

}

#-----------------------------------------------
#  Main MAIN main program starts here
#-----------------------------------------------
#os_version=$osexten  #osexten was exported by load.nmr
#acq_pid      =$1
#load_type    =$2

os_version=$1    #sol ibm sgi
shift            #because sh does not use $10 and up
cons_type=$1     #inova ... g2000
src_code_dir=$2  #/cdom/cdrom0/code
dest_dir=$3      #/export/home/vnmr
nmr_adm=$4       #vnmr1
nmr_group=$5     #nmr
vnmr_link=$6     #yes
man_link=$7      #no
gen_list=`echo $8 | sed 's/+/ /g'`  #agr8 or 9 is a list, items separated by a "*"
opt_list=`echo $9 | sed 's/+/ /g'`

nmr_home=`dirname $dest_dir`
nmr_group_no=30

echo "NMR Owner = $nmr_adm"
echo "NMR Group = $nmr_group"
echo "NMR Destination directory= $dest_dir"

source_dir=`dirname $src_code_dir`

acq_pid=-1
ostype="SOLARIS"   #for testing only, later exported from load.nmrj
 
if [ x$ostype = "xSOLARIS" ]
then
    chown_cmd="/usr/bin/chown -h "
    chgrp_cmd="/usr/bin/chgrp -h "
else
    chown_cmd="chown "
    chgrp_cmd="chgrp "
fi

if [ $acq_pid -ne -1 ]
then
   echo "Stopping acquisition."
   kill -2 $acq_pid
   sleep 5		# give time for kill message to show up.
fi

#and if we want to load vnmr we create entry in passwd/shadow

echo $* | grep -s VNMR > /dev/null
if [ $? -eq 0 ]
then
   #echo "Checking for $nmr_adm   in password file(s)"
   #echo "Checking for $nmr_group in group file"
   if [ x$ostype = "xIRIX" -o x$ostype = "xIRIX64" ]
   then
      $src_code_dir/i_vnmr.4j $nmr_adm $nmr_group /usr/people
   else
      if [ x$ostype = "xSOLARIS" ]
      then
          echo "Updating User group and password files"
          #$src_code_dir/i_vnmr.4j $nmr_adm $nmr_group /export/home
          nmr_home="/export/home"
          update_user_group
      else
          #$src_code_dir/i_vnmr.4 $nmr_adm $nmr_group /home
          nmr_home="/home"
          update_user_group /home
      fi
   fi
fi

if [ ! -d $dest_dir ]
then
    echo "Creating '$dest_dir' directory"
    mkdir $dest_dir
else
    echo "'$dest_dir' already exist"
fi

cd $dest_dir
chmod 755 .
${chown_cmd} $nmr_adm .
${chgrp_cmd} $nmr_group .

if [ ! -d tmp ]
then
   mkdir tmp
   ${chown_cmd} $nmr_adm tmp
   ${chgrp_cmd} $nmr_group tmp
fi

cp_files="n"
echo $* | grep -s VNMR > /dev/null
if [ $? -eq 0 ]
then
   if [ -d /vnmr ]
   then
      grep -s VERSION /vnmr/conpar | grep -s [5.2,5.3,6.1] > /dev/null
      if [ $? -eq 0 ]
      then
         cp /vnmr/conpar /tmp/conpar
         cp /vnmr/devicenames /tmp/devicenames
         rm -r /tmp/probes /tmp/shims
         cp -r /vnmr/probes /tmp/probes
         cp -r /vnmr/shims /tmp/shims
	 rm /tmp/probes/probe.tmplt
         cp_files='y'
      fi
   fi
fi


# if cp_files='y' then we are loading VNMR,
# so save gradtables and decclib directories

cp_gradtables='n'
cp_decclib='n'

if [ x$cp_files = "xy" ]
then
      if [ -d /vnmr/imaging/gradtables ]
      then
         (cd /vnmr; tar cf /tmp/gradtables.tar imaging/gradtables)
         cp_gradtables='y'
      fi
      if [ -d /vnmr/imaging/decclib ]
      then
         (cd /vnmr; tar cf /tmp/decclib.tar imaging/decclib)
         cp_decclib='y'
      fi
fi


##############################################
#########load the generic files 
echo "\n-------------------"
gen_testlist=`echo $gen_list | tr -d " "`

#if [ -z gen_testlist ]
if [ x$gen_testlist = "x" ]
then
   echo "Skipping NMR's GENERIC files\n"
else
   echo "Installing NMR's GENERIC files\n"
   temp_size=0
   tar_size=0
   did_vnmr="n"

   load_type=${cons_type}.sol
   for Item in $gen_list
   do
      cat $src_code_dir/$os_version/$load_type | \
      ( while read line
        do
           tar_cat=`echo $line | awk 'BEGIN { FS = " " } { print $1 }'`
  
           if [ x$tar_cat = x$Item ]
           then
     	      tar_size=`echo $line | awk 'BEGIN { FS = " " } { print $2 }'`
	      tar_name=`echo $line | awk 'BEGIN { FS = " " } { print $3 }'`
              temp_size=$tar_size

	      if [ `dirname $tar_name` = "code//acrobat/online/cdrom" ]
              then
                 echo $* | grep -s Imaging_or_Triax > /dev/null
                 if [ $? -eq 0 ]
	         then
	            domanuals $tar_name 1
                 else
	            domanuals $tar_name 0
	         fi
              else
                 if [ `dirname $tar_name` = "code/acrobat/acrobat" ]
                 then
                    tarfile=`basename $tar_name`
                    if [ $tarfile="ssolr.tar" -o $tarfile="irixr.tar" -o $tarfile="aixr.tar" ]
                    then
                       doacrobat
                    fi
                 else
                    if [ "x$nmr_adm" != "x" ]
                    then
                       echo "  Extracting  \"$Item\"  $source_dir/$tar_name"
                       (cd $dest_dir; su $nmr_adm -c "tar xpf $source_dir/$tar_name")
	               if [ $? -ne 0 ]
                       then
                          (cd $dest_dir; su $nmr_adm -c "tar xpf $source_dir/$tar_name")
	                  if [ $? -ne 0 ]
                          then
                              echo "Installation of $Item failed"
                          fi
                       fi
                       echo "  DONE:  $tar_size \n"
                    else
                       (cd $dest_dir; tar xpf $source_dir/$tar_name)
      	               if [ $? -ne 0 ]
                       then
                          (cd $dest_dir; tar xpf $source_dir/$tar_name)
	                  if [ $? -ne 0 ]
                          then
                              echo "Installation of $Item failed"
                          fi
                       fi
                    fi
                 fi
              fi
           fi
        done
      )

      if [ x$Item = "xVNMR" ]
      then
         did_vnmr="y"
      fi
   done
fi

##############################################
######### load the passworded options
echo "\n-------------------------" 
opt_testlist=`echo $opt_list | tr -d " "` 

#if [ -z opt_testlist ]
if [ x$opt_testlist = "x" ]
then
   echo "Skipping PASSWORDED OPTION files"
else
   echo "Installing PASSWORDED OPTION files"

   #if [ -z gen_testlist ] #should check for VNMR loaded instead
   if [ x$gen_testlist = "x" ] 
   then
      load_pw_option $opt_list
      #echo "\nPassworded Options Completed."
      exit
   else
      load_pw_option $opt_list
      #echo "\nPassworded options completed."
   fi
fi

echo "ALL REQUESTED SOFTWARE EXTRACTED"

#fix some things, depending on what system we are
if [ x$did_vnmr = "xy" ]
then

   #Check if jre exists and is newer than 1.1.6, if not, load it

   if [ -x /usr/bin/jre ]
   then
      version=`/usr/bin/jre -version 2>&1 | grep Version`
      minor=`echo $version | awk 'BEGIN { FS = "." } { print $2 }'`
      sub=`echo $version | awk 'BEGIN { FS = "." } { print $3 }'`
      if [ x$minor = "x" ]
      then
         minor=1
         sub=3
      fi 
      if [ $minor -lt 2 ]
      then 
         if [ $sub -lt 6 ]
         then
            load=1
         else
            load=0
         fi
      else
         load=0
      fi
   else
      version=""
      load=1
   fi

##########################
#commented out for testing   
#   if [ $load -ne 0 ]
#   then 
#      echo "Installing Java Runtime Environment (jre 1.1.6)" 0
#      echo " "
#      cd $dest_dir
#      if [ -d Solaris_JRE_1.1.6_03 ]
#      then
#         rm -rf Solaris_JRE_1.1.6_03
#      fi
#      if [ -d jre ]
#      then
#         rm -rf jre
#      fi
#      cp $src_code_dir/java/Solaris_JRE_1.1.6_03_sparc.bin $dest_dir
#      su vnmr1 -c $dest_dir/Solaris_JRE_1.1.6_03_sparc.bin
#      rm -f Solaris_JRE_1.1.6_03_sparc.bin
#      su vnmr1 -c "mv Solaris_JRE_1.1.6_03 jre"
#   fi

   echo "Reconfiguring files... "
   echo " "
   if ( test x$load_type = "xunity.opt" )
   then
      file=$dest_dir"/user_templates"
      cp $file"/global" $file"/tmp"
      cat $file/tmp | sed 's/lockgain 1 1 48/lockgain 1 1 70/' | \
         sed 's/lockpower 1 1 68/lockpower 1 1 63/' > $file/global
      rm $file/tmp
      nproc=`ls $dest_dir/par??0/stdpar/*/procpar`
      change_procpar
      nproc=`ls $dest_dir/par??0/tests/*/procpar`
      change_procpar
      nproc=`ls $dest_dir/parlib/*/procpar`
      change_procpar
      nproc=`ls $dest_dir/fidlib/*/procpar`
      change_procpar
   fi

   if ( test x$load_type = "xg2000.opt" -o x$load_type = "xmercury.opt" -o x$load_type = "xmercvx.opt" )
   then
      nproc=`ls $dest_dir/fidlib/*/procpar`
      change_procpar
      file=$dest_dir"/glide/adm"
      if (test -f $file/public.env)
      then
         cp  $file/public.env $file/public
         cat $file/public | sed 's/unity/gem/' > $file/public.env
         rm $file/public
      fi
   fi

   if ( test x$load_type = "xmercury.opt" -o x$load_type = "xmercvx.opt" )
   then
      file=$dest_dir"/user_templates"
      cp $file/global $file/tmp
      cat $file/tmp | sed 's/lockgain 1 1 48 0 1/lockgain 1 1 39 0 1/' | \
          sed 's/lockpower 1 1 68 0 1/lockpower 1 1 48 0 1/' > $file/global
      rm $file/tmp
   fi

   if ( test x$load_type = "xg2000.opt" )
   then
      file=$dest_dir"/user_templates"
      cp $file/global $file/tmp
      cat $file/tmp | sed 's/lockgain 1 1 48 0 1/lockgain 1 1 30 0 10/' | \
          sed 's/lockpower 1 1 68 0 1/lockpower 1 1 40 0 1/' > $file/global
      rm $file/tmp
   fi

   chmod 777   $dest_dir/tmp
   if (test -f $dest_dir/bin/cptoconpar)
   then
      chmod u+s  $dest_dir/bin/cptoconpar
   fi
   if [ ! -d $dest_dir/acqqueue ]
   then
      mkdir $dest_dir/acqqueue
      chmod 777 $dest_dir/acqqueue
      ${chown_cmd} $nmr_adm $dest_dir/acqqueue
      ${chgrp_cmd} $nmr_group $dest_dir/acqqueue
   fi

   if [ x$vnmr_link = "xyes" ]
   then
      cd /
      rm -f /vnmr
      ln -s $dest_dir /vnmr
      echo "Link '/vnmr' to VNMR Software"
   fi

   if [ x$cp_files = "xy" ]
   then
      echo "Restoring conpar and devicenames."
      mv /tmp/conpar $dest_dir/conpar.prev
      mv /tmp/devicenames $dest_dir/devicenames
      ${chown_cmd} $nmr_adm   $dest_dir/devicenames $dest_dir/conpar.prev
      ${chgrp_cmd} $nmr_group $dest_dir/devicenames $dest_dir/conpar.prev
      echo "Restoring shim and probe-calibration files"
      mv /tmp/shims/* $dest_dir/shims
      mv /tmp/probes/* $dest_dir/probes
      ${chown_cmd} -R $nmr_adm   $dest_dir/shims $dest_dir/probes
      ${chgrp_cmd} -R $nmr_group $dest_dir/shims $dest_dir/probes
   fi

   #Make initial gradtables and decclib dirs group writable,
   #regardless of how they are on the CD.
   #If we have old ones, totally ignore new ones.

   if [ x$cp_gradtables = "xy" ]
   then
      echo "Restoring gradtables."
      rm -rf $dest_dir/imaging/gradtables
      (cd $dest_dir; tar xpf /tmp/gradtables.tar)
   else
      chmod 775 $dest_dir/imaging/gradtables
   fi
   if [ x$cp_decclib = "xy" ]
   then
      echo "Restoring decclib."
      rm -rf $dest_dir/imaging/decclib
      (cd $dest_dir; tar xpf /tmp/decclib.tar)
   else
      chmod 775 $dest_dir/imaging/decclib
   fi

   #######################################################################
   #bottom part was move in from outside of this if, need to be rechecked

   #Use Vnmr Motif library if one not already present
   if (test ! -f /usr/dt/lib/libXm.so)
   then  
      ( cd $dest_dir/lib; mv libXmVnmr.so.3 libXm.so.3; ln -s libXm.so.3 libXm.so )
   fi
 
   #For Solaris 2.6 the types.h file of the GNU compiler can not be used
   ver=`uname -r`
   if [ $ver="5.6" ]
   then  
      ( cd $dest_dir/gnu/lib/gcc-lib/sparc-sun-solaris2.3/2.6.3/include/sys;
        mv types.h types.h.bk
      )  
   fi 
 
   #finally copy the revision file info to $dest_dir and add $load_type
   rm -rf $dest_dir/vnmrrev
   cp $source_dir/vnmr6.1 $dest_dir/vnmrrev
   echo `basename $load_type .opt` >> $dest_dir/vnmrrev
   chown $nmr_adm   $dest_dir/vnmrrev
   chgrp $nmr_group $dest_dir/vnmrrev
fi

#
# Wow, all done...
#
echo "\n\nSoftware Installation Completed."

