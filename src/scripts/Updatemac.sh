: '@(#)Updatemac.sh 22.1 03/24/08 2003-2004 '
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
#
#!/bin/sh
#
# env parameters
# sccsdir do get sources  (typically /vsccs/sccs)
# macobjdir  do compile results (typically /vobj/mac)
# sccsjdir sccs for java files (typically /vsccs/jsccs)
# autolog toggle for asking questions about log files (yes or no)

OStype=`uname -s`
m_arch=MacOs
time_stmp=`date '+%m%d%y-%H:%M'`
lognam=Objlog_${m_arch}_${time_stmp}
Pwd=`pwd`
PATH=$PATH:/usr/X11R6/bin
export PATH

if test $OStype != "Darwin"
then
   echo "This program expects to run on a Mac"
   exit
fi

if [ -z $sccsdir ]
then 
   sccsdir=/vsccs/sccs
   export sccsdir
fi

if [ -z $sccsjdir ]
then 
   sccsjdir=/vsccs/jsccs
   export sccsjdir
fi

# Needed for some include files (makediffparams)
if [ -z $lnxobjdir ]
then 
   lnxobjdir=/vobj/lnx
   export lnxobjdir
fi

if [ -z $macobjdir ]
then 
   macobjdir=${Pwd}/mac
   logdir=$macobjdir
   if [  -d $macobjdir ]
   then 
       mv $macobjdir ${macobjdir}.old
   fi
   mkdir $macobjdir
else
   if [ x$macobjdir = "x/vobj/mac" -o  x$macobjdir = "x/vol/vobj/mac" ]
   then
       echo -n "Updating content of $macobjdir directory, y/n ? [n]:"
       read answer
       if [ x$answer != "xy" -a x$answer != "xyes" ]
       then
          echo
          echo "Exiting   $0 --------"
          echo
          exit
       fi
       logdir=$macobjdir
   else
       if [ -d $macobjdir ]
       then
           logdir=$macobjdir
       else
           echo "The directory $macobjdir does not exist"
           exit
       fi
   fi
fi

# ISO quality record log
logpath=${logdir}/$lognam

make_objdir() {
    #set -x
    category=$1
    if test ! -d ${mac_proglib_dir}/$category 
    then 
        echo "Creating ${mac_proglib_dir}/$category directory."
        mkdir ${mac_proglib_dir}/$category;
    fi
    #set +x
}

log_line(){
    echo " $1 " | tee -a $logpath
}

#-------------------- MAIN Main main --------------------------------
echo " "
echo " "
echo "Writing ISO Quality Record to: $logpath"

log_line " "
log_line "--------------- $0 --------------- "
log_line " "
log_line "Date       : `date`"
log_line " "
log_line "Host name  : `uname -n`"
log_line "Host arch  : $m_arch"
log_line "Host OS    : $OStype"
log_line "OS version : `uname -r`"
log_line " "

# Shared library versions
ddl_ver=0.0
magical_ver=0.0

log_line "--------------- Mac recompilation --------------- "
log_line " "

mac_proglib_dir=$macobjdir/proglib
if test ! -d $mac_proglib_dir
then 
   mkdir $mac_proglib_dir
fi

#RULESET=LINUX; export RULESET;

target="MACOS"
categories="ncomm vnmrbg ddl bin psg psglib"
acqfilenames="expproc sendproc recvproc procproc nautoproc infoproc roboproc"
categories="vnmrbg bin psg tcl"
categories="bin psg tcl"
categories="vnmrbg bin psg"

echo "Mac proglib dir = $mac_proglib_dir"
echo "Target            = $target"
echo "Categories        = $categories"

echo "---------"
which gcc
which make
which gmake
which as
which ld
echo "---------"

st_time=`date '+%H:%M:%S'`
for file in $categories
do
   makefile=make${file}.mac
   echo "test make file  $sccsdir/$file/SCCS/s.$makefile"
   if test ! -f $sccsdir/$file/SCCS/s.$makefile
   then
      makefile=make${file}.lnx
   fi

   log_line " "
   log_line "    CATEGORY:  $file 	 IN 	  ${mac_proglib_dir}/$file"
   log_line "               using $makefile"

   make_objdir $file
   ( cd $mac_proglib_dir/$file;
     sccs -d$sccsdir/$file get $makefile;
     make -f $makefile $target;
   )
done

#-----------------------------------------
#Tcl specials
#cd ${mac_proglib_dir}/tcl
#grep "vnmr\/tcl" spingen.tcl 2>&1 > /dev/null
#if [ $? -eq 0 ]
#then 
#     chmod 666 spingen.tcl
#     sed 's/vnmr\/tcl/usr/' spingen.tcl > tmpxx
#     mv tmpxx spingen.tcl
#fi
#cp /vcommon/tclPro1.5.lnx/linux-ix86/lib/tbcload1.3 .
#/vcommon/tclPro1.5.lnx/linux-ix86/bin/procomp spincad.tcl spingen.tcl docker.tcl
#/sw/vbin/tclfixtbc spincad.tbc spingen.tbc docker.tbc
#-----------------------------------------

log_line ""
log_line "Start Time :  $st_time"
log_line "End Time   :  `date '+%H:%M:%S'`"
