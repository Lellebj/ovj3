: '@(#)i_vnmr3.sh 22.1 03/24/08 1991-1998 '
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

change_procpar() {
  for proc in $nproc
  do
    cp $proc /tmp/proc_tmp
    cat /tmp/proc_tmp | sed 's/4 "a" "n" "s" "y"/2 "n" "y"/' | \
    sed 's/9 "c" "f" "g" "m" "p" "r" "u" "w" "x"/5 "c" "f" "n" "p" "w"/' > $proc
  done
  rm /tmp/proc_tmp 
}
 
ch_mod() {
    if [ x$ostype = "xIRIX" -o x$ostype = "xIRIX64" ]
    then
	find $* -exec chmod 644 {} \;
    else
	chmod -R 644 $*
    fi
    chmod 755 $*
}

ch_xmod() {
    if [ x$ostype = "xIRIX" -o x$ostype = "xIRIX64" ]
    then
	find $* -exec chmod 755 {} \;
    else
	chmod -R 755 $*
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
   if [ x$linkmanuals = "xyes" ]
   then
      if test ! "x$nmr_adm" = "x"
      then
         (su $nmr_adm -c "ln -s $source_dir_code/acrobat/online online")
      else
         ln -s $source_dir_code/acrobat/online online
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
   if [ ! -d $destdir ]
   then
      mkdir -p $destdir
   fi
   cd $destdir
   tar xvf $source_dir/$c
./*install/INSTALL > /dev/null  2> /dev/null << +++
y
accept
$destdir
+++
   rm -r ./*install
   (cd $destdir/..;					\
    chown -R $nmr_adm     `basename $destdir`;		\
    chgrp -R $nmr_group   `basename $destdir`)
}


savevast()
{
  echo_send  "Backing up previous release VAST files." 0
  /usr/bin/rm -f /tmp/excludelist /tmp/vast.tar
#
# create the exclude list
#
  /usr/bin/echo "./info.new" > /tmp/excludelist
  /usr/bin/echo "./asm.this_release.bkup" >> /tmp/excludelist
  /usr/bin/echo "./asm.previous_release.bkup" >> /tmp/excludelist
#
# tar present asm directory
#
  (cd $dest_dir/asm; /usr/bin/tar -cXf /tmp/excludelist /tmp/vast.tar . ; )
}


 
restorevast()
{
  /usr/bin/rm -f /tmp/nvast.tar /tmp/vastlist.prev /tmp/vastlist.latest /tmp/combolist
#
# tar new release asm directory
#
   (cd $dest_dir/asm; tar -cXf /tmp/excludelist /tmp/nvast.tar . )
#
# generate two list of whats in the asm directories
#
   /usr/bin/tar -tf /tmp/vast.tar > /tmp/vastlist.prev
   /usr/bin/tar -tf /tmp/nvast.tar > /tmp/vastlist.latest
   /usr/bin/cat /tmp/vastlist.prev /tmp/vastlist.latest | /usr/bin/sort > /tmp/combolist
#
# create a unique list of files present in one but not the other
# these we will copy over to the new release asm
#
#  --- uniqlist maybe unique to the new or the old
   uniqlist=`/usr/bin/uniq -u /tmp/combolist`
# ---  extractlist are the unique ones in the previous release
   extractlist=`/usr/bin/tar -tf /tmp/vast.tar $uniqlist`
   /usr/bin/rm -rf $dest_dir/asm/asm.this_release.bkup;
   /usr/bin/rm -rf $dest_dir/asm/asm.previous_release.bkup
   /usr/bin/rm -rf $dest_dir/asm/info.new
   /usr/bin/mkdir -p $dest_dir/asm/asm.this_release.bkup
   /usr/bin/mkdir -p $dest_dir/asm/asm.previous_release.bkup
#
# create an untouch backup copy of this release
#
   echo_send " Backing up this release VAST files to $dest_dir/asm/asm.this_release.bkup" 0
   (cd $dest_dir/asm/asm.this_release.bkup; /usr/bin/tar -xf /tmp/nvast.tar )
   echo_send  " " 0
 
#
# copy over the new release racksetup and info files
#
   echo_send " Restoring previous release VAST racksetup and sample files" 0
#   tar tf /tmp/vast.tar ./racksetup ./info
   (cd $dest_dir/asm; /usr/bin/tar xvpf /tmp/vast.tar ./racksetup ./info | /usr/bin/cut -f2 -d' ' );
   echo_send " " 0
#
# if there some addition files to be copied do so now
#
   if [ x"$extractlist" != "x" ]
   then
      echo_send " Restoring user/system added VAST files" 0
      ( cd $dest_dir/asm; /usr/bin/tar xvpf /tmp/vast.tar $extractlist | /usr/bin/cut -f2 -d' ' )
      echo_send " " 0
      echo_send "  For user added protocols and/or racks, you will need" 0
      echo_send "  to manual update the protocol.vast and racks/rackInfo files. " 0
      echo_send " " 0
   fi
#
# create a complete backup of the previous release files, various *.conf
# and other files may be needed if they were customized
#
   ( cd $dest_dir/asm/asm.previous_release.bkup; /usr/bin/tar -xf /tmp/vast.tar )
   echo_send "A complete backup of the previous VAST files can be found in $dest_dir/asm/asm.previous_release.bkup" 0
   echo_send " " 0
   echo_send "If you change any of the '.conf'or other files you we need to manually" 0
   echo_send "reapply your changes." 0
 
   /usr/bin/rm -f /tmp/excludelist /tmp/vast.tar
   /usr/bin/rm -f /tmp/nvast.tar /tmp/vastlist.prev /tmp/vastlist.latest /tmp/combolist
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
pid=$1
shift
linkmanuals=$1
shift
makelink=$1
shift
opt_dir=$1
shift

real_console=`echo $console | cut -d. -f1`
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
   echo $* | grep -s VNMR > /dev/null
   if [ $? -eq 0 ]
   then
      echo_send "Checking for $nmr_adm   in password file(s)" 0
      echo_send "Checking for $nmr_group in group file" 0
      if [ x$ostype = "xIRIX" -o x$ostype = "xIRIX64" ]
      then
         $source_dir_code/i_vnmr.4 $nmr_adm $nmr_group /usr/people
      else
         if [ x$ostype = "xSOLARIS" ]
         then
             $source_dir_code/i_vnmr.4 $nmr_adm $nmr_group /export/home
         else
             $source_dir_code/i_vnmr.4 $nmr_adm $nmr_group /home
         fi
      fi
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
         cp -r /vnmr/shims /tmp/shims
         cp -r /vnmr/probes /tmp/probes
	 rm /tmp/probes/probe.tmplt
         cp_files='y'
      fi
   fi
fi


# if cp_files='y' then we are loading VNMR,
# so save gradtables and decclib directories
cp_gradtables='n'
cp_decclib='n'
cp_vast='n'
if [ x$cp_files = "xy" ]
then
      if [ -d /vnmr/imaging/gradtables ]
      then
         rm -f /tmp/gradtables.tar
         (cd /vnmr; tar cf /tmp/gradtables.tar imaging/gradtables)
         cp_gradtables='y'
      fi
      if [ -d /vnmr/imaging/decclib ]
      then
         rm -f /tmp/decclib.tar
         (cd /vnmr; tar cf /tmp/decclib.tar imaging/decclib)
         cp_decclib='y'
      fi
      if [ -d /vnmr/asm/info ]
      then
         rm -f /tmp/vast.tar
#         (cd /vnmr/asm; tar cf /tmp/vast.tar racksetup info)
         savevast
         cp_vast='y'
      fi
fi

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
         echo_send  $c $temp
         temp=$size
	 if [ `dirname $c` = "code//acrobat/online/cdrom" ]
         then
            echo $* | grep -s Imaging_or_Triax > /dev/null
            if [ $? -eq 0 ]
	    then
	       domanuals $c 1
            else
	       domanuals $c 0
	    fi
         else
            if [ `dirname $c` = "code/acrobat/acrobat" ]
            then
                doacrobat
            else
               if test ! "x$nmr_adm" = "x"
               then
                  (su $nmr_adm -c "cd $dest_dir; tar xpfB $source_dir/$c")
	          if [ $? -ne 0 ]
                  then
                     (su $nmr_adm -c "cd $dest_dir; tar xpfB $source_dir/$c")
	             if [ $? -ne 0 ]
                     then
                         echo_send "Installation of $1 failed" 0
                     fi
                  fi
               else
                  (cd $dest_dir;tar xpfB $source_dir/$c)
	          if [ $? -ne 0 ]
                  then
                     (cd $dest_dir;tar xpfB $source_dir/$c)
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
            (su $nmr_adm -c "cd $dest_dir; tar xpfB tmp.tar" )
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
            (cd $dest_dir;tar xpfB tmp.tar )
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
if [ x$did_vnmr = "xy" ]
then

   echo_send "Reconfiguring files... " "0"
   echo_send " " "0"
   if ( test x$console = "xunity.opt" )
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
     rm -f $dest_dir/asm/auto.conf $dest_dir/asm/enter.conf $dest_dir/asm/experiments
     mv $dest_dir/asm/auto.unity $dest_dir/asm/auto.conf
     mv $dest_dir/asm/enter.unity $dest_dir/asm/enter.conf
     mv $dest_dir/asm/experiments.unity $dest_dir/asm/experiments
     rm -f $dest_dir/user_templates/dg/default/dg.conf
     mv $dest_dir/user_templates/dg/default/dg.unity $dest_dir/user_templates/dg/default/dg.conf
   fi

   if ( test x$console = "xg2000.opt" -o x$console = "xmercury.opt" -o x$console = "xmercvx.opt" )
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

   if ( test x$console = "xmercury.opt" -o x$console = "xmercvx.opt" )
   then
      file=$dest_dir"/user_templates"
      cp $file/global $file/tmp
      cat $file/tmp | sed 's/lockgain 1 1 48 0 1/lockgain 1 1 39 0 1/' | \
          sed 's/lockpower 1 1 68 0 1/lockpower 1 1 48 0 1/' > $file/global
      rm $file/tmp
   fi

   if ( test x$console = "xmercury.opt" -o x$console = "xmercvx.opt" )
   then
     file=$dest_dir"/user_templates"
     cp $file"/global" $file"/tmp"
     cat $file/tmp |  awk '{ if ($1=="dsp") { print; getline;      \
			      printf("1 \"i\"\n"); } else print;}' \
			      > $file"/global"
     rm $file"/tmp"
   fi

   if ( test x$console = "xg2000.opt" )
   then
     file=$dest_dir"/user_templates"
     cp $file/global $file/tmp
     cat $file/tmp | sed 's/lockgain 1 1 48 0 1/lockgain 1 1 30 0 10/' | \
          sed 's/lockpower 1 1 68 0 1/lockpower 1 1 40 0 1/' > $file/global
     rm $file/tmp
     rm -f $dest_dir/asm/auto.conf $dest_dir/asm/enter.conf $dest_dir/asm/experiments
     mv $dest_dir/asm/auto.g2000 $dest_dir/asm/auto.conf
     mv $dest_dir/asm/enter.g2000 $dest_dir/asm/enter.conf
     mv $dest_dir/asm/experiments.g2000 $dest_dir/asm/experiments
     rm -f $dest_dir/user_templates/dg/default/dg.conf
   fi

   if ( test x$console = "xuplus.opt" )
   then
     rm -f $dest_dir/asm/auto.conf $dest_dir/asm/enter.conf $dest_dir/asm/experiments
     mv $dest_dir/asm/auto.uplus $dest_dir/asm/auto.conf
     mv $dest_dir/asm/enter.uplus $dest_dir/asm/enter.conf
     mv $dest_dir/asm/experiments.uplus $dest_dir/asm/experiments
     rm -f $dest_dir/user_templates/dg/default/dg.conf
     mv $dest_dir/user_templates/dg/default/dg.uplus $dest_dir/user_templates/dg/default/dg.conf
   fi

   if [ x$real_console = "xg2000" ]
   then  
      mv $dest_dir/user_templates/dg/default.g2000/* $dest_dir/user_templates/dg/default
   fi 

# if still there, delete the following.
   rm -rf $dest_dir/user_templates/dg/default.g2000
   rm -rf $dest_dir/user_templates/dg/default/dg.unity
   rm -rf $dest_dir/user_templates/dg/default/dg.uplus
   rm -rf $dest_dir/asm/auto.g2000
   rm -rf $dest_dir/asm/auto.unity
   rm -rf $dest_dir/asm/auto.uplus
   rm -rf $dest_dir/asm/enter.g2000
   rm -rf $dest_dir/asm/enter.unity
   rm -rf $dest_dir/asm/enter.uplus
   rm -rf $dest_dir/asm/experiments.g2000
   rm -rf $dest_dir/asm/experiments.unity
   rm -rf $dest_dir/asm/experiments.uplus

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

   if [ x$makelink = "xyes" ]
   then
      cd /
      rm -f /vnmr
      ln -s $dest_dir /vnmr
   fi

   if [ x$cp_files = "xy" ]
   then
      echo_send "Restoring conpar and devicenames." 0
      mv /tmp/conpar $dest_dir/conpar.prev
      mv /tmp/devicenames $dest_dir/devicenames
      ${chown_cmd} $nmr_adm   $dest_dir/devicenames $dest_dir/conpar.prev
      ${chgrp_cmd} $nmr_group $dest_dir/devicenames $dest_dir/conpar.prev
      echo_send "Restoring shim and probe-calibration files" 0
      mv /tmp/shims/* $dest_dir/shims
      mv /tmp/probes/* $dest_dir/probes
      rm -rf /tmp/shims /tmp/probes
      ${chown_cmd} -R $nmr_adm   $dest_dir/shims $dest_dir/probes
      ${chgrp_cmd} -R $nmr_group $dest_dir/shims $dest_dir/probes
   fi

#  Make initial gradtables and decclib dirs group writable,
#  regardless of how they are on the CD.
#  If we have old ones, totally ignore new ones.

   if [ x$cp_gradtables = "xy" ]
   then
      echo_send "Restoring gradtables." 0
#comment following line, this way what we set is added to what the users have
#      rm -rf $dest_dir/imaging/gradtables
      (cd $dest_dir; tar xpfB /tmp/gradtables.tar)
       rm -f /tmp/gradtables.tar
   else
      chmod 775 $dest_dir/imaging/gradtables
   fi

   if [ x$cp_decclib = "xy" ]
   then
      echo_send "Restoring decclib." 0
      rm -rf $dest_dir/imaging/decclib
      (cd $dest_dir; tar xpfB /tmp/decclib.tar)
      rm -f /tmp/decclib.tar
   else
      chmod 775 $dest_dir/imaging/decclib
   fi
   if [ x$cp_vast = "xy" ]
   then
      if [ -d $dest_dir/asm/info ]
      then
         echo_send "Restoring VAST rack information." 0
#         mv $dest_dir/asm/info $dest_dir/asm/info.new
#         mv $dest_dir/asm/racksetup $dest_dir/asm/info.new
#         (cd $dest_dir/asm; tar xpfB /tmp/vast.tar)
	 restorevast
      fi
      rm -f /tmp/vast.tar
   fi

   case $real_console in
        inova ) explist_file="explist.inova" ;;
        g2000 ) explist_file="explist.g2000" ;;
      mercury ) explist_file="explist.mercury" ;;
            * ) explist_file="explist.inova";;
   esac
   if [ -f $dest_dir/asm/${explist_file} ]
   then
      (cd $dest_dir/asm; mv -f $explist_file explist; rm -f explist.*)
   fi
fi

# Use Vnmr Motif library if one not already present
if (test ! -f /usr/dt/lib/libXm.so)
then
   ( cd $dest_dir/lib; mv libXmVnmr.so.3 libXm.so.3; ln -s libXm.so.3 libXm.so )
fi
#
# For Solaris 2.6 the types.h file of the GNU compiler can not be used
#
ver=`uname -r`
if [ $ver="5.6" ]
then
   ( cd $dest_dir/gnu/lib/gcc-lib/sparc-sun-solaris2.3/2.6.3/include/sys;
     mv types.h types.h.bk
   )
fi
if [ $ver="5.7" ]
then
   ( cd $dest_dir/gnu/lib/gcc-lib/sparc-sun-solaris2.3/2.6.3/include/sys;
     mv types.h types.h.bk
   )
fi

#
# finally copy the revision file info to $dest_dir and add $console
#
rm -rf $dest_dir/vnmrrev
cp $source_dir/vnmrrev $dest_dir/vnmrrev
echo `basename $console .opt` >> $dest_dir/vnmrrev
chown $nmr_adm   $dest_dir/vnmrrev
chgrp $nmr_group $dest_dir/vnmrrev

chown -hR $nmr_adm $dest_dir
chgrp -hR $nmr_group $dest_dir

# set execkillacqproc permissions/owners
chown root /vnmr/bin/execkillacqproc
chmod 500  /vnmr/bin/execkillacqproc

# set killroboproc permissions/owners
chown root:root /vnmr/bin/killroboproc
chmod 4755 /vnmr/bin/killroboproc

echo_send " " 0

#
# Wow, all done...
#
echo_send " " 0
echo_send "Software Load Completed." 0

