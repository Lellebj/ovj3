: '@(#)maninstall.sh 22.1 03/24/08 1999-2000 '
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
#!/bin/sh

getdirsize()
{
x=`pwd`
cd $1
du -sk * | awk 'BEGIN {sum=0} {sum=sum+$1} END  {printf sum}'
cd $x
}


##Vnmr Online manuals installation scripts.

##verify that user has the write permission
usr=`id | sed -e 's/[^(]*[(]\([^)]*\)[)].*/\1/'`

env | grep vnmrsystem > /dev/null
if [ $? -ne 0 ]
then
    echo ""
    echo "Please set the environment variable \"vnmrsystem\", then run $0 again."
    echo "Exiting $0 ..."
    echo ""
    exit
fi

##Get absolute path of vnmrsystem
if [ -h $vnmrsystem ]
then
    abs_path=`ls -l $vnmrsystem | awk '{print $NF}'`
else
    abs_path=$vnmrsystem
fi

VNMR_SYSTEM=$abs_path
if [ ! -d $VNMR_SYSTEM ]
then
   echo "$VNMR_SYSTEM does not exist"
   echo "Aborting $0 ..."
   exit
fi

progname=`/bin/basename $0`
cmd_dir=`/usr/bin/dirname $0`
firstchar=`echo $0 | cut -c1-1`
if [ x$firstchar = "x/" ]  #absolute path
then
   MAN_SRC_DIR=$cmd_dir    #This should be /cdrom/cdrom0 or /cdrom/vnmr_online
else
   if [ x$firstchar = "x." ]  #relative path
   then
       if [ x$cmd_dir = "x." ]
       then
           MAN_SRC_DIR=`pwd`
       fi
   else
       if [ x$cmd_dir = "x." ]
       then
           cmd_dir=
       fi
       MAN_SRC_DIR=`pwd`/${cmd_dir}
   fi
fi

if [ ! -d $MAN_SRC_DIR/.online ]
then
    MAN_SRC_DIR="/media/cdrecorder"
    if [ ! -d $MAN_SRC_DIR/.online ]
    then
        MAN_SRC_DIR="/media/cdrecorder1"
        if [ ! -d $MAN_SRC_DIR/.online ]
        then
            MAN_SRC_DIR="/media/cdrom"
            if [ ! -d $MAN_SRC_DIR/.online ]
            then
                echo "Cannot find $MAN_SRC_DIR/.online, exiting."
                exit
            fi
        fi
    fi
fi

vnmr_owner=`ls -lL $VNMR_SYSTEM/vnmrrev | awk '{print $3}'`

##If the user isn't neither vnmr-owner nor root
if [ x$usr != x$vnmr_owner -a x$usr != "xroot" ]
then
    touch $VNMR_SYSTEM/if_see_please_remove_me 2> /dev/null
    if [ $? -eq 0 ]
    then
        ##Having the write permission
        rm -f $VNMR_SYSTEM/if_see_please_remove_me
    else
        ##Do not have the write permission
        echo ""
        echo "Current user \"$USER\" does not have permission to write to the $VNMR_SYSTEM directory."
        echo "You must become either \"root\" or \"$vnmr_owner\" to install Vnmr Online Manuals"

        echo ""
        echo "Enter:"
        echo "1 for root"
        echo "2 for $vnmr_owner"
        echo "3 for Quit"
        echo "Which one (1,2 or 3): "
        read ans
        case x$ans in
               "x1") prev_user="root"
                     ;;
               "x2") prev_user=$vnmr_owner
                     ;;
               "x3") echo ""
                     echo "Exiting $0 ..."
                     echo ""
                     exit
                     ;;  
        esac

        result=1
        strike=0    #3 strikes, you will be out.
        while [ $result -eq 1 -a  $strike -ne 3 ]
        do
           echo ""
           echo "Please enter \"$prev_user\"'s password"
           su $prev_user -c ${MAN_SRC_DIR}/${progname}
           result=$?
           strike=`expr $strike + 1`
           echo " "
        done
        if [ $strike -eq 3 ]; then
            echo "Access denied. Switch user to either $vnmr_owner or root."
            echo "Run $0 program again "
            echo ""
        fi
 
        #Because "maninstall" be recursively called in the while loop above,
        #so, whatever happened, need to exit here
        exit
    fi
fi

acro_size=0
ostype=`uname -s`
 
if [ x$ostype = "xAIX" ]
then 
    this_acrobat=".acrobat_aix"
    cdstrg="install_dir=/cdrom/.acrobat_aix/Reader"
    acro_size=`getdirsize ${MAN_SRC_DIR}/$this_acrobat`
    DIR_CP="cp -r"

elif [ x$ostype = "xIRIX" ]
then
    this_acrobat=".acrobat_irix"
    cdstrg="install_dir=/CDROM/.acrobat_irix/Reader"
    acro_size=`getdirsize ${MAN_SRC_DIR}/$this_acrobat`
    DIR_CP="cp -r"

elif [ x$ostype = "xLinux" ]
then
    this_acrobat="none"
    cdstrg="none"
    DIR_CP="cp -rH"

elif [ x$ostype = "xSunOS" ]
then
    osver=`uname -r`
    if [ $osver -ge 5.0 ]
    then
        this_acrobat=".acrobat_sol"
        cdstrg="install_dir=/cdrom/cdrom0/.acrobat_sol/Reader"
        ostype="SOLARIS"
        acro_size=`getdirsize ${MAN_SRC_DIR}/$this_acrobat`
        DIR_CP="cp -r"
    else
        echo ""
        echo "The Vnmr manual viewer does not support $ostype"
        echo ""
        exit
    fi
else
    echo ""
    echo "The Vnmr manual viewer does not support $ostype"
    echo ""
    exit
fi

##Get available disk-space
flg=0
while [ $flg -eq 0 ]
do
   if [ x$ostype = xIRIX ]
    then
       avail_size=`df -k | awk ' BEGIN {awkName="'$abs_path'"}
                             { if ($7==awkName) print $5 } '`
   else
       avail_size=`df -k | awk ' BEGIN {awkName="'$abs_path'"}
                             { if ($6==awkName) print $4 } '`
   fi
   if [ x$avail_size != "x" ]
   then  
       flg=1
   else  
       abs_path=`dirname $abs_path`  #go up one level, then check again
   fi 
done
 
#man_cons=""
#console=`sed -n '3p' $VNMR_SYSTEM/vnmrrev | awk 'BEGIN { FS = "." } { print $1 }'`
#if [ x$console = "xuplus" -o x$console = "xVXR-S" ]
#then
#     man_cons="unity"
#else
#     man_cons=$console
#fi
#
#if [ x$console = "xsgi" ]
#then
#     man_cons="inova"
#fi
man_cons="pdfs"

load_jhelp="n"
#cd $VNMR_SYSTEM
#if [ -f java/vnmrj.jar ]
#then
#   load_jhelp="y"
#fi
#
##Get manuals size 
man_size=`getdirsize ${MAN_SRC_DIR}/.online/$man_cons`
req_size=`expr $acro_size + $man_size`
if [ x$load_jhelp = "xy" ]
then
   jhelp_size=`getdirsize ${MAN_SRC_DIR}/.jhelp`
   req_size=`expr $req_size + $jhelp_size`
fi

if [ $avail_size -lt $req_size ]
then 
     echo ""
     echo "   NOT enough disk-space ..."
     echo "   Vnmr Online Manuals for \"$man_cons\" requires $req_size MB of disk space"
     echo "   The current mounted partition \"$abs_path\" only has $avail_size MB available"
     echo "   Exiting $0 ..."
     echo ""
     exit
fi

cd $VNMR_SYSTEM
if [ -d online ]
then 
    rm -rf online
fi
mkdir online


if [ x$ostype = "xLinux" ]
then
    if [ ! -x /usr/bin/acroread ]
    then
        rpm -i  ${MAN_SRC_DIR}/.acrobat_lnx/acroread-*i386.rpm
    fi

else
    echo ""
    echo " Installing Acrobat Reader for $ostype ..."
    cd $MAN_SRC_DIR
    tar -cf - $this_acrobat | (cd $VNMR_SYSTEM/online; tar xfBp -)
    ( cd $VNMR_SYSTEM/online;
      mv -f $this_acrobat acrobat 2>/dev/null
      rm -rf $this_acrobat
    )
 
    cd $VNMR_SYSTEM/online/acrobat/bin
 
    #cdstrg="install_dir=/cdrom/cdrom0/.acrobat_sol/Reader"
    strg="install_dir=${VNMR_SYSTEM}/online/acrobat/Reader"
    awk ' BEGIN { NewVal="'$strg'"
                  CdVal="'$cdstrg'"
                }
          {  
             if ($1 != CdVal) print
             else  print NewVal
          }  
        ' < acroread > beremoved
 
    mv -f beremoved acroread
    chmod 755 acroread
fi

cd $VNMR_SYSTEM/online
mkdir online

echo "" 
echo " Installing VnmrJ Online Manuals (PDF)..."
$DIR_CP  $MAN_SRC_DIR/.online/$man_cons/*  online 

if [ x$man_cons = "xvnmrs" -a -d $VNMR_SYSTEM/menulib/menulib.imaging ]
then
   $DIR_CP  $MAN_SRC_DIR/.online/imaging/*  online
fi

cd $VNMR_SYSTEM
if [ x$load_jhelp = "xy" ]
then
   rm -rf jhelp
   mkdir jhelp
   echo ""
   echo " Installing VnmrJ Help ..."
   $DIR_CP $MAN_SRC_DIR/.jhelp/* jhelp
fi

if [ x$usr = "xroot" ]
then

   nmr_adm=`ls -l $VNMR_SYSTEM/vnmrrev | awk '{print $3}'`
   nmr_grp=`ls -l $VNMR_SYSTEM/vnmrrev | awk '{print $4}'`

   chown -R $nmr_adm  $VNMR_SYSTEM/online
   chgrp -R $nmr_grp  $VNMR_SYSTEM/online

  if [ x$load_jhelp = "xy" ]
   then
      chown -R $nmr_adm  $VNMR_SYSTEM/jhelp
      chgrp -R $nmr_grp  $VNMR_SYSTEM/jhelp
   fi
fi
          
echo ""
echo " -------- D O N E -------- "
echo ""
