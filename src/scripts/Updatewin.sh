: '@(#)Updatewin.sh 22.1 03/24/08 2003-2005 '
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
#
# env parameters
# sourcedir do save log files (typically /common)
# sccsdir do get sources  (typically /vsccs/sccs)
# winobjdir  do compile results (typically /vobj/win)
# solobjdir solaris object directory (typically /vobj/sol)
# commondir non-platform specific files (typically /vcommon)
# sccsjdir sccs for java files (typically /vsccs/jsccs)
# autolog toggle for asking questions about log files (yes or no)


OStype=`uname -s`
m_arch=`uname -m`
time_stmp=`date '+%m%d%y_%H_%M'`
lognam=Objlog_${m_arch}_${time_stmp}
Pwd=`pwd`
gccbin="/opt/gcc.3.3/bin"

if test $OStype != "Interix"
then
   echo "This program expects to run on a Windows computer"
#   exit
fi

#if [ -z $sccsdir ]
#then 
#   sccsdir=/vsccs/sccs
#fi

#if [ -z $sccsjdir ]
#then 
#   sccsjdir=/vsccs/jsccs
#fi

if [ x$winobjdir = "x" ]
then 
   #winobjdir=${Pwd}/win
   winobjdir=$vobjdir/win
   logdir=$winobjdir
   if [  -d $winobjdir ]
   then 
       mv $winobjdir ${winobjdir}.old
   fi
   mkdir $winobjdir
else
   if [ x$winobjdir = "x/vobj/win" -o  x$winobjdir = "x/vol/vobj/win" ]
   then
       echo -n "Updating content of $winobjdir directory, y/n ? [n]:"
       read answer
       if [ x$answer != "xy" -a x$answer != "xyes" ]
       then
          echo
          echo "Exiting   $0 --------"
          echo
          exit
       fi
       if [ -z $sourcedir ]
       then
           logdir=/common/complogs
       else
           logdir=${sourcedir}/complogs
       fi
   else
       if [ -d $winobjdir ]
       then
           logdir=$winobjdir
       else
           echo "The directory $winobjdir does not exist"
           exit
       fi
   fi
fi

# ISO quality record log
logpath=${logdir}/$lognam

make_objdir() {
    #set -x
    category=$1
    if test ! -d ${win_proglib_dir}/$category 
    then 
        echo "Creating ${win_proglib_dir}/$category directory."
        mkdir ${win_proglib_dir}/$category;
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
ddl_ver=0.1
magical_ver=0.0
port3_ver=1.1
f2c_ver=1.1

log_line "--------------- Windows recompilation --------------- "
log_line " "

win_proglib_dir=$winobjdir/proglib
if test ! -d $win_proglib_dir
then 
   mkdir $win_proglib_dir
fi

win_lib_dir=$winobjdir/lib
if test ! -d $win_lib_dir
then
   echo "Creating $win_lib_dir directory.";
   mkdir $win_lib_dir;
fi

#RULESET=LINUX; export RULESET;

target="WINDOWS"
categories="ddl psglib"
#categories="vnmrbg ncomm nvpsg tcl bin expproc sendproc recvproc procproc infoproc atproc nautoproc stat roboproc psglib kpsglib accounting fdm stars nvexpproc nvsendproc nvrecvproc nvinfoproc nvflash 3D ddl ib csi"
# categories="vnmrbg ncomm scripts bin psg expproc infoproc nautoproc procproc recvproc sendproc nvpsg psglib 3D nvexpproc nvrecvproc nvsendproc nvinfoproc nvlocki stat roboproc"
categories="nvexpproc nvrecvproc nvsendproc nvinfoproc nautoproc procproc nvlocki stat roboproc ncomm vnmrbg scripts bin 3D nvpsg psglib"

echo "Windows proglib dir = $win_proglib_dir"
echo "Target            = $target"
echo "Categories        = $categories"
echo "---------"
#which gcc
#which make
#which gmake
#which as
#which ld
echo "---------"

st_time=`date '+%H:%M:%S'`
for file in $categories
do
   case x$file in
      xbin )
         makefile=make${file}.win
         echo "test make file  $sccsdir/$file/SCCS/s.$makefile"
         if test ! -f $sccsdir/$file/SCCS/s.$makefile
         then
            makefile=make${file}
         fi

	 log_line " "
       	 log_line "    CATEGORY:  $file sdf		 IN 	  ${win_proglib_dir}/$file"
       	 log_line " "


       	 make_objdir $file
       	 ( cd $win_proglib_dir/$file; rm -rf *;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:/sw/vbin:$gccbin:$path";
           sccs -d$sccsdir/$file get $makefile;
           make -f $makefile $target 1>>$logpath 2>&1;
           sccs -d$sccsdir/$file get logonAsService.exe;
       	 )

         ;;

      xddl )
         makefile=make${file}.win

	 log_line " "
       	 log_line "    CATEGORY:  $file 	 IN 	  ${win_proglib_dir}/$file"
       	 log_line " "

       	 make_objdir $file
       	 ( cd $win_proglib_dir/$file;  rm -rf *;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:/sw/vbin:$gccbin:$path";
           sccs -d$sccsdir/$file get $makefile;
           make -f $makefile;
       	 )
         ( cd $win_lib_dir;
           rm -f libddl*;
           cp $win_proglib_dir/$file/libddl.a libddl.a;
           cp $win_proglib_dir/$file/libddl.so.$ddl_ver libddl.so.$ddl_ver;
           ln -s libddl.so.$ddl_ver libddl.so;
         )

         ;;

      xib )

	 log_line " "
       	 log_line "    CATEGORY:  $file 	 IN 	  ${win_proglib_dir}/$file"
       	 log_line " "

       	 make_objdir $file
       	 ( cd $win_proglib_dir/$file;  rm -rf *;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:/sw/vbin:$gccbin:$path";
	   sccs -d$sccsdir/$file get browser.sh;
           make browser;
           sccs -d$sccsdir/$file get makefdfgluer.win;
           make -f makefdfgluer.win;
           sccs -d$sccsdir/$file get makefdfsplit.win;
           make -f makefdfsplit.win;
           sccs -d$sccsdir/$file get makeparams.win;
           make -f makeparams.win;
           sccs -d$sccsdir/$file get makesis.win;
           make -f makesis.win;
       	 )
         magicaldir=$win_proglib_dir/$file/magical
         if test ! -d $magicaldir
         then
             echo "Creating `pwd`/magical directory.";
             mkdir $magicaldir;
         fi
         ( cd $magicaldir;
             sccs -d$sccsdir/$file get makemagical.win;
             make -f makemagical.win;
         )

         port3dir=$win_proglib_dir/$file/port3
         if test ! -d $port3dir
         then
             echo "Creating `pwd`/port3 directory.";
             mkdir $port3dir;
         fi
         ( cd $port3dir;
             sccs -d$sccsdir/$file get makeport3.win;
             make -f makeport3.win;
         )

         libf2cdir=$win_proglib_dir/$file/libf2c
         if test ! -d $libf2cdir
         then
             echo "Creating `pwd`/libf2c directory.";
             mkdir $libf2cdir;
         fi
         ( cd $libf2cdir;
             sccs -d$sccsdir/$file get makelibf2c.win;
             make -f makelibf2c.win;
         )

         ( cd $win_lib_dir;
             rm -f libmagical* libsis* libparams* libport3* libf2c*;
             cp $win_proglib_dir/$file/libsis.a libsis.a;
             cp $win_proglib_dir/$file/libparams.a libparams.a;
             cp $magicaldir/libmagical.a libmagical.a;
             cp $magicaldir/libmagical.so.$magical_ver libmagical.so.$magical_ver;
             ln -s libmagical.so.$magical_ver libmagical.so;
	     cp $port3dir/libport3.a libport3.a;
             cp $port3dir/libport3.so.$port3_ver libport3.so.$port3_ver;
             ln -s libport3.so.$port3_ver libport3.so;
	     cp $libf2cdir/libf2c.a libf2c.a;
             cp $libf2cdir/libf2c.so.$f2c_ver libf2c.so.$f2c_ver;
             ln -s libf2c.so.$f2c_ver libf2c.so;
         )

       	 ( cd $win_proglib_dir/$file;
             cp $win_lib_dir/libddl.a .;
             cp $win_lib_dir/libmagical.a .;
	     sccs -d$sccsdir/$file get make${file}.win;
             make -f make${file}.win
	 )

         ;;

      xcsi )

	 log_line " "
       	 log_line "    CATEGORY:  $file 	 IN 	  ${win_proglib_dir}/$file"
       	 log_line " "

	 ddldir=$win_proglib_dir/ddl
       	 if test ! -d $ddldir
         then
              echo "Creating $ddldir.";
              mkdir $ddldir;
	 fi
       	 ( cd $ddldir;  rm -rf *;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:/sw/vbin:$gccbin:$path";
           sccs -d$sccsdir/ddl get makeddl.win;
           make -f makeddl.win;
       	 )
	
	 ibdir=$win_proglib_dir/ib
       	 if test ! -d $ibdir
         then
              echo "Creating $ibdir.";
              mkdir $ibdir;
	 fi
       	 ( cd $ibdir;  rm -rf *;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:/sw/vbin:$gccbin:$path";
           sccs -d$sccsdir/ib get makeparams.win;
           make -f makeparams.win;
           sccs -d$sccsdir/ib get makesis.win;
           make -f makesis.win;
       	 )
         magicaldir=$win_proglib_dir/ib/magical
         if test ! -d $magicaldir
         then
             echo "Creating `pwd`/magical directory.";
             mkdir $magicaldir;
         fi
         ( cd $magicaldir;  rm -rf *;
             sccs -d$sccsdir/ib get makemagical.win;
             make -f makemagical.win;
         )
         ( cd $win_lib_dir;
             rm -f libmagical* libsis* libparams* libddl*;
             cp $ddldir/libddl.a libddl.a;
             cp $ddldir/libddl.so.$ddl_ver libddl.so.$ddl_ver;
             cp $ibdir/libsis.a libsis.a;
             cp $ibdir/libparams.a libparams.a;
             cp $magicaldir/libmagical.a libmagical.a;
             cp $magicaldir/libmagical.so.$magical_ver libmagical.so.$magical_ver;
             ln -s libddl.so.$ddl_ver libddl.so;
             ln -s libmagical.so.$magical_ver libmagical.so;
         )
       	 make_objdir $file
       	 ( cd $win_proglib_dir/$file;  rm -rf *;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:/sw/vbin:$gccbin:$path";
	   cp $win_lib_dir/libsis.a .;
           cp $win_lib_dir/libparams.a .;
           cp $win_lib_dir/libddl.a .;
           cp $win_lib_dir/libmagical.a .;
           sccs -d$sccsdir/$file get makecsi.win 
           make -f makecsi.win;
           sccs -d$sccsdir/$file get makeP_csi.win 
           make -f makeP_csi.win;
	 )
         ;;
	
	xscripts )
                makefile=make${file}
       
	        log_line " "
       	        log_line "    CATEGORY:  $file	 IN 	${win_proglib_dir}/$file"
       	        log_line " "

       	        make_objdir $file
       	        ( cd ${win_proglib_dir}/$file; rm -rf *;
                  PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:/sw/vbin:$gccbin:$path";
                  sccs -d$sccsdir/$file get $makefile;
                  make -f $makefile $target;
       	        )
	 ;;

	xkpsglib )
		makefile=make${file}

 		log_line " "
       	        log_line "    CATEGORY:  $file 	 IN 	  ${win_proglib_dir}/$file"
       	        log_line " "
	
		make_objdir $file
		( cd $win_proglib_dir/$file; rm -rf *;
                  PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:/sw/vbin:$gccbin:$path";
                  sccs -d$sccsdir/$file get $makefile;
                  make -f $makefile;
       	        )

	   ;;

	xstat )
		makefile=makeinfostat

 		log_line " "
       	        log_line "    CATEGORY:  $file 	 IN 	  ${win_proglib_dir}/$file"
       	        log_line " "
	
		make_objdir $file
		( cd $win_proglib_dir/$file;  rm -rf *;
                  PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:/sw/vbin:$gccbin:$path";
                  sccs -d$sccsdir/$file get $makefile;
                  make -f $makefile $target 1>>$logpath 2>&1;
       	        )

	   ;;

	xnvlocki )
		makefile=make${file}

 		log_line " "
       	        log_line "    CATEGORY:  $file 	 IN 	  ${win_proglib_dir}/$file"
       	        log_line " "
	
		make_objdir $file
		( cd $win_proglib_dir/$file; rm -rf *;
                  PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:/sw/vbin:$gccbin:$path";
                  sccs -d$sccsdir/bin get $makefile;
                  make -f $makefile $target 1>>$logpath 2>&1;
       	        )

	   ;;

      *)
         makefile=make${file}.win
         echo "test make file  $sccsdir/$file/SCCS/s.$makefile"
         if test ! -f $sccsdir/$file/SCCS/s.$makefile
         then
            makefile=make${file}
         fi

	 log_line " "
       	 log_line "    CATEGORY:  $file sdf		 IN 	  ${win_proglib_dir}/$file"
       	 log_line " "

       	 make_objdir $file
       	 ( cd $win_proglib_dir/$file; rm -rf *;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:/sw/vbin:$gccbin:$path";
           sccs -d$sccsdir/$file get $makefile;
           make -f $makefile $target 1>>$logpath 2>&1;
       	 )
         ;;
   esac
done

#-----------------------------------------
#Tcl specials
# cd ${win_proglib_dir}/tcl
# grep "vnmr\/tcl" spingen.tcl 2>&1 > /dev/null
# if [ $? -eq 0 ]
# then 
#      chmod 666 spingen.tcl
#      sed 's/vnmr\/tcl/usr/' spingen.tcl > tmpxx
#      mv tmpxx spingen.tcl
# fi
# cp $vcommondir/tcl.8.4.win/lib/lib*.a .
# /vcommon/tcl.8.4.win/linux-ix86/bin/procomp spincad.tcl spingen.tcl docker.tcl
# $swdir/vbin/tclfixtbc spincad.tbc spingen.tbc docker.tbc
#-----------------------------------------

log_line ""
log_line "Start Time :  $st_time"
log_line "End Time   :  `date '+%H:%M:%S'`"




