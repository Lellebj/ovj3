: '@(#)Updateobj.sh 22.1 03/24/08 Copyright (c) 1991-1997 Agilent Technologies'
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
:  update category objects
:  Supdate [category, make targets]
:  if no category is given then user is prompted for category and make targets
:  /bin/sh

# ISO quality record log
logdir=$sourcedir/complogs/
lognam=Objlog`uname -m`
logpath=${logdir}$lognam

# function to make the directory tree needed to compile a program
make_sysdir() {
#  set -x
  if test ! -d $sourcedir/sys$file 
  then 
    echo "Creating $sourcedir/sys$file directory."
    mkdir $sourcedir/sys$file;
    mkdir $sourcedir/sys$file/ow;
    mkdir $sourcedir/sys$file/sv;
    mkdir $sourcedir/sys$file/motif;
  fi
#  set +x
}
make_sysdir2() {
#  set -x
  if test ! -d $sourcedir/sys$file 
  then 
    echo "Creating $sourcedir/sys$file directory."
    mkdir $sourcedir/sys$file;
  fi
#  set +x
}
make_objdir() {
#  set -x
  if test ! -d $objdir/$file 
  then 
    echo "Creating $objdir/$file directory."
    mkdir $objdir/$file;
  fi
#  set +x
}

make_sysdirarch() {
#  set -x
  if test ! -d $sourcedir/sys$file/ppc 
  then 
    echo "Creating $sourcedir/sys$file/ppc directory."
    mkdir $sourcedir/sys$file;
    mkdir $sourcedir/sys$file/ppc;
    mkdir $sourcedir/sys$file/ppc_inst;
  fi
  if test ! -d $sourcedir/sys$file/68k 
  then 
    echo "Creating $sourcedir/sys$file/68k directory."
    mkdir $sourcedir/sys$file/68k;
    mkdir $sourcedir/sys$file/68k_inst;
  fi
}
#--------------------  main --------------------------------
 echo " "
 echo `date`
 echo " "
 echo "Writing ISO Quality Record to: "
 echo "Directory: $logdir "
 echo " "
 echo  "New Directory [$logdir]: "
 read tmpdir
 if [ x$tmpdir = "x" ]
 then
     tmpdir=$logdir
 fi
 logdir=$tmpdir
 echo " "
 echo "File Name: $lognam "
 echo "New File Name [$lognam]: "
 read tmpnam
 if [ x$tmpnam = "x" ]
 then
     tmpnam=$lognam
 fi
 lognam=$tmpnam

logpath=${logdir}$lognam

echo " " | tee $logpath 
echo `date` | tee $logpath 
echo " " | tee $logpath 
echo "================ $0 ==================== "  | tee -a $logpath 
echo " " | tee -a $logpath 
echo Date: `date` | tee -a $logpath 
echo " "  | tee -a $logpath
echo "Host: `uname -n`   Type: `uname -m`   OS Release: `uname -r`" | tee -a $logpath
echo " "  | tee -a $logpath

#  If OS type is reported as SunOS, distinguish between SunOS 4.x
#  and SunOS 5.x (Solaris)

OStype=`uname -s`
if test $OStype = "SunOS"
then
    osver=`uname -r`
    osmajor=`echo $osver | awk 'BEGIN { FS = "." } { print $1 }'`
    if test $osmajor = "5"
    then
        OStype="SOLARIS"
	arch="solaris"
	makepath="/usr/ccs/bin"
    else
       arch=`arch`
       makepath=
    fi
fi


# Sun Compiler directories & paths
# lang 30 compiler
#CC_BIN_PATH="/sw2/lang30/SUNWspro/bin:/usr/ccs/bin"
#LICENSE_FILE_PATH="/sw2/lang30/SUNWspro/license_dir/sunpro.lic,1"
#LIB_PATH="/sw2/lang30/SUNWspro/lib"

# Visual WorkShop or Forte 6.1 C compiler
#CC_BIN_PATH="/sw/Forte6.1/SUNWspro/bin:/usr/ccs/bin"
#LIB_PATH="/sw/Forte6.1/SUNWspro/lib"

# Forte is a symbolic link to the proper compiler
CC_BIN_PATH="/sw/Forte/SUNWspro/bin:/usr/ccs/bin"
CPLUSPLUS_PATH="/sw/Forte/SUNWspro/bin"

# Visual WorkShop
#CC_BIN_PATH="/sw/SUNWspro/bin:/usr/ccs/bin"
#LICENSE_FILE_PATH=
#LIB_PATH="/sw/SUNWspro/lib:/usr/dt/lib"

# Java JDK Home directory
JDKHOME="/sw/Java/UpdateobjJDK"
JDK_PATHS="/sw/Java/UpdateobjJDK/bin:/sw/Java/JavaCC/bin"
#JDK_CLASSES="/sw/Java/jws3.0/Java-WorkShop3.0/lib:/sw/Java/JavaCC/JavaCC.zip"
#JDK_CLASSES=".:/sw/Java/jws3.0/Java-WorkShop3.0/lib"
JDK_CLASSES=".:/sw/Java/UpdateobjJDK/lib:/sw/Java/UpdateobjJDK/jre/lib"

# VxWorks directories
VX_PATHS="/usr/ccs/bin:/sw/VX/vw/bin/$arch:/sw/VX/gnu/$arch.68k/bin"
VX32_PATHS="/usr/ccs/bin:/sw/VX332/bin/$arch:/sw/VX332/gnu/$arch.68k/bin"
GCC_PREFIX="/sw/VX/gnu/$arch.68k/lib/gcc-lib/"
GCC_PREFIX_PPC="/sw/VX/gnu/$arch.ppc/lib/gcc-lib/"
GCC_PREFIX332="/sw/VX332/gnu/$arch.68k/lib/gcc-lib/"
VX_HOST_TYPE="/sw/VX/vw" ; export VX_HOST_TYPE;
VX_HSP_BASE="/sw/VX/vw" ; export VX_HSP_BASE;
VX_BSP_BASE="/sw/VX/vw" ; export VX_BSP_BASE;
VX_VW_BASE="/sw/VX/vw" ; export VX_VW_BASE;
VX32_VW_BASE="/sw/VX332" ; export VX32_VW_BASE;

# WIND_BASE="/sw2/tor" ; export WIND_BASE;
WIND_BASE="$vxwksdir/wind" ; export WIND_BASE;
WIND_BASE_68K="$vxwksdir/wind" ; export WIND_BASE;
WIND_BASE_PPC="$vxwksdir/windppc2" ; export WIND_BASE_PPC;
WIND_BASE_PPC54="$vxwksdir/windt202ppc" ; export WIND_BASE_PPC54;
WIND_BASE_PPC55="$vxwksdir/windT2_2_PPC" ; export WIND_BASE_PPC55;
WIND_HOST_TYPE="sun4-solaris2" ; export WIND_HOST_TYPE;
# VW_HOME="/sw2/tor/target" ; export VW_HOME;
VW_HOME="$vxwksdir/wind/target" ; export VW_HOME;
#GCC_EXEC_PREFIX="$WIND_BASE/host/$WIND_HOST_TYPE/lib/gcc-lib/" ; export GCC_EXEC_PREFIX;
INCLUDE_PATH="$vxwksdir/wind/target"
INCLUDE_PATH_PPC="$vxwksdir/windppc2/target"
INCLUDE_PATH_PPC54="$vxwksdir/windt202ppc/target"
INCLUDE_PATH_PPC55="$vxwksdir/windT2_2_PPC/target"
GCC_PREFIX="$WIND_BASE/host/$WIND_HOST_TYPE/lib/gcc-lib/" 
GCC_PREFIX332="$WIND_BASE/host/$WIND_HOST_TYPE/lib/gcc-lib/"
GCC_PREFIX_PPC="$WIND_BASE_PPC/host/$WIND_HOST_TYPE/lib/gcc-lib/" 
GCC_PREFIX_PPC54="$WIND_BASE_PPC54/host/$WIND_HOST_TYPE/lib/gcc-lib/" 
GCC_PREFIX_PPC55="$WIND_BASE_PPC55/host/$WIND_HOST_TYPE/lib/gcc-lib/" 
VX_PATHS="/usr/ccs/bin:$WIND_BASE/host/$WIND_HOST_TYPE/bin"
VX_PATH_PPC="/usr/ccs/bin:$WIND_BASE_PPC/host/$WIND_HOST_TYPE/bin"

# we need to the the make provided with VxWorks, the SUNs make doesn't work
VX_PATH_PPC54="$WIND_BASE_PPC54/host/$WIND_HOST_TYPE/bin:/usr/ccs/bin"
VX_PATH_PPC55="$WIND_BASE_PPC55/host/$WIND_HOST_TYPE/bin:/usr/ccs/bin"

CPU="MC68040" ; export CPU;
VX_CPU_FAMILY="68k" ; export VX_CPU_FAMILY;

sun3=0

# Shared library versions
ddl_ver=0.0
magical_ver=0.0

case x$OStype in
	xSunOS )	
		suntype=`uname -m`
		if (test $suntype = "sun3" -o $suntype = "sun3x")
		then
   		  echo SunOS sun3 recompilation: | tee -a $logpath
   		  if test ! -d $sun3objdir
   		  then 
     		    echo "Creating $sun3objdir."
     		    mkdir $sun3objdir
   		  fi
   		  objdir=$sun3objdir/proglib
		  stdtargets="sun3"
		  sun3=1
		else
   		  echo SunOS sun4 recompilation: | tee -a $logpath
   		  if test ! -d $sun4objdir
   		  then 
     		    echo "Creating $sun4objdir."
     		    mkdir $sun4objdir
   		  fi
   		  objdir=$sun4objdir/proglib
		  stdtargets="sparc"
		fi
		;;
	xAIX )	
   		echo IBM AIX recompilation: | tee -a $logpath
   		if test ! -d $ibmobjdir
   		then 
     		  echo "Creating $ibmobjdir."
     		  mkdir $ibmobjdir
   		fi
   		objdir=$ibmobjdir/proglib
		stdtargets="AIX"
        	RULESET=AIX; export RULESET;
		;;
	xIRIX )	
   		echo SGI IRIX recompilation: | tee -a $logpath
   		if test ! -d $sgiobjdir
   		then 
     		  echo "Creating $sgiobjdir."
     		  mkdir $sgiobjdir
   		fi
   		objdir=$sgiobjdir/proglib
		stdtargets="IRIX"
        	RULESET=IRIX; export RULESET;
		;;

        xSOLARIS )
   		echo Solaris recompilation: | tee -a $logpath
   		if test ! -d $solobjdir
   		then 
     		  echo "Creating $solobjdir."
     		  mkdir $solobjdir
   		fi
   		objdir=$solobjdir/proglib
		stdtargets="SOLARIS"
		targets="SOLARIS"
        	RULESET=SOLARIS; export RULESET;
		;;

        *)      
		echo Unknown OS $OStype
		exit
		;;
esac

# create source directory if not present
if test ! -d $sourcedir
then 
  echo "Creating $sourcedir."
  mkdir $sourcedir
  mkdir $sourcedir/ow $sourcedir/sv $sourcedir/motif
fi

# create proglib subdirectory if not present
if test ! -d $objdir
then 
   echo "Creating $objdir."
   mkdir $objdir
  mkdir $objdir/ow $objdir/sv $objdir/motif
fi


if test $# -lt 1
then 
 echo Categories are:
 ls -C $sccsdir
 echo
 echo Java Categories are:
 ls -C $sccsjdir
 echo "Category for updating, or all [all]: "
 read answer
 echo "Make Targets to Update? (CR-default,dbx,prof,etc.): "
 read targets
else
 answer=$1
 shift 1
 targets=$*
fi

if [ "x$answer" = "x" ]
then
   answer="all"
fi

vnmrdone=0
if (test x$answer = "xall")
then
   if (test $sun3 -eq 1)
   then
#     halmon xracq xrconf autshm are done in Updateobj53
      filenames="gapmon glnc gshim kapmon"
   else
      filenames=`ls $sccsdir`
      filenames="$filenames `ls $sccsjdir`"
      filenames="ncomm vnmr ddl $filenames"
      echo $filenames
   fi
else
   filenames=$answer
fi

if test $stdtargets = "SOLARIS"
then
    targets="SOLARIS"
fi

echo "Object dir: $objdir, Stdtarget: $stdtargets"

stdate=`date '+%H:%M:%S'`
echo FILNAMES = $filenames
echo OSTYPE = $OStype

for file in $filenames
do
      case x$file in
     	 xacqproc | xstars | xautoproc | xlimnet )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else    
      		 echo " " | tee -a $logpath ;
        	 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#		 set -x
		 make_sysdir
		 make_objdir
        	 ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	 ( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file}; \
		 make -f make${file} $targets; )
             fi
             ;;

	 xbin )
      		echo " " | tee -a $logpath ;
        	echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#		set -x
		make_sysdir
		make_objdir
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get makesend2vnmr.rules.SOLARIS ;)
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get makesend2vnmr.rules.IRIX ;)
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get makesend2vnmr.rules.AIX ;)
        	( cd $objdir/$file; sccs -d$sccsdir/$file get makesend2vnmr.rules.SOLARIS ;)
        	( cd $objdir/$file; sccs -d$sccsdir/$file get makesend2vnmr.rules.IRIX ;)
        	( cd $objdir/$file; sccs -d$sccsdir/$file get makesend2vnmr.rules.AIX ;)
        	( cd $objdir/$file; sccs -d$sccsdir/$file get make${file}; \
		  make -f make${file} $stdtargets; )
		;;

	 xaccounting  | xgs )
      		echo " " | tee -a $logpath ;
        	echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#		set -x
		make_sysdir
		make_objdir
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file}; \
		  make -f make${file} $stdtargets; )
		;;

	 xdicom )
		if test $stdtargets = "SOLARIS"
		then
      		  echo " " | tee -a $logpath ;
        	  echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#		set -x
		  make_sysdir
		  make_objdir
        	  ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	  ( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file}; \
                    PATH=${CPLUSPLUS_PATH}:$PATH; export PATH; \
		    LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:.; export LD_LIBRARY_PATH; \
		    make -f make${file} $stdtargets; )
		else
		    echo $file only compiled on a Solaris system
		fi
		;;

	 xdicom_store )
      		echo " " | tee -a $logpath ;
        	echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#		set -x
		make_sysdir2
		make_objdir
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file}; \
		    make -f make${file} $targets; )
		;;

	 xsimul )
		if test $stdtargets = "SOLARIS"  -o  $stdtargets = "IRIX" -o $stdtargets = "AIX"
		then
		    skipping $file on a Solaris system
		else
      		    echo " " | tee -a $logpath ;
        	    echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#		    set -x
		    make_sysdir
		    make_objdir
        	    ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	    ( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file}; \
		    make -f make${file} $targets; )
		fi
		;;

	 xgacqproc )
		if test $stdtargets = "SOLARIS"
		then
      		  echo " " | tee -a $logpath ;
        	  echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		  make_sysdir
		  make_objdir
        	  ( cd $sourcedir/sys$file; sccs -d$sccsdir/acqproc get makeacqproc ; )
        	  ( cd $objdir/$file;  sccs -d$sccsdir/acqproc get makeacqproc; \
		    make -f makeacqproc gemplus; )
		else
		    echo $file must compiled on a Solaris system
		fi
		;;

	 xglide )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else

		if test $stdtargets = "SOLARIS" -o $stdtargets = "sparc"
		then
      		  echo " " | tee -a $logpath ;
        	  echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		  make_sysdir
		  make_objdir
        	  ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	  ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get makegadm ; )
        	  ( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file};	\
        	    cd $objdir/$file;  sccs -d$sccsdir/$file get makegadm;	\

		    make -f makegadm
		    make -f make${file} $targets; )
		else
		    echo $file must compiled on a Sun system
		fi
             fi
             ;;

#  psg used to be together with acqproc, autoproc, bin, etc., just above
#  it was separated because the Solaris product is to be compiled by GNU C and
#  we need to set this up before calling the make file.

	xpsg | xnvpsg )
      		echo " " | tee -a $logpath ;
        	echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		make_sysdir
		make_objdir
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file};  \
        	  if (test $stdtargets = "SOLARIS"); then		\
        	      PATH=$gnudir/bin:$PATH; export PATH;		\
        	      GNUDIR=$gnudir; export GNUDIR;		\
         	      GCC_EXEC_PREFIX=$gnudir/lib/gcc-lib/; export GCC_EXEC_PREFIX;\
        	  fi;						\
		  which cc;					\
		  echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;			\
		  make -f make${file} $stdtargets;			\
        	  if (test $stdtargets = "sparc"); then		\
        	      make -f make${file} lintlib;		\
        	  fi; )
		;;

#	 These contain window sources and are not a compilation category
	 xsunview | xxview | motif )
		echo category: \`$file\' skipped. ;
		;;

	 xkpsg )
                if test $stdtargets = "SOLARIS"
		then
      		    echo " " | tee -a $logpath ;
        	    echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		    make_sysdir
		    make_objdir
        	    ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file}; )
        	    ( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file};	\
        	      PATH=$gnudir/bin:$PATH; export PATH;		\
         	      GCC_EXEC_PREFIX=$gnudir/lib/gcc-lib/; export GCC_EXEC_PREFIX;\
		    which cc;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		    make -f make${file} $targets; )
		else
		    echo $file must compiled on a Solaris system
		fi
		;;

         xkpsglib )	
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		 echo " " | tee -a $logpath;
        	 echo "CATEGORY: \`kseqlib' IN \`$objdir/kseqlib'" | tee -a $logpath;
		 if test $stdtargets = "SOLARIS"
		 then
#		     set -x
		     make_sysdir
                     if test ! -d $objdir/kseqlib
                     then 
                         echo "Creating $objdir/kseqlib directory."
                         mkdir $objdir/kseqlib;
                     fi
        	     ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get makekseqlib ; )
        	     ( cd $objdir/kseqlib; sccs -d$sccsdir/$file get makekseqlib; \
        	     if (test $stdtargets = "SOLARIS"); then			\
        	        PATH=$gnudir/bin:$PATH; export PATH;		\
         	        GCC_EXEC_PREFIX=$gnudir/lib/gcc-lib/; export GCC_EXEC_PREFIX;\
        	     fi;					\
		     which cc;					\
		     echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		     rm -f errmsg;				\
		     make -f makekseqlib spot; )
		 else
		     echo $file must compiled on a Solaris system
		 fi
             fi 
	     ;;

	 xgpsg )
                if test $stdtargets = "SOLARIS"
		then
      		    echo " " | tee -a $logpath ;
        	    echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		    make_sysdir
		    make_objdir
        	    ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get makepsg2; )
        	    ( cd $objdir/$file;  sccs -d$sccsdir/$file get makepsg2;	\
        	      PATH=$gnudir/bin:$PATH; export PATH;		\
         	      GCC_EXEC_PREFIX=$gnudir/lib/gcc-lib/; export GCC_EXEC_PREFIX;\
		    which cc;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		    make -f makepsg2 $targets; )
		else
		    echo $file must compiled on a Solaris system
		fi
		;;

#
# targets here that must compile with different target depending on machine type 
#
         xvnmr )	
#                  vnmrdone=1
      	        if (test $vnmrdone -eq 0)
      		then
      		    echo " " | tee -a $logpath ;
        	    echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		    make_sysdir
		    make_objdir
        	    ( cd $sourcedir/sys$file; sccs -p$sccsdir/$file/SCCS get make${file} ; )
        	    ( cd $objdir/$file;  sccs -p$sccsdir/$file/SCCS get make${file}; )
		    if (test x$targets = "x")
		    then
#                        just for sun3s because some SUN4s get real slow when used
        	        ( cd $objdir/$file; make -f make${file} $stdtargets; )
      		    else
        	        ( cd $objdir/$file; make -f make${file} $targets; )
		    fi
#		    set -x
		    vnmrdone=1
                fi
		;;

#
#  The  SOLARIS target makes qtune for UnityPLUS
#
         xtune )	
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else 
      		 echo " " | tee -a $logpath ;
        	 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		 make_sysdir
		 make_objdir
        	 (cd $sourcedir/sys$file;
		     sccs -p$sccsdir/$file/SCCS get make${file} ; )
        	 (cd $objdir/$file; sccs -p$sccsdir/$file/SCCS get make${file};)

#        	 ( cd $objdir/$file; make -f make${file} $targets; )

		 if test $stdtargets = "SOLARIS"
		 then
		     (echo "Making swepttune for INOVA and UnityPLUS";
		     PATH=$CC_BIN_PATH:$PATH;
		     export PATH;
		     LM_LICENSE_FILE=$LICENSE_FILE_PATH;
		     export LM_LICENSE_FILE;
		     LD_LIBRARY_PATH=$LIB_PATH:/usr/openwin/lib;
		     export LD_LIBRARY_PATH;
		     cd $objdir/$file;
		     make -f make${file} SOLARIS;
		     make -f make${file} mercury;
		     make -f make${file} inova;)
		 else
		     echo Can only make the Solaris Nessie version of $file
		 fi
             fi  
	     ;;

         xstat | x3D )
                echo " " | tee -a $logpath ;
                echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
                make_sysdir
                make_objdir
                (cd $sourcedir/sys$file; sccs -p$sccsdir/$file/SCCS get make${file} ; )
                (cd $objdir/$file;  sccs -p$sccsdir/$file/SCCS get make${file}; )
                if (test x$targets = "x")
                then
#                    just for sun3s because some SUN4s get real slow when used
                    ( cd $objdir/$file; make -f make${file} $stdtargets; )
                else
                    ( cd $objdir/$file; make -f make${file} $targets; )
                fi
#               set -x
                ;;

         xacqi | xgacqi )	
              if test  $stdtargets = "IRIX" -o $stdtargets = "AIX"
              then
                  echo "Skipping $file, NOT done for $stdtargets"
              else
		  if (test x$file = "xgacqi")
		  then
		      file="acqi"
		      realfile="gacqi"
		  else
		      realfile=$file
		  fi
      		  echo " " | tee -a $logpath ;
        	  echo "CATEGORY: \`$realfile' IN \`$objdir/$file'" | tee -a $logpath;
		  make_sysdir
		  make_objdir
		  if (test x$file = "xacqi")
		  then
		      cd  $objdir/acqi
		      list=`grep -l GEMPLUS *`
		      for item in $list
		      do
		          rm -f `basename $item .c`.o
		      done
		      list=`grep -l NESSIE *`
		      for item in $list
		      do
		          rm -f `basename $item .c`.o
		      done
		  fi
        	  (cd $sourcedir/sys$file; sccs -p$sccsdir/$file/SCCS get make${file} ; )
        	  (cd $objdir/$file;  sccs -p$sccsdir/$file/SCCS get make${file}; )
		  if (test x$realfile = "xacqi")
		  then
		      (cd $sourcedir/sys$file; sccs -p$sccsdir/$file/SCCS get makeautoshim ; )
        	      (cd $objdir/$file;  sccs -p$sccsdir/$file/SCCS get makeautoshim; )
		  fi
		if (test x$realfile = "xgacqi")
		then
		   if test $stdtargets = "SOLARIS"
		   then
		      ( cd $objdir/$file; make -f make${file} gemplus; )
                   else
		      echo $realfile must compiled on a Solaris system
                   fi
		else
		   if (test x$targets = "x")
		   then
#                     just for sun3s because some SUN4s get real slow when used
        	      ( cd $objdir/$file; make -f make${file} $stdtargets; )
			  if (test x$realfile = "xacqi")
			  then
			     ( cd $objdir/$file; make -f makeautoshim $stdtargets; )
			  fi
      		   else
        	      ( cd $objdir/$file; make -f make${file} $targets; )
		   	if test $stdtargets = "SOLARIS"
		   	then
		           if (test x$realfile = "xacqi")
		           then
			   ( cd $objdir/$file;
			     echo "Making iiadisplay for INOVA";
			     list=`grep -l NESSIE *`
			     for item in $list
			     do
		   	     rm -f `basename $item .c`.o
			     done
			     make -f make${file} inova; )
                           fi
			fi
			  if (test x$realfile = "xacqi")
			  then
			     ( cd $objdir/$file; make -f makeautoshim $stdtargets; )
			  fi
		   fi
		fi
#		set -x
            fi
	    ;;

         xfdm )	
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		 echo " " | tee -a $logpath;
        	 echo "CATEGORY: \`fdm' IN \`$objdir/fdm'" | tee -a $logpath;
		 if test $stdtargets = "SOLARIS"
		 then
#		     set -x
		     make_sysdir2
		     make_objdir
        	     (cd $sourcedir/sys$file; sccs -p$sccsdir/$file/SCCS get make${file} ; )
        	     (cd $objdir/$file;  sccs -p$sccsdir/$file/SCCS get make${file}; \
		     PATH=/usr/local/bin:$PATH; export PATH; \
		     which g++; 	\
		     make -f make$file SOLARIS; )
		 else
		     echo $file must compiled on a Solaris system
		 fi
             fi 
	     ;;

         xgpsglib )	
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		 echo " " | tee -a $logpath;
        	 echo "CATEGORY: \`gseqlib' IN \`$objdir/gseqlib'" | tee -a $logpath;
		 if test $stdtargets = "SOLARIS"
		 then
#		     set -x
		     make_sysdir
                     if test ! -d $objdir/gseqlib
                     then 
                         echo "Creating $objdir/gseqlib directory."
                         mkdir $objdir/gseqlib;
                     fi
        	     ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get makegseqlib ; )
        	     ( cd $objdir/gseqlib; sccs -d$sccsdir/$file get makegseqlib; \
        	     if (test $stdtargets = "SOLARIS"); then			\
        	        PATH=$gnudir/bin:$PATH; export PATH;		\
         	        GCC_EXEC_PREFIX=$gnudir/lib/gcc-lib/; export GCC_EXEC_PREFIX;\
        	     fi;					\
		     which cc;					\
		     echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		     rm -f errmsg;				\
		     make -f makegseqlib gemplus; )
		 else
		     echo $file must compiled on a Solaris system
		 fi
             fi 
	     ;;

         xpsglib )	
      		echo " " | tee -a $logpath;
        	echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#		set -x
		make_objdir
  		if test ! -d $sourcedir/$file 
  		then 
    		  echo "Creating $sourcedir/$file directory."
    		  mkdir $sourcedir/$file;
  		fi
        	( cd $sourcedir/$file; sccs -d$sccsdir/$file get makepsglib ; )
        	( cd $objdir/$file; sccs -d$sccsdir/$file get makepsglib;	\
        	if (test $stdtargets = "SOLARIS"); then				\
        	    PATH=$gnudir/bin:$PATH; export PATH;			\
         	    GCC_EXEC_PREFIX=$gnudir/lib/gcc-lib/; export GCC_EXEC_PREFIX; \
        	fi;								\
		which cc;							\
		echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;			\
		rm -f errmsg;							\
		make -f makepsglib $stdtargets )
		;;

         xscripts )    
                echo " " | tee -a $logpath;
                echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
#               set -x
                make_sysdir
                ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; 
                   make -f make${file} $stdtargets; )
#                set +x
                ;;

	 xhalmon | xautshm | xgapmon | xglnc | xgshim | xkapmon )	
             if test  $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		 echo " " | tee -a $logpath;
        	 echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
#		 set -x
		 make_sysdir
      	         if (test $sun3 -eq 1)
      		 then
        	     (cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file}; \
		            make -f make${file} $targets;)
      		 else
        	     (cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file}; \
		            make -f make${file} Source;)
		 	
		 fi
             fi
	     ;;

	 xxracq | xxrconf )	
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      	         if (test $sun3 -eq 1)
      		 then
      		     echo " " | tee -a $logpath;
        	     echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
#		     set -x
		     make_sysdir
        	     (cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file}; \
		                make -f make${file} $targets; )
      		 else
		     echo $file must compiled on a SUN3
		 fi
             fi
	     ;;

	 xlimnet_sunos )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
		if (test $OStype = "SunOS")
		then
      		  echo " " | tee -a $logpath;
		  basefile="limnet"
        	  echo "CATEGORY: \`$file' IN \`$objdir/$basefile'" | tee -a $logpath;

#	    Create (for example) /common/syslimnet_sunos

		  if test ! -d $sourcedir/sys$file 
		  then 
		    echo "Creating $sourcedir/sys$file directory."
		    mkdir $sourcedir/sys$file;
		  fi

#	    Create (for example) /vobj/sun4/proglib/limnet

		  if test ! -d $objdir/$basefile 
		  then 
		    echo "Creating $objdir/$basefile directory."
		    mkdir $objdir/$basefile;
		  fi

		  ( cd $sourcedir/sys$file; sccs -p$sccsdir/$file/SCCS get make${file} ; )
		  ( cd $objdir/$basefile;  sccs -p$sccsdir/$file/SCCS get make${file}; \
		    make -f make${file} $targets; )
		else
		  echo "$file cannot be compiled on $OStype"
		fi
             fi
	     ;;
	
	 xlimnet_solaris )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
		if test $stdtargets = "SOLARIS"
		then
      		  echo " " | tee -a $logpath;
		  basefile="limnet"
        	  echo "CATEGORY: \`$file' IN \`$objdir/$basefile'" | tee -a $logpath;

#	    Create (for example) /common/syslimnet_solaris

		  if test ! -d $sourcedir/sys$file 
		  then 
		    echo "Creating $sourcedir/sys$file directory."
		    mkdir $sourcedir/sys$file;
		  fi

#	    Create (for example) /vobj/sol/proglib/limnet

		  if test ! -d $objdir/$basefile 
		  then 
		    echo "Creating $objdir/$basefile directory."
		    mkdir $objdir/$basefile;
		  fi

		  ( cd $sourcedir/sys$file; sccs -p$sccsdir/$file/SCCS get make${file} ; )
		  ( cd $objdir/$basefile;  sccs -p$sccsdir/$file/SCCS get make${file}; \
		    make -f make${file} $targets; )
		else
		    echo $file must compiled on a Solaris system
		fi
             fi
	     ;;

	 xlimnet_ibm )
             if (test $stdtargets = "AIX")
             then
      		echo " " | tee -a $logpath;
		basefile="limnet"
        	echo "CATEGORY: \`$file' IN \`$objdir/$basefile'" | tee -a $logpath;
		if test ! -d $sourcedir/sys$file 
		then 
		    echo "Creating $sourcedir/sys$file directory."
		    mkdir $sourcedir/sys$file;
		fi
		if test ! -d $objdir/$basefile 
		then 
		    echo "Creating $objdir/$basefile directory."
		    mkdir $objdir/$basefile;
		fi
		( cd $sourcedir/sys$file; sccs -p$sccsdir/$file/SCCS get make${file} ; )
		( cd $objdir/$basefile;  sccs -p$sccsdir/$file/SCCS get make${file}; \
		    make -f make${file} all; )
	     else
		    echo $file must compiled on a AIX system
             fi
	     ;;

	 xkernel_solaris )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
		if test $stdtargets = "SOLARIS"
		then
      		    echo " " | tee -a $logpath ;
        	    echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		    if test ! -d $sourcedir/sys$file
		    then
		        mkdir $sourcedir/sys$file
                    fi
		    make_objdir
		    ( cd $sourcedir/sys$file;				\
		      sccs -p$sccsdir/$file/SCCS get make${file} ; )
		    ( cd $objdir/$file;					\
		      sccs -p$sccsdir/$file/SCCS get make${file};	\
		      make -f make${file} $stdtargets; )
		else
		    echo $file must compiled on a Solaris system
		fi
             fi
             ;;

	 x3Dimg )
		if test $stdtargets = "SOLARIS" -o $stdtargets = "sparc"
		then
      		  echo " " | tee -a $logpath ;
        	  echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		  make_sysdir
		  make_objdir
        	  ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get SCCS ; )
        	  ( cd $objdir/$file; sccs -d$sccsdir/$file get makedisp3d; \
		    make -f makedisp3d; )
		else
		    echo $file must compiled on a Sun system
		fi
		;;

	 xcsi )
		if test $stdtargets = "SOLARIS"
		then
      		  echo " " | tee -a $logpath ;
        	  echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		  make_sysdir
		  make_objdir
        	  ( cd $objdir/$file;
		        PATH=$CC_BIN_PATH:$PATH;
		   	export PATH;
		        LM_LICENSE_FILE=$LICENSE_FILE_PATH;
		   	export LM_LICENSE_FILE;
		        LD_LIBRARY_PATH=$LIB_PATH:/usr/openwin/lib;
		   	export LD_LIBRARY_PATH;
		    if test ! -d $objdir/ib
		    then
			echo "Creating $objdir/ib.";
			mkdir $objdir/ib;
		    fi
		    ( cd $objdir/ib;
		    	sccs -d$sccsdir/ib get makesis;
		    	make -f makesis;
		    	sccs -d$sccsdir/ib get makeparams;
		    	make -f makeparams;
		    )
		    rm -f libsis*;
		    cp $objdir/ib/libsis* .;
		    rm -f libparam*;
		    cp $objdir/ib/libparam* .;
		    if test ! -d $objdir/ib/magical
		    then
			echo "Creating $objdir/ib/magical.";
			mkdir $objdir/ib/magical;
		    fi
		    ( cd $objdir/ib/magical;
			sccs -d$sccsdir/ib get makemagical;
			make -f makemagical;
		    )
		    ( cd /vobj/sol/lib;
		      rm -f libmagical*;
		      cp $objdir/ib/magical/libmagical_sol.a libmagical.a;
		      cp $objdir/ib/magical/libmagical_sol.so.$magical_ver libmagical.so.$magical_ver;
		      ln -s libmagical.so.$magical_ver libmagical.so;
		    )
		    sccs -d$sccsdir/$file get makecsi;
		    make -f makecsi;
		    sccs -d$sccsdir/$file get makeP_csi;
		    make -f makeP_csi; )
		else
		    echo $file must compiled on a Solaris system
		fi
		;;

	xlcpeaks )
		if test $stdtargets = "SOLARIS"
		then
		  echo " " | tee -a $logpath ;
        	  echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		  make_sysdir
		  make_objdir
        	  ( cd $sourcedir/sys$file; \
		       sccs -d$sccsdir/$file get make${file} ; )
        	  ( cd $objdir/$file;
		    PATH=$CC_BIN_PATH:$PATH;
		    export PATH;
		    LM_LICENSE_FILE=$LICENSE_FILE_PATH;
		    export LM_LICENSE_FILE;
		    #LD_LIBRARY_PATH=$LIB_PATH:/usr/openwin/lib;
		    #export LD_LIBRARY_PATH;
		    sccs -d$sccsdir/$file get make${file} ;
		    make -f make${file} ;
		  )
		else
		    echo $file must compiled on Solaris
		fi
		;;

	xddl )
		if test $stdtargets = "SOLARIS" -o $stdtargets = "sparc"
		then
		  echo " " | tee -a $logpath ;
        	  echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		  make_sysdir
		  make_objdir
        	  ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	  ( cd $objdir/$file;
		    if [ $stdtargets = "sparc" ]
		    then
			PATH=/sw/CenterLine/bin:$PATH;
			export PATH;
		    else
		         PATH=$CC_BIN_PATH:$PATH;
		   	export PATH;
		         LM_LICENSE_FILE=$LICENSE_FILE_PATH;
		   	export LM_LICENSE_FILE;
		        LD_LIBRARY_PATH=$LIB_PATH:/usr/openwin/lib;
		   	export LD_LIBRARY_PATH;
		    fi
		    sccs -d$sccsdir/$file get makeddl;
		    make -f makeddl "SHAREDLIB_VER=$ddl_ver";
		    ( cd /vobj/sol/lib;
		      rm -f libddl*;
		      cp $objdir/$file/libddl_sol.a libddl.a;
		      cp $objdir/$file/libddl_sol.so.$ddl_ver libddl.so.$ddl_ver;
		      ln -s libddl.so.$ddl_ver libddl.so;
		    )
		  )
		else
		    echo $file must compiled on a Sun system
		fi
		;;

	xib )
		if test $stdtargets = "SOLARIS" -o $stdtargets = "sparc"
		then
		  echo " " | tee -a $logpath ;
        	  echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		  make_sysdir
		  make_objdir
        	  ( cd $sourcedir/sys$file;
		    sccs -d$sccsdir/$file get makefdfgluer; \
		    sccs -d$sccsdir/$file get makefdfsplit; \
		    sccs -d$sccsdir/$file get makesis; \
		    sccs -d$sccsdir/$file get makeparams; \
		    sccs -d$sccsdir/$file get make${file} ; )
        	  ( cd $objdir/$file;
		    if [ $stdtargets = "sparc" ]
		    then
			PATH=/sw/CenterLine/bin:$PATH;
			export PATH;
		    else
		         PATH=$CC_BIN_PATH:$PATH;
		   	export PATH;
		         LM_LICENSE_FILE=$LICENSE_FILE_PATH;
		   	export LM_LICENSE_FILE;
		        LD_LIBRARY_PATH=$LIB_PATH:/usr/openwin/lib;
		   	export LD_LIBRARY_PATH;
		    fi
		    sccs -d$sccsdir/$file get browser.sh;
		    make browser;
		    sccs -d$sccsdir/$file get makefdfgluer;
		    make -f makefdfgluer;
		    sccs -d$sccsdir/$file get makefdfsplit;
		    make -f makefdfsplit;
		    sccs -d$sccsdir/$file get makesis;
		    make -f makesis;
		    sccs -d$sccsdir/$file get makeparams;
		    make -f makeparams;
		    if test ! -d magical
		    then
			echo "Creating `pwd`/magical directory.";
			mkdir magical;
		    fi
		    ( cd magical;
			sccs -d$sccsdir/$file get makemagical;
			make -f makemagical;
		    )
		    ( cd /vobj/sol/lib;
		      rm -f libmagical*;
		      cp $objdir/ib/magical/libmagical_sol.a libmagical.a;
		      cp $objdir/ib/magical/libmagical_sol.so.$magical_ver libmagical.so.$magical_ver;
		      ln -s libmagical.so.$magical_ver libmagical.so;
		    )
		    rm -f libmagical_sol.a;
		    ln -s magical/libmagical_sol.a libmagical_sol.a;

		    if test ! -d port3
		    then
			echo "Creating `pwd`/port3 directory.";
			mkdir port3;
		    fi
		    ( cd port3;
			sccs -d$sccsdir/$file get makeport3;
			rm -f libport3.so.*;
			make -f makeport3;
		    )
		    ( cd /vobj/sol/lib;
		      rm -f libport3*;
		      cp $objdir/ib/port3/libport3.a libport3.a;
		      cp $objdir/ib/port3/libport3.so.* .;
		      ln -s libport3.so.* libport3.so;
		    )

		    if test ! -d libf2c
		    then
			echo "Creating `pwd`/libf2c directory.";
			mkdir libf2c;
		    fi
		    ( cd libf2c;
			sccs -d$sccsdir/$file get makelibf2c;
			rm -f libf2c.so.*;
			make -f makelibf2c;
		    )
		    ( cd /vobj/sol/lib;
		      rm -f libf2c*;
		      cp $objdir/ib/libf2c/libf2c.a libf2c.a;
		      cp $objdir/ib/libf2c/libf2c.so.* .;
		      ln -s libf2c.so.* libf2c.so;
		    )

		    sccs -d$sccsdir/$file get make${file};
		    make -f make${file} )
		else
		    echo $file must compiled on a Sun system
		fi
		;;

	xshim3d )
	     set -x
             if test  $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		echo " " | tee -a $logpath ;
        	echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		make_sysdir2
		make_objdir
		(cd $objdir/$file;  sccs -d$sccsjdir/$file get make${file}; \
		  make -f make${file} Source;
		  make -f make${file} SOLARIS; )
	     fi
            set +x
		;;

#
#  Nessie Compilations are ansi thus on sun4 must use acc compiler
#  we need to set this up before calling the make file.
# 
	 xexpproc  | xsendproc  | xncomm | \
	 xrecvproc | xprocproc  | xnautoproc | xroboproc | xatproc )
             if test  $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		echo " " | tee -a $logpath ;
        	echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		make_sysdir
		make_objdir
		if (test $OStype = "SunOS")
		then
        	  ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	  ( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file};  \
                    TCL_LIBRARY=/vcommon/tcl/srcTcl;       \
                    TCL_INCLUDE=/vcommon/tcl/srcTcl;       \
		    JDK_HOME=/sw/Java/UpdateobjJDK;		   \
        	    PATH=/sw/lang201n:$PATH;               \
                    export PATH TCL_INCLUDE TCL_LIBRARY JDK_HOME;   \
		    LM_LICENSE_FILE=/sw/lang201n/license_dir/sunpro.lic,1; export LM_LICENSE_FILE; \
		    
		    LD_LIBRARY_PATH=/sw/lang201n/lib:/usr/openwin/lib; export LD_LIBRARY_PATH; \
		   echo $PATH; which cc;	\
		  make -f make${file} std dbx; )
		else
        	  ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	  ( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file};  \
		    PATH=$CC_BIN_PATH:$PATH; export PATH;  \
		    LM_LICENSE_FILE=$LICENSE_FILE_PATH; export LM_LICENSE_FILE; \
		    LD_LIBRARY_PATH=$LIB_PATH:/usr/openwin/lib; export LD_LIBRARY_PATH; \
		    TCL_LIBRARY=/vcommon/tcl/srcTcl; export TCL_LIBRARY; \
		    TCL_INCLUDE=/vcommon/tcl/srcTcl; export TCL_INCLUDE; \
		    JDK_HOME=/sw/Java/UpdateobjJDK;	 export JDK_HOME;   \
		   echo $PATH; which cc;	\
		   make -f make${file} std dbx; )
		fi
             fi
             ;;

	 xnvexpproc  | xnvsendproc  | xnvrecvproc | xnvinfoproc | xnvflash )
      		echo " " | tee -a $logpath ;
        	echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		make_sysdir
		make_objdir
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file};  \
		  PATH=$CC_BIN_PATH::/sw/NDDS/ndds.3.0m/scripts:$PATH; export PATH;  \
		   LM_LICENSE_FILE=$LICENSE_FILE_PATH; export LM_LICENSE_FILE; \
		   LD_LIBRARY_PATH=$LIB_PATH:/usr/openwin/lib; export LD_LIBRARY_PATH; \
		    TCL_LIBRARY=/vcommon/tcl/srcTcl; export TCL_LIBRARY; \
		    TCL_INCLUDE=/vcommon/tcl/srcTcl; export TCL_INCLUDE; \
		    JDK_HOME=/sw/Java/UpdateobjJDK;	 export JDK_HOME;   \
		   echo $PATH; which cc;	\
		   make -f make${file} all; )
             ;;


	 xinfoproc )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		echo " " | tee -a $logpath ;
        	echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		make_sysdir
		make_objdir
		if (test $OStype = "SunOS")
		then
        	  ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	  ( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file};  \
        	    PATH=/sw/lang201n:$PATH; export PATH;  \
		    LM_LICENSE_FILE=/sw/lang201n/license_dir/sunpro.lic,1; export LM_LICENSE_FILE; \
		    
		    LD_LIBRARY_PATH=/sw/lang201n/lib:/usr/openwin/lib; export LD_LIBRARY_PATH; \

		  make -f make${file} std dbx; )
		else
        	  ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	  ( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file};  \
		    PATH=$CC_BIN_PATH:$PATH; export PATH;  \
		    LM_LICENSE_FILE=$LICENSE_FILE_PATH; export LM_LICENSE_FILE; \
		    LD_LIBRARY_PATH=$LIB_PATH:/usr/openwin/lib; export LD_LIBRARY_PATH; \
		   make -f make${file} SOLARIS ; )
		fi
             fi
             ;;

#Below we make the integrated vxWorks and vxWorks.auto
# They also update vwacq.o, vwcom.o, and vwauto.o
# so the case-s for these *.o files could eventually be deleted
         xkvwacqkernel  )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		echo " " | tee -a $logpath;
        	echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
		if [ ! -d $sourcedir/sys$file ]  
		then
		      mkdir -p $sourcedir/sys$file
		fi 
		(  PATH=$PATH:$VX_PATHS; export PATH;  			\
		    VW_HOME=$INCLUDE_PATH;     	export VW_HOME;		\
		    GCC_EXEC_PREFIX=$GCC_PREFIX; export GCC_EXEC_PREFIX; \
		    CPU="MC68040" ; export CPU;				\
		    VX_CPU_FAMILY="68k" ; export VX_CPU_FAMILY;		\
		    which cc68k;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;		\
		    cd  $VW_HOME/config/mercury_mv162;			\
		  sccs -d$sccsdir/$file get Makefile;			\
		  sccs -d$sccsdir/vwacqkernel get config.h;			\
		  which cc68k;						\
		  echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;		\
		  make vxWorks.dev vxWorks.rel ; 			\
		  cp -p NMRdev.vxWorks NMRrel.vxWorks NMRdev.vxWorks.sym $sourcedir/sys$file ; \
		  cp -p NMRdev.vxWorks.sym $sourcedir/sys$file/vxWorks.sym; )
             fi
             ;;


#Below we make the integrated vxWorks and vxWorks.auto
# They also update vwacq.o, vwcom.o, and vwauto.o
# so the case-s for these *.o files could eventually be deleted
         xvwacqkernel  )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		echo " " | tee -a $logpath;
        	echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
		if [ ! -d $sourcedir/sys$file/68k ]  
		then
		      mkdir -p $sourcedir/sys$file/68k
		fi 
		if [ ! -d $sourcedir/sys$file/ppc ]  
		then
		      mkdir -p $sourcedir/sys$file/ppc
		fi 
 		echo ""
		echo " ----------------  68K Kernel --------------------------- "
 		echo ""
		(  PATH=$PATH:$VX_PATHS; export PATH;  			\
		    VW_HOME=$INCLUDE_PATH;     	export VW_HOME;		\
		    GCC_EXEC_PREFIX=$GCC_PREFIX; export GCC_EXEC_PREFIX; \
		    CPU="MC68040" ; export CPU;				\
		    VX_CPU_FAMILY="68k" ; export VX_CPU_FAMILY;		\
		    which cc68k;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;		\
		    cd  $VW_HOME/config/inova_mv162;			\
		  sccs -d$sccsdir/$file get Makefile;			\
		  sccs -d$sccsdir/$file get config.h;			\
		  which cc68k;						\
		  echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;		\
		  make vxWorks.dev vxWorks.rel ; 			\
		  cp -p NMRdev.vxWorks NMRrel.vxWorks NMRdev.vxWorks.sym $sourcedir/sys$file/68k ; \
		  cp -p NMRdev.vxWorks.sym $sourcedir/sys$file/68k/vxWorks.sym; )
 		echo ""
		echo " ----------------  PPC Kernel --------------------------- "
 		echo ""
        	 ( PATH=$VX_PATH_PPC54:$PATH; export PATH;  \
		    VW_HOME=$INCLUDE_PATH_PPC54;     	export VW_HOME;	\
		    WIND_BASE=$WIND_BASE_PPC54 ; export WIND_BASE;
	    	    GCC_EXEC_PREFIX=$GCC_PREFIX_PPC54; export GCC_EXEC_PREFIX; \
		    CPU="PPC603" ; export CPU;				\
		    VX_CPU_FAMILY="ppc" ; export VX_CPU_FAMILY;		\
		    LD_LIBRARY_PATH="$WIND_BASE/host/$WIND_HOST_TYPE/lib" ; export LD_LIBRARY_PATH; \
		    which ccppc;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;		\
		    echo "LD_LIBRARY_PATH=" $LD_LIBRARY_PATH;		\
		    cd  $VW_HOME/config/inova_mv2303;                    \
		    PWD=`pwd`; echo $PWD ;	\
		    echo $WIND_BASE ; echo $LD_LIBRARY_PATH ;	\
		   sccs -d$sccsdir/${file}ppc get Makefile;		\
		   sccs -d$sccsdir/${file}ppc get config.h;		\
		    which ccppc;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		   which make ; \
		   make dev rel ; 			\
		  cp -p NMRdev.vxWorks NMRrel.vxWorks NMRdev.vxWorks.sym $sourcedir/sys$file/ppc ; \
		  cp -p NMRdev.vxWorks.sym $sourcedir/sys$file/ppc/vxWorks.sym; )
             fi
             ;;

         xvwautokernel )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		echo " " | tee -a $logpath;
        	echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
		if [ ! -d $sourcedir/sys$file ]  
		then
		      mkdir -p $sourcedir/sys$file
		fi 
		(  PATH=$PATH:$VX_PATHS; export PATH;  			\
		    VW_HOME=$INCLUDE_PATH;     	export VW_HOME;		\
		    GCC_EXEC_PREFIX=$GCC_PREFIX; export GCC_EXEC_PREFIX; \
		    CPU="CPU32" ; export CPU;				\
		    VX_CPU_FAMILY="68k" ; export VX_CPU_FAMILY;		\
		    which cc68k;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;		\
		    cd  $VW_HOME/config/inova_msr332;			\
		  sccs -d$sccsdir/$file get Makefile;			\
		  sccs -d$sccsdir/$file get config.h;			\
		  which cc68k;						\
		  echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;		\
		  make vxWorks.rel ; 			\
		 )

#		(  PATH=$PATH:$VX_PATHS; export PATH;  			\
#		    VW_HOME=$INCLUDE_PATH;     	export VW_HOME;		\
#		    GCC_EXEC_PREFIX=$GCC_PREFIX; export GCC_EXEC_PREFIX; \
#		    CPU="CPU32" ; export CPU;				\
#		    VX_CPU_FAMILY="68k" ; export VX_CPU_FAMILY;		\
#		    which cc68k;					\
#		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;		\
#		    cd  $VW_HOME/config/inova_msr332;			\
#		  sccs -d$sccsdir/$file get Makefile;			\
#		  sccs -d$sccsdir/$file get config.h;			\
#		  which cc68k;						\
#		  echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;		\
#		  make vxWorks.dev vxWorks.rel ; 			\
#		  cp -p NMRdev.vxWorks NMRrel.vxWorks NMRdev.vxWorks.sym $sourcedir/sys$file ; \
#		  cp -p NMRdev.vxWorks.sym $sourcedir/sys$file/vxWorks.sym; \
#		  cd  $VW_HOME/config/inova_msrII;			\
#		  sccs -d$sccsdir/$file get Makefile;			\
#		  sccs -d$sccsdir/$file get config.h;			\
#		  which cc68k;						\
#		  echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;		\
#		  make devII relII; 					\
#		  cp -p NMRdev.vxWorksMSRII NMRdev.vxWorksMSRII.sym NMRrel.vxWorksMSRII $sourcedir/sys$file ; \
#		 )

#		( PATH=$VX32_PATHS:$PATH; export PATH;			\
#		  LM_LICENSE_FILE=/sw/VX332/license.dat;		\
#		  GCC_EXEC_PREFIX=$GCC_PREFIX332;  export GCC_EXEC_PREFIX; \
#		  VWGNU_HOME=/sw/VX332/gnu;	export VWGNU_HOME;	\
#		  VW_HOME=/sw/VX332;     	export VW_HOME;		\
#		  VX_VW_BASE=$VW_HOME;		export VX_VW_BASE;	\
#		  VX_HOST_TYPE=$arch;		export VX_HOST_TYPE;	\
#		  VX_HSP_BASE=$VW_HOME;		export VX_HSP_BASE;	\
#		  VX_BSP_BASE=$VW_HOME;		export VX_BSP_BASE;	\
#		  VX_VW_BASE=$VW_HOME;		export VX_VW_BASE;	\
#		  CPU=CPU32;			export CPU;	\
#		  VX_CPU_FAMILY=68k;		export VX_CPU_FAMILY;	\
#                  cd $sourcedir/sys$file;				\
#		  sccs -d$sccsdir/$file get Makefile;			\
#		  sccs -d$sccsdir/$file get Makefile.CPU32gnu;		\
#		  sccs -d$sccsdir/$file get config.h;			\
#		  which cc68k;					\
#		  echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
#		  make vxWorks.rel vxWorks.dev; )
             fi
             ;;

	 xvwcom  | xvwacq )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		echo " " | tee -a $logpath;
        	echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
#		set -x
		make_sysdirarch
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file}; )
        	( cd $sourcedir/sys$file/68k; sccs -d$sccsdir/$file get make${file}; \
		    OLDPATH=$PATH;			\
        	    PATH=$PATH:$VX_PATHS; export PATH;  \
		    VW_HOME=$INCLUDE_PATH;     	export VW_HOME;		\
		    GCC_EXEC_PREFIX=$GCC_PREFIX; export GCC_EXEC_PREFIX; \
		    CPU="MC68040" ; export CPU;				\
		    VX_CPU_FAMILY="68k" ; export VX_CPU_FAMILY;		\
		    which cc68k;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		    make -f make${file}; $PATH=$OLDPATH; export PATH )
        	( cd $sourcedir/sys$file/68k_inst; sccs -d$sccsdir/$file get make${file}; \
		    OLDPATH=$PATH;			\
        	    PATH=$PATH:$VX_PATHS; export PATH;  \
		    VW_HOME=$INCLUDE_PATH;     	export VW_HOME;		\
		    GCC_EXEC_PREFIX=$GCC_PREFIX; export GCC_EXEC_PREFIX; \
		    CPU="MC68040" ; export CPU;				\
		    VX_CPU_FAMILY="68k" ; export VX_CPU_FAMILY;		\
		    which cc68k;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		    make -f make${file} inst; $PATH=$OLDPATH; export PATH )
        	( cd $sourcedir/sys$file/ppc; sccs -d$sccsdir/$file get make${file}; \
        	    PATH=$PATH:$VX_PATH_PPC; export PATH;  \
		    VW_HOME=$INCLUDE_PATH_PPC; 	export VW_HOME;		\
		    INCLUDE_PATH=$INCLUDE_PATH_PPC; 	export INCLUDE_PATH;		\
		    GCC_EXEC_PREFIX=$GCC_PREFIX_PPC; export GCC_EXEC_PREFIX; \
		    CPU="PPC603" ; export CPU;				\
		    VX_CPU_FAMILY="ppc" ; export VX_CPU_FAMILY;		\
		    which ccppc;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		    make -f make${file}; )
        	( cd $sourcedir/sys$file/ppc_inst; sccs -d$sccsdir/$file get make${file}; \
        	    PATH=$PATH:$VX_PATH_PPC; export PATH;  \
		    VW_HOME=$INCLUDE_PATH_PPC; 	export VW_HOME;		\
		    INCLUDE_PATH=$INCLUDE_PATH_PPC; 	export INCLUDE_PATH;		\
		    GCC_EXEC_PREFIX=$GCC_PREFIX_PPC; export GCC_EXEC_PREFIX; \
		    CPU="PPC603" ; export CPU;				\
		    VX_CPU_FAMILY="ppc" ; export VX_CPU_FAMILY;		\
		    which ccppc;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		    make -f make${file} inst54; )
             fi
	     ;;
#		    VW_HOME=$VX_VW_BASE; export VW_HOME; \
#		    VX_CPU_FAMILY=68k; export VX_CPU_FAMILY; 	\



	 xnvacq | xnvdsp )
      		echo " " | tee -a $logpath;
        	echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
		set -x
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file}; )
        	( cd $sourcedir/sys$file; \
		    which ccppc;	\
		    make -f make${file}; )
	     ;;


	 xkvwacq )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		echo " " | tee -a $logpath;
        	echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
#		set -x
		make_sysdir
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file}; \
        	    PATH=$PATH:$VX_PATHS; export PATH;  \
		    VW_HOME=$INCLUDE_PATH;     	export VW_HOME;		\
		    GCC_EXEC_PREFIX=$GCC_PREFIX; export GCC_EXEC_PREFIX; \
		    CPU="MC68040" ; export CPU;				\
		    VX_CPU_FAMILY="68k" ; export VX_CPU_FAMILY;		\
		    which cc68k;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		    make -f make${file}; )
             fi
	     ;;

	 xvwauto )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		echo " " | tee -a $logpath;
        	echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
#		set -x
		make_sysdir
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file}; \
        	    PATH=$PATH:$VX_PATHS; export PATH;  \
		    VW_HOME=$INCLUDE_PATH;     	export VW_HOME;		\
		    GCC_EXEC_PREFIX=$GCC_PREFIX; export GCC_EXEC_PREFIX; 
		    CPU="CPU32" ; export CPU;				\
		    VX_CPU_FAMILY="68k" ; export VX_CPU_FAMILY;		\
		    which cc68k;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		    make -f make${file}; )
             fi
             ;;


#Below we make the integrated vxWorks and vxWorks.auto
# They also update vwacq.o, vwcom.o, and vwauto.o
# so the case-s for these *.o files could eventually be deleted
         xnvacqkernel  )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		echo " " | tee -a $logpath;
        	echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
		if [ ! -d $sourcedir/sys$file ]  
		then
		      mkdir -p $sourcedir/sys$file
		fi 
 		echo ""
		echo " ----------------  Nirvana IBM405 PPC Kernel --------------------------- "
 		echo ""
        	 ( PATH=$VX_PATH_PPC55:$PATH; export PATH;  \
		    VW_HOME=$INCLUDE_PATH_PPC55;     	export VW_HOME;	\
		    WIND_BASE=$WIND_BASE_PPC55 ; export WIND_BASE;
	    	    GCC_EXEC_PREFIX=$GCC_PREFIX_PPC55; export GCC_EXEC_PREFIX; \
		    CPU="PPC405" ; export CPU;				\
		    VX_CPU_FAMILY="ppc" ; export VX_CPU_FAMILY;		\
		    LD_LIBRARY_PATH="$WIND_BASE/host/$WIND_HOST_TYPE/lib" ; export LD_LIBRARY_PATH; \
		    which ccppc;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;		\
		    echo "LD_LIBRARY_PATH=" $LD_LIBRARY_PATH;		\
		    cd  $VW_HOME/config/nirvana_405gpr ;                    \
		    PWD=`pwd`; echo $PWD ;	\
		    echo $WIND_BASE ; echo $LD_LIBRARY_PATH ;	\
		   sccs -d$sccsdir/${file} get Makefile;		\
		   sccs -d$sccsdir/${file} get config.h;		\
		    which ccppc;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		   which make ; \
		   make dev ; 		)	
             fi
             ;;


#		    VW_HOME=$VX32_VW_BASE; export VW_HOME; \
#		    GCC_EXEC_PREFIX=$GCC_PREFIX332; export GCC_EXEC_PREFIX; 
#		    VX_CPU_FAMILY=68k; export VX_CPU_FAMILY; 	\
	xbootpd )
           if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
           then
               echo "Skipping $file, NOT done for $stdtargets"
           else
	     if [ x$targets = "xSOLARIS" ]
	     then
      		echo " " | tee -a $logpath;
        	echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
		make_sysdir
		make_objdir
		( cd $sourcedir/sys$file;				\
		   sccs -p$sccsdir/$file/SCCS get make${file} ; )
		( cd $objdir/$file;					\
		      sccs -p$sccsdir/$file/SCCS get make${file};	\
		      sccs -p$sccsdir/$file/SCCS get bootptab;	\
		      make -f make${file}; )
		else
		    echo $file must compiled on a Solaris system
	     fi
           fi
           ;;

	xtcl )
      		echo " " | tee -a $logpath;
        	echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
		make_sysdir
		make_objdir
		( cd $sourcedir/sys$file;				\
		   sccs -p$sccsdir/$file/SCCS get makevnmrwish ; )
		( cd $objdir/$file;					\
		      sccs -p$sccsdir/$file/SCCS get makevnmrwish;	\
		      make -f makevnmrwish $stdtargets; )
		( cd $objdir/../lib; \
		      sccs -p$sccsdir/$file/SCCS get makevnmrwish;	\
		      make -f makevnmrwish LIB_$stdtargets; \
		      rm -f makevnmrwish; )

                ( cd $sourcedir/sys$file

                  if [ x$OStype = "xSOLARIS" ]
                  then
                     rm -f  sol/* sgi/*
                     rsh -l chin enterprise /sw/vbin/tclprocomp spincad.tcl spingen.tcl docker.tcl
                     cp docker.tbc vnmr
                     rm -f vnmr/docker.tcl

                     if [ ! -d sol ]
                     then 
                          mkdir sol
                     fi
                     cp spincad.tbc sol
                     cp spingen.tbc sol
                     ( cd sol; /sw/vbin/tclfixtbc spincad.tbc spingen.tbc )
                  fi

                  if [ x$OStype = "xIRIX" ]
                  then
                     if [ ! -d sgi ]
                     then 
                          mkdir sgi
                     fi
                     cp spincad.tbc sgi
                     cp spingen.tbc sgi
                     ( cd sgi; /sw/vbin/tclfixtbc spincad.tbc spingen.tbc )
                  fi
                )
          ;;

         xdsp )	
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
		make_objdir
		( cd $objdir/$file;					\
		      sccs -p$sccsdir/$file/SCCS get make${file};	\
		      make -f make${file}; )
             fi
             ;;

     	 xbackproj )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else    
      		 echo " " | tee -a $logpath ;
        	 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#		 set -x
		 make_sysdir
		 make_objdir
        	 ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	 ( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file}; \
		 make -f make${file} ; )
             fi
             ;;

#     	 xdbmanager )
#             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
#             then
#                 echo "Skipping $file, NOT done for $stdtargets"
#             else    
#      		 echo " " | tee -a $logpath ;
#        	 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
##		 set -x
#		 make_sysdir
#        	 ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; \
#		 make -f make${file} ; )
#             fi
#             ;;

          xadmin )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
	     else
      		 echo " " | tee -a $logpath ;
        	 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#		 set -x
		 make_sysdir
        	( cd $sourcedir/sys$file; sccs -d$sccsjdir/$file get make${file}; \
		  PATH=$JDK_PATHS:$PATH; export PATH;  		\
		  CLASSPATH=$JDK_CLASSES; export CLASSPATH;	\
		  echo "JDK_PATH = $JDK_PATHS";			\
		  echo "CLASS_PATH = $JDK_CLASSES";		\
		  which javac;					\
		  java -version;				\
		 make -f make${file} ; )
             fi
             ;;

 	xjaccount )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
                 echo " " | tee -a $logpath ;
                 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#                set -x
                 make_sysdir
                ( cd $sourcedir/sys$file; sccs -d$sccsjdir/$file get make${file}; \
                  PATH=$JDK_PATHS:$PATH; export PATH;           \
                  CLASSPATH=$JDK_CLASSES; export CLASSPATH;     \
                  echo "JDK_PATH = $JDK_PATHS";                 \
                  echo "CLASS_PATH = $JDK_CLASSES";             \
                  which javac;                                  \
                  java -version;                                \
                  make -f make${file} ;                         \
                  sccs -d$sccsjdir/jaccount get AccountingDasho.sh;     \
                  make AccountingDasho;                         \
                  ./AccountingDasho ;                           \
                )

             fi
             ;;


          xmanagedb )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
                 echo " " | tee -a $logpath ;
                 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#                set -x
                 make_sysdir
                ( cd $sourcedir/sys$file; sccs -d$sccsjdir/$file get make${file};
                  PATH=$JDK_PATHS:$PATH; export PATH;
                  CLASSPATH=$JDK_CLASSES; export CLASSPATH;
                  echo "JDK_PATH = $JDK_PATHS";
                  echo "CLASS_PATH = $JDK_CLASSES";
                  which javac;
		  java -version;
                  make -f make${file} ;
		  sccs -d$sccsjdir/managedb get ManageDB.dox;		
		  sccs -d$sccsjdir/managedb get ManageDBDasho.sh;
		  make ManageDBDasho;			
		  ./ManageDBDasho ;		
		)
             fi
             ;;

          xvnmrbg )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then 
                 echo "Skipping $file, NOT done for $stdtargets"
             else 
                 echo " " | tee -a $logpath ;
                 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
        	 (cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file}; \
		            make -f make${file} Source;)
                 make_sysdir
		 make_objdir
        	( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file};
                  PATH=${CPLUSPLUS_PATH}:$PATH; export PATH;
		  make -f make${file} $targets; )
             fi
             ;;

          xmenujlib )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then 
                 echo "Skipping $file, NOT done for $stdtargets"
             else 
                 echo " " | tee -a $logpath ;
                 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;

                 if [ ! -d /vcommon/menujlib ]
                 then
                    mkdir /vcommon/menujlib
                 fi
                ( cd /vcommon/menujlib; sccs -d$sccsjdir/$file get make${file};
                  make -f make${file} ;
                  rm -f make${file}        ) 
             fi
             ;;

          xcryo )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
                 echo " " | tee -a $logpath ;
                 echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
#                set -x
                 make_sysdir2
                ( cd $sourcedir/sys$file; sccs -d$sccsjdir/$file get makecryobay; \
                  PATH=$JDK_PATHS:$PATH; export PATH;           \
                  CLASSPATH=$JDK_CLASSES; export CLASSPATH;     \
                  echo "JDK_PATH = $JDK_PATHS";                 \
                  echo "CLASS_PATH = $JDK_CLASSES";             \
                  echo "which javac"
                  which javac;                                  \
                  java -version;                                \
                  echo "which cc"
                  which cc;                                     \
                  make -f makecryobay SOLARIS			\
		  )
             fi
             ;;

          xhermes )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
                 echo " " | tee -a $logpath ;
                 echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
#                set -x
                 make_sysdir2
                ( cd $sourcedir/sys$file; sccs -d$sccsjdir/$file get make${file}; \
                  PATH=$JDK_PATHS:$PATH; export PATH;           \
                  CLASSPATH=$JDK_CLASSES; export CLASSPATH;     \
                  echo "JDK_PATH = $JDK_PATHS";                 \
                  echo "CLASS_PATH = $JDK_CLASSES";             \
                  echo "which javac"
                  which javac;                                  \
                  java -version;                                \
                  echo "which cc"
                  which cc;                                     \
                  make -f make${file} SOLARIS			\
		  )
             fi
             ;;

          xapt )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
                 echo " " | tee -a $logpath ;
                 echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
#                set -x
                 make_sysdir2
                ( cd $sourcedir/sys$file; sccs -d$sccsjdir/$file get make${file}; \
                  PATH=$JDK_PATHS:$PATH; export PATH;           \
                  CLASSPATH=$JDK_CLASSES; export CLASSPATH;     \
                  echo "JDK_PATH = $JDK_PATHS";                 \
                  echo "CLASS_PATH = $JDK_CLASSES";             \
                  echo "which javac"
                  which javac;                                  \
                  java -version;                                \
                  echo "which cc"
                  which cc;                                     \
                  make -f make${file}				\
		  )
             fi
             ;;

          xvnmrj )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
                 echo " " | tee -a $logpath ;
                 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#                set -x
                 make_sysdir
                ( cd $sourcedir/sys$file; sccs -d$sccsjdir/$file get make${file}; \
                  PATH=$JDK_PATHS:$PATH; export PATH;           \
                  CLASSPATH=$JDK_CLASSES; export CLASSPATH;            \
                  echo "JDK_PATH = $JDK_PATHS";                 \
                  echo "CLASS_PATH = $JDK_CLASSES";            \
		  echo 'find vnmr ( -name "*.class"-o -name "*.properties" ) -exec rm -f {};';   \
                  find vnmr \( -name "*.class" -o -name "*.properties" \) -exec \rm -f '{}' \; ;\
                  echo "which javac"
                  which javac;                                          \
                  java -version;                                       \
                  echo "which cc"
                  which cc;                                          \
                  make -f make${file} ;         \
		  sccs -d$sccsjdir/vnmrj get VnmrJ.dox;		\
		  sccs -d$sccsdir/scripts get VnmrJDasho.sh;	\
		  make VnmrJDasho;				\
		  ./VnmrJDasho ;				\
		  )
             fi
             ;;

          xvnmrjdoc )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
                 echo " " | tee -a $logpath ;
                 echo "CATEGORY: \`$file' IN \`$objdir/vnmrj'" | tee -a $logpath;
#                set -x
                 make_sysdir
                ( cd $sourcedir/sysvnmrj; sccs -d$sccsjdir/vnmrj get makevnmrj; \
                  PATH=$JDK_PATHS:$PATH; export PATH;           \
                  CLASSPATH=$JDK_CLASSES; export CLASSPATH;            \
                  echo "JDK_PATH = $JDK_PATHS";                 \
                  echo "CLASS_PATH = $JDK_CLASSES";            \
                  java -version;                                       \
                  make -f makevnmrj javaDoc; )
#                  mv -f html /vdoc/vnmrj;       \
#                  ln -s /vdoc $sourcedir/sysdoc; )
             fi
             ;;

#          xvnmrjdoc )
#             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
#             then 
#                 echo "Skipping $file, NOT done for $stdtargets"
#             else 
#                 echo " " | tee -a $logpath ;
#                 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#                 vnmrjdoc_dir="/vdoc/vnmrj/text" 
#                 if [ ! -d $vnmrjdoc_dir ] 
#                 then  
#                    mkdir -p $vnmrjdoc_dir 
#                 fi 
#                 ( cd $vnmrjdoc_dir; sccs -d$sccsjdir/$file get make${file}; \
#                   make -f make${file} ;        \
#                   ln -s /vdoc $sourcedir/sysdoc; )
#             fi    
#             ;;

          xjpsgdoc )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
	     else
      		 echo " " | tee -a $logpath ;
        	 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
                 jpsgdoc_dir="/vdoc/jpsg/text"
                 if [ ! -d $jpsgdoc_dir ]
                 then 
                    mkdir -p $jpsgdoc_dir
                 fi
#        	 ( cd $jpsgdoc_dir; sccs -d$sccsjdir/file get make${file}; \
#		   make -f make${file} ; 	\
#                   ln -s /vdoc $sourcedir/sysdoc; )
        	( cd $sourcedir/sysjpsg/src; sccs -d$sccsjdir/$file get make${file}; \
		  PATH=$JDK_PATHS:$PATH; export PATH;  		\
		  CLASSPATH=$JDK_CLASSES; export CLASSPATH;	\
		  echo "JDK_PATH = $JDK_PATHS";			\
		  echo "CLASS_PATH = $JDK_CLASSES";		\
		  which javac;					\
		  java -version;				\
		  make -f makepkg jdocs; )
             fi
             ;;

          xjplot )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
	     else
      		 echo " " | tee -a $logpath ;
        	 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
#		 set -x
		 make_sysdir
        	( cd $sourcedir/sys$file; sccs -d$sccsjdir/$file get make${file}; \
		  PATH=$JDK_PATHS:$PATH; export PATH;  		\
		  CLASSPATH=$JDK_CLASSES; export CLASSPATH;	\
		  echo "JDK_PATH = $JDK_PATHS";			\
		  echo "CLASS_PATH = $JDK_CLASSES";		\
		  which javac;					\
		  java -version; 				\
		 make -f make${file} ; )
             fi
             ;;


          xjpsg )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
	     else
      		 echo " " | tee -a $logpath ;
        	 echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		 set -x
		 make_sysdir
  		 if test ! -d $sourcedir/sys$file/src 
  		 then 
    		  echo "Creating $sourcedir/sys$file/src directory."
    		  mkdir -p $sourcedir/sys$file/src/JSRC;
  		 fi
        	( cd $sourcedir/sys$file; \
		  echo 'find lib ( -name "*.class"-o -name "*.properties" -o -name "*.jar*" ) -exec rm -f {};';   \
                  find lib \( -name "*.class" -o -name "*.properties" -o -name "*.jar*" \) -exec \rm -f '{}' \; ;\
		  echo 'find build ( -name "*.class"-o -name "*.properties" -o -name "*.jar*" ) -exec rm -f {};';   \
                  find build \( -name "*.class" -o -name "*.properties" -o -name "*.jar*" \) -exec \rm -f '{}' \; ;\
		  cd $sourcedir/sys$file/src; sccs -d$sccsjdir/$file get makepkg; \
                  PATH=$JDK_PATHS:$PATH; export PATH;           \
                  CLASSPATH=$JDK_CLASSES; export CLASSPATH;     \
                  echo "JDK_PATH = $JDK_PATHS";                 \
                  echo "CLASS_PATH = $JDK_CLASSES";             \
		  echo "which javac";				\
		  which javac;					\
		  java -version;				\
		  cleanjtb ;					\
		  make -f makepkg std; 				\
		  cd ..;					\
		  sccs -d$sccsjdir/jpsg get Jpsg.dop;		\
		  sccs -d$sccsdir/scripts get JpsgDasho.sh;	\
		  make JpsgDasho;				\
		  ./JpsgDasho ; )
             fi
             ;;

		
        *)      
		echo Updating not supported for \'"$file"\' ;
		;;
      esac
		
done

echo "Start Time: $stdate, End Time: `date '+%H:%M:%S'`"
