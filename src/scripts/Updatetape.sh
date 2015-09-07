#! /bin/sh
: '@(#)Updatetape.sh 22.1 03/24/08 1991-2006 '
#
# Copyright (C) 2015  University of Oregon
# 
# You may distribute under the terms of either the GNU General Public
# License or the Apache License, as specified in the README file.
# 
# For more information, see the README file.
# 
#
#
#  update tape directories 
#  Updatetape [category] [target]
#  if no category is given then user is prompted for category
#  similarly with target

#  Changes in this script must be coordinated with changes
#  in the script ``vnmr_tarout'' or ``limnet_tarout''

#  Establish SCCS categories to update

# ISO quality record log
logdir=$sourcedir/complogs/
lognam=Tapelog`uname -m`
logpath=${logdir}$lognam
#stripper="IRIS rdibm warpspeed"
stripper="IRIS"


# function to strip the objects with the proper machine
strip_obj() {
#  set -x
   if (test $ok2strip = "y")
    then
      case x$target in

#       xsun4 )
#	set -x
#	   strip $1
#	;;

       xsgi)
	set -x
	   rsh IRIS strip $1
	;;
       xibm )
	set -x
	   rsh rdibm strip $1
	;;
       xsol | xgem | xinova )
	set -x
	   strip $1
#	   rsh enterprise strip $1
	;;
	*)
	;;
       esac
      set +x
   fi
}

# function to make the directory tree needed to compile a program

make_objdir() {
#  set -x
  if test ! -d $1
  then 
    echo "Creating $1 directory."
    mkdir -p $1 ;
  fi
  set +x
}

# function to make symbolic link, if link doesn't already exist (avoid error msges)
make_ln() {
#set -x
  if test ! -f $2
  then
     echo "ln -s $1 $2"
     /usr/bin/ln -s $1 $2
  else
     echo "$1 -> $2 link OK."
  fi
# set +x
}


# Function to extract X resource files from SCCS
# get_xresource_file category tapedir subdir name
# E.g.: "get_xresource_file acqi tape_sol app-defaults Acqi"

get_xresource_file() {
    make_objdir $commondir/$2/$3
    (cd $commondir/$2/$3;
     PATH=$PATH:/usr/lib:/usr/ccs/lib; export PATH;
     rm -f $4;
     sccs -p$sccsdir/$1/SCCS get $4;
     cpp -P -D$2=$2 $4 $$.i;
     mv -f $$.i $4)
}

# function to copy special category programs
# for example:  get_special_progs stars STARS sol starsprg

get_special_progs() {
	make_objdir $commondir/$2
	make_objdir $commondir/$2/tape_$3
	make_objdir $commondir/$2/tape_$3/bin
	set -x
	(cd $commondir/$2/tape_$3/bin; rm -f $4; cp $objdir/proglib/$1/$4 $4)
	set +x
}

# function to strip object files in a special category
# it has one fewer args than get_psecial_progs, since the
# SCCS category is no longer required.
# Thus: strip_special_progs STARS sol starsprg

strip_special_progs()
{
	strip_obj $commondir/$1/tape_$2/bin/$3
}

#--------------------  main --------------------------------
 echo " "
 echo `date`
 echo " "
 echo "Writing ISO Quality Record to: "
 echo "Directory: $logdir "
 echo " "
 printf "New Directory [%s]: " $logdir
 # echo -n "New Directory [$logdir]: "
 read tmpdir
 if [ x$tmpdir = "x" ]
 then
     tmpdir=$logdir
 fi
 logdir=$tmpdir
 echo " "
 echo "File Name: $lognam "
 printf "New File Name [%s]: " $lognam
 # echo -n "New File Name [$lognam]: "
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
echo Host: `hostname`  Type: `uname -m`  | tee -a $logpath
echo " "  | tee -a $logpath

# Shared Library Version
so_ver=$psg_so_ver
LIB_ACQCOM_SO="2.0"

if test $# -lt 1
then 
 echo Categories are:
 ls -C $sccsdir
 echo
 echo Java Categories are:
 ls -C $sccsjdir
 echo
 printf "Category for updating, or all [all]: "
 # echo -n "Category for updating, or all [all]: "
 read answer
else
 answer=$1
 shift 1
fi
if [ "x$answer" = "x" ]
then
   answer="all"
fi
if (test "x$answer" = "xall")
then
   chosen_categories=`ls -C $sccsdir`
   chosen_categories="$chosen_categories `ls -C $sccsjdir`"
else
   chosen_categories=$answer
fi

#  Establish targets for updating, SUN-3, SUN-4 or COMMON

# all_targets="sun4 sgi ibm sol gem common inova"
all_targets="sgi ibm sol gem common inova"
if test $# -lt 1
then
 echo Targets are: $all_targets
 printf "Target for updating, or all [std]: "
 # echo -n "Target for updating, or all [all]: "
 read answer
else
 answer=$1
 shift 1
fi

if [ "x$answer" = "x" ]
then
   answer="std"
fi

if (test "x$answer" = "xall")
then
  chosen_targets=$all_targets
elif(test "x$answer" = "xstd")
then
  chosen_targets="sol gem inova common"
else
  chosen_targets=$answer
fi

ok2strip="y"
stripmode="be stripped"
if test $# -lt 1
then
 printf "Strip binaries (y or n) [n]: "
 # echo -n "Strip binaries (y or n) [n]: "
 read answer
 if [ "x$answer" = "x" ]
 then
    answer="n"
 fi

 if (test "x$answer" = "xn" )
 then
  ok2strip="n"
  stripmode="NOT be stripped"
 else
    echo "Checking access to IBM & SGI host for stripping"
    for ihost in $stripper
    do
      printf "Checking access to %s: " $ihost
#       echo -n "Checking access to $ihost: "
      rsh $ihost "echo 0 > /dev/null"
      if [ "$?" -ne 0 ]
      then
        echo "$0 : Problem with reaching remote host $ihost"
        exit 1
      else
        echo " OK"
      fi
    done
 fi
fi

echo    " " | tee -a $logpath
echo    "CATEGORIES:" | tee -a $logpath
echo    "$chosen_categories" | tee -a $logpath
echo    " " | tee -a $logpath
echo    "TARGETS:    $chosen_targets" | tee -a $logpath
echo    " " | tee -a $logpath
echo    "Binaries will $stripmode." | tee -a $logpath
echo    " " | tee -a $logpath
printf "Type <C/R> to continue, ^C to quit: "
# echo -n "Type <C/R> to continue, ^C to quit: "
read answer

for target in $chosen_targets
do
    if (test x$target = "xgem")
    then
      objdir=$solobjdir
      sobjdir=$solobjdir
    elif (test x$target = "xsun4")
    then
      objdir=$sun4objdir
      sobjdir=$sun4objdir
    elif (test x$target = "xsgi")
    then
      objdir=$sgiobjdir
      sobjdir=$sgiobjdir
    elif (test x$target = "xibm")
    then
      objdir=$ibmobjdir
      sobjdir=$ibmobjdir
    elif (test x$target = "xsol")
    then
      objdir=$solobjdir
      sobjdir=$solobjdir
    elif (test x$target = "xinova")
    then
      objdir=$solobjdir
      sobjdir=$solobjdir
    else
      objdir=$commondir
      sobjdir=$commondir
    fi

    lnxobjdir="/vobj/lnx"

    for category in $chosen_categories
    do
       case x$category in

       xaccounting)
         case x$target in
            xgem | xsgi | xibm | xinova | xsun4 )
	       echo "Skipping category: $category   target: $target"
	       continue;
	       ;;

            xcommon )
	       filelist="update_acctng view_acctng console_acct"
	       make_objdir $objdir/adm/bin
	       for xfile in $filelist
	       do
		  set -x
       		  rm -f $objdir/adm/bin/$xfile
		  cp -p $solobjdir/proglib/$category/$xfile $objdir/adm/bin/$xfile
		  set +x
		  echo $xfile >> $logpath
	       done
	       continue;
	       ;;

	    xsol )
	       filelist="console_login"
	       make_objdir $objdir/adm/bin
	       for xfile in $filelist
	       do
		  set -x
       		  rm -f $objdir/adm/bin/$xfile
		  cp -p $objdir/proglib/$category/$xfile $objdir/adm/bin/$xfile
	  	  set +x
		  echo $xfile >> $logpath
	       done
	       continue;
	       ;;

         esac
         ;;

       xacqproc)

         case x$target in
            xcommon | xgem | xsgi | xibm | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

      	echo " "
	echo " " >> $logpath
	make_objdir $objdir/acqbin
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
        if (test x$target = "xsol")
        then
	    filelist="Acqproc startacqproc killacqproc"
        else
	    filelist="Acqproc test4acq killacq startacqproc killacqproc"
        fi
		echo "acqproc file list: $filelist"
	set -x
	for xfile in $filelist
	do
	  echo $xfile >> $logpath
          rm -f $objdir/acqbin/$xfile
	  cp -p $sobjdir/proglib/$category/$xfile $objdir/acqbin/$xfile
	  set +x
	  strip_obj $objdir/acqbin/$xfile
	  set -x
	done
	set +x
	;;

       xautoproc)

         case x$target in
            xcommon | xgem | xsgi | xibm | xinova)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

	make_objdir $objdir/acqbin
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	set -x
	  echo " " >> $logpath
	  echo Autoproc >> $logpath
	rm -f $objdir/acqbin/Autoproc
	cp -p $sobjdir/proglib/$category/Autoproc $objdir/acqbin/Autoproc
	set +x
	strip_obj $objdir/acqbin/Autoproc
	;;

       xacqi)

         case x$target in
            xcommon | xgem | xsgi | xibm | xinova)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

	make_objdir $objdir/bin
	make_objdir $objdir/binx
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
        if (test x$target = "xsol")
        then
	    echo "iadisplay_ow " >> $logpath
	    set -x
	    cp -p $sobjdir/proglib/$category/uplusobj/iadisplay_ow $objdir/bin/iadisplay
	    cp -p $sobjdir/proglib/$category/iiadisplay   $objdir/bin/iiadisplay
	    set +x
	    strip_obj $objdir/bin/iadisplay
	    strip_obj $objdir/bin/iiadisplay
	    tapedir="sol"
        else
	    echo "iadisplay, iadisplay_ow " >> $logpath
	    set -x
	    rm -f $objdir/bin/iadisplay
	    cp -p $sobjdir/proglib/$category/iadisplay $objdir/bin/iadisplay
	    rm -f $objdir/binx/iadisplay
	    cp -p $sobjdir/proglib/$category/uplusobj/iadisplay_ow $objdir/binx/iadisplay
	    set +x
	    strip_obj $objdir/bin/iadisplay
	    strip_obj $objdir/binx/iadisplay
	    tapedir="sun"
        fi
	echo "autoshim " >> $logpath
	set -x
	rm -f $objdir/bin/autoshim
	cp -p $sobjdir/proglib/$category/autoshim $objdir/bin/autoshim
	set +x
	strip_obj $objdir/bin/autoshim

	if [ $tapedir ]
	then
	    get_xresource_file $category tape_$tapedir app-defaults Acqi
	fi
	;;

       xstat)

	make_objdir $objdir/bin
	make_objdir $objdir/binx
	make_objdir $objdir/acqbin

         case x$target in
            xcommon | xgem | xinova)
	      echo "Skipping category: $category   target: $target" | tee -a $logpath
	    set +x
	      continue;
		;;
	    xsun4 )
      	      echo " " | tee -a $logpath
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	      echo " " >> $logpath
	      echo "Acqstat   Acqstat_ow  acqinfo_svc" >> $logpath
	      set -x
              rm -f $objdir/bin/Acqstat
	      cp -p $sobjdir/proglib/$category/Acqstat $objdir/bin/Acqstat
              rm -f $objdir/binx/Acqstat
	      cp -p $sobjdir/proglib/$category/Acqstat_ow $objdir/binx/Acqstat
              rm -f $objdir/acqbin/acqinfo_svc
	      cp -p $sobjdir/proglib/$category/acqinfo_svc $objdir/acqbin/acqinfo_svc
              rm -f $objdir/bin/showstat
	      cp -p $sobjdir/proglib/$category/showstat $objdir/bin/showstat
              rm -f $objdir/bin/Acqmeter
	      cp -p $sobjdir/proglib/$category/Acqmeter $objdir/bin/Acqmeter
	      set +x
	      echo " " >> $logpath
	      strip_obj $objdir/bin/Acqstat
	      strip_obj $objdir/binx/Acqstat
	      strip_obj $objdir/acqbin/acqinfo_svc
	      strip_obj $objdir/bin/showstat
	      strip_obj $objdir/bin/Acqmeter
	    ;;
            xsol )
      	      echo " " | tee -a $logpath
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	      echo " " >> $logpath
	      echo "Acqstat  Infostat  acqinfo_svc" >> $logpath
              set -x
              rm -f $objdir/bin/Acqstat
	      cp -p $sobjdir/proglib/$category/Acqstat $objdir/bin/Acqstat
              rm -f $objdir/bin/Infostat
	      cp -p $sobjdir/proglib/$category/Infostat $objdir/bin/Infostat
              rm -f $objdir/acqbin/acqinfo_svc
	      cp -p $sobjdir/proglib/$category/acqinfo_svc $objdir/acqbin/acqinfo_svc
              rm -f $objdir/bin/showstat
	      cp -p $sobjdir/proglib/$category/showstat $objdir/bin/showstat
              rm -f $objdir/bin/Acqmeter
	      cp -p $sobjdir/proglib/$category/Acqmeter $objdir/bin/Acqmeter
              set +x
	      echo " " >> $logpath
	      strip_obj $objdir/bin/Acqstat
	      strip_obj $objdir/bin/Infostat
	      strip_obj $objdir/acqbin/acqinfo_svc
	      strip_obj $objdir/bin/showstat
	      strip_obj $objdir/bin/Acqmeter
            ;;
            xibm | xsgi )
      	      echo " " | tee -a $logpath
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	      echo " " >> $logpath
	      echo "Acqstat  acqinfo_svc" >> $logpath
              set -x
              rm -f $objdir/bin/Acqstat
	      cp -p $sobjdir/proglib/$category/Acqstat $objdir/bin/Acqstat
              rm -f $objdir/acqbin/acqinfo_svc
	      cp -p $sobjdir/proglib/$category/acqinfo_svc $objdir/acqbin/acqinfo_svc
              rm -f $objdir/bin/showstat
	      cp -p $sobjdir/proglib/$category/showstat $objdir/bin/showstat
              rm -f $objdir/bin/Acqmeter
	      cp -p $sobjdir/proglib/$category/Acqmeter $objdir/bin/Acqmeter
              set +x
	      echo " " >> $logpath
	      strip_obj $objdir/bin/Acqstat
	      strip_obj $objdir/acqbin/acqinfo_svc
	      strip_obj $objdir/bin/showstat
	      strip_obj $objdir/bin/Acqmeter
            ;;
          esac

	set +x
	;;

       xfdm )
	case x$target in
            xsun4 | xsgi | xibm | xinova | xgem | xcommon )
            echo "Skipping category: $category   target: $target"
	    set +x
            continue;
               ;;
	esac

	filelist="fdm1 fdm2"
	for xfile in $filelist
	do
	  echo $xfile >> $logpath
	    set -x
            rm -f $objdir/bin/$xfile
	    cp -p $sobjdir/proglib/$category/$xfile $objdir/bin/$xfile
	    set +x
	    strip_obj $objdir/bin/$xfile
	done
	;;

       xpsg)
	dest="psg"
	source="psg"
        case x$target in
            xgem )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;

	   xcommon)
		make_objdir $objdir/bin
		echo " " | tee -a $logpath
		echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		echo " " >> $logpath
		echo "psg/* " >> $logpath
		set -x
		( cd $commondir/psg; make -f $sourcedir/syspsg/makepsg userp )
		( cd $commondir/nuctables; sccs -d$sccsdir/psg get lockfreqtab )
	        set +x
		continue;
	  ;;

          xsun4 )
	        filelist="libpsglib.a libparam.a libpsglib.so.$so_ver \
		  libparam.so.$so_ver x_ps.o"
          ;;

          xinova )
		continue;
#	        filelist="libpsglib_nes.a libparam_nes.a libpsglib.so.$so_ver \
#		  libparam.so.$so_ver x_ps.o"
#		dest="npsg"
#		source="npsg/sol"
          ;;

          xsol )
	        filelist="libpsglib.a libparam.a libpsglib.so.$so_ver \
		  libparam.so.$so_ver x_ps.o"
          ;;

          xsgi )
	        filelist="libpsglib.a libparam.a libpsglib.so \
		  libparam.so x_ps.o"
          ;;
 	  xibm )
	        filelist="libpsglib.a libparam.a x_ps.o"
	  ;;

	esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath

	echo " " >> $logpath
	make_objdir $objdir/$dest

	for xfile in $filelist
	do
	  echo $xfile >> $logpath
	  set -x
          rm -f $objdir/$dest/$xfile
	  cp -p $sobjdir/proglib/$source/$xfile $objdir/$dest/$xfile
	  set +x
	done
	rm -f libpsglib.so libparam.so

#  Following required for shared libraries to really work on Solaris

        if (test x$target = "xsol" -o x$target = "xinova")
        then
set -x
           (cd $objdir/$dest; 	\
		make_ln libparam.so.$so_ver libparam.so ; \
                make_ln libpsglib.so.$so_ver libpsglib.so; )
#	   ln -s libparam.so.$so_ver libparam.so; \
#           ln -s libpsglib.so.$so_ver libpsglib.so; )
set +x
        fi

	echo seqgenmake >> $logpath
	make_objdir $objdir/acqbin
	set -x
        rm -f $objdir/acqbin/seqgenmake
        cp -p $sourcedir/syspsg/seqgenmake $objdir/acqbin/seqgenmake
 
	set +x
	;;

       xkpsglib)
         case x$target in
            xgem | xsun4 | xsgi | xibm | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac
	if (test x$target = "xcommon")
	then
	  make_objdir $commondir/kpsglib
	  echo " " 
	  echo "CATEGORY: $category   TARGET: $target" | tee -a $logpath
	  echo " " >> $logpath
	 set +x
	  ( cd $commondir/kpsglib; rm -f *; cp -p $sourcedir/syskpsglib/*.c .  ; \
		 rm -f *make*; )
	 set +x
		( make_objdir $objdir/kpsglib;
		  cd $objdir/kpsglib;
		  sccs -d$sccsdir/kpsglib get makekpsglib
		  make -ef makekpsglib TARGET_DIR=$objdir/kpsglib all
		)
		( make_objdir $objdir/gPFG/psglib;
		  cd $objdir/gPFG/psglib;
		  sccs -d$sccsdir/kpsglib get makekpsglib
		  make -ef makekpsglib TARGET_DIR=$objdir/kpsglib pfg
		)
	    set +x
	  continue;
	fi

	make_objdir $objdir/kseqlib
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set +x
	( cd $objdir/kseqlib; rm -f * )
	( cd $sobjdir/proglib/kseqlib; cp -p * $objdir/kseqlib)
	( cd $objdir/kseqlib; rm -f *.c; rm -f *.h; rm -f *.o; rm -f *.p; \
	     rm -f errmsg makekseqlib* ; )
	set +x
        ( cd $objdir/kseqlib; filelist=`ls *` ; for xfile in $filelist ;  \
					do  echo $xfile >> $logpath ; done; )
	strip_obj "`ls $objdir/kseqlib/*`"
	( cd $sourcedir/syskpsglib; rm -f *.h; rm -f *.o; rm -f *.p; \
	     rm -f errmsg makekseqlib* )
	set +x
	;;

       xgpsglib)
         case x$target in
            xgem | xsun4 | xsgi | xibm | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac
	if (test x$target = "xcommon")
	then
	  make_objdir $commondir/gpsglib
	  echo " " 
	  echo "CATEGORY: $category   TARGET: $target" | tee -a $logpath
	  echo " " >> $logpath
	 set +x
	  ( cd $commondir/gpsglib; rm -f *; cp -p $sourcedir/sysgpsglib/*.c .  ; \
		 rm -f *make*; )
	 set +x
          ( cd $commondir/gpsglib; filelist=`ls *` ; for xfile in $filelist ;  \
					do  echo $xfile >> $logpath ; done; )
	    set +x
	  continue;
	fi

	make_objdir $objdir/gseqlib
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set +x
	( cd $objdir/gseqlib; rm -f * )
	( cd $sobjdir/proglib/gseqlib; cp -p * $objdir/gseqlib)
	( cd $objdir/gseqlib; rm -f *.c; rm -f *.h; rm -f *.o; rm -f *.p; \
	     rm -f errmsg makegseqlib* ; )
	set +x
        ( cd $objdir/gseqlib; filelist=`ls *` ; for xfile in $filelist ;  \
					do  echo $xfile >> $logpath ; done; )
	strip_obj "`ls $objdir/gseqlib/*`"
	( cd $sourcedir/sysgpsglib; rm -f *.h; rm -f *.o; rm -f *.p; \
	     rm -f errmsg makegseqlib* )
	set +x
	;;

       xpsglib)
         case x$target in
            xgem | xcommon | xinova | xsun4 | xsgi | xibm | xsol )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	    xcommon_unused )
	      echo " " 
	      echo "CATEGORY: $category   TARGET: $target" | tee -a $logpath
	      echo " " >> $logpath
	     set -x
		( make_objdir $objdir/psglib;
		  cd $objdir/psglib;
		  sccs -d$sccsdir/psglib get makepsglib
		  make -ef makepsglib TARGET_DIR=$objdir/psglib
		)
		( make_objdir  $objdir/Gmap/psglib;
		  cd $objdir/Gmap/psglib;
		  sccs -d$sccsdir/psglib get makepsglib
		  make -ef makepsglib TARGET_DIR=$objdir/Gmap/psglib Gmap
		)
		( make_objdir  $objdir/Gxyz/psglib;
		  cd $objdir/Gxyz/psglib;
		  sccs -d$sccsdir/psglib get makepsglib
		  make -ef makepsglib TARGET_DIR=$objdir/Gxyz/psglib Gxyz
		)
		( make_objdir $objdir/LCNMR/psglib;
		  cd $objdir/LCNMR/psglib;
		  sccs -d$sccsdir/psglib get makepsglib
		  make -ef makepsglib TARGET_DIR=$objdir/LCNMR/psglib LCNMR
		)
		( make_objdir $objdir/Diffusion/psglib;
		  cd $objdir/Diffusion/psglib;
		  sccs -d$sccsdir/psglib get makepsglib
		  make -ef makepsglib TARGET_DIR=$objdir/Diffusion/psglib Diffusion
		)
		( make_objdir $objdir/DOSY/psglib;
		  cd $objdir/DOSY/psglib;
		  sccs -d$sccsdir/psglib get makepsglib
		  make -ef makepsglib TARGET_DIR=$objdir/DOSY/psglib DOSY
		)
		( make_objdir $objdir/Gilson/psglib;
		  cd $objdir/Gilson/psglib;
		  sccs -d$sccsdir/psglib get makepsglib
		  make -ef makepsglib TARGET_DIR=$objdir/Gilson/psglib Gilson
		)
		( make_objdir $objdir/PFG/psglib;
		  cd $objdir/PFG/psglib;
		  sccs -d$sccsdir/psglib get makepsglib
		  make -ef makepsglib TARGET_DIR=$objdir/PFG/psglib pfg
		)
		( make_objdir $objdir/IMAGE/psglib;
		  cd $objdir/IMAGE/psglib;
		  sccs -d$sccsdir/psglib get makepsglib
		  make -ef makepsglib TARGET_DIR=$objdir/IMAGE/psglib sis
		)
		( make_objdir $objdir/IMAGE_patent/psglib;
		  cd $objdir/IMAGE_patent/psglib;
		  sccs -d$sccsdir/psglib get makepsglib
		  make -ef makepsglib TARGET_DIR=$objdir/IMAGE_patent/psglib ImagePatent
		)
		( make_objdir $objdir/Backproj/psglib;
		  cd $objdir/Backproj/psglib;
		  sccs -d$sccsdir/psglib get makepsglib
		  make -ef makepsglib TARGET_DIR=$objdir/Backproj/psglib backproj
		)
		( make_objdir $objdir/CSI/psglib;
		  cd $objdir/CSI/psglib;
		  sccs -d$sccsdir/psglib get makepsglib
		  make -ef makepsglib TARGET_DIR=$objdir/CSI/psglib csi
		)
	     set +x
	      ;;

	    xinova_unused )
		make_objdir $objdir/nseqlib
      		echo " " | tee -a $logpath
        	echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		echo " " >> $logpath
		set +x
		( cd $objdir/nseqlib; rm -f * )
		( cd $sobjdir/proglib/$category; cp -p * $objdir/nseqlib)
		( cd $objdir/nseqlib; rm -f *.c; rm -f *.h; rm -f *.o; rm -f *.p; \
	     	rm -f errmsg makeseqlib*  ; )
		set +x
        	( cd $objdir/nseqlib; filelist=`ls *` 
		  for xfile in $filelist
		  do  echo $xfile >> $logpath ; done; )
		strip_obj "`ls $objdir/nseqlib/*`"
		( cd $sourcedir/psglib; rm -f *.h; rm -f *.o; rm -f *.p; \
	     	rm -f errmsg makeseqlib* )
		set -x
		sccs -d$sccsdir/psglib get makeseqlib
		( make_objdir $commondir/Gmap/seqlib;
		  rm -f $commondir/Gmap/seqlib/* ;
		  make -ef makeseqlib SRC_DIR=$sobjdir/proglib/psglib TARGET_DIR=$commondir/Gmap/seqlib Gmap
		)
		( make_objdir $commondir/Gxyz/seqlib;
		  rm -f $commondir/Gxyz/seqlib/* ;
		  make -ef makeseqlib SRC_DIR=$sobjdir/proglib/psglib TARGET_DIR=$commondir/Gxyz/seqlib Gxyz
		)
		( make_objdir $commondir/LCNMR/seqlib;
		  rm -f $commondir/LCNMR/seqlib/* ;
		  make -ef makeseqlib SRC_DIR=$sobjdir/proglib/psglib TARGET_DIR=$commondir/LCNMR/seqlib LCNMR
		)
		( make_objdir $commondir/Diffusion/seqlib;
		  rm -f $commondir/Diffusion/seqlib/* ;
		  make -ef makeseqlib SRC_DIR=$sobjdir/proglib/psglib TARGET_DIR=$commondir/Diffusion/seqlib Diffusion
		)
		( make_objdir $commondir/DOSY/seqlib;
		  rm -f $commondir/DOSY/seqlib/* ;
		  make -ef makeseqlib SRC_DIR=$sobjdir/proglib/psglib TARGET_DIR=$commondir/DOSY/seqlib DOSY
		)
		( make_objdir $commondir/Gilson/seqlib;
		  rm -f $commondir/Gilson/seqlib/* ;
		  make -ef makeseqlib SRC_DIR=$sobjdir/proglib/psglib TARGET_DIR=$commondir/Gilson/seqlib Gilson
		)
		( make_objdir $commondir/PFG/seqlib;
		  rm -f $commondir/PFG/seqlib/* ;
		  make -ef makeseqlib SRC_DIR=$sobjdir/proglib/psglib TARGET_DIR=$commondir/PFG/seqlib pfg
		)
		( make_objdir $commondir/IMAGE/seqlib;
		  rm -f $commondir/IMAGE/seqlib/* ;
		  make -ef makeseqlib SRC_DIR=$sobjdir/proglib/psglib TARGET_DIR=$commondir/IMAGE/seqlib sis
		)
		( make_objdir $commondir/IMAGE_patent/seqlib;
		  rm -f $commondir/IMAGE_patent/seqlib/* ;
		  make -ef makeseqlib SRC_DIR=$sobjdir/proglib/psglib TARGET_DIR=$commondir/IMAGE_patent/seqlib ImagePatent
		)
		( make_objdir $commondir/Backproj/seqlib;
		  rm -f $commondir/Backproj/seqlib/* ;
		  make -ef makeseqlib SRC_DIR=$sobjdir/proglib/psglib TARGET_DIR=$commondir/Backproj/seqlib backproj
		)
		( make_objdir $commondir/CSI/seqlib;
		  rm -f $commondir/CSI/seqlib/* ;
		  make -ef makeseqlib SRC_DIR=$sobjdir/proglib/psglib TARGET_DIR=$commondir/CSI/seqlib csi
		)
		rm -f makeseqlib
		set +x
		;;
	    * )
		make_objdir $objdir/seqlib
      		echo " " | tee -a $logpath
        	echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		echo " " >> $logpath
		set +x
		( cd $objdir/seqlib; rm -f * )
		( cd $sobjdir/proglib/$category; cp -p * $objdir/seqlib)
		( cd $objdir/seqlib; rm -f *.c; rm -f *.h; rm -f *.o; rm -f *.p; \
	     	rm -f errmsg makeseqlib* ; )
		set +x
        	( cd $objdir/seqlib; filelist=`ls *` ; for xfile in $filelist ; do  echo $xfile >> $logpath ; done; )
		strip_obj "`ls $objdir/seqlib/*`"
		set +x
		( cd $sourcedir/psglib; rm -f *.h; rm -f *.o; rm -f *.p; \
	     	rm -f errmsg makeseqlib* )
		set +x
		;;
	 esac
	set +x
	;;

       xdsp )
	case x$target in
	   xinova )
	      echo " " >> $logpath
	      make_objdir $objdir/acq
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		  set -x
                  cp -p $sobjdir/proglib/dsp/nskip1.ram  $objdir/acq/tms320dsp.ram
		  set +x
           ;;

            *)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;

	esac
	;;

# xracq, autshm and halmon are 68000 programs; thus these 
# categories are skipped if target is SUN3 or SUN4

       xxracq)

         case x$target in
            xgem | xsun4 | xsol | xsgi | xibm | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac


	make_objdir $commondir/acq
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set -x
	rm -f $commondir/acq/xr.out
	rm -f $commondir/acq/xrop.out
	rm -f $commondir/acq/xrxrp.out
	rm -f $commondir/acq/xrxrl.out
	rm -f $commondir/acq/xrxrh.out
 	rm -f $commondir/acq/xrxrp_img.out
 	rm -f $commondir/acq/xrxrh_img.out
	cp -p $sourcedir/sys$category/xrop.out $commondir/acq/xrop.out
	cp -p $sourcedir/sys$category/xrxrp.out $commondir/acq/xrxrp.out
	cp -p $sourcedir/sys$category/xrxrh.out $commondir/acq/xrxrh.out
#   imaging object are now named xrxrp.out & xrxrh.out and are the standard 7/30/96  GMB
#	cp -p $sourcedir/sys$category/xrxrp_img.out $commondir/acq/xrxrp_img.out
#	cp -p $sourcedir/sys$category/xrxrh_img.out $commondir/acq/xrxrh_img.out
	set +x
        echo "xrop.out xrxrp.out xrxrl.out xrxrh.out" >> $logpath
#	echo "xrxrp_img.out xrxrh_img.out" >> $logpath
	;;

       xxrconf)

         case x$target in
            xgem | xsun4 | xsol | xsgi | xibm | xinova)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

	make_objdir $commondir/acq
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set -x
	rm -f $commondir/acq/xr.conf
	cp -p $sourcedir/sys$category/xr.conf $commondir/acq/xr.conf
	set +x
	echo "xr.conf" >> $logpath
	;;

       xautshm)

         case x$target in
            xgem | xsun4 | xsol | xsgi | xibm | xinova)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

	make_objdir $commondir/acq
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set -x
#	rm -f $commondir/acq/autshm.out
#	rm -f $commondir/acq/autshm_img.out
#	cp -p $sourcedir/sys$category/autshm.out $commondir/acq/autshm.out
#   imaging object are now named autshm.out and are the standard 7/30/96  GMB
#	cp -p $sourcedir/sys$category/autshm_img.out \
#		$commondir/acq/autshm_img.out
	set +x
	echo "autshm is done in Updatetape53" >> $logpath
#	echo "autshm autshm_img" >> $logpath
	;;

       xhalmon)

         case x$target in
            xgem | xsun4 | xsol | xsgi | xibm | xinova)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

	make_objdir $commondir/acq
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set -x
	rm -f $commondir/acq/rhmon.out
	cp -p $sourcedir/sys$category/rhmon.out $commondir/acq/rhmon.out
	set +x
	echo "rhmon.out" >> $logpath
	;;

       xscripts)
        case x$target in
            xgem )
      	      echo " "
	      echo "Skipping category: $category   target: $target"
      	      echo " "
	    set +x
	      continue;
	    ;;
	    xsol )
	       get_xresource_file $category \
			tape_$target user_templates .Xdefaults
	       (cd $commondir/tape_$target/user_templates;
		rm -f .dtprofile;
	        sccs -p$sccsdir/$category/SCCS get .dtprofile;)
	       get_xresource_file $category tape_$tapedir app-defaults XTerm
	       continue;
	    ;;
	    xsgi | xibm )
	       get_xresource_file $category \
			tape_$target user_templates .Xdefaults
	       continue;
	    ;;
            xsun4 )
	       get_xresource_file $category \
			tape_sun user_templates .Xdefaults
      	       echo " " | tee -a $logpath
               echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	       echo " " >> $logpath
	       echo vxrTool >> $logpath
	       set -x
               rm -f $objdir/binx/vxrTool
	       cp -p $sourcedir/sys$category/vxrTool $objdir/binx/vxrTool
	       set +x
	    ;;
	   xcommon )
      	      echo " " | tee -a $logpath
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
      	      echo " " | tee -a $logpath
	      filelist="rc.vnmr"
	      for xfile in $filelist
	      do
	        echo $xfile >> $logpath
	        set -x
                rm -f $objdir/$xfile
	        cp -p $sourcedir/sys$category/$xfile $objdir/$xfile
	        set +x
	      done
	      echo " " >> $logpath
    
	      make_objdir $objdir/bin
              rm -f $objdir/bin/usetacq
	      filelist=" S99pgsql bootr	create_pgsql_user \
		   convertgeom cryoclient dbinstall dbsetup dbupdate decctool \
		   enter  execkillacqproc fixpsg getgroup getuserinfo     \
		   isjpsgup jsetacq killft3d killjpsg killstat loginpassword \
		   loginpasswordcheck loginpasswordVJ makesuacqproc \
		   makeuser managedb  mkvnmrjadmin  vxrTool 	  \
		   psggen 	 readbrutape  tryquitjpsg 	 seqgen  spingen  \
		   setacq 	 setether 	 setnoether		\
		   setuserpsg  sudoins updateuser  vbg	Vn	\
                   status patchinstall  patchremove protopub rvnmrj rvnmrx       \
                   auconvert aureduce auevent auinit aupurge aupw auredt \
		   makeP11checksums chksudocmd calcramp  killau killch vjhelp     \
		   vnmrj vnmr_jadmin vnmr2sc jtestgroup jtestuser jvnmruser \
		   jdeluser	\
		   S99scanlog setupscanlog scanlog arAuditing ckDaemon	\
		   vnmrlp vnmrplot vnmrprint gsetacq vnmr_color vnmr_accounting	\
		   vnmr_cdump vnmr_explib vnmr_setgauss vnmr_showfit    \
		   vnmr_singleline \
		   vnmr_usemark  vnmr_spinner vnmr_temp vnmr vnmrshell wtgen \
		   vnmredit vnmr_textedit vnmr_vi setGgrp managelnxdev \
		   xseqpreen vnmr_ihelp vnmr_uname adddevices getoptions vnmr_gs \
		   setgem setuni solpatchupdate isetacq lnvsetacq lnvsetacq2 \
		   lsetacq restore3x slimSetacq \
		   nvsetacq rmipcs \
		   loadkernel vnmr_jplot dicom_store dicom_ping protune"
              echo $filelist | tee -a $logpath
	      for xfile in $filelist
	      do
	        echo $xfile >> $logpath
	        set -x
                rm -f $objdir/bin/$xfile
	        cp -p $sourcedir/sys$category/$xfile $objdir/bin/$xfile
	        set +x
	      done

	      set -x
	      cp -p $sobjdir/bin/setacq $objdir/bin/usetacq
	      set +x

	      make_objdir $objdir/768AS/bin
	      filelist="config_768AS temp_768AS setup_768AS stat_768AS designer_768AS gilson_768AS robocmd_768AS sensor_768AS toolbar_768AS robotester_768AS vnmr_gilson"
	      echo " " >> $logpath
	      for xfile in $filelist
	      do
	        echo $xfile >> $logpath
	        set -x
                rm -f $objdir/768AS/bin/$xfile
	        cp -p $sourcedir/sys$category/$xfile $objdir/768AS/bin/$xfile
	        set +x
	      done

	      make_objdir $objdir/Gilson/bin
	      filelist="vnmr_gilson combiplate"
	      echo " " >> $logpath
	      for xfile in $filelist
	      do
	        echo $xfile >> $logpath
	        set -x
                rm -f $objdir/Gilson/bin/$xfile
	        cp -p $sourcedir/sys$category/$xfile $objdir/Gilson/bin/$xfile
	        set +x
	      done
	      xfile="plate_glue.tcl"
	      echo $xfile >> $logpath
	      set -x
              rm -f $objdir/Gilson/bin/$xfile
	      cp -p $sourcedir/systcl/$xfile $objdir/Gilson/bin/$xfile
	      set +x

	      make_objdir $objdir/IMAGE/bin
	      filelist="getXrecon setimg filecheck"
	      echo " " >> $logpath
	      for xfile in $filelist
	      do
	        echo $xfile >> $logpath
	        set -x
                rm -f $objdir/IMAGE/bin/$xfile
	        cp -p $sourcedir/sys$category/$xfile $objdir/IMAGE/bin/$xfile
	        set +x
	      done
	       ;;
	  xinova )
		make_objdir $objdir/acq
		filelist="vwScript vwScriptPPC vwAutoScript"
                echo " " >> $logpath
                for xfile in $filelist
                do
                  echo $xfile >> $logpath
		  set -x
                  rm -f $objdir/acq/$xfile
                  cp -p $sourcedir/sys$category/$xfile $objdir/acq/$xfile
		  set +x
                done
	       ;;
	  esac
	  set +x
	;;

       xsimul)

         case x$target in
            xgem | xcommon | xsgi | xibm | xinova)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac


	make_objdir $objdir/acqbin
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
      	echo " "
	echo "Simul no longer put on Vnmr System Tape 7/3/91 GB, DI"
	set -x
	rm -f $objdir/acqbin/simul
#	cp -p $sobjdir/proglib/$category/simul $objdir/acqbin/simul
#	strip $objdir/acqbin/simul
	set +x
	;;

       xvnmr)
         case x$target in
            xgem | xcommon | xinova)
	    echo "Skipping category: $category   target: $target"
	    set +x
	    continue;
	       ;;
	 esac

	make_objdir $objdir/bin
	make_objdir $objdir/binx
	make_objdir $objdir/lib
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set -x
	rm -f $objdir/bin/Vnmr
	rm -f $objdir/binx/Vnmr
	set +x

         case x$target in

 	    xsun4)
		set -x
		cp -p $sobjdir/proglib/$category/Vnmr $objdir/bin/Vnmr
		cp -p $sobjdir/proglib/$category/Vnmr_ow $objdir/binx/Vnmr
		set +x
	        strip_obj "$objdir/bin/Vnmr $objdir/binx/Vnmr"
		tapedir="sun"
		;;

 	    xibm | xsgi )
		set -x
		cp -p $sobjdir/proglib/$category/Vnmr $objdir/bin/Vnmr
		set +x
		echo "Vnmr " >> $logpath
	        strip_obj $objdir/bin/Vnmr
		tapedir=$target
		;;

 	    xsol )
		set -x
		rm -f $objdir/lib/libacqcomm.so
		cp -p $sobjdir/proglib/$category/Vnmr $objdir/bin/Vnmr
		cp -p $sobjdir/proglib/$category/libacqcomm.a \
		      $objdir/lib/libacqcomm.a
		cp -p $sobjdir/proglib/$category/libacqcomm.so.$LIB_ACQCOM_SO\
		      $objdir/lib/libacqcomm.so.$LIB_ACQCOM_SO
		(cd $objdir/lib; 	\
		 ln -s libacqcomm.so.$LIB_ACQCOM_SO libacqcomm.so)
		set +x
		echo "Vnmr " >> $logpath
	        strip_obj $objdir/bin/Vnmr
		tapedir=$target
		;;

	 esac
	if [ $tapedir ]
	then
	    get_xresource_file $category tape_$tapedir app-defaults Vnmr
	fi
	set +x
	;;

#       xkbin)
#	if (test x$target = "xsol")
#	then
#	   make_objdir	$commondir/kPbox/bin
#	   filelist="Pbox Pxfid Pxsim Pxspy"
#	   for xfile in $filelist
#	   do
#	     echo $xfile >> $logpath
#	       set -x
#	       rm -f $commondir/kPbox/bin/$xfile
#	       cp -p $sobjdir/proglib/$category/$xfile $commondir/kPbox/bin
#	       set +x
#	       strip_obj $commondir/kPbox/bin/$xfile
#	   done
#        fi
#	;;

       xbin)
	if (test x$target = "xcommon")
	then
	  echo "Skipping category: $category   target: $target"
	    set +x
	  continue;
	fi

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	echo "banner vconfig" >> $logpath

	make_objdir $objdir/bin

        filelist=""
        filelist2=""
        filelist3=""
	liblist=""
        case x$target in

           xsun4 )

		make_objdir $objdir/binx
#  		special program banner can not be recompiled, just copied now.
	 	set -x
	 	cp -p $commondir/banners/banner_$target $objdir/bin/banner
	 	set +x

	        filelist="fitspec decomp eatchar expfit gin_setup makeprintcap \
		  spins tape tek_setup unix_vxr vn vxrTool vxr_unix \
		  editdevices xdcvt convertbru expandphase portrait \
		  dps_ps_gen diffshims cpos_cvt psfilter readsctables \
		  imcalc imfit log_mag plane_decode tabc cptoconpar \
		  vnmr_confirmer convert		\
		  eccsend weight.h"
		liblist="libMagick"
		tapedir="sun"
	   ;;

	   xsgi )

# sgi not have: banner , eatchar, vxrTool, eccsend, vconfig,
#			vconfig_ow, pulsetool, pulsetool_ow,
#			pulsechild, pulsechild_ow, eccTool, eccTool_ow
#			beccphase, eccdiff, eccdisp, eccphase, feccphase

	        filelist="fitspec decomp expfit gin_setup \
		  spins send2Vnmr tape tek_setup unix_vxr vn vxr_unix \
		  portrait makeprintcap editdevices xdcvt convertbru \
		  dps_ps_gen expandphase diffparams diffshims cpos_cvt psfilter \
        	  vconfig pulsetool pulsechild readsctables \
		  imcalc imfit log_mag plane_decode tabc \
		  rmsAddData vnmr_confirmer Pbox PboxAdapter Pxfid Pxsim Pxspy	\
		  fontselect convertcmx \
		  weight.h"
		tapedir=$target
	   ;;

	   xibm )

# ibm not have: banner , eatchar, makeprintcap, vxrTool, eccsend, vconfig,
#			vconfig_ow, pulsetool, pulsetool_ow,
#			pulsechild, pulsechild_ow, eccTool, eccTool_ow
#			beccphase, eccdiff, eccdisp, eccphase, feccphase

	        filelist="fitspec decomp expfit gin_setup \
		  spins send2Vnmr tape tek_setup unix_vxr vn vxr_unix \
		  portrait editdevices xdcvt expandphase convertbru \
		  dps_ps_gen diffshims cpos_cvt psfilter readsctables \
        	  vconfig pulsetool pulsechild \
		  imcalc imfit log_mag plane_decode tabc \
		  vnmr_confirmer Pbox PboxAdapter Pxfid Pxsim Pxspy fontselect convertcmx \
		  weight.h"
		tapedir=$target
	   ;;

	   xsol )
		make_objdir $objdir/binx

	        filelist="convertbru cpos_cvt cptoconpar     \
			send2Vnmr decomp diffparams diffshims dps_ps_gen \
			eatchar eccsend eccTool editdevices  \
			ejectthecdrom expandphase expect expfit fitspec \
			fm_calshim fm_shuffle gin_setup \
		        imcalc imfit log_mag loginvjpassword plane_decode readsctables \
			Probe_edit portrait psfilter pulsechild         \
			pulsetool spins tabc tape     \
			Pbox PboxAdapter Pxfid Pxsim Pxspy \
			rmsAddData tek_setup unix_vxr vconfig vn        \
			setGifAspect vnmr_confirmer convert showconsole   \
			beccphase eccdiff eccdisp eccphase feccphase gs \
			vxr_unix weight.h xdcvt ihwinfo fontselect \
			convertcmx fileowner findLinks nvlocki	\
			gsregrid    gsbin      gsphtofield      gsvtobin  \
			gsdiff     gsfield          gsft        gshimcalc  \
			gsadd   gsbinmulti gsmean gsphcheck gscale gsign   \
			gsphdiff gsft2d gsmapmask gsreformat gsremap"
		liblist="libMagick"
		tapedir=$target
		filelist2="read_raw_data"
		filelist3="killroboproc"
	   ;;

           xgem )
	        filelist="gconfig kconfig catcheaddr findedevices"
	   ;;

        esac

	echo " " >> $logpath

	for xfile in $filelist
	do
	  echo $xfile >> $logpath
	    set -x
            rm -f $objdir/bin/$xfile
	    cp -p $sobjdir/proglib/$category/$xfile $objdir/bin/$xfile
	    set +x
	    strip_obj $objdir/bin/$xfile
	done
        for xfile in $filelist2
        do
          echo $xfile >> $logpath
          set -x
          rm -f $commondir/IMAGE/bin/$xfile
          cp -p $sobjdir/proglib/$category/$xfile $commondir/IMAGE/bin/$xfile
          set +x
          strip_obj $commondir/IMAGE/bin/$xfile
        done
        filelist2=""
        for xfile in $filelist3
        do
          echo $xfile >> $logpath
          set -x
          rm -f $commondir/768AS/bin/$xfile
          cp -p $sobjdir/proglib/$category/$xfile $commondir/768AS/bin/$xfile
          set +x
          strip_obj $commondir/768AS/bin/$xfile
        done
        filelist3=""
	for xfile in $liblist
	do
	  echo $xfile >> $logpath
	    set -x
            rm -f $objdir/lib/$xfile.*
	    #cp -p $sobjdir/proglib/$category/$xfile.a $objdir/lib
	    # Look inside the .so file to get the full name with version info
	    fileVer=`dump -Lv $sobjdir/proglib/$category/$xfile.so | grep SONAME | sed 's/^.*[ \t]//'`
	    make_objdir $objdir/lib
	    cp -p $sobjdir/proglib/$category/$xfile.so $objdir/lib/$fileVer
	    ln -s $fileVer $objdir/lib/$xfile.so
	    set +x
	done
	set -x
        rm -f $objdir/bin/usrwt.o 
	cp -p $sobjdir/proglib/$category/usrwt.o $objdir/bin/usrwt.o
	set +x
	echo "usrwt.o " >> $logpath
	echo " " >> $logpath

# ---- do the following only for sun3 sun4 --------
       case x$target in

	xsun4 | xsun3 )
#
# windowing programs sv vs ow 
#	Robert uses a different naming scheme , so just make some aliases 
set -x
	( cd $sobjdir/proglib/$category; rm -f vconfig; ln -s vconfig_$target vconfig; rm -f vconfig_ow; ln -s vconfig_ow_$target vconfig_ow )
set +x
#	Phil uses a different naming scheme , so just make some aliases 
set -x
	( cd $sobjdir/proglib/$category; rm -f eccTool_ow; ln -s XeccTool eccTool_ow )
set +x
        filelist="vconfig pulsetool pulsechild eccTool"
        for xfile in $filelist
        do
	echo $xfile >> $logpath
	    set -x
	    rm -f $objdir/bin/$xfile
	    cp -p $sobjdir/proglib/$category/$xfile $objdir/bin/$xfile
	    rm -f $objdir/binx/$xfile
	    cp -p $sobjdir/proglib/$category/${xfile}_ow $objdir/binx/$xfile
	    set +x
	    strip_obj "$objdir/bin/$xfile $objdir/binx/$xfile"
        done
        ;;

#  For the moment we keep both /vnmr/bin and /vnmr/binx on Solaris.

#	xsol )
#        filelist="vconfig pulsetool pulsechild eccTool"
#        for xfile in $filelist
#        do
#	    echo $xfile >> $logpath
#	    cp -p $objdir/proglib/$category/$xfile $objdir/binx/$xfile
#        done
#	;;
	esac

	if [ $tapedir ]
	then
	    make_objdir $commondir/tape_$tapedir/app-defaults
	    appfiles="Config EccTool Enter PulseTool Status"
	    for file in $appfiles
	    do
	      get_xresource_file $category tape_$tapedir app-defaults $file
	    done
	    get_xresource_file tcl tape_$tapedir app-defaults Dg
	fi
	;;

       xlimnet)

         case x$target in
            xgem | xsgi | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

	make_objdir $objdir/limnet
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath

	if (test x$target != "xcommon")		# scripts are common to both
	then
	  filelist="dnode eread ewrite makelimnet1"
	  for xfile in $filelist
	  do
	    echo $xfile >> $logpath
	    set -x
            rm -f $objdir/limnet/$xfile
	    cp -p $sobjdir/proglib/$category/$xfile $objdir/limnet/$xfile
	    set +x
	  done
	  echo " " >> $logpath
	  filelist="eaddr elist in.limnet limnetd limnets1"
	  for xfile in $filelist
	  do
	    echo $xfile >> $logpath
            set -x
	    rm -f $objdir/limnet/$xfile
	    cp -p $sobjdir/proglib/$category/$xfile $objdir/limnet/$xfile
	    set +x
	    strip_obj $objdir/limnet/$xfile 
	  done
	  set +x
	fi
	;;

       xkernel3)
	echo "Skipping category: $category"
	;;

       xkernel4)

         case x$target in
            xgem | xcommon | xsgi | xibm | xsol | xinova)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

	echo " "
        echo category: $category
	sourcefiles="CUSTOM README conf.c files sc_conf.c shreg.h"
	binaryfiles="clock.o sh.o"
	kernelmaker="revenge"
	set -x
	cwd=`pwd`
	cd $sun4objdir/kernel
	for xfile in $sourcefiles
	do
	  rm -f $xfile
	  if (test $xfile = "shreg.h")
	  then
	    sccs -d$sccsdir/kernel3 get $xfile
	  else
	    sccs -d$sccsdir/kernel4 get $xfile
	  fi
	done

# assume the binary files are on kernelmaker in /usr/sys/sun4/OBJ

	for xfile in $binaryfiles
	do
	  rm -f $xfile
	  rcp $kernelmaker:/usr/sys/sun4/OBJ/$xfile $xfile
	done

	rm -f vmunix
	rcp $kernelmaker:/usr/sys/sun4/VNMR_DNA/vmunix vmunix
	set +x
	;;

       xsas)
	echo "Use the update_tape script in the SCCS category SAS"
	;;

       xshuffler)

         case x$target in
            xgem | xsun4 | xsgi | xibm | xsol | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	set -x

        make_objdir  $sourcedir/sys$category

        ( cd $sourcedir/sys$category; rm -rf motif ow sv )
        ( cd $sourcedir/sys$category; sccs -d$sccsjdir/$category get make${category};

	   targetdir=$objdir/shuffler
	   if [ ! -d $targetdir ]
	   then
		mkdir -p $targetdir
	   fi;
           make -f make${category} LIQUIDS TARGET_DIR=$targetdir

	   targetdir=$objdir/IMAGE/imaging/shuffler
	   if [ ! -d $targetdir ]
	   then
		mkdir -p $targetdir
	   fi;
           make -f make${category} IMAGE   TARGET_DIR=$targetdir

	   targetdir=$objdir/WALKUP/walkup/shuffler
	   if [ ! -d $targetdir ]
	   then
		mkdir -p $targetdir
	   fi;
           make -f make${category} WALKUP  TARGET_DIR=$targetdir

	   targetdir=$objdir/PART11/shuffler
	   if [ ! -d $targetdir ]
	   then
		mkdir -p $targetdir
	   fi;
           make -f make${category} PART11  TARGET_DIR=$targetdir
        )


        ( cd $objdir/WALKUP/walkup/shuffler
	  pwd
          rm -f *.xml
          filelist=`ls *.xml.walkup`
	  for file in $filelist
	  do
	      tofile=`basename $file .walkup`
	      mv $file $tofile
	  done
        )
	( cd $objdir/IMAGE/imaging/shuffler
          rm -f *.xml
          filelist=`ls *.img`
          for file in $filelist 
          do
              tofile=`basename $file .img`
              mv $file $tofile
          done
	)
	( cd $objdir/PART11/shuffler
          rm -f *.xml
          filelist=`ls *.xml.p11`
          for file in $filelist 
          do
              tofile=`basename $file .p11`
              mv $file $tofile
          done
        )
	set +x
	;;

       xp11)

         case x$target in
            xgem | xsun4 | xsgi | xibm | xsol | xinova )
               echo "Skipping category: $category   target: $target"
            set +x
               continue;
               ;;
         esac

        echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
        set -x
        ( cd /vcommon/p11;
          sccs -d$sccsjdir/p11 get makep11
          make -ef makep11  P11
        )
	;;

       xxml)

         case x$target in
            xgem | xsun4 | xsgi | xibm | xsol | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	set -x
	( cd $objdir/xml;
	  sccs -d$sccsjdir/xml get makexmlfiles
	  make -ef makexmlfiles  Properties
	  sccs -d$sccsjdir/xml get makexmlfiles
	  make -ef makexmlfiles  P11
	  sccs -d$sccsjdir/xml get makexmlfiles
	  make -ef makexmlfiles  Admin
	)

	set -x
	( cd $objdir/xml;
	  sccs -d$sccsjdir/xml get makexmlfiles
	  make -ef makexmlfiles TARGET_DIR=$objdir/WALKUP/walkup/templates/vnmrj/interface Walkup_Interface
	  cd $objdir/WALKUP/walkup/templates/vnmrj/interface
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.walkup//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/WALKUP/walkup/templates/vnmrj/properties Walkup_Properties
	  cd $objdir/WALKUP/walkup/templates/vnmrj/properties
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.walkup//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/WALKUP/walkup/templates/layout/default Walkup_Defaultdir
	  cd $objdir/WALKUP/walkup/templates/layout/default
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.walkup//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/Protune/templates/vnmrj/interface Protune_Interface
	  rm -f $objdir/xml/makexmlfiles
	)
	set +x

	( cd $objdir/xml
	  sccs -d$sccsjdir/xml get makexmlfiles
	  make -ef makexmlfiles TARGET_DIR=$objdir/Solids/templates/vnmrj/interface Solids_Interface
	  cd $objdir/Solids/templates/vnmrj/interface
	  dfiles=`ls *`
	  for file in $dfiles
	  do
	      new=`echo $file | sed 's/.solids//g' `
	      if [ x$file != x$new ]
	      then
	          mv -f $file $new
	      fi
	  done
	  rm -f $objdir/xml/makexmlfiles
	)

	set -x
	( cd $objdir/xml;
	  sccs -d$sccsjdir/xml get makexmlfiles

	  ifacedir=$objdir/LCNMR/lc/templates/vnmrj/interface
	  mkdir -p $ifacedir
	  make -ef makexmlfiles TARGET_DIR=$ifacedir Lc_Interface

	  shuffdir=$objdir/LCNMR/lc/shuffler
	  mkdir -p $shuffdir
	  make -ef makexmlfiles TARGET_DIR=$shuffdir Lc_Shuffler

	  cd $ifacedir
	  dfiles=`ls *.lc`
	  for file in $dfiles
	  do
	    new=`basename $file .lc`
	    mv -f $file $new
	  done

	  cd $shuffdir
	  dfiles=`ls *.lc`
	  for file in $dfiles
	  do
	    new=`basename $file .lc`
	    mv -f $file $new
	  done
	)
	set +x

	( cd $objdir/xml;
	  sccs -d$sccsjdir/xml get makexmlfiles
	  make -ef makexmlfiles TARGET_DIR=$objdir/templates/vnmrj/interface Interface
	  make -ef makexmlfiles TARGET_DIR=$objdir/templates/vnmrj/panelitems Panelitems
	  make -ef makexmlfiles TARGET_DIR=$objdir/templates/layout/default Defaultdir
	  make -ef makexmlfiles TARGET_DIR=$objdir/Gilson/templates/layout/toolPanels Vast_ToolPanels
	  make -ef makexmlfiles TARGET_DIR=$objdir/templates/layout/toolPanels Exp_ToolPanels
	  make -ef makexmlfiles TARGET_DIR=$objdir/templates_inova/vnmrj/protocols Inova_Protocols
	  make -ef makexmlfiles TARGET_DIR=$objdir/templates_vnmrs/vnmrj/protocols Vnmrs_Protocols
	  make -ef makexmlfiles TARGET_DIR=$objdir/templates/vnmrj/protocols Protocols
	  make -ef makexmlfiles TARGET_DIR=$objdir/IMAGE/imaging/templates/vnmrj/interface Img_Interface
	  cd $objdir/IMAGE/imaging/templates/vnmrj/interface
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.img//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/IMAGE/imaging/templates/layout/default Img_Defaultdir
	  cd $objdir/IMAGE/imaging/templates/layout/default
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.img//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/IMAGE/imaging_inova/templates/layout/default Inova_Img_Defaultdir
	  cd $objdir/IMAGE/imaging_inova/templates/layout/default
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.img//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/IMAGE/imaging_vnmrs/templates/layout/default Vnmrs_Img_Defaultdir
	  cd $objdir/IMAGE/imaging_vnmrs/templates/layout/default
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.img//g' | sed 's/vnmrs_//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/IMAGE/imaging/templates/layout/toolPanels Img_ToolPanels
	  cd $objdir/IMAGE/imaging/templates/layout/toolPanels
	    mv acqtoolPanels.xml.img acq.xml
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.img//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/IMAGE/imaging/templates/vnmrj/properties Img_Properties
	  cd $objdir/IMAGE/imaging/templates/vnmrj/properties
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.img//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/IMAGE/imaging_inova/templates/vnmrj/protocols Img_Protocols_Inova
	  cd $objdir/IMAGE/imaging_inova/templates/vnmrj/protocols
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.img//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/IMAGE/imaging_vnmrs/templates/vnmrj/protocols Img_Protocols
	  cd $objdir/IMAGE/imaging_vnmrs/templates/vnmrj/protocols
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.img//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
            vnmrs_list=`ls vnmrs_*`
            for file in $vnmrs_list 
            do
               newfln=`echo $file | cut -c7-`
               rm -f $newfln
               mv $file $newfln
            done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/IMAGE/imaging_vnmrs/ATP/templates/vnmrj/protocols Img_ATP_Protocols
	  cd $objdir/IMAGE/imaging_vnmrs/ATP/templates/vnmrj/protocols
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.img//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
            vnmrs_list=`ls vnmrs_*`
            for file in $vnmrs_list 
            do
               newfln=`echo $file | cut -c7-`
               rm -f $newfln
               mv $file $newfln
            done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/CSI/imaging/templates/vnmrj/protocols ImageCSI
	  cd $objdir/CSI/imaging/templates/vnmrj/protocols
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.img//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/IMAGE_patent/imaging/templates/vnmrj/protocols ImagePatent
	  cd $objdir/IMAGE_patent/imaging/templates/vnmrj/protocols
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.img//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
	  cd $objdir/xml;
	  make -ef makexmlfiles TARGET_DIR=$objdir/IMAGE_SENSE/imaging/templates/layout/default SENSE_Interface
	  cd $objdir/IMAGE_SENSE/imaging/templates/layout/default
	    dfiles=`ls *`
	    for file in $dfiles
	    do
	      new=`echo $file | sed 's/.img//g' | sed 's/vnmrs_//g' `
	      if [ x$file != x$new ]
	      then
	        mv -f $file $new
	      fi
	    done
	  cd $objdir/xml;
	  rm -f $objdir/xml/makexmlfiles
	)
        set -x
        ( cd $objdir/DOSY/templates;
	  sccs -d$sccsjdir/xml get makexmlfiles
	  make -ef makexmlfiles TARGET_DIR=$objdir/DOSY/templates/vnmrj/protocols Dosy_Protocols
	  make -ef makexmlfiles TARGET_DIR=$objdir/DOSY/templates/vnmrj/interface Dosy_Interface
          rm -f $objdir/DOSY/templates/makexmlfiles
        )
        ( cd $objdir/STARS/templates;
	  sccs -d$sccsjdir/xml get makexmlfiles
	  make -ef makexmlfiles TARGET_DIR=$objdir/STARS/templates/vnmrj/interface Stars_Interface
          rm -f $objdir/STARS/templates/makexmlfiles
        )
	set +x
	;;

       xmenulib)

         case x$target in
            xgem | xsun4 | xsgi | xibm | xsol | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	set -x
	( cd $objdir/menulib;
	  sccs -d$sccsdir/menulib get makemenulib
	  make -ef makemenulib TARGET_DIR=$objdir/menulib
	  rm -f $objdir/menulib/makemenulib
	)
	( cd $objdir/menulib;
	  sccs -d$sccsdir/menulib get makemenulib
	  make -ef makemenulib TARGET_DIR=$objdir/menulib PBOX
	  rm -f $objdir/menulib/makemenulib
	)
 	( cd $objdir/IMAGE/menulib/menulib.imaging;
 	  sccs -d$sccsdir/menulib get makemenulib
	  make -ef makemenulib TARGET_DIR=$objdir/IMAGE/menulib/menulib.imaging sis
	  rm -f $objdir/IMAGE/menulib/menulib.imaging/makemenulib
 	)
	( cd $objdir/Gmap/menulib;
	  sccs -d$sccsdir/menulib get makemenulib
	  make -ef makemenulib TARGET_DIR=$objdir/Gmap/menulib Gmap
	  rm -f $sourcedir/menulib/makemenulib
	)
	( cd $objdir/LCNMR/menulib;
	  sccs -d$sccsdir/menulib get makemenulib
	  make -ef makemenulib TARGET_DIR=$objdir/LCNMR/menulib LCNMR
	  rm -f $sourcedir/menulib/makemenulib
	)
	( cd $objdir/STARS/menulib;
	  sccs -d$sccsdir/menulib get makemenulib
	  make -ef makemenulib TARGET_DIR=$objdir/STARS/menulib STARS
	  rm -f $sourcedir/menulib/makemenulib
	)
	set +x
	;;

       xmaclib)

         case x$target in
            xgem | xsun4 | xsgi | xibm | xsol | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac


      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set -x
	( cd $objdir/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/maclib
	  rm -f $sourcedir/maclib/makemaclib
	)
	( cd $objdir/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/maclib PBOX
	  rm -f $sourcedir/maclib/makemaclib
	)
	( cd $objdir/gPFG/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/gPFG/maclib gpfg
	  rm -f $sourcedir/maclib/makemaclib
	)
	( cd $objdir/PFG/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/PFG/maclib pfg
	  rm -f $sourcedir/maclib/makemaclib
	)
	( cd $objdir/Image/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/Image/maclib Image
	  rm -f $sourcedir/maclib/makemaclib
	)
 	( cd $objdir/Autotest/maclib/maclib.autotest
 	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/Autotest/maclib/maclib.autotest Autotest
	  rm -f $objdir/Autotest/maclib/maclib.autotest/makemaclib
 	)
	( cd $objdir/vnmrj/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/vnmrj/maclib vnmrj
	  rm -f $sourcedir/maclib/makemaclib
	)
 	( cd $objdir/IMAGE/maclib/maclib.imaging;
 	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/IMAGE/maclib/maclib.imaging sis
	  rm -f $objdir/IMAGE/maclib/maclib.imaging/makemaclib
 	)
 	( cd $objdir/IMAGE_patent/maclib/maclib.imaging;
 	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/IMAGE_patent/maclib/maclib.imaging ImagePatent
	  rm -f $objdir/IMAGE_patent/maclib/maclib.imaging/makemaclib
 	)
 	( cd $objdir/IMAGE_SENSE/imaging/maclib/;
 	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/IMAGE_SENSE/imaging/maclib sense
	  rm -f $objdir/IMAGE_patent/maclib/maclib.imaging/makemaclib
 	)
	( cd $objdir/Gmap/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/Gmap/maclib Gmap
	  rm -f $sourcedir/maclib/makemaclib
	)
	( cd $objdir/Gxyz/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/Gxyz/maclib Gxyz
	  rm -f $sourcedir/maclib/makemaclib
	)
	( cd $objdir/LCNMR/maclib/maclib.lc;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/LCNMR/maclib/maclib.lc LCNMR
	  rm -f $sourcedir/maclib/maclib.lc/makemaclib
	)
	( cd $objdir/Diffusion/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/Diffusion/maclib Diffusion
	  rm -f $sourcedir/maclib/makemaclib
	)
	( cd $objdir/DOSY/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/DOSY/maclib DOSY
	  rm -f $sourcedir/maclib/makemaclib
	)
	( make_objdir $objdir/768AS/maclib;
	  cd $objdir/768AS/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/768AS/maclib 768AS
	  rm -f $sourcedir/maclib/makemaclib
	)
	( cd $objdir/Gilson/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/Gilson/maclib Gilson
	  rm -f $sourcedir/maclib/makemaclib
	)
	( cd $objdir/Protune/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/Protune/maclib Protune
	  rm -f $sourcedir/maclib/makemaclib
	  cd $objdir/Protune/maclib
          make_ln protune protunegui
	)
	( cd $objdir/STARS/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/STARS/maclib STARS
	  rm -f $sourcedir/maclib/makemaclib
	)
	( cd $objdir/Solids/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/Solids/maclib Solids
	  rm -f $sourcedir/maclib/makemaclib
	)
	( cd $objdir/MR400FH/maclib;
	  sccs -d$sccsdir/maclib get makemaclib
	  make -ef makemaclib TARGET_DIR=$objdir/MR400FH/maclib MR400FH
	  rm -f $sourcedir/maclib/makemaclib
	)
	set +x
	echo "Standard, PFG, gPFG, Imaging " >> $logpath
	;;

       xmanual)

         case x$target in
            xgem | xsun4 | xsgi | xibm | xsol | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set -x
	( cd $objdir/manual;
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/manual
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/manual PBOX
	  rm -f $objdir/manual/makemanual
	)
	( cd $objdir/gPFG/manual;
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/gPFG/manual gpfg
	  rm -f $objdir/manual/makemanual
	)
	( cd $objdir/PFG/manual;
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/PFG/manual pfg
	  rm -f $objdir/manual/makemanual
	)
	( cd $objdir/Image/manual;
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/Image/manual Image
	  rm -f $sourcedir/manual/makemanual
	)
	( cd $objdir/Gmap/manual;
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/Gmap/manual Gmap
	  rm -f $sourcedir/manual/makemanual
	)
	( cd $objdir/LCNMR/manual;
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/LCNMR/manual LCNMR
	  rm -f $sourcedir/manual/makemanual
	)
	( cd $objdir/Diffusion/manual;
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/Diffusion/manual Diffusion
	  rm -f $sourcedir/manual/makemanual
	)
	( cd $objdir/FDM/manual;
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/FDM/manual FDM
	  rm -f $sourcedir/manual/makemanual
	)
	( cd $objdir/Gilson/manual;
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/Gilson/manual Gilson
	  rm -f $sourcedir/manual/makemanual
	)
	( cd $objdir/Protune/manual;
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/Protune/manual Protune
	  rm -f $sourcedir/manual/makemanual
	)
	( cd $objdir/DOSY/manual;
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/DOSY/manual DOSY
	  rm -f $sourcedir/manual/makemanual
	)
	( cd $objdir/Solids/manual;
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/Solids/manual Solids
	  rm -f $sourcedir/manual/makemanual
	)
	( cd $objdir/MR400FH/manual;
	  sccs -d$sccsdir/manual get makemanual
	  make -ef makemanual TARGET_DIR=$objdir/MR400FH/manual MR400FH
	  rm -f $sourcedir/manual/makemanual
	)
	set +x
	echo "Standard, PFG, gPFG, Imaging " >> $logpath
	;;

       xhelp)

         case x$target in
            xgem | xsun4 | xsgi | xibm | xsol | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set -x
	( cd $objdir/help;
	  sccs -d$sccsdir/help get makehelp
	  make -ef makehelp TARGET_DIR=$objdir/help
	  rm -f $objdir/help/makehelp
	)
	( cd $objdir/help;
	  make_objdir $objdir/Pbox/help
	  sccs -d$sccsdir/help get makehelp
	  make -ef makehelp TARGET_DIR=$objdir/Pbox/help PBOX
	  rm -f $objdir/help/makehelp
        )
	( cd $objdir/help;
	  make_objdir $objdir/kPbox/help
	  sccs -d$sccsdir/help get makehelp
	  make -ef makehelp TARGET_DIR=$objdir/kPbox/help KPBOX
	  mv $objdir/kPbox/help/kPbox $objdir/kPbox/help/Pbox
	  chmod +w $objdir/kPbox/help/Pbox
	  mv $objdir/kPbox/help/kPbox180 $objdir/kPbox/help/Pbox180
	  chmod +w $objdir/kPbox/help/Pbox180
	  rm -f $objdir/help/makehelp
	)
 	( cd $objdir/IMAGE/help/help.imaging;
 	  sccs -d$sccsdir/help get makehelp
	  make -ef makehelp TARGET_DIR=$objdir/IMAGE/help/help.imaging sis
	  rm -f $objdir/IMAGE/help/help.imaging/makehelp
 	)
 	( cd $objdir/Gmap/help;
 	  sccs -d$sccsdir/help get makehelp
	  make -ef makehelp TARGET_DIR=$objdir/Gmap/help Gmap
	  rm -f $objdir/Gmap/help/makehelp
 	)
	set +x
	echo "Standard" >> $logpath
	;;

       xshapelib)

         case x$target in
            xgem | xsun4 | xsgi | xibm | xsol | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set -x
	( cd $objdir/shapelib;
	  sccs -d$sccsdir/shapelib get makeshapelib
	  make -ef makeshapelib TARGET_DIR=$objdir/shapelib
	  rm -f $objdir/shapelib/makeshapelib
	)
	( cd $objdir/LCNMR/shapelib;
	  sccs -d$sccsdir/shapelib get makeshapelib
	  make -ef makeshapelib TARGET_DIR=$objdir/LCNMR/shapelib lcnmr
	  rm -f $objdir/LCNMR/shapelib/makeshapelib
	)
	( make_objdir $objdir/kPbox/shapelib
	  cd $objdir/kPbox/shapelib;
	  sccs -d$sccsdir/shapelib get makeshapelib
	  make -ef makeshapelib TARGET_DIR=$objdir/kPbox/shapelib kshape
	  rm -f $objdir/LCNMR/shapelib/makeshapelib
	)
	set +x
	echo "Standard" >> $logpath
	;;

       x3D)

         case x$target in
            xcommon | xgem | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

	make_objdir $objdir/bin
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath

	filelist="ft3d getplane compressfid"
	for xfile in $filelist
	do
	  echo $xfile >> $logpath
	    set -x
	    rm -f $objdir/bin/$xfile
	    cp -p $sobjdir/proglib/$category/$xfile $objdir/bin/$xfile
	    set +x
	    strip_obj $objdir/bin/$xfile
        done
	set +x
	;;

       xbackproj)

         case x$target in
            xsgi | xibm | xgem )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	   xcommon)
	      echo " " | tee -a $logpath
	      echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	      echo " " >> $logpath
	      set -x
	      ( cd $objdir/Backproj/maclib;
	  	sccs -d$sccsdir/$category get make$category
	  	make -ef make$category macros
	  	rm -f make$category
	      )
	      set +x
	      continue;
	  ;;
	 esac

	make_objdir $objdir/bin
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath

	filelist="bp_2d bp_3d bp_ball bp_mc bp_sort"
	for xfile in $filelist
	do
	  echo $xfile >> $logpath
	    set -x
	    rm -f $objdir/bin/$xfile
	    cp -p $sobjdir/proglib/$category/$xfile $objdir/bin/$xfile
	    set +x
	    strip_obj $objdir/bin/$xfile
        done
	set +x
	;;

       xglide)

         case x$target in
            xcommon | xsgi | xibm | xgem | xinova)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

	make_objdir $objdir/bin
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	(
	    echo "glide gadm " >> $logpath
	    set -x
	    cp -p $sobjdir/proglib/$category/glide $objdir/bin/glide
	    cp -p $sobjdir/proglib/$category/gadm $objdir/bin/gadm
	    set +x
	    strip_obj $objdir/bin/glide
	    strip_obj $objdir/bin/gadm
	)
	set +x
	;;

       xgacqi)

         case x$target in
            xcommon | xsun4 | xsgi | xibm | xsol | xinova)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

	make_objdir $objdir/bin
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	(
	    echo "iadisplay " >> $logpath
	    set -x
	    cp -p $sobjdir/proglib/acqi/giadisplay $objdir/bin/giadisplay
	    set +x
	    strip_obj $objdir/bin/giadisplay
	)
	set +x
	;;

       xgacqproc)

         case x$target in
            xcommon | xsun4 | xsgi | xibm | xsol | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

      	echo " "
	echo " " >> $logpath
	make_objdir $objdir/acqbin
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	filelist="gAcqproc"
	echo "acqproc file list: $filelist"
	for xfile in $filelist
	do
	  echo $xfile >> $logpath
	  set -x
          rm -f $objdir/acqbin/$xfile
	  cp -p $sobjdir/proglib/$category/$xfile $objdir/acqbin/$xfile
	  set +x
	  strip_obj $objdir/acqbin/$xfile
	done
	set +x
	;;

       xkapmon)

         case x$target in
            xcommon | xsun4 | xsgI | xibm | xsol | xinova )
	       echo "Skipping category: $category   target: $target"
	      set +x
	       continue;
	       ;;
	 esac


	make_objdir $commondir/acq
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set -x
	rm -f $commondir/acq/kapmon
	cp -p $sourcedir/sys$category/apmon $commondir/acq/kapmon
	set +x
        echo "kapmon" >> $logpath
	;;

       xgapmon)

         case x$target in
            xcommon | xsun4 | xsgI | xibm | xsol | xinova )
	       echo "Skipping category: $category   target: $target"
	      set +x
	       continue;
	       ;;
	 esac


	make_objdir $commondir/acq
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set -x
	rm -f $commondir/acq/apmon
	cp -p $sourcedir/sys$category/apmon $commondir/acq/apmon
	set +x
        echo "apmon" >> $logpath
	;;

       xglnc)

         case x$target in
            xcommon | xsun4 | xsgi | xibm | xsol | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac


	make_objdir $commondir/acq
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set -x
	rm -f $commondir/acq/lnc
	cp -p $sourcedir/sys$category/lnc $commondir/acq/lnc
	set +x
        echo "apmon" >> $logpath
	;;

       xkpsg)

        case x$target in
            xcommon | xsun4 | xsgi | xibm | xsol | xinova)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

	make_objdir $objdir/bin
	echo " " | tee -a $logpath
	echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	echo "kseqgen psg/* " >> $logpath
	rm -f $objdir/bin/gseqgen
	make_objdir $commondir/kpsg
	( cd $commondir/kpsg; make -f $sourcedir/syskpsg/makekpsg userp )

	filelist="libpsglib.a libparam.a libpsglib.so.$so_ver \
	  libparam.so.$so_ver x_ps.o"

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath

	echo " " >> $logpath
	make_objdir $objdir/kpsg

	for xfile in $filelist
	do
	  echo $xfile >> $logpath
	  set -x
          rm -f $objdir/kpsg/$xfile
	  cp -p $sobjdir/proglib/$category/$xfile $objdir/kpsg/$xfile
	  set +x
	done
	rm -f libpsglib.so libparam.so

#  Following required for shared libraries to really work on Solaris

          (cd $objdir/kpsg;				\
	   rm -f libparam.so;				\
           rm -f libpsglib.so;				\
           make_ln libparam.so.$so_ver libparam.so;	\
           make_ln libpsglib.so.$so_ver libpsglib.so; )
#           ln -s libparam.so.$so_ver libparam.so;	\
#           ln -s libpsglib.so.$so_ver libpsglib.so; )

	echo seqgenmake >> $logpath
	make_objdir $objdir/acqbin
	set -x
        rm -f $objdir/acqbin/seqgenmake
        cp -p $sourcedir/syskpsg/seqgenmake $objdir/acqbin/seqgenmake
	set +x
 
	;;

       xgpsg)

        case x$target in
            xcommon | xsun4 | xsgi | xibm | xsol | xinova)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

	make_objdir $objdir/bin
	echo " " | tee -a $logpath
	echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	echo "gseqgen psg/* " >> $logpath
	rm -f $objdir/bin/gseqgen
	make_objdir $commondir/gpsg
	( cd $commondir/gpsg; make -f $sourcedir/sysgpsg/makepsg2 userp )

	filelist="libpsglib.a libparam.a libpsglib.so.$so_ver \
	  libparam.so.$so_ver x_ps.o"

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath

	echo " " >> $logpath
	make_objdir $objdir/gpsg

	for xfile in $filelist
	do
	  echo $xfile >> $logpath
	  set -x
          rm -f $objdir/gpsg/$xfile
	  cp -p $sobjdir/proglib/$category/$xfile $objdir/gpsg/$xfile
	  set +x
	done
	rm -f libpsglib.so libparam.so

#  Following required for shared libraries to really work on Solaris

#	set -x
          (cd $objdir/gpsg;				\
	   rm -f libparam.so;				\
           rm -f libpsglib.so;				\
           make_ln libparam.so.$so_ver libparam.so;	\
           make_ln libpsglib.so.$so_ver libpsglib.so; )
#           ln -s libparam.so.$so_ver libparam.so;	\
#           ln -s libpsglib.so.$so_ver libpsglib.so; )
#	set +x

	echo seqgenmake >> $logpath
	make_objdir $objdir/acqbin
	set -x
        rm -f $objdir/acqbin/seqgenmake
        cp -p $sourcedir/sysgpsg/seqgenmake $objdir/acqbin/seqgenmake
	set +x
 
	;;

       xgshim)

         case x$target in
            xcommon | xsun4 | xsgi | xibm | xsol | xinova )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

	make_objdir $commondir/acq
      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath
	set -x
	rm -f $commondir/acq/autshm
	cp -p $sourcedir/sys$category/autshm $commondir/acq/autshm
	set +x
	echo "gshim" >> $logpath
	;;

       xcsi)

         case x$target in
            xsun4 | xsgi | xibm | xgem )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath

         case x$target in

 	    xcommon )
		set -x
	 	( cd $objdir/CSI/tape_sol/user_templates/csi_initdir;
	 	  sccs -d$sccsdir/csi get makecsi_initdir
		  make -ef makecsi_initdir 
		  rm -f makecsi_initdir
	 	)
	      	( cd $objdir/CSI/maclib;
	  	  sccs -d$sccsdir/$category get csi2d
	     	)
		set +x
		echo "csi " >> $logpath
	        continue;
		;;
 	    xsol)
		make_objdir $objdir/bin
		filelist="csi P_csi"
		echo "csi file list: $filelist"
		for xfile in $filelist
		do
		  set -x
       		  rm -f $objdir/bin/$xfile
		  cp -p $sobjdir/proglib/$category/$xfile $objdir/bin/$xfile
		  set +x
	  	  strip_obj $objdir/bin/$xfile
		  echo $xfile >> $logpath
		done
		;;
	 esac
	set +x
	;;

       xib)
         case x$target in
            xgem )
	    echo "Skipping category: $category   target: $target"
	    set +x
	    continue;
	       ;;
	 esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath

         case x$target in

 	    xcommon )
		set -x
		make_objdir $objdir/bin
		rm -f $solobjdir/bin/browser
		cp -p $solobjdir/proglib/$category/browser \
				$solobjdir/bin/browser
	 	( cd $objdir/IMAGE/tape_sol/user_templates/ib_initdir;
	 	  sccs -d$sccsdir/ib get makeib_initdir
		  make -ef makeib_initdir 
		  rm -f makeib_initdir
	 	)
	 	( cd $objdir/IMAGE/tape_sun/user_templates/ib_initdir;
	 	  sccs -d$sccsdir/ib get makeib_initdir
		  make -ef makeib_initdir 
		  rm -f makeib_initdir
	 	)
		set +x
		echo "browser " >> $logpath
	    set +x
	        continue;
		;;

 	    xsun4)
		make_objdir $objdir/bin
		make_objdir $objdir/binx
		filelist="fdfgluer fdfsplit"
		echo "ib file list: $filelist"
		for xfile in $filelist
		do
		  set -x
       		  rm -f $objdir/bin/$xfile
		  cp -p $objdir/proglib/$category/$xfile $objdir/bin/$xfile
		  set +x
	  	  strip_obj $objdir/bin/$xfile
		  echo $xfile >> $logpath
		done
		set +x
		filelist="ib_ui ib_graphics"
		echo " $filelist"
		set -x
		for xfile in $filelist
		do
		  set -x
       		  rm -f $objdir/binx/$xfile
		  cp -p $sobjdir/proglib/$category/$xfile $objdir/binx/$xfile
		  set +x
	  	  strip_obj $objdir/binx/$xfile
		  echo $xfile >> $logpath
		done
		set +x
		;;

 	    xsol)
		make_objdir $objdir/bin
		filelist="fdfgluer fdfsplit ib_ui ib_graphics"
		echo "ib file list: $filelist"
		for xfile in $filelist
		do
		  set -x
       		  rm -f $objdir/bin/$xfile
		  cp -p $sobjdir/proglib/$category/$xfile $objdir/bin/$xfile
		  set +x
	  	  strip_obj $objdir/bin/$xfile
		  echo $xfile >> $logpath
		done
		set -x
	        rm -f $objdir/bin/libddl.a
	        cp -p $sobjdir/proglib/ddl/libddl_sol.a $objdir/bin/libddl.a
		set +x
		echo "libddl_sol.a" >> $logpath
		set +x
		;;

 	    xibm | xsgi )
	    	echo "Skipping category: $category   target: $target"
		;;

	 esac
	set +x
	;;

       x3Dimg)
         case x$target in
            xcommon | xsgi | xibm | xgem | xinova )
	    echo "Skipping category: $category   target: $target"
	    set +x
	    continue;
	       ;;
	 esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath

         case x$target in

 	    xsun4)
		make_objdir $objdir/bin
		make_objdir $objdir/binx
		set +x
		echo " disp3d"
		set -x
       		rm -f $objdir/binx/disp3d
		cp -p $sobjdir/proglib/$category/disp3d $objdir/binx/disp3d
		echo " disp3d" >> $logpath
		set +x
	  	strip_obj $objdir/binx/disp3d
		;;

 	    xsol)
		make_objdir $objdir/bin
		filelist="disp3d"
		echo "3Dimg file list: $filelist"
		for xfile in $filelist
		do
		  set -x
       		  rm -f $objdir/bin/$xfile
		  cp -p $sobjdir/proglib/$category/$xfile $objdir/bin/$xfile
		  set +x
	  	  strip_obj $objdir/bin/$xfile
		  echo $xfile >> $logpath
		done
		;;
	 esac
	set +x
	;;

       xlcpeaks)
         case x$target in
            xcommon | xsgi | xibm | xgem | xinova | xsun4)
	    echo "Skipping category: $category   target: $target"
	    set +x
	    continue;
	       ;;
	 esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath

         case x$target in

 	    xsol)
		make_objdir $objdir/bin
		filelist="vjLCAnalysis"
		echo "$category file list: $filelist"
		for xfile in $filelist
		do
		  set -x
       		  rm -f $objdir/bin/$xfile
		  cp -p $sobjdir/proglib/$category/$xfile $objdir/bin/$xfile
		  set +x
	  	  strip_obj $objdir/bin/$xfile
		  echo $xfile >> $logpath
		done
		;;
	 esac
	set +x
	;;

	xtcl )

	case x$target in
            xsun4 | xgem )
            echo "Skipping category: $category   target: $target"
	    set +x
            continue;
               ;;
        esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath

         case x$target in

            xinova | xsol )
		set -x
		cp -p $commondir/tcl/srcTcl/libtbcload13.so $objdir/lib
		cp -p $commondir/tcl/srcTcl/libtcl*so $objdir/lib
		cp -p $commondir/tcl/srcTk/libtk*so $objdir/lib
                set +x
		;;
		
            xibm )
		set -x
		cp -p $commondir/tcl/srcTcl/libtcl_IBM.a $objdir/lib/libtcl.a
		cp -p $commondir/tcl/srcTk/libtk_IBM.a $objdir/lib/libtk.a
                set +x
		;;
		
            xsgi )
		set -x
		cp -p $commondir/tcl/srcTcl/libtbcload13_SGI.a $objdir/lib/libtbcload13.a
		cp -p $commondir/tcl/srcTcl/libtcl_SGI.a $objdir/lib/libtcl.a
		cp -p $commondir/tcl/srcTk/libtk_SGI.a $objdir/lib/libtk.a
                set +x
		;;
		

 	    xcommon)
	        filelist="accnt_helpTip arrow.bmp arrow2.bmp \
		        deck.tk menu2.tk scroll2.tk collection.tcl \
                        composite.tcl docker.tbc popup.tcl psgcolor.tcl \
                        psghelp.tcl splash.tcl"
		echo "tk vnmr library file list: $filelist"
                rm -rf $objdir/tcl/tklibrary/vnmr
		make_objdir $objdir/tcl/tklibrary/vnmr
		for xfile in $filelist
		do
		   set -x
		   rm -f $objdir/tcl/tklibrary/vnmr/$xfile
                   cp -p $sourcedir/sys$category/vnmr/$xfile $objdir/tcl/tklibrary/vnmr/$xfile
		   set +x
		   echo $xfile >> $logpath
		done

	        filelist="combi.help combi.m.xbm dirview.tk"
		echo "tk vnmr Gilson library file list: $filelist"
                rm -rf $commondir/Gilson/tcl/tklibrary/vnmr
		make_objdir $commondir/Gilson/tcl/tklibrary/vnmr
		for xfile in $filelist
		do
		   set -x
		   rm -f $commondir/Gilson/tcl/tklibrary/vnmr/$xfile
                   cp -p $sourcedir/sys$category/vnmr/$xfile $commondir/Gilson/tcl/tklibrary/vnmr/$xfile
		   set +x
		   echo $xfile >> $logpath
		done

		filelist="add_printer decctool dg dgconf dpsgen enter fileListen \
			spin status temp pl_color nms xcal2"
		echo "tcl file list: $filelist"
		make_objdir $objdir/tcl/bin
		for xfile in $filelist
		do
		  set -x
       		  rm -f $objdir/tcl/bin/$xfile
		  cp -p $sourcedir/sys$category/$xfile.tcl $objdir/tcl/bin/$xfile
		  set +x
		  echo $xfile >> $logpath
		done
		filelist="at atrecord atregbuilt"
		echo "autotest tcl file list: $filelist"
		for xfile in $filelist
		do
		  set -x
       		  rm -f $objdir/tcl/bin/$xfile.tcl $objdir/tcl/bin/$xfile
		  cp -p $sourcedir/sys$category/$xfile.tcl $objdir/tcl/bin/$xfile.tcl
		  cp -p $sourcedir/sysscripts/$xfile $objdir/tcl/bin/$xfile
		  set +x
		  echo $xfile >> $logpath
		done
#		get_xresource_file $category tape_sol app-defaults Dg

		make_objdir $objdir/adm/bin
		set -x
       		rm -f $objdir/adm/bin/acc_vnmr
       		rm -f $objdir/adm/bin/xcal
		cp -p $sourcedir/sysaccounting/acc_vnmr.tcl $objdir/adm/bin/acc_vnmr
		cp -p $commondir/tcl/tclsh $objdir/tcl/bin
		cp -p $sourcedir/sysaccounting/xcal.tcl $objdir/adm/bin/xcal
		set +x

		make_objdir $commondir/768AS/asm
		(cd $commondir/768AS/asm ; rm -rf tcl )
		set +x

		make_objdir $commondir/768AS/tcl
		make_objdir $commondir/768AS/tcl/bin
		echo "768AS tcl file list: gilson"
		set -x
		rm -f $commondir/768AS/tcl/bin/gilson
	        cp -p $sourcedir/sys$category/gilson.tcl $commondir/768AS/tcl/bin/gilson
		set +x
		echo gilson >> $logpath

		filelist="gilson combiplate plate_glue"
		echo "Gilson tcl file list: $filelist"
		for xfile in $filelist
		do
		  set -x
		  rm -f $commondir/Gilson/tcl/bin/$xfile 
	          cp -p $sourcedir/sys$category/$xfile.tcl $commondir/Gilson/tcl/bin/$xfile
		  set +x
		  echo $xfile >> $logpath
		done

		rm -f $commondir/Gilson/asm/racksetup
		(cd $commondir/Gilson/asm; sccs -p$sccsdir/roboproc/SCCS get racksetup)
		rm -f $commondir/768AS/asm/racksetup
		rm -f $commondir/768AS/asm/racksetup_768AS
		(cd $commondir/768AS/asm; sccs -p$sccsdir/roboproc/SCCS get racksetup; sccs -p$sccsdir/roboproc/SCCS get racksetup_768AS)

		make_objdir $commondir/Gilson/asm/tcl 
		filelist="get.tcl put.tcl wash.tcl inject.tcl retrieve.tcl mix.tcl transfer.tcl"
		(cd $commondir/Gilson/asm/tcl; rm -f *; sccs -p$sccsdir/roboproc/SCCS get $filelist )
		set +x

		make_objdir $commondir/Gilson/asm/protocols 
		filelist="inittitrationGet.tcl inittitrationPut.tcl titrationGet.tcl titrationPut.tcl"
		(cd $commondir/Gilson/asm/protocols; rm -f *; sccs -p$sccsdir/roboproc/SCCS get $filelist )
		set +x

		make_objdir $commondir/Gilson/asm/racks 
		make_objdir $commondir/768AS/asm/racks 
		filelist="rackInfo code_200.grk code_201.grk code_201h.grk code_202.grk code_204.grk code_205.grk code_205h.grk code_505.grk code_505h.grk code_afr2.grk code_209.grk code_30rp.grk code_31rp.grk code_211.grk code_854.grk code_3mm.grk code_5mm.grk m215_inj.grk m215sw_inj.grk"
		(cd $commondir/Gilson/asm/racks; rm -f *; sccs -p$sccsdir/roboproc/SCCS get $filelist )
		(cd $commondir/768AS/asm/racks; rm -f *; sccs -p$sccsdir/roboproc/SCCS get $filelist )

		make_objdir $commondir/Gilson/asm/info 
		make_objdir $commondir/768AS/asm/info 
		filelist="default samp0 samp1 samp2 samp3 samp4 samp5 samp6 samp7 samp8 samp9 samps"
		(cd $commondir/Gilson/asm/info; rm -rf *; sccs -p$sccsdir/roboproc/SCCS get $filelist )
		(cd $commondir/768AS/asm/info; rm -rf *; sccs -p$sccsdir/roboproc/SCCS get $filelist )
		set +x

		make_objdir $commondir/768AS/asm/info/768AS
		filelist="default"
		(cd $commondir/768AS/asm/info/768AS; rm -f *; sccs -p$sccsdir/roboproc/SCCS get $filelist )
		set +x
		;;

	 esac
	set +x
        ;;


       xdicom)

         case x$target in
            xcommon | xgem | xsgi | xibm | xinova)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath

        if (test x$target = "xsol")
        then
	   make_objdir $solobjdir/bin
#           ( set -x;  cd $sobjdir/proglib/$category; \
#		sccs -d/vsccs/sccs/$category get dicom.dic; ) 

	   filelist="createdicom createdcm dicomlpr"
	   for xfile in $filelist
	   do
	       echo $xfile >> $logpath
	       set -x
               rm -f $solobjdir/bin/$xfile
	       cp -p $solobjdir/proglib/$category/$xfile $solobjdir/bin/$xfile
	       set +x
	       strip_obj $objdir/bin/$xfile
	   done

           set +x
         fi
         ;;
         

       xdicom_store)

         case x$target in
            xcommon | xgem | xsgi | xibm | xinova)
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	 esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath

        if (test x$target = "xsol")
        then

           make_objdir $commondir/Dicom/dicom/bin
           make_objdir $commondir/Dicom/dicom/conf

           filelist="byte_swap     create_ctn_input create_fdf_dicom \
                     split_fdf     start_server     create_dicom     \
                     stop_server   store_image"


           for xfile in $filelist
           do
               echo $xfile >> $logpath
               rm -f $commondir/Dicom/dicom/bin/$xfile
               cp -p $solobjdir/proglib/$category/$xfile $commondir/Dicom/dicom/bin/$xfile
               rm -f $commondir/Dicom/dicom_lnx/bin/$xfile
               cp -p $lnxobjdir/proglib/$category/$xfile $commondir/Dicom/dicom_lnx/bin/$xfile
               strip_obj $commondir/Dicom/dicom/bin/$xfile
           done
           cd $commondir/Dicom/dicom/conf
           sccs -d$sccsdir/dicom get dicom_store.cfg
           cd $commondir/Dicom/dicom_lnx/conf
           sccs -d$sccsdir/dicom get dicom_store.cfg

           filelist="dcm_create_object dcm_ctnto10 dicom_echo send_image"

           for xfile in $filelist
           do
               echo $xfile >> $logpath
               rm -f $commondir/Dicom/dicom/bin/$xfile
               cp -p /sw/Dicom/dicom/bin/$xfile $commondir/Dicom/dicom/bin/$xfile
               rm -f $commondir/Dicom/dicom_lnx/bin/$xfile
               cp -p /sw/Dicom/dicom_lnx/bin/$xfile $commondir/Dicom/dicom_lnx/bin/$xfile
               strip_obj $commondir/Dicom/dicom/bin/$xfile
           done

         fi
         ;;
         


	xtune )

	case x$target in
            xsun4 | xsgi | xibm )
            echo "Skipping category: $category   target: $target"
	    set +x
            continue;
               ;;
        esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath

         case x$target in

 	    xcommon)
		set -x
		make_objdir $objdir/tune/manual
	 	( cd $objdir/tune/manual;
	 	  sccs -p$sccsdir/tune/SCCS get maketune
		  make -ef maketune man
		  rm -f maketune
	 	)
	 	( cd $objdir/tune;
	 	  sccs -p$sccsdir/tune/SCCS get maketune
		  make -ef maketune manifest
		  rm -f maketune
	 	)
	 	( 
		  get_xresource_file $category tape_sol app-defaults Qtune
	 	)
		set +x
		;;

# sol, inova and gem are quite similar for tune.
# (sol works with the UnityPLUS version)
# all three use the same tune user interface, qtune_ui
# key difference is the program that interacts with the console,
# qtune_data (UnityPLUS), iqtune_data (inova), mqtune_data (Mercury/VX)

	    xsol)
		make_objdir $objdir/bin
		filelist="qtune_ui qtune_data"
		echo "tune file list: $filelist"
		for xfile in $filelist
		do
		  set -x
       		  rm -f $objdir/bin/$xfile
		  cp -p $sobjdir/proglib/$category/$xfile $objdir/bin/$xfile
		  set +x
	  	  strip_obj $objdir/bin/$xfile
		  echo $xfile >> $logpath
		done
		set +x
		;;

 	    xinova)
		make_objdir $objdir/bin
		filelist="qtune_ui iqtune_data"
		echo "tune file list: $filelist"
		for xfile in $filelist
		do
		  set -x
       		  rm -f $objdir/bin/$xfile
		  cp -p $sobjdir/proglib/$category/$xfile $objdir/bin/$xfile
		  set +x
	  	  strip_obj $objdir/bin/$xfile
		  echo $xfile >> $logpath
		done
		set +x
		;;

	    xgem)
		make_objdir $objdir/bin
		filelist="qtune_ui mqtune_data"
		echo "tune file list: $filelist"
		for xfile in $filelist
		do
		  set -x
       		  rm -f $objdir/bin/$xfile
		  cp -p $sobjdir/proglib/$category/$xfile $objdir/bin/$xfile
		  set +x
	  	  strip_obj $objdir/bin/$xfile
		  echo $xfile >> $logpath
		done
		set +x
		;;
	 esac
	set +x
        ;;


	xprocproc  | xinfoproc | xrecvproc | xexpproc | \
	xnautoproc | xroboproc | xsendproc | xatproc )

	case x$target in
            xsun4 | xsgi | xibm | xsol | xgem | xcommon )
            echo "Skipping category: $category   target: $target"
	    set +x
            continue;
               ;;
        esac

      	echo " " | tee -a $logpath
        echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
	echo " " >> $logpath

        case x$category in
	   xexpproc )
	     ifile="Expproc"
	     ofile="Expproc"
	     ;;
	   xinfoproc )
	     ifile="Infoproc"
	     ofile="Infoproc"
	     ;;
	   xnautoproc )
	     ifile="Autoproc"
	     ofile="nAutoproc"
	     ;;
           xprocproc )
             ifile="Procproc"
             ofile="Procproc"
	      ;;
	   xrecvproc )
	     ifile="Recvproc"
	     ofile="Recvproc"
	     ;;
	   xroboproc )
	     ifile="Roboproc"
	     ofile="Roboproc"
	     ;;
	   xsendproc )
	     ifile="Sendproc"
	     ofile="Sendproc"
	     ;;
	   xatproc )
	     ifile="Atproc"
	     ofile="Atproc"
	     ;;
	   * )
	     ifile="XXXXXX"
	     ofile="XXXXXX"
	esac
        
	echo "Proc Family with: " >> $logpath
        set -x
	rm -f $objdir/acqbin/$ofile
	cp -p $sobjdir/proglib/$category/$ifile $objdir/acqbin/$ofile
	set +x
	strip_obj $objdir/acqbin/$ofile
	echo $xfile >> $logpath
        if [ x$category = "xroboproc" ]
        then
          set -x
	  rm -f $objdir/acqbin/gilalign
#	  cp -p $sobjdir/proglib/$category/gilalign $objdir/acqbin/gilalign
	  rm -f $commondir/Gilson/bin/gilalign
	  cp -p $sobjdir/proglib/$category/gilalign $commondir/Gilson/bin/gilalign
	  rm -f $commondir/768AS/bin/gilalign
	  cp -p $sobjdir/proglib/$category/gilalign $commondir/768AS/bin/gilalign
	  rm -f $commondir/768AS/bin/Gilscript
	  cp -p $sobjdir/proglib/$category/Gilscript $commondir/768AS/bin/Gilscript
          rm -f $objdir/bin/nmsalign
	  cp -p $sobjdir/proglib/$category/nmsalign $objdir/bin
          rm -f $objdir/bin/ptalign
	  cp -p $sobjdir/proglib/$category/ptalign $objdir/bin
	  set +x
	  strip_obj $objdir/acqbin/gilalign
	  strip_obj $objdir/bin/nmsalign
	  echo gilalign Gilscript >> $logpath
        fi

#        if [ x$category = "xexpproc" ]
#        then
#          set -x
#	  rm -f $objdir/acqbin/send2Vnmr
#	  cp -p $sobjdir/proglib/$category/send2Vnmr $objdir/acqbin/send2Vnmr
#	  set +x
#	  strip_obj $objdir/acqbin/send2Vnmr
#	  echo send2Vnmr >> $logpath
#        fi
        ;;

       xncomm )
	case x$target in
            xsun4 | xsgi | xibm | xsol | xgem | xcommon )
            echo "Skipping category: $category   target: $target"
	    set +x
            continue;
               ;;
	esac

		  set -x
	rm -f $objdir/lib/libncomm.so
	cp -p $sobjdir/proglib/ncomm/libncomm.a  $objdir/lib/libncomm.a
	cp -p $sobjdir/proglib/ncomm/libncomm.so.$so_ver \
	      $objdir/lib/libncomm.so.$so_ver
        (cd $objdir/lib; ln -s libncomm.so.$so_ver libncomm.so)
		  set +x
	;;

       xkvwacqkernel )
	case x$target in
	   xgem )
	      echo " " >> $logpath
	      make_objdir $commondir/acq
	      make_objdir $commondir/acq/kvxBoot
	      make_objdir $commondir/acq/kvxBoot.small
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		  set -x
	      rm -f $commondir/acq/kvxBoot.small/vxWorks
              cp -p $sourcedir/sys$category/NMRrel.vxWorks $commondir/acq/kvxBoot.small/vxWorks
	      rm -f $commondir/acq/kvxBoot/vxWorks
	      rm -f $commondir/acq/kvxBoot/vxWorks.sym
              cp -p $sourcedir/sys$category/NMRdev.vxWorks $commondir/acq/kvxBoot/vxWorks
              cp -p $sourcedir/sys$category/NMRdev.vxWorks.sym $commondir/acq/kvxBoot/vxWorks.sym
		  set +x
           ;;
	esac
	;;

#ccccc
       xvwacqkernel )
	case x$target in
	   xinova )
	      echo " " >> $logpath
	      make_objdir $commondir/acq
	      make_objdir $commondir/acq/vxBoot.big
	      make_objdir $commondir/acq/vxBoot.small
	      make_objdir $commondir/acq/vxBootPPC.big
	      make_objdir $commondir/acq/vxBootPPC.small
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		  set -x
	      rm -f $commondir/acq/vxBoot.small/vxWorks
	      rm -f $commondir/acq/vxBoot.big/vxWorks
	      rm -f $commondir/acq/vxBoot.big/vxWorks.sym
              cp -p $sourcedir/sys$category/68k/NMRrel.vxWorks $commondir/acq/vxBoot.small/vxWorks
              cp -p $sourcedir/sys$category/68k/NMRdev.vxWorks $commondir/acq/vxBoot.big/vxWorks
              cp -p $sourcedir/sys$category/68k/NMRdev.vxWorks.sym $commondir/acq/vxBoot.big/vxWorks.sym

	      rm -f $commondir/acq/vxBootPPC.small/vxWorks
	      rm -f $commondir/acq/vxBootPPC.big/vxWorks
	      rm -f $commondir/acq/vxBootPPC.big/vxWorks.sym
              cp -p $sourcedir/sys$category/ppc/NMRrel.vxWorks $commondir/acq/vxBootPPC.small/vxWorks
              cp -p $sourcedir/sys$category/ppc/NMRdev.vxWorks $commondir/acq/vxBootPPC.big/vxWorks
              cp -p $sourcedir/sys$category/ppc/NMRdev.vxWorks.sym $commondir/acq/vxBootPPC.big/vxWorks.sym
		  set +x
           ;;
	esac
	;;

       xkvwacq )
	set -x
	case x$target in
	   xgem )
	      echo " " >> $logpath
	      make_objdir $objdir/acq
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		  set -x
	      rm -f $commondir/acq/kvwacq.o
	      rm -f $commondir/acq/kvwtasks.o
	      rm -f $commondir/acq/kvwhdobj.o
	      rm -f $commondir/acq/kvwlibs.o
	      cp -p $sourcedir/sys$category/vwacq.o $commondir/acq/kvwacq.o
	      cp -p $sourcedir/sys$category/vwtasks.o $commondir/acq/kvwtasks.o
	      cp -p $sourcedir/sys$category/vwhdobj.o $commondir/acq/kvwhdobj.o
	      cp -p $sourcedir/sys$category/vwlibs.o $commondir/acq/kvwlibs.o
		  set +x
	   ;;
	esac
	;;

       xvwautokernel )
	case x$target in
	   xinova )
	      echo " " >> $logpath
	      make_objdir $commondir/acq
	      make_objdir $commondir/acq/vxBoot.auto
	      make_objdir $commondir/acq/vxBoot.auto.small
	      make_objdir $commondir/acq/vxBoot.auto.big
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		  set -x

	      rm -f $commondir/acq/vxBoot.auto/vxWorks.auto
	      rm -f $commondir/acq/vxBoot.auto.small/vxWorks.auto
	      rm -f $commondir/acq/vxBoot.auto.small/vxWorksMSRII.auto
	      rm -f $commondir/acq/vxBoot.auto.big/vxWorks.auto
	      rm -f $commondir/acq/vxBoot.auto.big/vxWorksMSRII.auto
	      rm -f $commondir/acq/vxBoot.auto.big/vxWorksMSRII.auto.sym

              cp -p $sourcedir/sys$category/NMRrel.vxWorks $commondir/acq/vxBoot.auto/vxWorks.auto

              cp -p $sourcedir/sys$category/NMRrel.vxWorks $commondir/acq/vxBoot.auto.small/vxWorks.auto
              cp -p $sourcedir/sys$category/NMRrel.vxWorksMSRII $commondir/acq/vxBoot.auto.small/vxWorksMSRII.auto

              cp -p $sourcedir/sys$category/NMRdev.vxWorks $commondir/acq/vxBoot.auto.big/vxWorks.auto
              cp -p $sourcedir/sys$category/NMRdev.vxWorks.sym $commondir/acq/vxBoot.auto.big/vxWorks.auto.sym
              cp -p $sourcedir/sys$category/NMRdev.vxWorksMSRII $commondir/acq/vxBoot.auto.big/vxWorksMSRII.auto
              cp -p $sourcedir/sys$category/NMRdev.vxWorksMSRII.sym $commondir/acq/vxBoot.auto.big/vxWorksMSRII.auto.sym

		  set +x
           ;;
	esac
	;;

       xvwacq )
	set -x
	case x$target in
	   xinova )
	      echo " " >> $logpath
	      make_objdir $commondir/acq/vxBoot.big
	      make_objdir $commondir/acq/vxBootPPC.big
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		  set -x
	      rm -f $commondir/acq/vxBoot.big/vwacq.o
	      rm -f $commondir/acq/vxBoot.big/vwtasks.o
	      rm -f $commondir/acq/vxBoot.big/vwhdobj.o
	      rm -f $commondir/acq/vxBoot.big/vwlibs.o

	      #cp -p $sourcedir/sys$category/68k/vwacq.o $commondir/acq/vxBoot.big/vwacq.o
	      cp -p $sourcedir/sys$category/68k/vwtasks.o $commondir/acq/vxBoot.big/vwtasks.o
	      cp -p $sourcedir/sys$category/68k/vwhdobj.o $commondir/acq/vxBoot.big/vwhdobj.o
	      cp -p $sourcedir/sys$category/68k/vwlibs.o $commondir/acq/vxBoot.big/vwlibs.o

	      rm -f $commondir/acq/vxBootPPC.big/vwacq.o
	      rm -f $commondir/acq/vxBootPPC.big/vwtasks.o
	      rm -f $commondir/acq/vxBootPPC.big/vwhdobj.o
	      rm -f $commondir/acq/vxBootPPC.big/vwlibs.o
	      #cp -p $sourcedir/sys$category/ppc/vwacq.o $commondir/acq/vxBootPPC.big/vwacq.o
	      cp -p $sourcedir/sys$category/ppc/vwtasks.o $commondir/acq/vxBootPPC.big/vwtasks.o
	      cp -p $sourcedir/sys$category/ppc/vwhdobj.o $commondir/acq/vxBootPPC.big/vwhdobj.o
	      cp -p $sourcedir/sys$category/ppc/vwlibs.o $commondir/acq/vxBootPPC.big/vwlibs.o
		  set +x
	   ;;
	esac
	;;

        xvwauto )
	set -x
	case x$target in
	   xinova )
	      echo " " >> $logpath
	      make_objdir $objdir/acq
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		  set -x
	      rm -f $commondir/acq/vwauto.o
              rm -f $commondir/acq/vxBoot.auto.big/vwauto.o
	      cp -p $sourcedir/sys$category/vwauto.o $commondir/acq/vxBoot.auto.big/vwauto.o
		  set +x
	   ;;
	esac
	;;

       xvwcom )
	set -x
	case x$target in
	   xinova )
	      echo " " >> $logpath
	      make_objdir $commondir/acq/vxBoot.big
	      make_objdir $commondir/acq/vxBootPPC.big
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		  set -x
	      rm -f $commondir/acq/vxBoot.big/vwcom.o
              cp -p $sourcedir/sys$category/68k/vwcom.o $commondir/acq/vxBoot.big/vwcom.o   

	      rm -f $commondir/acq/vxBootPPC.big/vwcom.o
              cp -p $sourcedir/sys$category/ppc/vwcom.o $commondir/acq/vxBootPPC.big/vwcom.o
		  set +x
	   ;;
	esac
	;;
       xbootpd )
	case x$target in
            xsun4 | xsgi | xibm | xsol | xgem | xcommon )
            echo "Skipping category: $category   target: $target"
	    set +x
            continue;
               ;;
	esac

		  set -x
	rm -f $objdir/acqbin/bootpd
	cp -p $sobjdir/proglib/bootpd/bootpd  $objdir/acqbin/bootpd
	rm -f $objdir/acq/bootptab
	cp -p $sobjdir/proglib/bootpd/bootptab  $objdir/acq/bootptab
		  set +x
	;;

       xgs )
         case x$target in
            xgem | xsun4 | xcommon | xsol | xinova )
	       echo "Skipping category: $category   target: $target"
	       continue;
	       ;;

	    xsgi | xibm )
	  	set -x
	  	rm -f $objdir/bin/gs
	  	cp -p $objdir/proglib/gs/gs  $objdir/bin/gs
		  echo $gs >> $logpath
		set +x
	       continue;
	       ;;

         esac
	;;



       xjplot )
	case x$target in
            xsun4 | xsgi | xibm | xsol | xgem )
            echo "Skipping category: $category   target: $target"
	    set +x
            continue;
               ;;

            xcommon )
                set -x
	        rm -rf $objdir/tape_sol/user_templates/icon
		cp -rp $sobjdir/icon $objdir/tape_sol/user_templates
	        rm -rf $objdir/tape_sgi/user_templates/icon
		cp -rp $sobjdir/icon $objdir/tape_sgi/user_templates
	        rm -rf $objdir/tape_ibm/user_templates/icon
		cp -rp $sobjdir/icon $objdir/tape_ibm/user_templates
                set +x
		;;

	
            xinova )
	     make_objdir $objdir/java
	     set -x
	     rm -f $objdir/java/jplot.jar
	     cp -p $sourcedir/sys$category/jplot.jar  $objdir/java
	     set +x
		;;

	esac

	;;


       xjpsg )
	case x$target in
            xsun4 | xsgi | xibm | xsol | xgem )
            echo "Skipping category: $category   target: $target"
	    set +x
            continue;
               ;;

            xcommon )
		filelist="Jpsg.sh PSGGo.cps PSGSetup.cps PSGscan.cps PSGerrors.properties"
		(set -x; 				\
			cd $sourcedir/sys$category; 		\
		 	sccs -p$sccsjdir/jpsg/SCCS get $filelist; make Jpsg; )

		;;

	
            xinova )
		;;

	esac

	;;


       xstars )
	program_list="starsprg qpar"	# for reference only right now
	case x$target in
	    xsol )
	        echo " " >> $logpath
                echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		get_special_progs stars STARS $target starsprg
		strip_special_progs STARS $target starsprg
		get_special_progs stars STARS $target qpar
		strip_special_progs STARS $target qpar
	       ;;

	    * )
                echo "Skipping category: $category   target: $target"
	       ;;
	esac
	;;


       xapt )
	  case x$target in
            xgem )
              echo " " >> $logpath
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath

              make_objdir $objdir/java
              set -x
              rm -f $objdir/java/apt.jar
              cp -p $sourcedir/sys$category/apt.jar  $objdir/java
              set +x
              ;;

            * )
              echo "Skipping category: $category   target: $target"
              set +x
              continue;
              ;;

            esac
            ;;


       xhermes )
	  case x$target in
            xinova )
              program_list="Temp768AS.jar Setup768AS.jar Robotester768AS.jar \
               Config768AS.jar Gilson768AS.jar Sensor768AS.jar Stat768AS.jar \
               RoboCmd768AS.jar SamplePrep768AS.jar ToolBar768AS.jar"
                
              echo " " >> $logpath
              echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath

              make_objdir $commondir/768AS/java
              for file in $program_list
              do
                set -x
                rm -f $commondir/768AS/java/$file
                cp -p $sourcedir/sys$category/$file $commondir/768AS/java
                set +x
                echo $file >> $logpath
              done

              icon_list="768ASIconAlign.gif 768ASTB_Align.gif 768ASalign.gif 768ASIconConfig.gif 768ASTB_Config.gif 768ASconfig.gif 768ASIconDesigner.gif 768ASTB_Designer.gif 768ASdesigner.gif 768ASIconRoboCmd.gif 768ASTB_RoboCmd.gif 768ASrobocmd.gif 768ASIconSensor.gif 768ASTB_Sensor.gif 768ASsensor.gif 768ASIconSetup.gif 768ASTB_Setup.gif 768ASsetup.gif 768ASIconStatus.gif 768ASTB_Status.gif 768ASstatus.gif 768ASIconTemp.gif 768ASTB_Temp.gif 768AStemp.gif up2.gif down2.gif left2.gif right2.gif"

              make_objdir $commondir/768AS/iconlib
              for file in $icon_list
              do
                set -x
                rm -f $commondir/768AS/iconlib/$file
                cp -p $commondir/iconlib/768AS_iconlib/$file $commondir/768AS/iconlib
                set +x
                echo $file >> $logpath
              done
              ;;

            * )
              echo "Skipping category: $category   target: $target"
 	      set +x
              continue;
              ;;

            esac
            ;;

       *)      
	echo Updating not supported for \'"$category"\' ;
	;;

      esac		# end of the case of categories
    done
done
