: /bin/sh
# '@(#)vnmrh_tarout.sh 22.1 03/24/08 1991-1996 '
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
#  Version for combined support of SUN-3 and SUN-4
# Mod. 8/16/89 removed acqbin/Acqstatmsg & acqbin/test4stat  from tape
# Mod. 8/16/89 added   acqbin/acqinfo_svc    GMB
# Mod. 10/25/89 added  bin/dps_ps_gen    GMB
# Mod. 10/31/89 added the 4 kernel tar files after sun4obj GMB

# shared library version number
so_ver=$psg_so_ver

# -- common bin script files to include on tape  
# --    remember bin is ar so name must 15 chars or less
cbinfiles="bin/readbrutape		\
	bin/wtgen		\
	bin/psggen		\
	bin/seqgen		\
	bin/booleanpreen	\
	bin/killft3d		\
	bin/xseqpreen		\
	bin/Vn			\
	bin/makeuser		\
	bin/makesuacqproc	\
	bin/setuserpsg		\
	bin/setacq		\
	bin/setether		\
	bin/setnoether		\
	bin/execkillacqproc	\
	bin/vbg			\
	bin/vnmr_explib		\
	bin/vnmr_setgauss	\
	bin/vnmr_showfit	\
	bin/vnmr_singleline	\
	bin/vnmr_usemark	\
	bin/vnmrplot		\
	bin/vnmr		\
	bin/vnmrprint"

#--- common directories to tar and ar, 
#    note: directories that have sub directories must be tarred
#          ar directories of just files and where file names <= 15 characters
dir2tar="			\
	fidlib			\
	manual			\
	maclib"

# -- par200 par300 par400 par500 par600 parlib, 
# --- i.e. par* are tarred as one tar file.
	
dir2ar="			\
	psg			\
	psglib			\
	shapelib		\
	help			\
	menulib			\
	tablib"

Wlist=" $dir2tar $dir2ar	\
	par200			\
	par300			\
	par400			\
	par500			\
	par600			\
	parlib"
	
#--- directories from PFG common to go into tar file
dir4PFG="			\
	parlib			\
	maclib			\
	manual			\
	psglib"

# -- misc common files tarred into one tar file.
comlist="			\
	bootup_message		\
	rc.vnmr			\
	acqqueue/acqinfo	\
	acq/a*			\
	acq/xr.conf		\
	acq/xrxrh.out 		\
	acq/rhmon.out 		\
	conpar			\
	devicenames		\
	devicetable		\
	asm			\
	nuctables		\
	shimmethods		\
	shims			\
	solvents		\
	user_templates		\
	varian.icon"

# -- acqbin files
acqbfiles="acqbin/Acqproc	\
        acqbin/acqinfo_svc      \
        acqbin/Autoproc         \
        acqbin/send2Vnmr        \
        acqbin/startacqproc     \
        acqbin/killacqproc      \
        acqbin/seqgenmake"

# -- common binary bin files (sun3 & sun4)
binfiles="bin/banner            \
        bin/Acqstat		\
        bin/compressfid         \
        bin/convertbru          \
        bin/cpos_cvt            \
        bin/decomp              \
	bin/diffshims		\
        bin/eatchar             \
	bin/editdevices		\
        bin/enter               \
        bin/expfit              \
        bin/fpa_test            \
        bin/gin_setup           \
        bin/iadisplay           \
        bin/makeprintcap        \
	bin/getplane		\
	bin/portrait		\
	bin/psfilter		\
        bin/spins               \
        bin/status              \
        bin/tape                \
        bin/tek_setup           \
        bin/unix_vxr            \
	bin/vconfig		\
        bin/vn                  \
	bin/usrwt.o		\
	bin/vxrTool		\
	bin/vxr_unix		\
	bin/weight.h		\
	bin/xdcvt		\
	bin/dps_ps_gen"

bin4files="bin/Vnmr             \
	bin/fitspec		\
	bin/pulsetool		\
	bin/pulsechild		\
	bin/ft3d"

psgfiles="psg/libpsglib.a       \
        psg/libparam.a          \
        psg/llib-lpsg.ln	\
	psg/libpsglib.so.$so_ver \
	psg/libparam.so.$so_ver"

#-------------------------------------------------------
tst4file () {
 if test -s $1
 then
   echo "File $1 Exists, Delete (rm) or Rename (mv)"
   abort=y
 fi;
}

#-------------------------------------------------------
mktarfiles () {    # $1 is the passed directory
   echo "Generating Tar or Ar common files"
   if test ! -d $1/com
   then
     mkdir $1/com
   else
     rm -rf $1/com	# remove all previous files
     mkdir $1/com
   fi
   cd $commondir

#-- tar file in comlist  into one tar file ---------
     echo "com.tar files:"
     echo "$comlist"
     tar cf $1/com/com.tar $comlist
     (cd $1/com; compress com.tar; )
     echo " "

#-- tar file in dirs2tar list ---------
   tarfile="$dir2tar" 
   for file in $tarfile
   do
     echo -n "$file  "
     tar cf $1/com/$file.tar $file
   done
   (cd $1/com; compress maclib.tar; compress manual.tar; )

#-- tar the par* files into one tar file ---------
   echo
   echo `ls -d par*`
   tar cf $1/com/par.tar par*
   (cd $1/com; compress par.tar; )

#-- ar the common bin scripts into bin ar file ---------
   echo -n "bin  "
   ar cr $1/com/bin.ar $cbinfiles

#-- ar the files in the dirs2ar list 
   arfile="$dir2ar"
   for file in $arfile
   do
     echo -n "$file  "
     ar cr $1/com/$file.ar $file/*
   done
   (cd $1/com; compress psg.ar; )

#--- tar the PFG common files maclib, manual, psglib
   echo
   echo -n "PFG: parlib maclib manual "
   cd PFG
   tar cf $1/com/PFG.tar maclib manual parlib
   cd ..

#-----   Now time for Object Files
   echo "Generating Tar or Ar Sun4 files"
   if test ! -d $1/sun4
   then
     mkdir $1/sun4
   else
     rm -rf $1/sun4	# remove all privous files
     mkdir $1/sun4
   fi
   cd $sun4objdir
   echo -n "acqbin  "
   tar -cf $1/sun4/acqbin.tar $acqbfiles
   echo -n "bin  "
   tar -cf $1/sun4/bin.tar $bin4files $binfiles
   echo -n "psg  "
   tar -cf $1/sun4/psg.tar $psgfiles
   echo "seqlib  "
   tar -cf $1/sun4/seqlib.tar seqlib  ;

   echo "Moving Kernel Tar files"
   if test ! -d $1/kernels
   then
     mkdir $1/kernels
     mkdir $1/kernels/bin
   else
     rm -rf $1/kernels	# remove all privous files
     mkdir $1/kernels
     mkdir $1/kernels/bin
   fi
   cd $sunkernels
   echo " bin/setacq *"
   cp -p $commondir/bin/setacq $1/kernels/bin
   cp -p * $1/kernels

}

#-------------------------------------------------------
mkcomp () {
   echo "Compressing Tar or Ar Common files"
   (cd $1/com; compress -v *.*ar )
   echo "Compressing Tar or Ar Sun3 files"
   (cd $1/sun3; compress -v *.*ar )
   echo "Compressing Tar or Ar Sun4 files"
   (cd $1/sun4; compress -v *.*ar );
   echo "Compressing Tar Kernel files"
   (cd $1/kernels; compress -v *.*ar );
}
 

# ------------------ Start of Main  ---------------------------
echo " "
echo "Date: `date`"
echo " "

name=`basename $0`
if ( test $name = "vnmrh_tarout" )
then
 echo "Making VNMR Tar Tape for combined SUN-3/SUN-4 support"
 taropt=cvfb
 blksiz=2000
 tardev=/dev/nrst8
 tardev1=/dev/nrst8
 tardev2=/dev/nrst8
 tardev3=/dev/nrst8
 tardev4=/dev/nrst8
 tardev5=/dev/nrst8
elif ( test $name = "vnmr_tarfile" )
then
 echo -n "Specify Directory to place Tar Files: "
 read tardir
 echo "You Selected Directory: $tardir"
 echo -n "Proceed ? (y or n) "
 read answer
 if (test "x$answer" != "xy")
 then 
   echo "User Aborted."
   exit 1
 fi
 taropt=cvf
 blksiz=""
 date=`date +%y%m%d.%H:%M`
 tardev=$tardir/vnmr_tarfile.${date}
 tardev1=$tardir/Loadscripts
 tardev2=$tardir/Com
 tardev3=$tardir/Sun3
 tardev4=$tardir/Sun4
 tardev5=$tardir/Kernels
# check for file presents.. 
 tst4file $tardev1; tst4file $tardev2; tst4file $tardev3
 tst4file $tardev4; tst4file $tardev5; tst4file $tardev6
 tst4file $tardev7; tst4file $tardev8
 if ( test $abort = "y" )
 then
   exit 1
 fi
 echo "Making VNMR Tar File \`$tardev' for combined SUN-3/SUN-4 support"
else
  echo "Illegal Call Name: $name"
  exit 1
fi

 echo
 echo "common files from: $commondir"
 echo "sun3 files from: $sun3objdir"
 echo "sun4 files from: $sun4objdir"
 echo "kernel files from: $sunkernels"
 echo
 echo -n "The Above Correct? (y or n) [y]: "
 read answer
 if [ x$answer = "x" ]
 then
   answer="y"
 fi
 if test ! x$answer = "xy"
 then
   echo "aborted."
   exit 1
 fi

 echo -n "Tape Format: WYSIWYG, Tar Files, Tar Files w/ Compression? (w,t,c) [t]:  "
 read tapetype
 if [ x$tapetype = "x" ]
 then
   tapetype="t"
 fi
 if (test "x$tapetype" != "xw" -a "x$tapetype" != "xt" -a "x$tapetype" != "xc")
 then 
   echo "Invalid Tape Format: $tapetype"
   exit 1
 fi
 if (test ! "x$tapetype" = "xw")
 then
   echo -n "Specify Directory to place Tar Files [/vtapes/sunh]: "
   read tmpdir
   if [ x$tmpdir = "x" ]
   then
     tmpdir="/vtapes/sunh"
   fi
   echo "You Selected Tape Format: $tapetype, And directory: $tmpdir"
   Tarlist="				\
	-C $tmpdir/com com.tar.Z	\
	-C $tmpdir/com bin.ar		\
	-C $tmpdir/com fidlib.tar	\
	-C $tmpdir/com help.ar		\
	-C $tmpdir/com maclib.tar.Z	\
	-C $tmpdir/com manual.tar.Z	\
	-C $tmpdir/com menulib.ar	\
	-C $tmpdir/com par.tar.Z	\
	-C $tmpdir/com psg.ar.Z		\
	-C $tmpdir/com psglib.ar	\
	-C $tmpdir/com shapelib.ar	\
	-C $tmpdir/com PFG.tar		\
	-C $tmpdir/com tablib.ar"

   ZTarlist="				\
	-C $tmpdir/com com.tar.Z	\
	-C $tmpdir/com bin.ar.Z		\
	-C $tmpdir/com fidlib.tar.Z	\
	-C $tmpdir/com help.ar.Z	\
	-C $tmpdir/com maclib.tar.Z	\
	-C $tmpdir/com manual.tar.Z	\
	-C $tmpdir/com menulib.ar.Z	\
	-C $tmpdir/com par.tar.Z	\
	-C $tmpdir/com psg.ar.Z		\
	-C $tmpdir/com psglib.ar.Z	\
	-C $tmpdir/com shapelib.ar.Z	\
	-C $tmpdir/com PFG.tar.Z		\
	-C $tmpdir/com tablib.ar.Z"
    echo -n "Proceed with Only Compression(c) or Compression & Make tape(b)? (c,b, or n) [b]: "
    read answer
    if [ x$answer = "x" ]
    then
      answer="b"
    fi
    if test "x$answer" = "xn"
    then
      echo "User Aborted."
      exit 1
    elif test "x$answer" = "xc"
    then
      mktape="n"
    elif test "x$answer" = "xb"
    then
      mktape="y"
    else
      echo "Invalid Answer."
      exit 1
    fi
  else
   echo "You Selected Tape Format: $tapetype"
   echo -n "Proceed with Making Tape? (y or n) "
   read mktape
   if (test "x$mktape" != "xy" -a "x$mktape" != "xn" )
   then 
     echo "Invalid Answer: $mktape"
     exit 1
   fi
 fi

 if (test ! "x$tapetype" = "xw")
 then
  if (test "x$tapetype" = "xt")
  then
    comtarlist="$Tarlist"
    sun4tarlist="acqbin.tar bin.tar psg.tar seqlib.tar"
  else
    comtarlist="$ZTarlist"
    sun4tarlist="acqbin.tar.Z bin.tar.Z psg.tar.Z seqlib.tar.Z"
  fi
  if test -d $tmpdir/com
  then
    nfiles=`(cd $tmpdir/com; ls *.*ar* | wc -l)`
  else
    nfiles=0
  fi
  if test $nfiles -gt 0
  then
   ls -ts $tmpdir/com/*.*ar* $tmpdir/sun4/*.*ar* $tmpdir/kernels/*.*ar*
   echo -n "Use present tar & ar files in: $tmpdir  (y or n) [n]: "
   read answer
   if [ "x$tapetype" = "x" ]
   then
      answer="n"
   fi
   if test ! "x$answer" = "xy"
   then
     mktarfiles $tmpdir
     if test "x$tapetype" = "xc"
     then
       mkcomp $tmpdir
     fi
   else
     echo "Using Present Tar Files."
   fi
  else
   mktarfiles $tmpdir
   if test "x$tapetype" = "xc"
   then
     mkcomp $tmpdir
   fi
  fi
 else
  comtarlist="$cbinfiles $comlist $Wlist"
  sun4tarlist="$acqbfiles $bin4files $binfiles $psgfiles seqlib"
 fi

 if test "x$mktape" != "xy"
 then
   echo "No tape made, as requested."
   exit 0
 fi

#  Rewind the tape if taring to tape device

if ( test $tardev = "/dev/nrst8" )
then
  mt -f /dev/nrst8 rewind
fi

#  First file contains loading scripts  /common

echo "Writing Load Files"
cd $commondir
tar cvf $tardev1		\
        VnmrS_4.2a		\
        loadvnmr		\
        installdecomp		\
        finish_load		\
	makevnmr1		\
	makevnmr2

#  Second file contains stuff common to both systems  /common

echo "Writing Common Files"
tar $taropt $tardev2 $blksiz $comtarlist

# if tar file then copy separate tar files into One
if (test ! $tardev = "/dev/nrst8")
then
 ( cd $tardir; \
 tar -cvf `basename $tardev` `basename $tardev1`; \
 rm -f `basename $tardev1`; \
 tar -rvf `basename $tardev` `basename $tardev2`; \
 rm -f `basename $tardev2` )
fi

#  Third file contains SUN-3 stuff   /sun3obj

#  Fourth file contains SUN-4 stuff

echo "Writing Sun4 Files"
if (test "x$tapetype" = "xw")
then
 cd $sun4objdir
else
 cd $tmpdir/sun4
fi

tar $taropt $tardev4 $blksiz $sun4tarlist

# if tar file then copy separate tar files into One.
if (test ! $tardev = "/dev/nrst8")
then
 ( cd $tardir; \
 tar -rvf `basename $tardev` `basename $tardev4`; \
 rm -f `basename $tardev4`; )
fi

#--  Fifth file contains an aggregate tar image of all the arch-k_sunos.tar images
# e.g. there are sun3_4.1.1.tar, sun3_4.1.tar, sun4_4.1.tar, sun4_4.1.1.tar
#	sun4_4.1.2.tar, etc in one tar image.

echo " "
echo "Writing setacq and Kernel Tar Files"
cd $tmpdir
cd kernels
tar ${taropt}h $tardev5 $blksiz	 bin *4.1.3*

# if tar file then copy separate tar files into One.
if (test ! $tardev = "/dev/nrst8")
then
 ( cd $tardir; \
 tar -rvf `basename $tardev` `basename $tardev5`; \
 rm -f `basename $tardev5`; )
fi

#  Finish by rewinding the tape

if ( test $tardev = "/dev/nrst8" )
then
  mt -f /dev/nrst8 rewind
fi
echo "VNMR tape complete"
exit 0
