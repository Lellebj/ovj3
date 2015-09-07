: '@(#)Updatelnx.sh 22.1 03/24/08 2003-2004 '
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
#!/bin/sh
#
# env parameters
# sourcedir do save log files (typically /common)
# sccsdir do get sources  (typically /vsccs/sccs)
# lnxobjdir  do compile results (typically /vobj/lnx)
# solobjdir solaris object directory (typically /vobj/sol)
# commondir non-platform specific files (typically /vcommon)
# sccsjdir sccs for java files (typically /vsccs/jsccs)
# autolog toggle for asking questions about log files (yes or no)

OStype=`uname -s`
m_arch=`uname -m`
time_stmp=`date '+%m%d%y-%H:%M'`
lognam=Objlog_${m_arch}_${time_stmp}
Pwd=`pwd`

if test $OStype != "Linux"
then
   echo "This program expects to run on a Linux computer"
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

if [ -z $solobjdir ]
then 
   solobjdir=/vobj/sol
   export solobjdir
fi

if [ -z $nddsdir ]
then 
   nddsdir=/sw/NDDS/ndds.3.1b.rev3
   export nddsdir
fi

if [ -z $nddsgendir ]
then 
   nddsgendir=/sw/NDDS/ndds.3.1b.rev3
   export nddsgendir
fi

if [ -z $vcommondir ]
then 
   vcommondir=/vcommon
   export vcommondir
fi

if [ -z $lnxjredir ]
then 
   lnxjredir=/vcommon/JRE.linux
   export lnxjredir
fi

if [ -z $swbindir ]
then 
   swbindir=/sw/vbin
   export swbindir
fi

if [ -z $lnxobjdir ]
then 
   lnxobjdir=${Pwd}/lnx
   export lnxobjdir
   logdir=$lnxobjdir
   if [  -d $lnxobjdir ]
   then 
       mv $lnxobjdir ${lnxobjdir}.old
   fi
   mkdir $lnxobjdir
else
   if [ x$lnxobjdir = "x/vobj/lnx" -o  x$lnxobjdir = "x/vol/vobj/lnx" ]
   then
       echo -n "Updating content of $lnxobjdir directory, y/n ? [n]:"
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
       if [ -d $lnxobjdir ]
       then
           logdir=$lnxobjdir
       else
           echo "The directory $lnxobjdir does not exist"
           exit
       fi
   fi
fi

# ISO quality record log
logpath=${logdir}/$lognam

make_objdir() {
    #set -x
    category=$1
    if test ! -d ${lnx_proglib_dir}/$category 
    then 
        echo "Creating ${lnx_proglib_dir}/$category directory."
        mkdir ${lnx_proglib_dir}/$category;
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

log_line "--------------- Linux recompilation --------------- "
log_line " "

lnx_proglib_dir=$lnxobjdir/proglib
if test ! -d $lnx_proglib_dir
then 
   mkdir $lnx_proglib_dir
fi

lnx_lib_dir=$lnxobjdir/lib
if test ! -d $lnx_lib_dir
then
   echo "Creating $lnx_lib_dir directory.";
   mkdir $lnx_lib_dir;
fi

#RULESET=LINUX; export RULESET;

target="LINUX"
# categories that can be compiled with the ndds 4x option 
# categories="nvexpproc nvsendproc nvrecvproc nvinfoproc nvflash nvacq"
#
echo "Linux proglib dir = $lnx_proglib_dir"
categories="ddl psglib"
categories="vnmrbg ncomm psg nvpsg kpsg tcl bin expproc sendproc recvproc procproc infoproc atproc nautoproc stat roboproc psglib kpsglib accounting fdm stars nvexpproc nvsendproc nvrecvproc nvinfoproc nvflash nvacq3x nvacq nvlocki 3D dicom dicom_store ddl ib csi 3Dimg lcpeaks backproj xrecon"
#categories="nvlocki"

# categories that can be compiled with the ndds 4x option 
# categories="nvexpproc nvsendproc nvrecvproc nvinfoproc nvflash nvacq"

echo "Linux proglib dir = $lnx_proglib_dir"
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
   case x$file in
      xddl )
         makefile=make${file}.lnx

	 log_line " "
       	 log_line "    CATEGORY:  $file 	 IN 	  ${lnx_proglib_dir}/$file"
       	 log_line " "

       	 make_objdir $file
       	 ( cd $lnx_proglib_dir/$file;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:$swbindir:$path";
           sccs -d$sccsdir/$file get $makefile;
           make -f $makefile;
       	 )
         ( cd $lnx_lib_dir;
           rm -f libddl*;
           cp $lnx_proglib_dir/$file/libddl.a libddl.a;
           cp $lnx_proglib_dir/$file/libddl.so.$ddl_ver libddl.so.$ddl_ver;
           ln -s libddl.so.$ddl_ver libddl.so;
         )
         ;;
      xib )

	 log_line " "
       	 log_line "    CATEGORY:  $file 	 IN 	  ${lnx_proglib_dir}/$file"
       	 log_line " "

       	 make_objdir $file
       	 ( cd $lnx_proglib_dir/$file;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:$swbindir:$path";
	   sccs -d$sccsdir/$file get browser.sh;
           make browser;
           sccs -d$sccsdir/$file get makefdfgluer.lnx;
           make -f makefdfgluer.lnx;
           sccs -d$sccsdir/$file get makefdfsplit.lnx;
           make -f makefdfsplit.lnx;
           sccs -d$sccsdir/$file get makeparams.lnx;
           make -f makeparams.lnx;
           sccs -d$sccsdir/$file get makesis.lnx;
           make -f makesis.lnx;
       	 )
         magicaldir=$lnx_proglib_dir/$file/magical
         if test ! -d $magicaldir
         then
             echo "Creating `pwd`/magical directory.";
             mkdir $magicaldir;
         fi
         ( cd $magicaldir;
             sccs -d$sccsdir/$file get makemagical.lnx;
             make -f makemagical.lnx;
         )

         port3dir=$lnx_proglib_dir/$file/port3
         if test ! -d $port3dir
         then
             echo "Creating `pwd`/port3 directory.";
             mkdir $port3dir;
         fi
         ( cd $port3dir;
             sccs -d$sccsdir/$file get makeport3.lnx;
             make -f makeport3.lnx;
         )

         libf2cdir=$lnx_proglib_dir/$file/libf2c
         if test ! -d $libf2cdir
         then
             echo "Creating `pwd`/libf2c directory.";
             mkdir $libf2cdir;
         fi
         ( cd $libf2cdir;
             sccs -d$sccsdir/$file get makelibf2c.lnx;
             make -f makelibf2c.lnx;
         )

         ( cd $lnx_lib_dir;
             rm -f libmagical* libsis* libparams* libport3* libf2c*;
             cp $lnx_proglib_dir/$file/libsis.a libsis.a;
             cp $lnx_proglib_dir/$file/libparams.a libparams.a;
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

       	 ( cd $lnx_proglib_dir/$file;
             cp $lnx_lib_dir/libddl.a .;
             cp $lnx_lib_dir/libmagical.a .;
	     sccs -d$sccsdir/$file get make${file}.lnx;
             make -f make${file}.lnx
	 )

         ib_initdir=$lnx_proglib_dir/$file/ib_initdir
         if test ! -d $ib_initdir
         then
             echo "Creating `pwd`/ib_initdir directory.";
             mkdir $ib_initdir;
         fi
         ( cd $ib_initdir;
             sccs -d$sccsdir/$file get makeib_initdir;
             make -f makeib_initdir linux;
             cd math/functions/src;
             ln -s $lnx_lib_dir/libf2c.so.$f2c_ver libf2c.so;
             ln -s $lnx_lib_dir/libport3.so.$port3_ver libport3.so;
             ln -s $lnx_lib_dir/libddl.so.$ddl_ver libddl.so;
             make;
             rm -f libf2c.so libport3.so libddl.so;
         )
         ;;
      xcsi )

	 log_line " "
       	 log_line "    CATEGORY:  $file 	 IN 	  ${lnx_proglib_dir}/$file"
       	 log_line " "

	 ddldir=$lnx_proglib_dir/ddl
       	 if test ! -d $ddldir
         then
              echo "Creating $ddldir.";
              mkdir $ddldir;
	 fi
       	 ( cd $ddldir;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:$swbindir:$path";
           sccs -d$sccsdir/ddl get makeddl.lnx;
           make -f makeddl.lnx;
       	 )
	
	 ibdir=$lnx_proglib_dir/ib
       	 if test ! -d $ibdir
         then
              echo "Creating $ibdir.";
              mkdir $ibdir;
	 fi
       	 ( cd $ibdir;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:$swbindir:$path";
           sccs -d$sccsdir/ib get makeparams.lnx;
           make -f makeparams.lnx;
           sccs -d$sccsdir/ib get makesis.lnx;
           make -f makesis.lnx;
       	 )
         magicaldir=$lnx_proglib_dir/ib/magical
         if test ! -d $magicaldir
         then
             echo "Creating `pwd`/magical directory.";
             mkdir $magicaldir;
         fi
         ( cd $magicaldir;
             sccs -d$sccsdir/ib get makemagical.lnx;
             make -f makemagical.lnx;
         )
         ( cd $lnx_lib_dir;
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
       	 ( cd $lnx_proglib_dir/$file;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:$swbindir:$path";
	   cp $lnx_lib_dir/libsis.a .;
           cp $lnx_lib_dir/libparams.a .;
           cp $lnx_lib_dir/libddl.a .;
           cp $lnx_lib_dir/libmagical.a .;
           sccs -d$sccsdir/$file get makecsi.lnx 
           make -f makecsi.lnx;
           sccs -d$sccsdir/$file get makeP_csi.lnx 
           make -f makeP_csi.lnx;
	 )
         ;;
      x3Dimg )

	 log_line " "
       	 log_line "    CATEGORY:  $file 	 IN 	  ${lnx_proglib_dir}/$file"
       	 log_line " "

	 make_objdir $file
       	 ( cd $lnx_proglib_dir/$file;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:$swbindir:$path";
           cp $lnx_lib_dir/libddl.a .;
           sccs -d$sccsdir/$file get makedisp3d.lnx;
           make -f makedisp3d.lnx;
       	 )
         ;;

#    special handling to give the ndds4x target so these compile with NDDS 4x version
#    to go back to ndds 3x just comment this case  GMB
      xnvinfoproc | xnvexpproc | xnvsendproc | xnvrecvproc )

         makefile=make${file}.lnx
	       log_line " "
       	 log_line "    CATEGORY:  $file 	 IN 	  ${lnx_proglib_dir}/$file"
       	 log_line " "

	       make_objdir $file
       	 ( cd $lnx_proglib_dir/$file;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:$swbindir:$path";
           sccs -d$sccsdir/$file get $makefile;
           make -f $makefile ndds4x;
       	 )
         ;;

#
#    special handling for nvflash compiles both 3x, 4x and 42x NDDS versions 
#    
      xnvflash )

         makefile=make${file}.lnx
	       log_line " "
       	 log_line "    CATEGORY:  $file 	 IN 	  ${lnx_proglib_dir}/$file"
       	 log_line " "

	       make_objdir $file
       	 ( cd $lnx_proglib_dir/$file;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:$swbindir:$path";
           sccs -d$sccsdir/$file get $makefile;
           rm -f *.o *.c *.h;
           make -f $makefile;
           rm -f *.o *.c *.h;
           make -f $makefile ndds4x;
	        rm -f *.o *.c *.h;
           make -f $makefile ndds42x;
       	 )
         ;;


#    special handling to give the ndds4x target so these compile with NDDS 4x version
#    to go back to ndds 3x just comment this case  GMB
#    nvlock is buried within the bin directory and the ndds4x target is not easily passed
#    so we do it directly here...   GMB
      xnvlocki )
         makefile=make${file}.lnx
	       log_line " "
       	 log_line "    CATEGORY:  $file 	 IN 	  ${lnx_proglib_dir}/$file"
       	 log_line " "

	       make_objdir bin
       	 ( cd $lnx_proglib_dir/bin;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:$swbindir:$path";
           sccs -d$sccsdir/bin get $makefile;
           make -f $makefile ndds4x;
       	 )
         ;;


#    special handling to give the ndds4x makefile so this compile with NDDS 4x version
#    to go back to ndds 3x just comment this case  GMB
      xnvacq )

         makefile=make${file}4x.lnx
	       log_line " "
       	 log_line "    CATEGORY:  $file 	 IN 	  ${lnx_proglib_dir}/$file"
       	 log_line " "

	       make_objdir $file
       	 ( cd $lnx_proglib_dir/$file;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:$swbindir:$path";
           sccs -d$sccsdir/$file get $makefile;
           make -f $makefile;
       	 )
         ;;

#    special handling to compile with NDDS 3x version
      xnvacq3x )

         makefile=makenvacq.lnx
	       log_line " "
       	 log_line "    CATEGORY:  $file 	 IN 	  ${lnx_proglib_dir}/$file"
       	 log_line " "

	       make_objdir $file
       	 ( cd $lnx_proglib_dir/$file;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:$swbindir:$path";
           sccs -d$sccsdir/nvacq get $makefile;
           make -f $makefile;
       	 )
         ;;

      *)
         makefile=make${file}.lnx

	 log_line " "
       	 log_line "    CATEGORY:  $file 	 IN 	  ${lnx_proglib_dir}/$file"
       	 log_line " "

       	 make_objdir $file
       	 ( cd $lnx_proglib_dir/$file;
           PATH="/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:$swbindir:$path";
           sccs -d$sccsdir/$file get $makefile;
           make -f $makefile $target;
       	 )
         ;;
   esac
done

#-----------------------------------------
#Tcl specials
cd $lnx_proglib_dir/tcl
grep "vnmr\/tcl" spingen.tcl 2>&1 > /dev/null
if [ $? -eq 0 ]
then 
     chmod 666 spingen.tcl
     sed 's/vnmr\/tcl/usr/' spingen.tcl > tmpxx
     mv tmpxx spingen.tcl
fi
cp $vcommondir/tclPro1.5.lnx/linux-ix86/lib/tbcload1.3 .
$vcommondir/tclPro1.5.lnx/linux-ix86/bin/procomp spincad.tcl spingen.tcl docker.tcl
$swbindir/tclfixtbc spincad.tbc spingen.tbc docker.tbc
#-----------------------------------------

log_line ""
log_line "Start Time :  $st_time"
log_line "End Time   :  `date '+%H:%M:%S'`"
