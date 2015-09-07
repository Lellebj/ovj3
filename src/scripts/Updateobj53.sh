: '@(#)Updateobj53.sh 22.1 03/24/08 Copyright (c) 1991-1997 Agilent Technologies'
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

# sccs, source and object path changes for 53 specific compiles
sourcedir=/vobj/sol53/common
export sourcedir
sccsdir=/vsccs/sccs53
export sccsdir
solobjdir=/vobj/sol53
export solobjdir

logdir=$sourcedir/complogs/
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
make_objdir() {
#  set -x
  if test ! -d $objdir/$file 
  then 
    echo "Creating $objdir/$file directory."
    mkdir $objdir/$file;
  fi
#  set +x
}

#--------------------  main --------------------------------
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

# VxWorks directories
VX_PATHS="/sw/VX/vw/bin/$arch:/sw/VX/gnu/$arch.68k/bin"
VX32_PATHS="/sw/VX332/bin/$arch:/sw/VX332/gnu/$arch.68k/bin"
GCC_PREFIX="/sw/VX/gnu/$arch.68k/lib/gcc-lib/"
GCC_PREFIX332="/sw/VX332/gnu/$arch.68k/lib/gcc-lib/"
VX_HOST_TYPE="/sw/VX/vw" ; export VX_HOST_TYPE;
VX_HSP_BASE="/sw/VX/vw" ; export VX_HSP_BASE;
VX_BSP_BASE="/sw/VX/vw" ; export VX_BSP_BASE;
VX_VW_BASE="/sw/VX/vw" ; export VX_VW_BASE;
VX32_VW_BASE="/sw/VX332" ; export VX32_VW_BASE;

sun3=0

# Shared library versions
ddl_ver=0.0
magical_ver=0.0

case x$OStype in
	xSunOS )	
		suntype=`uname -m`
		if (test $suntype = "sun3x" )
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

# categories not normally compile but are present
# decode, halbug, simul, xrbug 
if (test $sun3 -eq 1)
then
      filenames="autshm halmon xracq xrconf"
else
      filenames="acqi acqproc autoproc psg psglib"
fi

if test $# -lt 1
then 
 echo Categories are:
 echo $filenames
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
if (test "x$answer" != "xall")
then
   filenames=$answer
fi


if test "$stdtargets" = "SOLARIS"
then
    targets="SOLARIS"
fi

echo "Object dir: $objdir, Stdtarget: $stdtargets"

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
        	( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file}; \
		  make -f make${file} $stdtargets; )
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

	xpsg )
      		echo " " | tee -a $logpath ;
        	echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		make_sysdir
		make_objdir
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file};  \
        	  if (test $stdtargets = "SOLARIS"); then		\
        	      PATH=$gnudir/bin:$PATH; export PATH;		\
         	      GCC_EXEC_PREFIX=$gnudir/lib/gcc-lib/sparc-sun-solaris2.3/2.6.3/; export GCC_EXEC_PREFIX;\
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
         	      GCC_EXEC_PREFIX=$gnudir/lib/gcc-lib/sparc-sun-solaris2.3/2.6.3/; export GCC_EXEC_PREFIX;\
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
         	        GCC_EXEC_PREFIX=$gnudir/lib/gcc-lib/sparc-sun-solaris2.3/2.6.3/; export GCC_EXEC_PREFIX;\
        	     fi;					\
		     which cc;					\
		     echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
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
         	      GCC_EXEC_PREFIX=$gnudir/lib/gcc-lib/sparc-sun-solaris2.3/2.6.3/; export GCC_EXEC_PREFIX;\
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
		     PATH=/sw/lang30/SUNWspro/bin:/usr/ccs/bin:$PATH;
		     export PATH;
		     LM_LICENSE_FILE=/sw/lang30/SUNWspro/license_dir/sunpro.lic,1;
		     export LM_LICENSE_FILE;
		     LD_LIBRARY_PATH=/sw/lang30/SUNWspro/lib:/usr/openwin/lib;
		     export LD_LIBRARY_PATH;
		     cd $objdir/$file;
		     make -f make${file} SOLARIS;
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
         	        GCC_EXEC_PREFIX=$gnudir/lib/gcc-lib/sparc-sun-solaris2.3/2.6.3/; export GCC_EXEC_PREFIX;\
        	     fi;					\
		     which cc;					\
		     echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
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
        	( cd $sourcedir/$file; sccs -d$sccsdir/$file get makeseqlib ; )
        	cd $objdir/$file; sccs -d$sccsdir/$file get makeseqlib;
        	if (test $stdtargets = "SOLARIS") 
		then
        	    PATH=$gnudir/bin:$PATH; export PATH
         	    GCC_EXEC_PREFIX=$gnudir/lib/gcc-lib/sparc-sun-solaris2.3/2.6.3/; export GCC_EXEC_PREFIX;
        	fi
		which cc
		echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX
		make -f makeseqlib $stdtargets
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
		  	PATH=/sw/lang30/SUNWspro/bin:/usr/ccs/bin:$PATH;
		   	export PATH;
		  	 LM_LICENSE_FILE=/sw/lang30/SUNWspro/license_dir/sunpro.lic,1;
		   	export LM_LICENSE_FILE;
		   	LD_LIBRARY_PATH=/sw/lang30/SUNWspro/lib:/usr/openwin/lib;
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

	xddl )
		if test $stdtargets = "SOLARIS" -o $stdtargets = "sparc"
		then
		  echo " " | tee -a $logpath ;
        	  echo "CATEGORY: \`$file' IN \`$objdir/$file'" | tee -a $logpath;
		  make_sysdir
		  make_objdir
        	  ( cd $objdir/$file;
		    if [ $stdtargets = "sparc" ]
		    then
			PATH=/sw/CenterLine/bin:$PATH;
			export PATH;
		    else
		  	 PATH=/sw/lang30/SUNWspro/bin:/usr/ccs/bin:$PATH;
		   	export PATH;
		  	 LM_LICENSE_FILE=/sw/lang30/SUNWspro/license_dir/sunpro.lic,1;
		   	export LM_LICENSE_FILE;
		   	LD_LIBRARY_PATH=/sw/lang30/SUNWspro/lib:/usr/openwin/lib;
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
		    sccs -d$sccsdir/$file get makeddl; \
		    sccs -d$sccsdir/$file get make${file} ; )
        	  ( cd $objdir/$file;
		    if [ $stdtargets = "sparc" ]
		    then
			PATH=/sw/CenterLine/bin:$PATH;
			export PATH;
		    else
		  	 PATH=/sw/lang30/SUNWspro/bin:/usr/ccs/bin:$PATH;
		   	export PATH;
		  	 LM_LICENSE_FILE=/sw/lang30/SUNWspro/license_dir/sunpro.lic,1;
		   	export LM_LICENSE_FILE;
		   	LD_LIBRARY_PATH=/sw/lang30/SUNWspro/lib:/usr/openwin/lib;
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
		    sccs -d$sccsdir/$file get makeddl;
		    make -f makeddl;
		    if test ! -d magical
		    then
			echo "Creating `pwd`/magical.";
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
		    sccs -d$sccsdir/$file get make${file};
		    make -f make${file} )
		else
		    echo $file must compiled on a Sun system
		fi
		;;


#
#  Nessie Compilations are ansi thus on sun4 must use acc compiler
#  we need to set this up before calling the make file.
# 
	 xexpproc  | xsendproc  | xncomm | \
	 xrecvproc | xprocproc  | xnautoproc | xroboproc )
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
        	    PATH=/sw/lang201n:$PATH; export PATH;  \
		    LM_LICENSE_FILE=/sw/lang201n/license_dir/sunpro.lic,1; export LM_LICENSE_FILE; \
		    
		    LD_LIBRARY_PATH=/sw/lang201n/lib:/usr/openwin/lib; export LD_LIBRARY_PATH; \

		  make -f make${file} std dbx; )
		else
        	  ( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file} ; )
        	  ( cd $objdir/$file;  sccs -d$sccsdir/$file get make${file};  \
        	    PATH=/sw/lang30/SUNWspro/bin:/usr/ccs/bin:$PATH; export PATH;  \
		    LM_LICENSE_FILE=/sw/lang30/SUNWspro/license_dir/sunpro.lic,1; export LM_LICENSE_FILE; \
		    
		    LD_LIBRARY_PATH=/sw/lang30/SUNWspro/lib:/usr/openwin/lib; export LD_LIBRARY_PATH; \

		   make -f make${file} std dbx; )
		fi
             fi
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
        	    PATH=/sw/lang30/SUNWspro/bin:/usr/ccs/bin:$PATH; export PATH;  \
		    LM_LICENSE_FILE=/sw/lang30/SUNWspro/license_dir/sunpro.lic,1; export LM_LICENSE_FILE; \
		    
		    LD_LIBRARY_PATH=/sw/lang30/SUNWspro/lib:/usr/openwin/lib; export LD_LIBRARY_PATH; \

		   make -f make${file} SOLARIS ; )
		fi
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
        	( PATH=$VX_PATHS:$PATH; export PATH;			\
		  LM_LICENSE_FILE=/sw/VX/license.dat;	export LM_LICENCE_FILE;	\
		  GCC_EXEC_PREFIX=$GCC_PREFIX;	export GCC_EXEC_PREFIX;	\
		  VW_HOME=/sw/VX/vw;		export VW_HOME;		\
		  VWGNU_HOME=/sw/VX/gnu;	export VWGNU_HOME;	\
		  VX_HOST_TYPE=$arch;		export VX_HOST_TYPE;	\
		  VX_HSP_BASE=$VW_HOME;		export VX_HSP_BASE;	\
		  VX_BSP_BASE=$VW_HOME;		export VX_BSP_BASE;	\
		  VX_VW_BASE=$VW_HOME;		export VX_VW_BASE;	\
		  CPU=MC68040;			export CPU;		\
		  VX_CPU_FAMILY=68k;		export VX_CPU_FAMLIY;	\
                  cd $sourcedir/sys$file;				\
		  sccs -d$sccsdir/$file get Makefile;			\
		  sccs -d$sccsdir/$file get Makefile.MC68040gnu;	\
		  sccs -d$sccsdir/$file get config.h;			\
		  which cc68k;					\
		  echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		  make vxWorks.dev vxWorks.rel ; )
             fi
             ;;

         xvwautokernel )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		echo " " | tee -a $logpath;
        	echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;

		( PATH=$VX32_PATHS:$PATH; export PATH;			\
		  LM_LICENSE_FILE=/sw/VX332/license.dat;		\
		  GCC_EXEC_PREFIX=$GCC_PREFIX332;  export GCC_EXEC_PREFIX; \
		  VWGNU_HOME=/sw/VX332/gnu;	export VWGNU_HOME;	\
		  VW_HOME=/sw/VX332;     	export VW_HOME;		\
		  VX_VW_BASE=$VW_HOME;		export VX_VW_BASE;	\
		  VX_HOST_TYPE=$arch;		export VX_HOST_TYPE;	\
		  VX_HSP_BASE=$VW_HOME;		export VX_HSP_BASE;	\
		  VX_BSP_BASE=$VW_HOME;		export VX_BSP_BASE;	\
		  VX_VW_BASE=$VW_HOME;		export VX_VW_BASE;	\
		  CPU=CPU32;			export CPU;	\
		  VX_CPU_FAMILY=68k;		export VX_CPU_FAMILY;	\
                  cd $sourcedir/sys$file;				\
		  sccs -d$sccsdir/$file get Makefile;			\
		  sccs -d$sccsdir/$file get Makefile.CPU32gnu;		\
		  sccs -d$sccsdir/$file get config.h;			\
		  which cc68k;					\
		  echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		  make vxWorks.rel vxWorks.dev; )
             fi
             ;;

	 xvwcom  | xvwacq  )
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
      		echo " " | tee -a $logpath;
        	echo "CATEGORY: \`$file' IN \`$sourcedir/sys$file'" | tee -a $logpath;
#		set -x
		make_sysdir
        	( cd $sourcedir/sys$file; sccs -d$sccsdir/$file get make${file}; \
        	    PATH=$VX_PATHS:$PATH; export PATH;  \
		    GCC_EXEC_PREFIX=$GCC_PREFIX; export GCC_EXEC_PREFIX; 
		    VW_HOME=$VX_VW_BASE; export VW_HOME; \
		    VX_CPU_FAMILY=68k; export VX_CPU_FAMILY; 	\
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
        	    PATH=$VX32_PATHS:$PATH; export PATH;  \
		    GCC_EXEC_PREFIX=$GCC_PREFIX332; export GCC_EXEC_PREFIX332; 
		    VW_HOME=$VX32_VW_BASE; export VW_HOME; \
		    VX_CPU_FAMILY=68k; export VX_CPU_FAMILY; 	\
		    which cc68k;					\
		    echo "GCC_EXEC_PREFIX=" $GCC_EXEC_PREFIX;	\
		    make -f make${file}; )
             fi
             ;;

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
		   sccs -p$sccsdir/$file/SCCS get makevnmrwish ; )
		( cd $objdir/$file;					\
		      sccs -p$sccsdir/$file/SCCS get makevnmrwish;	\
		      make -f makevnmrwish; )
		else
		    echo $file must compiled on a Solaris system
	     fi
          fi
          ;;

         xdsp )	
             if test $stdtargets = "IRIX" -o $stdtargets = "AIX"
             then
                 echo "Skipping $file, NOT done for $stdtargets"
             else
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

        *)      
		echo Updating not supported for \'"$file"\' ;
		;;
      esac
		
done
