: /bin/sh
: '@(#)Updatetape53.sh 22.1 03/24/08 1991-1996 '
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
#  update tape directories 
#  Updatetape [category] [target]
#  if no category is given then user is prompted for category
#  similarly with target

#  Changes in this script must be coordinated with changes
#  in the script ``vnmr_tarout'' or ``limnet_tarout''

#  Establish SCCS categories to update

# ISO quality record log

# sccs, source and object path changes for 53 specific tape update
sourcedir=/vobj/sol53/common
export sourcedir
sccsdir=/vsccs/sccs53
export sccsdir
solobjdir=/vobj/sol53
export solobjdir
commondir=/vobj/sol53/vcommon
export commondir

logdir=$sourcedir/complogs/
lognam=Tapelog`uname -m`
logpath=${logdir}$lognam
#stripper="IRIS rdibm warpspeed"
stripper="warpspeed"


# function to strip the objects with the proper machine
strip_obj() {
#  set -x
   if (test $ok2strip = "y")
    then
      case x$target in

       xsun4 )
	set -x
	   strip $1
	;;
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
	   rsh warpspeed strip $1
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
 echo "Writing ISO Quality Record to: "
 echo "Directory: $logdir "
 echo " "
 echo -n "New Directory [$logdir]: "
 read tmpdir
 if [ x$tmpdir = "x" ]
 then
     tmpdir=$logdir
 fi
 logdir=$tmpdir
 echo " "
 echo "File Name: $lognam "
 echo -n "New File Name [$lognam]: "
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
echo Host: `hostname`  Type: `uname -m`  | tee -a $logpath
echo " "  | tee -a $logpath

# Shared Library Version
so_ver=$psg_so_ver
LIB_ACQCOM_SO="2.0"

if test $# -lt 1
then 
 echo Categories are:
 echo acqi acqproc autoproc psg psglib autshm halmon simul xracq xrconf
 echo -n "Category for updating, or all [all]: "
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
   chosen_categories="acqi acqproc autoproc psg psglib autshm halmon simul xracq xrconf"
else
   chosen_categories=$answer
fi

#  Establish targets for updating, SUN-3, SUN-4 or COMMON

all_targets="sol common"
if test $# -lt 1
then
 echo Targets are: $all_targets
 echo -n "Target for updating, or all [all]: "
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
  chosen_targets=$all_targets
else
  chosen_targets=$answer
fi

ok2strip="y"
stripmode="be stripped"
if test $# -lt 1
then
 echo -n "Strip binaries (y or n) [n]: "
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
      echo -n "Checking access to $ihost: "
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
echo -n "Type <C/R> to continue, ^C to quit: "
read answer

for target in $chosen_targets
do
    if (test x$target = "xsol")
    then
      objdir=$solobjdir
      sobjdir=$solobjdir 
    elif (test x$target = "xcommon")
    then
      objdir=$commondir
      sobjdir=/vobj/sol53/common
    else
      echo "Not a valid selection; " $target
      exit 1
    fi

    for category in $chosen_categories
    do
       case x$category in
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
	    cp -p $sobjdir/proglib/$category/iadisplay_ow $objdir/bin/iadisplay
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
	    cp -p $sobjdir/proglib/$category/iadisplay_ow $objdir/binx/iadisplay
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
	        filelist="libpsglib.a libparam.a llib-lpsg.ln libpsglib.so.$so_ver \
		  libparam.so.$so_ver x_ps.o"
          ;;

          xinova )
	        filelist="libpsglib_nes.a libparam_nes.a llib-lpsg.ln libpsglib.so.$so_ver \
		  libparam.so.$so_ver x_ps.o"
		dest="npsg"
		source="npsg/sol"
          ;;

          xsol )
	        filelist="libpsglib.a libparam.a llib-lpsg.ln libpsglib.so.$so_ver \
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

#  Following required for shared libraries to really work on Solaris

        if (test x$target = "xsol" -o x$target = "xinova")
        then
           (cd $objdir/$dest; ln -s libparam.so.$so_ver libparam.so; \
            ln -s libpsglib.so.$so_ver libpsglib.so; )
        fi

	echo seqgenmake >> $logpath
	make_objdir $objdir/acqbin
	set -x
        rm -f $objdir/acqbin/seqgenmake
        cp -p $sourcedir/syspsg/seqgenmake $objdir/acqbin/seqgenmake
 
	set +x
	;;

       xpsglib)
         case x$target in
            xgem )
	       echo "Skipping category: $category   target: $target"
	    set +x
	       continue;
	       ;;
	    xcommon )
	      echo " " 
	      echo "CATEGORY: $category   TARGET: $target" | tee -a $logpath
	      echo " " >> $logpath
              ( cd $sourcedir/psglib; filelist=`ls *` ; for xfile in $filelist ; do  echo $xfile >> $logpath ; done; )
	     set -x
	      ( cd $commondir/psglib; rm -f *; cp -p $sourcedir/psglib/* .  ; rm -f *make*; )
	     set +x
	      ;;

	    xinova )
		make_objdir $objdir/nseqlib
      		echo " " | tee -a $logpath
        	echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		echo " " >> $logpath
		set -x
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
		;;
	    * )
		make_objdir $objdir/seqlib
      		echo " " | tee -a $logpath
        	echo "CATEGORY: $category     TARGET: $target" | tee -a $logpath
		echo " " >> $logpath
		set -x
		( cd $objdir/seqlib; rm -f * )
		( cd $sobjdir/proglib/$category; cp -p * $objdir/seqlib)
		( cd $objdir/seqlib; rm -f *.c; rm -f *.h; rm -f *.o; rm -f *.p; \
	     	rm -f errmsg makeseqlib* ; )
		set +x
        	( cd $objdir/seqlib; filelist=`ls *` ; for xfile in $filelist ; do  echo $xfile >> $logpath ; done; )
		strip_obj "`ls $objdir/seqlib/*`"
		set -x
		( cd $sourcedir/psglib; rm -f *.h; rm -f *.o; rm -f *.p; \
	     	rm -f errmsg makeseqlib* )
		set +x
		;;
	 esac
	set +x
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
	rm -f $commondir/acq/autshm.out
	rm -f $commondir/acq/autshm_img.out
	cp -p $sourcedir/sys$category/autshm.out $commondir/acq/autshm.out
#   imaging object are now named autshm.out and are the standard 7/30/96  GMB
#	cp -p $sourcedir/sys$category/autshm_img.out \
#		$commondir/acq/autshm_img.out
	set +x
	echo "autshm" >> $logpath
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

       *)      
	echo Updating not supported for \'"$category"\' ;
	;;

      esac		# end of the case of categories
    done
done
