: /bin/sh
# '@(#)makeuser.sh 1991-2009 '
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

ostype=`uname -s`
set_system_stuff() {
    #  ostype:  IBM: AIX , Sun: SunOS or solaris , SGI: IRIX , RedHat: Linux, Windows: Interix
set -x
    case x$ostype in
          "xLinux")
                           sysV="n"
                           default_dir="/home"
                           ;;
	 
	       "xInterix")
                           sysV="n"
                           # XP   user home = /dev/fs/C/SFU/home
                           # Win7 user home = /dev/fs/C/User
                           # XP   SFUDIR_INTERIX = /dev/fs/C/SFU
                           # WIN7 SFUDIR_INTERIX = /dev/fs/C/WIndows/SUA
                           sfu_ver=`uname -r`
                           if [ "x3.5" = "x$sfu_ver" ] 
                           then
                               default_dir="$SFUDIR_INTERIX/home"
                           else
                               default_dir="/dev/fs/C/User"
                           fi
                           ;;

	                *)
                           sysV="n"
                           default_dir="$SFUDIR_INTERIX/home"
			                  ;;
     esac

    if [ -d "$default_dir" ]
    then
        default_dir="C:/SFU/home"
    fi
}

####################################################################
#  echo without newline - needs to be different for BSD and System V
####################################################################
nnl_echo() {
        if test $# -lt 1
        then
            echo
        else
            echo -n $*
        fi
}

####################################################################
#  script function to obtain value for vnmrsystem
#  implemented as a separate function, rather than inline,
#  because it is called at a different place,
#  depending on whether the current account is root or non-root
####################################################################

get_vnmrsystem() {

    #  Get value of vnmrsystem
    #  If not defined, ask for its value
    #  Use /vnmr as the default
    #  make sure directory exists

    if test x"$vnmrsystem" = "x"
    then
       vnmrsystem="/vnmr"
    fi
}

####################################################################
#  Script function to get thr groupname to use
####################################################################
get_group()
{
   if [ x$1 != "x" ]
   then 
      nmr_group=$1
   elif [ x$ostype = "xDarwin"  -o  x$ostype = "xInterix" ]
   then
      nmr_group=`id -gn`
   else
      cd "$vnmrsystem"
      nmr_group=`ls -ld . | awk '{ print $4 }'`
   fi
}
      
####################################################################
#  Script function to extract home directory 
#  use the ~username feature of the C-shell
####################################################################

get_homedir() {
    if [ "x$ostype" = "xInterix" ]
    then
        home_dir=""
	     home_dir=`/vnmr/bin/getuserinfo $1 | awk 'BEGIN { FS = ";" } {print $2}'`
        /bin/winpath2unix $home_dir
    else
        echo "/home"
    fi
}

####################################################################
#  Script function to make the home directory
####################################################################

make_homedir() {
    if mkdir "$cur_homedir"
    then
        chmod 775 "$cur_homedir"
	     if [ x$ostype != "xInterix" ] 
	     then
	         chown -R $name_add "$cur_homedir"
	         chgrp -R $nmr_group "$cur_homedir"
	     fi
        echo 0
    else
        echo "Cannot create $cur_homedir"
        echo 1
    fi
}

####################################################################
#  Script function to verify the user name has no invalid characters
####################################################################

verify_user_name() {
    namelen=`echo "$1" | awk '{ print length( $0 ) }'`
    if [ $namelen -lt 1 ]
    then
        echo "No user name was given"
        return 1
    fi
    if [ $namelen -gt 8 ]
    then
        echo "User name with $namelen letters exceeds UNIX limit of 8"
        return 1
    fi

    echo $1 | awk '
    /^[0-9A-Za-z_][0-9A-Za-z_-]*$/ {
	exit 0
    }

    #  if the input does not match the above pattern, then the name is rejected
    #  locate the offending character and point it out

    {
        namelen = length( $0 )
	for (iter = 1; iter <= namelen; iter++) {
            onechar = substr( $0, iter, 1 )
            if (onechar == "-" && iter == 1) {
                print "Leading '-' not allowed in a user name"
                break
            }
            if ((onechar < "A" || onechar > "Z") && (onechar < "a" || onechar > "z") && \
		(onechar < "0" || onechar > "z") && (onechar != "_") && (onechar != "-")) {
                print "User name " $0 " not permitted, invalid character"
                  for (jter = 1; jter < iter+10; jter++)
                    printf( " " )
                print( "^" )
                if (iter > 1)
                  for (jter = 1; jter < iter+10; jter++)
                    printf( " " )
                print( "|" )
                break
            }
	}
        exit 1
    }
    '
}

run_updaterev () {

   if [ x$ostype = "xLinux" ]
   then
       (export PATH; PATH="$PATH":"$vnmrsystem"/bin; \
        cd "$vnmrsystem"/bin; Vnmrbg -mback -n1 "updaterev" 2> /dev/null)
   else
       (export PATH; PATH="$PATH":"$vnmrsystem"/bin; cd "$vnmrsystem"/bin; Vnmrbg -mback -n1 "updaterev")
   fi

}

##########################################################

update_dotfiles() {

cd "$cur_homedir"
if [ x$ostype="xDarwin" -a $# -eq 2 -a $2="y"  ]
then
   dotfiles=
else
   dotfiles=`(cd "$vnmrsystem"/user_templates; ls .??*)`
fi
for file in $dotfiles
do
    if [ $# -ge 4 ]  #Called from Java
    then
	    if [ x$user_update = "xy" ]
	    then
	        if [ x$ostype != "xInterix" -a x$file = "x.login"  ]
 	        then	
		        continue
	        fi
	    elif [ x$user_update = "xn" ]
	    then
	        continue
	    fi
    fi
    if test $intera_unix = "y"
    then
        nnl_echo  "OK to update $file (y or n) [y]: "
        read yesno
        if test x$yesno = "xn" -o x$yesno = "xno"
        then
            continue
        fi
    fi
    if test -f $file
    then
	     if [ x$ostype != "xInterix" -a x$file = "x.cshrc"  ]
 	     then	
          continue
        fi
        if [ $intera_unix = "n" -a  x$file = "x.cshrc" ]
        then
          continue
        fi
        mv $file $file.bkup.$date
        echo "  $file backed up in $file.bkup.$date";
    fi
    /bin/cp "$vnmrsystem"/user_templates/$file .
    chmod 644 $file
    if test $file = ".openwin-init"
    then
       chmod +x .openwin-init
    fi
    if [ $file = ".xinitrc" -o $file = ".mwmrc" ]
    then
       chmod +x $file
    fi
    if test $as_root = "y"
    then
        chown $name_add $file
        chgrp $nmr_group $file
    else
        chgrp $nmr_group $file
    fi
    echo "  $file updated from templates."
done

}

##########################################################

create_uservnmrsys() {

if test ! -d $cur_homedir/vnmrsys
then
    mkdir  -p $cur_homedir/vnmrsys
    chmod 775 $cur_homedir/vnmrsys
    if test $as_root = "y"
    then
        chown $name_add $cur_homedir/vnmrsys
        chgrp $nmr_group $cur_homedir/vnmrsys
    else
        chgrp $nmr_group $cur_homedir/vnmrsys
    fi

    if [ x$ostype = "xInterix" ]
    then
	  chmod 777 $cur_homedir/vnmrsys
    fi
fi
}

##########################################################
make_usersubdirs() {

#  make some subdirectories of the user's VNMR directory

cd "$cur_homedir/vnmrsys"

dirlist="help maclib manual menulib parlib probes psglib seqlib shapelib shims \
	tablib imaging templates templates/layout mollib"
for subdir in $dirlist
do
    if test ! -d $subdir
    then
        if test $intera_vnmr = "y"
        then
            nnl_echo  "Create $subdir in your VNMR user directory (y or n) [y]: "
            read yesno
            if test x$yesno = "xn" -o x$yesno = "xno"
            then
                continue
            fi
        fi
        mkdir $subdir
        chmod 775 $subdir
	if [ x$ostype = "xInterix" ]
	then
	    chmod 777 $subdir
 	 fi
        if test $as_root = "y"
        then
            chown $name_add $subdir
            chgrp $nmr_group $subdir
        else
            chgrp $nmr_group $subdir
        fi
        if test $subdir = "imaging"
        then
            mkdir $subdir/eddylib
            chmod 775 $subdir/eddylib
	    if [ x$ostype = "xInterix" ]
	    then
		chmod 777 $subdir
	    fi
            if test $as_root = "y"
            then
                chown $name_add $subdir/eddylib
                chgrp $nmr_group $subdir/eddylib
            else
                chgrp $nmr_group $subdir/eddylib
            fi
        fi
        echo "  VNMR $subdir directory created."
    fi
done


}


##########################################################
make_userexp1() {

cd "$cur_homedir/vnmrsys"
if test ! -d exp1
then
    mkdir exp1
    chmod 775 exp1
    if [ x$ostype = "xInterix" ]
    then
   	chmod 777 exp1
    fi
    /bin/cp "$vnmrsystem"/fidlib/fid1d.fid/text    exp1/.
    /bin/cat "$vnmrsystem"/fidlib/fid1d.fid/procpar | sed 's"/vnmr/fidlib/Ethylindanone/Ethylindanone_PROTON_01"exp"' > exp1/procpar
    /bin/cp exp1/procpar exp1/curpar
    chmod 664 exp1/*
    mkdir exp1/acqfil
    chmod 775 exp1/acqfil
#    ln -s "$vnmrsystem"/fidlib/fid1d.fid/fid     exp1/acqfil/fid
    mkdir exp1/datdir
    chmod 775 exp1/datdir
    if test $as_root = "y"
    then
        chown -R $name_add exp1
        chgrp -R $nmr_group exp1
    else
        chgrp -R $nmr_group exp1 2> /dev/null
    fi
    echo "  VNMR experiment 1 created."
fi

}

##########################################################
make_userdata(){

cd "$cur_homedir/vnmrsys"
if test ! -d data
then
    mkdir data
    chmod 775 data
    if test $as_root = "y"
    then
        chown $name_add data
        chgrp $nmr_group data
    else
        chgrp $nmr_group data
    fi
fi

}
##########################################################

make_update_global() {

cd "$cur_homedir/vnmrsys"

if [ x$ostype != "xLinux" ]
then
    vnmruser=`pwd`
    export vnmruser
fi

if test ! -s global
then
    /bin/cp "$vnmrsystem"/user_templates/global .
    chmod 644 global
    if test $as_root = "y"
    then
	if [ x$ostype != "xInterix" ]
	then
	    chown $name_add global
	fi
        chgrp $nmr_group global
    else
        chgrp $nmr_group global
        run_updaterev
    fi
    echo "  global updated from templates;"

elif test $as_root = "y"
then
    mv global global.bkup.$date
    echo "  global backed up in global.bkup.$date"
    /bin/cp "$vnmrsystem"/user_templates/global .
    chmod 644 global
    chown $name_add global
    chgrp $nmr_group global
else
    /bin/cp global global.bkup.$date
    echo "  global backed up in global.bkup.$date"
    rm -rf global[0-9]
    run_updaterev
    if test ! -s global
    then
	 /bin/cp "$vnmrsystem"/user_templates/global .
	 chmod 644 global
	 chgrp $nmr_group global
         echo "  global updated from templates."
    else
         echo "  global updated with current values."
    fi
fi

}

##########################################################

make_pboxfiles() {

cd "$cur_homedir/vnmrsys"

#  The pbox defaults file goes in the shapelib subdirectory of the
#  user's VNMR directory.  If none present in that subdirectory, a
#  copy is present in the VNMR system directory and a shapelib exists
#  in the user's VNMR directory, then copy in the current version.

if test ! -f shapelib/.Pbox_defaults
then
  if test -f "$vnmrsystem"/shapelib/.Pbox_defaults
  then
    if test -d shapelib
    then
      /bin/cp "$vnmrsystem"/shapelib/.Pbox_defaults shapelib
      chmod 644 shapelib/.Pbox_defaults
      if test $as_root = "y"
      then
        chown $name_add shapelib/.Pbox_defaults
        chgrp $nmr_group shapelib/.Pbox_defaults
      else
        chgrp $nmr_group shapelib/.Pbox_defaults
      fi
      echo "  .Pbox_defaults updated from shapelib;"
    fi
  fi
fi


}
##########################################################
clean_userseqlib() {

cd "$cur_homedir/vnmrsys"

#  remove contents of seqlib
#  use word count program (wc) so script variable will have a value
#  that `test' sees as a single argument

if test -d seqlib
then
    tmpval=`(cd seqlib; ls) | wc -c`
    if test $tmpval != "0"
    then
	echo "  removing old pulse sequences for $name_add"
	(cd seqlib; rm -f *)
    fi
fi

}

##########################################################

clean_persistence() {

cd "$cur_homedir/vnmrsys"
export vnmrsystem
if test -d persistence
then
    if [ x$ostype = "xInterix" -a x$as_root = "xy" ]
    then
	chmod 755 persistence
	chown "$curr_user" persistence
	persis_files=`ls persistence`
	for persis_file in  $persis_files
	do
	    chown -R "$curr_user" "persistence/$persis_file"
	done
    fi
    rm -f persistence/LocatorHistory_*
    rm -f persistence/TagList
    rm -f persistence/session
    echo "  persistence directory cleaned."
fi

}
##########################################################

clean_userpsg() {
#  remove make file and binary files in psg (*.ln, *.a, *.so.* *.o)
#  One level of evaluation ($filespec => *.a) - Use double quotes
#  Expand implicit wildcard ($filespec => libpsglib.a) - no quote characters
#  redirect error output to /dev/null, to avoid messages if no such files exist

cd "$cur_homedir/vnmrsys"
if test -d psg
then
    for filespec in "*.a" "*.so.*" "*.ln" "*.o" "makeuserpsg"
    do
	tmpval=`(cd psg; ls $filespec 2>/dev/null) | wc -c`
	if test $tmpval != "0"
	then
	    echo "  removing '$filespec' from psg subdirectory"
	    (cd psg; rm -f $filespec)
	fi
    done
fi

}


##########################################################

create_imagingfile() {

cd "$cur_homedir/vnmrsys"

# Imaging Files and Directories
imgfiles="ib_initdir csi_initdir"
for file in $imgfiles
do
    if [ $file = "ib_initdir" -o $file = "csi_initdir" ]
    then
	if test -d "$vnmrsystem"/user_templates/$file
	then
    	   if test -d "$cur_homedir"/vnmrsys/$file -a $intera_unix = "y"
    	   then
        	nnl_echo  "OK to update $file (y or n) [y]: "
        	read yesno
        	if test x$yesno = "xn" -o x$yesno = "xno"
        	then
        	    continue
        	fi
	   fi
    	   if test -d "$cur_homedir"/vnmrsys/$file
	   then
           	mv "$cur_homedir"/vnmrsys/$file "$cur_homedir"/vnmrsys/$file.bkup.$date
           	echo "  $file backed up in $file.bkup.$date";
	   fi
	   # Copy with tar to preserve symbolic links:
	   (cd "$vnmrsystem"/user_templates; tar cf - $file | (cd "$cur_homedir"/vnmrsys; tar xfBp -))
    	   if test $as_root = "y"
    	   then
        	chown -R $name_add "$cur_homedir"/vnmrsys/$file
        	chgrp -R $nmr_group "$cur_homedir"/vnmrsys/$file
    	   else
        	chgrp -R $nmr_group "$cur_homedir"/vnmrsys/$file
    	   fi
	   if [ $file = "ib_initdir" ]
	   then
	        rm -f "$cur_homedir"/vnmrsys/aip_initdir
	        ln -s ib_initdir "$cur_homedir"/vnmrsys/aip_initdir
    	        if test $as_root = "y"
    	        then
        	     chown -h $name_add "$cur_homedir"/vnmrsys/aip_initdir
        	     chgrp -h $nmr_group "$cur_homedir"/vnmrsys/aip_initdir
    	        else
        	     chgrp -h $nmr_group "$cur_homedir"/vnmrsys/aip_initdir
    	        fi
	   fi
           echo "  $file updated from templates."
	fi
    elif [ $file = "pulsecal" ]
    then
	if test -d "$vnmrsystem"/imaging
	then
	   if test ! -f "$cur_homedir"/vnmrsys/$file
	   then
    	        if test $intera_unix = "y"
    	        then
        	    nnl_echo  "OK to create $file (y or n) [y]: "
        	    read yesno
        	    if test x$yesno = "xn" -o x$yesno = "xno"
        	    then
        	        continue
        	    fi
	        fi
		pcaldate=`date +%m%d%y`
		echo "     PULSE CALIBRATION VALUES\n" > $cur_homedir/vnmrsys/$file
		echo "     rfcoil      length        flip       power      date\n" >> $cur_homedir/vnmrsys/$file
		echo "     main             1         180          30     $pcaldate" >> $cur_homedir/vnmrsys/$file
		echo "  pulsecal file created."
    	        if test $as_root = "y"
    	        then
        	     chown -h $name_add "$cur_homedir"/vnmrsys/pulsecal
        	     chgrp -h $nmr_group "$cur_homedir"/vnmrsys/pulsecal
    	        else
        	     chgrp -h $nmr_group "$cur_homedir"/vnmrsys/pulsecal
    	        fi
	   fi
	fi
    fi
done
if test -d "$vnmrsystem"/user_templates/ib_initdir
then
    if test ! -d "$cur_homedir"/vnmrsys/prescan
    then
       mkdir "$cur_homedir"/vnmrsys/prescan
       if test $as_root = "y"
       then
          chown -h $name_add "$cur_homedir"/vnmrsys/prescan
          chgrp -h $nmr_group "$cur_homedir"/vnmrsys/prescan
       else
          chgrp -h $nmr_group "$cur_homedir"/vnmrsys/prescan
       fi
    fi
fi
# End Imaging Files
}

######################################
#  start of main, Main, MAIN,  script
######################################

wrkng_dir=`pwd`
if (test x$vnmrsystem = "x")
then
   vnmrsystem="/vnmr"
   . /vnmr/user_templates/.vnmrenvsh
fi

set_system_stuff

curr_user=`id | sed -e 's/[^(]*[(]\([^)]*\)[)].*/\1/'`
new_account="n"
user_name=$1
user_dir="$2"     # /home
user_group=$3
user_update=$4  #"y" or "n", or "appmode"
system_dir=$5    # /vnmr
date=`date +%y%m%d.%H:%M`

if [ $# -ge 4 -a x$ostype = "xDarwin" ]  #Called from Java
then
#  exit if called from java and system is a Mac
   exit 0
fi

# cmd /usr/local/bin/sudo /usr/varian/sbin/makeuser $user_name $HOME nmr appmode
# run by vnmrj adm (when saving user) to set vnmrbg appmode
if [ x$user_update = "xappmode" ]
then
  if [ x$ostype = "xInterix" ] 
  then
      # for Interix just call Vnmrbg as the user, assumption is one user and they installled VnmrJ
      /vnmr/bin/Vnmrbg -mback -n1 'setappmode'
  else
      echo "Wrong OS: $ostype"
  fi
  exit 0
fi

if [ $# -ge 4 -a  x$user_update = "xautoupdate" ]
then
   as_root="y"
   intera_unix="n"
   intera_vnmr="n"
   user_update="y"  # 
   curr_user="$user_name"
   cur_homedir="$user_dir/$user_name"
   name_add="$user_name"
   nmr_group="$user_group"
   # update_dotfiles   # done directly by Windows installer
   create_uservnmrsys
   create_imagingfile
   clean_userseqlib
   clean_userpsg
   make_usersubdirs
   make_userexp1
   make_userdata
   make_update_global
   make_pboxfiles
   clean_persistence
   cd "$wrkng_dir"
   exit 0
fi

if [ x$ostype = "xInterix" ] 
then
	rootuser=`/vnmr/bin/isAdmin "$curr_user" | awk '{print $1}'`
	if [ x$rootuser != "x" ]
	then 
	    as_root="y"
	fi
elif [ x$curr_user = "xroot" ]
then
    as_root="y"
fi

exit 0

#    #  Username now in password, group file
#    cur_homedir=`get_homedir $name_add`
#    if [ x"$cur_homedir" = "x" -a x$ostype = "xInterix" ]
#    then
#	     cur_homedir="$user_dir/$name_add"
#    fi
#
#    if [ x$ostype = "xInterix" ]
#    then
#	     chown "$curr_user" "$cur_homedir"
#	     if [ -d "$cur_homedir/vnmrsys" ]
#	     then
#	         chown "$curr_user" "$cur_homedir/vnmrsys"
#	     fi
#    fi
#
#    #  Make home directory if not present
#    if [ ! -d "$cur_homedir" ]
#    then
#        if [ x`make_homedir` = "x1" ]
#        then
#            exit 1
#        fi
#
#	# for interix, set $HOME
#	if [ x$ostype = "xInterix" ]
#	then
#	    cur_homedir_win=`unixpath2win "$cur_homedir"`
#	    net user "$user_name" /HOMEDIR:"$cur_homedir_win"
#	fi
#
#    #  Ask if OK to update account

sys_user=`ls -l "$vnmrsystem"/vnmrrev | awk '{ printf $3}'`

intera_unix="n"
intera_vnmr="n"


if [ x$ostype="xDarwin" -a $# -eq 2 -a $2="y"  ]
then
  intera_vnmr="n"
else
if [ $# -lt 4 ]
then
  
  nnl_echo  "Automatically configure user $name_add account (y or n) [y]: "
  read yesno
  if test x$yesno = "xn" -o x$yesno = "xno"
  then
     nnl_echo  "Automatically configure UNIX environment (.files) (y or n) [y]: "
     read yesno
     if test x$yesno = "xn" -o x$yesno = "xno"
     then
        intera_unix="y"
     fi
     nnl_echo  "Automatically configure VNMR directories (y or n) [y]: "
     read yesno
     if test x$yesno = "xn" -o x$yesno = "xno"
     then
        intera_vnmr="y"
     fi
  fi
fi
fi

cd "$cur_homedir"
if [ x$ostype = "xIRIX" -o x$ostype = "xLinux" -o x$ostype = "xDarwin" ]
then
   intera_CDE="n"
elif [ x$ostype = "xInterix" ]
then
   intera_CDE="n"
   intera_unix="n"
fi

exit 0

# update_dotfiles 

create_uservnmrsys

create_imagingfile

clean_userseqlib

clean_userpsg

make_usersubdirs

clean_persistence

make_userexp1

make_userdata

make_update_global

make_pboxfiles

#if [ x$ostype = "xLinux" ]
#then
#   cd "$cur_homedir"
#   if [ ! -d Desktop ]
#   then
#      mkdir Desktop
#      if test $as_root = "y"
#      then
#         chown $name_add Desktop
#         chgrp $nmr_group Desktop
#      fi
#   fi
#   cd Desktop
#   cp "$vnmrsystem"/user_templates/vnmrj.desktop vnmrj.desktop
#   if test $as_root = "y"
#   then
#      chown "$name_add":$nmr_group vnmrj.desktop
#   fi
#   if [ x$name_add = x$sys_user ]
#   then
#      cp "$vnmrsystem"/user_templates/vnmrjadmin.desktop vnmrjadmin.desktop
#      if test $as_root = "y"
#      then
#         chown "$name_add":$nmr_group vnmrjadmin.desktop
#      fi
#   fi
#   if [ -f "$vnmrsystem"/templates/vnmrj/properties/labelResources_ja.properties ]
#   then
#      cp "$vnmrsystem"/user_templates/vnmrjja.desktop vnmrjja.desktop
#      if test $as_root = "y"
#      then
#         chown "$name_add":$nmr_group vnmrjja.desktop
#      fi
#   fi
#   if [ -f "$vnmrsystem"/templates/vnmrj/properties/labelResources_zh_CN.properties ]
#   then
#      cp "$vnmrsystem"/user_templates/vnmrjzh.desktop vnmrjzh.desktop
#      if test $as_root = "y"
#      then
#         chown "$name_add":$nmr_group vnmrjzh.desktop 
#      fi
#   fi
#fi
#
#if [ x$ostype = "xInterix" ]
#then
#   chmod -R 775 "$cur_homedir"/vnmrsys
#fi
#
#if test -d templates/vnmrj/properties
#then
#    if [ x$ostype = "xInterix" ]
#    then
#	chmod 755 templates/vnmrj/properties
#	chown "$curr_user" templates/vnmrj/properties
#	prop_files=`ls templates/vnmrj/properties`
#	for prop_file in  $prop_files
#	do
#	    chown -R "$curr_user" "templates/vnmrj/properties/$prop_file"
#	done
#	rm -rf templates/vnmrj/properties
#    else
#	rm -rf templates/vnmrj/properties 
#    fi
#    echo "  templates/vnmrj/properties directory removed."
#fi
#
#if [ x$ostype = "xInterix" ] 
#then
#    chown "$name_add" "$cur_homedir"
#    chown "$name_add" "$cur_homedir/vnmrsys"
#    chown "$name_add" "$cur_homedir/vnmrsys/global"
#fi
#
echo ""
echo "Updating for $name_add complete"
echo ""
