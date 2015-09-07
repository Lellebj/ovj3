: '@(#)i_vnmr1.sh 22.1 03/24/08 1991-1994 '
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
: '@(#)i_vnmr3.sh 13.1 10/10/97 1991-1997 '
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


config_chown() {
    if [ x$ostype = "xSOLARIS" ]
    then
        chown_cmd="/usr/bin/chown -h "
        chgrp_cmd="/usr/bin/chgrp -h "
    else
        chown_cmd="chown "
        chgrp_cmd="chgrp "
    fi
}

echo_send() {
   if [ x$textOnly = "xy" ]
   then
      if [ $2 -eq 0 ]
      then
         echo $1
      else
         echo Loading $1 at $2 kbytes
      fi
   else
      $source_dir_code/send.$osexten $pid "$1" $2
   fi
}

domanuals()
{
   dir_now=`pwd`
   dir_from=$source_dir/$1
   if [ ! -d $dest_dir/acrobat/online ]
   then
      if test ! "x$nmr_adm" = "x"
      then
         (su $nmr_adm -c "mkdir -p $dest_dir/acrobat/online")
      else
         mkdir -p $dest_dir/acrobat/online
      fi
   fi
   cd $dest_dir/acrobat
   if [ -d online ]
   then
      rm -rf online/`basename $1`
   else
      mkdir online
   fi
   if [ x$linkmanuals = "xyes" ]
   then
      if test ! "x$nmr_adm" = "x"
      then
         (su $nmr_adm -c "ln -s $dir_from online/`basename $1`")
      else
         ln -s $dir_from online/`basename $1`
      fi
   else
      if test ! "x$nmr_adm" = "x"
      then
         (su $nmr_adm -c "cp -rp  $dir_from  online/`basename $1`")
      else
         cp -rp $dir_from online/`basename $1`
      fi
   fi
   if [ x$ostype = "xIRIX" -o x$ostype = "xIRIX64" ]
   then
      (cd $dest_dir/acrobat;				\
      chown -R $nmr_adm    online/`basename $1`;	\
      chgrp -R $nmr_group  online/`basename $1`)
   fi

   cd $dir_now
}

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
$source_dir_code/acrobat/acrobat/install > /dev/null 2> /dev/null << +++
y
accept
$destdir
+++
   else
$source_dir_code/acrobat/acrobat/install > /dev/null 2> /dev/null << +++
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
#-------------------------------------------------------
#  Main MAIN main program starts here
#
# get the arguments you want to keep
#
acqpid=$1
shift
console=$1
shift
source_dir_code=$1
source_dir=`dirname $source_dir_code`
shift
dest_dir=$1
shift
#force the destination to "/vnmr"
dest_dir="/vnmr"
pid=$1
shift
linkmanuals=$1
shift
makelink=$1
shift
opt_dir=$1
shift

config_chown

#
# if we are root we'll load vnmr
# and if we want to load vnmr we create entry in passwd/shadow
# and if we want to load vnmr we create the directory
# only if needed of course
#
user=`id | sed -e 's/[^(]*[(]\([^)]*\)[)].*/\1/'`
if [ x$user != "xroot" ]
then
   echo_send "You must be root to load VNMR and its options." 0
   echo_send "Click <Dismiss> and become root." 0
   echo_send "Then start load.nmr again." 0
   exit 1
else
   if [ $acqpid -ne -1 ]
   then
      echo_send "Stopping acquisition." 0
      kill -2 $acqpid
      sleep 5		# give time for kill message to show up.
   fi
   if [ ! -d /vnmr ]
   then
      echo_send "You must first load VNMR and create the /vnmr link" 0
      echo_send "Follow instructions in the 'Software Installation Manual'" 0
      exit 1
   fi
   if [ ! -d $dest_dir ]
   then
       echo_send "Creating '$dest_dir'" 0
       mkdir $dest_dir
       ${chown_cmd} $nmr_adm $dest_dir
       ${chgrp_cmd} $nmr_group $dest_dir
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
fi

if [ x$console = "xmercvx.sol" ]
then
  if [ -f $dest_dir/acqbin/Acqproc ]
  then 
      echo_send "Deleting unwanted files" 0
      rm -rf $dest_dir/acqbin/Acqproc
      rm -rf $dest_dir/acqbin/gAcqproc
      rm -rf $dest_dir/acqbin/Autoproc
      rm -rf $dest_dir/acqbin/acqinfo_svc
      rm -rf $dest_dir/psg
      rm -rf $dest_dir/lib/libparam.a
      rm -rf $dest_dir/lib/libparam..so.6.0
      rm -rf $dest_dir/lib/libpsglib.a
      rm -rf $dest_dir/lib/libpsglib.so.6.0
      rm -rf $dest_dir/bin/giadisplay
      rm -rf $dest_dir/bin/setacq
   fi
fi


#
# iff /$dest_dir already exists, check if it is owned by vnmr1/nmr 
# change $nmr_adm and $nmr_group accordingly
# If it is vnmr1/nmr, it stays vnmr1/nmr, if not it changes
nmr_adm=`ls -ld $dest_dir/. | awk 'BEGIN { FS = " " } { print $3 }'`
nmr_group=`ls -ld $dest_dir/. | awk 'BEGIN { FS = " " } { print $4 }'`
echo_send "Using $nmr_adm/$nmr_group as VNMR administrator/group" 0

#
# now load the requested options
#
echo_send "Loading '$*'" 0

i=0
n_no_pass=$1
shift
did_vnmr="n"
temp=0
size=0
while [ $i -lt $n_no_pass ]
do
   cat $source_dir_code/$opt_dir/$console | (while read line
   do
      b=`echo $line | awk 'BEGIN { FS = " " } { print $1 }'`
      if [ x$b = x$1 ]
      then
	 size=`echo $line | awk 'BEGIN { FS = " " } { print $2 }'`
	 c=`echo $line | awk 'BEGIN { FS = " " } { print $3 }'`
       if [ `dirname $c` != "code//acrobat/online" -o  x$linkmanuals != "xyes" ]
       then
         echo_send  $c $temp
         temp=$size
       else
         echo_send $c 0
       fi
	 if [ `dirname $c` = "code//acrobat/online" ]
         then
	    domanuals $c
         else
            if [ `dirname $c` = "code/acrobat/acrobat" ]
            then
               d=`basename $c`
               if [ $d="ssolr.tar" -o $d="irixr.tar" -o $d="aixr.tar" ]
               then
                  doacrobat
               fi
            else
               if test ! "x$nmr_adm" = "x"
               then
                  (cd $dest_dir;su $nmr_adm -c "tar xpf $source_dir/$c")
	          if [ $? -ne 0 ]
                  then
                     (cd $dest_dir;su $nmr_adm -c "tar xpf $source_dir/$c")
	             if [ $? -ne 0 ]
                     then
                         echo_send "Installation of $1 failed" 0
                     fi
                  fi
               else
                  (cd $dest_dir;tar xpf $source_dir/$c)
	          if [ $? -ne 0 ]
                  then
                     (cd $dest_dir;tar xpf $source_dir/$c)
	             if [ $? -ne 0 ]
                     then
                         echo_send "Installation of $1 failed" 0
                     fi
                  fi
               fi
            fi
         fi
      fi
   done
   echo_send " " $temp
   )
   if [ x$1 = "xVNMR" ]
   then
      did_vnmr="y"
   fi
   i=`expr $i + 1`
   shift
done

#
# Next load the passworded options
#
i=0
n_pass=$1
shift
if [ $n_pass -ge 1 ]
then
   echo_send " " 0
   echo_send "Loading Passworded option" 0
fi
console=`basename $console $opt_dir`opt
temp=0
while [ $i -lt $n_pass ]
do
   cat $source_dir_code/$opt_dir/$console | (while read line
   do
      b=`echo $line | awk 'BEGIN { FS = " " } { print $1 }'`
      if [ x$b = x$1 ]
      then
	 size=`echo $line | awk 'BEGIN { FS = " " } { print $2 }'`
	 c=`echo $line | awk 'BEGIN { FS = " " } { print $3 }'`
         echo_send  $c $temp
         temp=$size
         if test ! "x$nmr_adm" = "x"
         then
            (cd $dest_dir; $source_dir_code/decode.$osexten $2 \
			 < $source_dir/$c > tmp.tar )
            (cd $dest_dir;su $nmr_adm -c "tar xpf tmp.tar" )
	    if [ $? -ne 0 ]
            then
               echo_send "Password for $1 incorrect. " 0
               echo_send "  If you have the correct password" 0
	       echo_send "  you can load the option separately" 0
               echo_send "  when this install is complete." 0
               echo_send "  Run load.nmr again, and only select $1" 0
            fi
            rm -f $dest_dir/tmp.tar
         else
            (cd $dest_dir;$source_dir_code/decode.$osexten $2  \
			 < $source_dir/$c > tmp.tar )
            (cd $dest_dir;tar xpf tmp.tar )
	    if [ $? -ne 0 ]
            then
               echo_send "Password for $1 incorrect " 0
               echo_send "  If you have the correct password" 0
	       echo_send "  you can load the option separately" 0
               echo_send "  when this install is complete." 0
               echo_send "  Run load.nmr again, and only select $1" 0
            
	    fi
            rm -f $dest_dir/tmp.tar
         fi
      fi
   done
   echo_send " " $temp
   )
   if [ x$1 = "xVNMR" ]
   then
      did_vnmr="y"
   fi
   i=`expr $i + 1`
   shift; shift
done
echo_send " " 0

#
# fix some things, depending on what system we are
#
#
# For Solaris 2.6 the types.h file of the GNU compiler can not be used
#
ver=`uname -r`
if [ $ver="5.6" ]
then
   ( cd /vnmr/gnu/lib/gcc-lib/sparc-sun-solaris2.3/2.6.3/include/sys;
     mv types.h types.h.bk
   )
fi
if [ $ver="5.7" ]
then
   ( cd /vnmr/gnu/lib/gcc-lib/sparc-sun-solaris2.3/2.6.3/include/sys;
     mv types.h types.h.bk
   )
fi

# 
# Because the second CDROM includes the patches, and loading the patches
# after loading the CDROM would be disatrous, we make a patch directory
#
if [ ! -d 6.1AgenSOLmer101 ]
then
   mkdir -p /vnmr/adm/patch/6.1AgenSOLmer101
   chown -R $nmr_adm   /vnmr/adm/patch/6.1AgenSOLmer101
   chgrp -R $nmr_group /vnmr/adm/patch/6.1AgenSOLmer101
fi

#
# finally copy the revision file info to /vnmr and add $console
#
rm -rf /vnmr/vnmrrev
cp $source_dir/vnmr6.1 /vnmr/vnmrrev
echo `basename $console .opt` >> /vnmr/vnmrrev
chown $nmr_adm   /vnmr/vnmrrev
chgrp $nmr_group /vnmr/vnmrrev

#
# Wow, all done...
#
echo_send " " 0
echo_send "Software Load Completed." 0

