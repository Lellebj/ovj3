: /bin/sh
# '@(#)vnmr_tarout.sh 22.1 03/24/08 1991-1996 '
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
#  Version for support of SUN-4 Xwindows
#

# ISO quality record log
lognam=VnmrS_tarlog`uname -m`
logdirectory=$logdir
if [ x$logdirectory = "x" ]
then
   logdirectory=$sourcedir/complogs
fi

# shared library version number
so_ver=$psg_so_ver

# ---- List of files that go into the various tar or ar images ------

# -- misc common files tarred into one tar file.
#  COM.TAR list of file in  com.tar 
ComTarLst="			\
	bootup_message		\
	rc.vnmr			\
	acqqueue/acqinfo	\
	acq/xrxrh.out		\
	acq/xrxrp.out		\
	acq/xrop.out		\
	acq/rhmon.out		\
	acq/autshm.out		\
	acq/xr.conf		\
	acq/acqi*		\
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

# -- common bin script files to include on tape  
# --    remember bin is ar so name must 15 chars or less
# COMBIN.TAR List of file in combin.tar 
ComBinScripts2Tar="		\
	bin/readbrutape		\
	bin/wtgen		\
	bin/psggen		\
	bin/seqgen		\
	bin/killft3d		\
	bin/killstat		\
	bin/Vn			\
	bin/makeuser		\
	bin/makesuacqproc	\
	bin/setuserpsg		\
	bin/setacq		\
	bin/setether		\
	bin/setnoether		\
	bin/getoptions		\
	bin/execkillacqproc	\
	bin/updateuser		\
	bin/vbg			\
	bin/vnmredit		\
	bin/vnmr_textedit	\
	bin/vnmr_vi		\
	bin/vnmr_ihelp		\
	bin/vnmr_setgauss	\
	bin/vnmr_showfit	\
	bin/vnmr_singleline	\
	bin/vnmr_uname		\
	bin/vnmr_usemark	\
	bin/vnmrlp		\
	bin/vnmrshell		\
	bin/vnmrplot		\
	bin/vnmr		\
	bin/vnmrprint"

#--- common directories to tar and ar, 
#    note: directories that have sub directories must be tarred
#          ar directories of just files and where file names <= 15 characters
# directories tarred: fidlib.tar, manual.tar, psg.tar, etc...

ComDirs2Tar="			\
	fidlib			\
	manual			\
	maclib			\
	shapelib		\
	help			\
	menulib			\
	tablib			\
	userlib"

# -- par200 par300 par400 par500 par600 parlib, 
# --- i.e. par* are tarred as one tar file "par.tar".
# PAR.TAR
	
ComPar2Tar="		\
		par200	\
		par300	\
		par400	\
		par500	\
		par600	\
		par750	\
		parlib"

#--- directories from PFG common to go into tar file
# pfg.tar
ComPFG2Tar="			\
	parlib			\
	maclib			\
	manual			\
	psglib"

#--- directories from Image common to go into tar file
# image.tar
ComImage2Tar="			\
	imaging			\
	parlib			\
	maclib			\
	manual			\
	psglib"			\

#--- directories from kermit common to go into tar file
# kermit.tar
ComKermit2Tar="			\
		kermit/kermit.doc"

# -- files to include in common acqbin tar file
# --- acqbin.tar 
BinAcq2Tar="acqbin/Acqproc	\
        acqbin/acqinfo_svc      \
        acqbin/Autoproc         \
        acqbin/send2Vnmr        \
        acqbin/startacqproc     \
        acqbin/killacqproc      \
        acqbin/seqgenmake"

# -- binary common to SunView & X-window to include in bin.tar file 
# --- bin.tar 
BinFiles2Tar="bin/banner            \
        bin/compressfid         \
        bin/convertbru          \
        bin/cpos_cvt            \
        bin/decomp              \
	bin/diffshims		\
        bin/eatchar             \
	bin/editdevices		\
        bin/expfit              \
	bin/fitspec		\
	bin/ft3d		\
        bin/gin_setup           \
        bin/makeprintcap        \
	bin/getplane		\
	bin/portrait		\
	bin/psfilter		\
        bin/showstat            \
        bin/spins               \
        bin/tape                \
        bin/tek_setup           \
        bin/unix_vxr            \
        bin/vn                  \
	bin/usrwt.o		\
	bin/vxr_unix		\
	bin/weight.h		\
	bin/xdcvt		\
	bin/dps_ps_gen"

# -- binary SunView base programs to include in bins.tar file 
# --- bins.tar 
BinSV2Tar="bin/Vnmr             \
	bin/pulsetool		\
	bin/pulsechild		\
	bin/iadisplay		\
	bin/vconfig		\
	bin/status		\
	bin/enter		\
	bin/vxrTool		\
	bin/Acqstat"

# -- binary X-Windows base programs to include in binx.tar file 
# --- binx.tar 
BinX2Tar="binx/Vnmr           \
	binx/pulsetool		\
	binx/pulsechild		\
	binx/iadisplay		\
	binx/vconfig		\
	binx/status		\
	binx/enter		\
	binx/vxrTool		\
	binx/Acqstat"

# -- Shared libraries used by the Pulse Sequencies 
# --- psg.tar 
BinPsg2Tar="psg/libpsglib.a       \
        psg/libparam.a          \
        psg/llib-lpsg.ln	\
	psg/libpsglib.so.$so_ver \
	psg/libparam.so.$so_ver	\
        psg/x_ps.o"

# -- Glide files to tar
# --- glide.tar 
BinGlide2Tar="bin/gadm       \
	bin/glide		\
	-C $commondir glide/adm	\
	-C $commondir glide/exp	\
	-C $commondir glide/templates"

#---- PFG binaries to tar
# --- pfg.tar 
BinPFG2Tar="seqlib/g2pul	\
	seqlib/gcosy		\
	seqlib/ghmqc		\
	seqlib/ghsqc		\
	seqlib/gmqcosy		\
	seqlib/gnoesy		\
	seqlib/gtnnoesy		\
	seqlib/gtnroesy		\
	seqlib/p2pul		\
	seqlib/profile"

#---- Image binaries to tar
# --- image.tar 
BinImage2Tar="bin/eccsend	\
	bin/eccTool		\
	seqlib/center		\
	seqlib/cssibn		\
	seqlib/cssish		\
	seqlib/ecc		\
	seqlib/gsh2Dpul		\
	seqlib/gsh2pul		\
	seqlib/mslicer		\
	seqlib/zap"



#---- Standard seqlib binaries to tar
# --- seqlib.tar 
BinSeq2Tar="seqlib/apt		\
	  seqlib/binom		\
	  seqlib/br24		\
	  seqlib/cosyps		\
	  seqlib/cpmgt2		\
	  seqlib/cyclenoe	\
	  seqlib/cylbr24	\
	  seqlib/cylmrev	\
	  seqlib/d2pul		\
	  seqlib/dept		\
	  seqlib/dqcosy		\
	  seqlib/flipflop	\
	  seqlib/hcchtocsy	\
	  seqlib/het2dj		\
	  seqlib/hetcor		\
	  seqlib/hetcorcp1	\
	  seqlib/hmqc		\
	  seqlib/hmqcr		\
	  seqlib/hmqctocsy	\
	  seqlib/hom2dj		\
	  seqlib/inadqt		\
	  seqlib/inept		\
	  seqlib/jumpret	\
	  seqlib/mqcosy		\
	  seqlib/mrev8		\
	  seqlib/noesy		\
	  seqlib/ppcal		\
	  seqlib/presat		\
	  seqlib/pwxcal		\
	  seqlib/redor1		\
	  seqlib/relayh		\
	  seqlib/roesy		\
	  seqlib/s2pul		\
	  seqlib/s2pulq		\
	  seqlib/s2pulr		\
	  seqlib/sh2pul		\
	  seqlib/ssecho		\
	  seqlib/ssecho1	\
	  seqlib/tncosyps	\
	  seqlib/tndqcosy	\
	  seqlib/tnmqcosy	\
	  seqlib/tnnoesy	\
	  seqlib/tnroesy	\
	  seqlib/tntocsy	\
	  seqlib/tocsy		\
	  seqlib/wfgtest	\
	  seqlib/xnoesysync	\
	  seqlib/xpolar		\
	  seqlib/xpolar1"

Bin4Kermit2Tar="kermit/kermit_sun4"

# ------ SV Frame files  ---------------
#    frame_sv.tar
Bin4SVFrame2Tar="			\
		frame3/online_manual	\
		frame3/fontdir          \
		frame3/sv"

# ------ X Frame files  ---------------
# frame_xw.tar 
Bin4XFrame2Tar="			\
		frame/online_manual \
		frame/xw"

# ---- List of tar or ar images that go onto the Tape ------

TapeloadFileLst="			\
		VnmrS_5.1a	\
        	loadvnmr		\
        	installdecomp		\
        	finish_load		\
		common.toc		\
		sun4.toc		\
        	getchoices.sun4		\
		makevnmr1		\
		makevnmr2"

TapeComFileLst="			\
			com.tar.Z	\
			combin.tar	\
			fidlib.tar	\
			help.tar		\
			maclib.tar.Z	\
			manual.tar.Z	\
			menulib.tar	\
			par.tar.Z	\
			psg.tar.Z		\
			psglib.tar	\
			shapelib.tar	\
			tablib.tar	\
			pfg.tar		\
			image.tar	\
			kermit.tar	\
			userlib.tar"

TapeSun4FileLst="		\
		acqbin.tar 	\
		bin.tar 	\
		psg.tar 	\
		seqlib.tar 	\
		bins.tar 	\
		limnet.tar 	\
		frame_sv.tar.Z 	\
		pfg.tar 	\
		image.tar 	\
		kermit.tar"
Kernels2Move="			\
		sun4_4.1.1.tar	\
		sun4_4.1.2.tar	\
		sun4c_4.1.2.tar	\
		sun4c_4.1.3_U1.tar	\
		sun4c_ndma_4.1.3_U1.tar	\
		sun4m_4.1.3_U1.tar	\
		sun4c_4.1.4.tar	\
		sun4m_4.1.4.tar"

TapeSun4FileLst="$TapeSun4FileLst $Kernels2Move"

#-------------------------------------------------------
# ask what kind of system the tape drive is on

remotetape () {

    echo -n "Enter hostname of remote tape drive: "
    read REMOTE_HOST
    echo ""
    echo "Login name: $LOGNAME "
    echo -n "Checking access to host: "
    rsh $REMOTE_HOST "echo 0 > /dev/null"
    if [ "$?" -ne 0 ]
    then
      echo "$0 : Problem with reaching remote host $REMOTE_HOST"
      exit 1
    fi
    echo "OK."

    echo -n "SUNOS, SGI, IBM, SOLARIS system making tape? [SUNOS]: "
    read answer
    if [ x$answer = "x" ]
    then
      answer="SUNOS"
    fi
    case $answer in
    SUNOS)
 	tardev=/dev/nrst8
 	tardev1=/dev/nrst8
 	tardev2=/dev/nrst8
 	tardev3=/dev/nrst8
 	tardev4=/dev/nrst8
 	tardev5=/dev/nrst8
	mtopt="-f"
	;;
    SGI)
 	tardev=/dev/nrtapens
 	tardev1=/dev/nrtapens
 	tardev2=/dev/nrtapens
 	tardev3=/dev/nrtapens
 	tardev4=/dev/nrtapens
 	tardev5=/dev/nrtapens
	mtopt="-t"
	;;
	  
    SOLARIS)
 	tardev=/dev/rmt/0mbn
 	tardev1=/dev/rmt/0mbn
 	tardev2=/dev/rmt/0mbn
 	tardev3=/dev/rmt/0mbn
 	tardev4=/dev/rmt/0mbn
 	tardev5=/dev/rmt/0mbn
	mtopt="-f"
	;;

    IBM)
 	tardev=/dev/rmt0.1
 	tardev1=/dev/rmt0.1
 	tardev2=/dev/rmt0.1
 	tardev3=/dev/rmt0.1
 	tardev4=/dev/rmt0.1
 	tardev5=/dev/rmt0.1
	mtopt="-f"
	;;

    *)
	;;
   esac

}
#-------------------------------------------------------

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
   echo    " " | tee -a $logpath
   echo "Generating Tar Common files" | tee -a $logpath
   if test ! -d $1/com
   then
     mkdir $1/com
   else
     rm -rf $1/com	# remove all previous files
     mkdir $1/com
   fi
   if test ! -d $1/tmp
   then
     mkdir $1/tmp
   else
     rm -rf $1/tmp	# remove all previous files
     mkdir $1/tmp
   fi
   cd $commondir

#-- tar file in ComTarLst  into one tar file ---------
     echo "com.tar files:"
     echo "$ComTarLst"
     echo "com.tar " >> $logpath
     tar cf $1/com/com.tar $ComTarLst
     (cd $1/com; rm -f com.sizes; du -s com.tar > com.sizes ; compress com.tar; )
     echo " "

#-- tar the common bin scripts into bin tar file ---------
   echo -n "combin  "
   echo "combin.tar " >> $logpath
   tar cf $1/com/combin.tar $ComBinScripts2Tar
   ( cd $1/com; du -s combin.tar >> com.sizes; )


#-- Directories to create tar images for ---------
   tarfile="$ComDirs2Tar" 
   for file in $tarfile
   do
     echo -n "$file  "
     echo ${file}.tar >> $logpath
     tar cf $1/com/$file.tar $file
     ( cd $1/com; du -s $file.tar >> com.sizes; )
   done
   echo " "
   echo "psg.tar: psg psglib" 
   echo "psg.tar: psg psglib" >> $logpath
   (cd $commondir; cp -rp psg $1/tmp)
   cd $1/tmp
   chmod 755   ./psg
   chmod 644   ./psg/*
   tar cf $1/com/psg.tar psg
   rm -rf $1/tmp/*
   (cd $commondir; cp -rp psglib $1/tmp)
   chmod 755   ./psglib
   chmod 644   ./psglib/*
   tar cf $1/com/psglib.tar psglib
   rm -rf $1/tmp/*
   (cd $1/com; du -s psglib.tar >> com.sizes; )
   (cd $1/com; du -s psg.tar >> com.sizes; )
   (cd $1/com; compress maclib.tar; compress manual.tar;  compress psg.tar )

   cd $commondir/upar
#-- tar the par* files into one tar file ---------
   echo " "
   echo "par.tar: `echo $ComPar2Tar | tr -s '\011'`" 
   echo "par.tar: `echo $ComPar2Tar | tr -s '\011'`" >> $logpath
   cp -rp $ComPar2Tar $1/tmp
   cd $1/tmp
   chmod 644   ./par??0/stdpar/*/*
   chmod 755   ./par??0/stdpar/*
   chmod 644   ./par??0/tests/*/*
   chmod 755   ./par??0/tests/*
   chmod 644   ./parlib/*/*
   chmod 755   ./par???/*
   chmod 755   ./par???
   tar cf $1/com/par.tar $ComPar2Tar
   rm -rf $ComPar2Tar
   (cd $1/com; du -s par.tar >> com.sizes; compress par.tar; )
   cd $commondir

#--- tar the PFG common files maclib, manual, psglib
   echo " "
   echo -n "PFG: `echo $ComPFG2Tar | tr -s '\011'`"
   echo "pfg.tar: `echo $ComPFG2Tar | tr -s '\011'`" >> $logpath
   cd PFG
   tar cf $1/com/pfg.tar $ComPFG2Tar
   (cd $1/com; du -s pfg.tar >> com.sizes; )
   cd ..

#--- tar the Image common files maclib, manual, parlib imaging
   echo " "
   echo -n "Image: `echo $ComImage2Tar | tr -s '\011'`"
   echo "image.tar: `echo $ComImage2Tar | tr -s '\011'`" >> $logpath
   cd Image
   tar cf $1/com/image.tar $ComImage2Tar
   (cd $1/com; du -s image.tar >> com.sizes; )
   cd ..

#--- tar the kermit common files kermit.doc, kermit.nr kermit.ps 
   echo " "
   echo -n "Kermit: `echo $ComKermit2Tar | tr -s '\011'`"
   echo "kermit.tar: `echo $ComKermit2Tar | tr -s '\011'` " >> $logpath
   tar cf $1/com/kermit.tar $ComKermit2Tar
   (cd $1/com; du -s kermit.tar >> com.sizes; )
   echo " "

#-----   Now time for Object Files
   echo    " " | tee -a $logpath
   echo    " " | tee -a $logpath
   echo "Generating Tar Sun4 files" | tee -a $logpath
   if test ! -d $1/sun4
   then
     mkdir $1/sun4
   else
     rm -rf $1/sun4	# remove all previous files
     mkdir $1/sun4
   fi
   cd $sun4objdir
   echo -n "acqbin  "
   echo "acqbin.tar" >> $logpath
   tar -cf $1/sun4/acqbin.tar $BinAcq2Tar

   echo -n "bin  "
   echo "bin.tar" >> $logpath
   tar -cf $1/sun4/bin.tar $BinFiles2Tar

   echo -n "bins  "
   echo "bins.tar" >> $logpath
   tar -cf $1/sun4/bins.tar $BinSV2Tar

#  echo -n "binx  "
#  echo "binx.tar" >> $logpath
#  tar -cf $1/sun4/binx.tar $BinX2Tar

   echo -n "psg  "
   echo "psg.tar" >> $logpath
   tar -cf - $BinPsg2Tar | (cd $1/tmp; tar xfBp -)
   cd $1/tmp
   chmod 755   ./psg
   chmod 755   ./psg/*
   tar -cf $1/sun4/psg.tar psg
   rm -rf psg
   cd $sun4objdir

   echo "seqlib  "
   echo "seqlib.tar" >> $logpath
   tar -cf - $BinSeq2Tar | (cd $1/tmp; tar xfBp -)
   cd $1/tmp
   chmod 755   ./seqlib
   chmod 755   ./seqlib/*
   tar -cf $1/sun4/seqlib.tar seqlib
   rm -rf seqlib
   cd $sun4objdir

   echo "limnet  "
   echo "limnet.tar" >> $logpath
   tar -cf $1/sun4/limnet.tar limnet

#  echo "Glide "
#  echo "glide.tar" >> $logpath
#  tar -cf $1/sun4/glide.tar $BinGlide2Tar

   echo "PFG "
   echo "pfg.tar" >> $logpath
   tar -cf $1/sun4/pfg.tar $BinPFG2Tar
   echo "Image "
   echo "image.tar" >> $logpath
   tar -cf $1/sun4/image.tar $BinImage2Tar

   echo "kermit "
   echo "kermit.tar" >> $logpath
   cd $commondir
   tar -cf $1/sun4/kermit.tar $Bin4Kermit2Tar
   echo    " " | tee -a $logpath
   echo    " " | tee -a $logpath
   echo "Moving Kernel Tar files: FROM $sunkernels TO $1/sun4" | tee -a $logpath
   echo    " " | tee -a $logpath
   cd $sunkernels
   for file in $Kernels2Move
   do
     echo "$file"
     echo ${file} >> $logpath
     cp -p ${file} $1/sun4
   done
   cd $sun4objdir
   (cd $1/sun4; rm -f sun4.sizes; du -s *.tar > sun4.sizes; )
#  (cd $1/sun4; compress binx.tar; )

   echo    " " | tee -a $logpath
   echo    " " | tee -a $logpath
   echo "Generating Frame Tar files" | tee -a $logpath
   echo    " " | tee -a $logpath
   cd $commondir
   echo -n "sun4/sv "
   echo "sun4 frame_sv.tar" >> $logpath

   tar -cf $1/sun4/frame_sv.tar $Bin4SVFrame2Tar
   (cd $1/sun4; du -s frame_sv.tar >> sun4.sizes; )
   (cd $1/sun4; compress frame_sv.tar ; )
#  echo "sun4/ow "
#  echo "sun4 frame_xw.tar" >> $logpath

#  tar -cf $1/sun4/frame_xw.tar $Bin4XFrame2Tar
#  (cd $1/sun4; du -s frame_xw.tar >> sun4.sizes; )
#  (cd $1/sun4; compress frame_xw.tar ; )
#  rm -f  exclude.tmp

}

#-------------------------------------------------------
mktoc () {    # $1 is the passed directory
   echo    " " | tee -a $logpath
   echo "Generating Update TOC files" | tee -a $logpath
   echo    " " | tee -a $logpath
   cd $tmpdir
   if test ! -d $tmpdir/instal
   then
     mkdir $tmpdir/instal
   else
     rm -rf $tmpdir/instal	# remove all previous files
     mkdir $tmpdir/instal
   fi
   cd instal
   echo -n "common.toc "
   cp -p $sourcedir/sysscripts/common.toc common.toc
   Updatetoc common.toc ../com/com.sizes common.toc.awk
   rm -f common.toc
   mv common.toc.awk common.toc
   echo -n "sun4.toc  "
   cp -p $sourcedir/sysscripts/sun3.toc sun4.toc
   Updatetoc sun4.toc ../sun4/sun4.sizes sun4.toc.awk
   rm -f sun4.toc
   mv sun4.toc.awk sun4.toc
   cp -p $sun4objdir/proglib/bin/getchoices getchoices.sun4
   echo "vnmros=SunOS" > VnmrS_5.1a
   filelist="loadvnmr finish_load installdecomp makevnmr1 makevnmr2"
   for xfile in $filelist
   do
     cp -p $sourcedir/sysscripts/$xfile $xfile
   done
   echo " "
}


# ------------------ Start of Main  ---------------------------

name=`basename $0`
if ( test $name = "vnmr_tarout" )
then
 echo "Making VnmrS Tar Tape for SunView support"
 taropt=cvfb
 blksiz=2000
 tardev=/dev/nrst8
 tardev1=/dev/nrst8
 tardev2=/dev/nrst8
 tardev3=/dev/nrst8
 tardev4=/dev/nrst8
 tardev5=/dev/nrst8
 echo "Writing ISO Quality Record to: "
 echo "Directory: $logdirectory "
 echo " "
 echo -n "New Directory [$logdirectory]: "
 read tmpdir
 if [ x$tmpdir = "x" ]
 then
     tmpdir=$logdirectory
 fi
 logdirectory=$tmpdir
 echo " "
 echo "File Name: $lognam "
 echo -n "New File Name [$lognam]: "
 read tmpnam
 if [ x$tmpnam = "x" ]
 then
     tmpnam=$lognam
 fi
 lognam=$tmpnam
elif ( test $name = "vnmr_tarfile" )
then
 echo -n "Specify Directory to place Tar Files: "
 read tardir
 echo "You Selected Directory: $tardir"
 echo "Proceed ? (y or n) \c"
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
 echo "Making VnmrS Tar File \`$tardev' for SunView support"
else
  echo "Illegal Call Name: $name"
  exit 1
fi

logpath=$logdirectory/$lognam
echo " " | tee $logpath 
echo "================ $0 ==================== "  | tee -a $logpath 
echo " " | tee -a $logpath 
echo Date: `date` | tee -a $logpath 
echo " "  | tee -a $logpath
echo Host: `hostname`  Type: `uname -m`  | tee -a $logpath
echo " "  | tee -a $logpath


 echo    " " | tee -a $logpath
 echo "installation files from: $sourcedir/sysscripts" | tee -a $logpath
 echo "common files from: $commondir" | tee -a $logpath
 echo "sun4 files from: $sun4objdir" | tee -a $logpath
 echo "kernel files from: $sunkernels" | tee -a $logpath
 echo    " " | tee -a $logpath
 echo "PSG Shared Library Version: $psg_so_ver" | tee -a $logpath
 echo    " " | tee -a $logpath
 echo
 echo -n "The Above Correct? (y or n) [y]: " 
 read answer
 if [ x$answer = "x" ]
 then
   answer="y"
 fi
 if test ! x$answer = "xy"
 then
   echo "installation files from env sourcedir/syscripts: $sourcedir/sysscripts"
   echo "common files from env commondir: $commondir"
   echo "sun4 files from env sun4objdir: $sun4objdir"
   echo "kernel files from env sunkernels: $sunkernels"
   echo "PSG Shared Library Version from env psg_so_ver: $psg_so_ver"
   echo "Log directory from env logdir (default sourcedir/complogs): $logdir"
   echo "Tape directory from env tapedir (default /vtapes): $tapedir"
   echo "aborted."
   exit 1
 fi

 echo "Tape Format: Tar Files w/ Compression.{t}"

 tapetype="t"

   tmptape=$tapedir
   if [ x$tmptape = "x" ]
   then
     tmptape="/vtapes"
   fi
   echo -n "Specify Directory to place Tar Files [$tmptape/sunS]: "
   read tmpdir
   if [ x$tmpdir = "x" ]
   then
     tmpdir=$tmptape/sunS
   fi
   echo    " " | tee -a $logpath
   echo "You Selected Tape Format: $tapetype, And directory: $tmpdir"  | tee -a $logpath
   echo    " " | tee -a $logpath

    echo -n "Proceed with Compression(c) or Compression & Make tape(b)? (c,b, or n) [b]: "
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

  echo -n "Tape Local or Remote ? (l or r) [l]: " 
  read answer
  if [ x$answer = "x" ]
  then
    answer="l"
  fi
  if test "x$answer" = "xl"
  then
   REMOTE_HOST="local"
  elif test "x$answer" = "xr"
  then
    remotetape		# obtain remote tape info
  fi

#-------------------------------------------------------------------
#-------------------------------------------------------------------
# check to see if any files in com directory for common tar images
#-------------------------------------------------------------------
  if test -d $tmpdir/com
  then
    nfiles=`(cd $tmpdir/com; ls *.*ar* | wc -l)`
  else
    nfiles=0
  fi

#-------------------------------------------------------------------
# if there are files then print them and ask if they should be used
#-------------------------------------------------------------------
  if test $nfiles -gt 0
  then
   ls -ts $tmpdir/com/*.*ar* $tmpdir/sun4/*.*ar*
   echo -n "Use present tar & ar files in: $tmpdir  (y or n) [n]: "
   read answer
   if [ "x$answer" = "x" ]
   then
      answer="n"
   fi
  else
   answer="n"
  fi

#-------------------------------------------------------------
#  Create the tar files that will needed for the tape
#-------------------------------------------------------------
   if test ! "x$answer" = "xy"
   then
     mktarfiles $tmpdir
#-------------------------------------------------------------
#  Update the xxx.toc files with the proper sizes of the tar files 
#-------------------------------------------------------------
     mktoc $tmpdir
   else
     echo "Using Present Tar Files."
   fi


 if test "x$mktape" != "xy"
 then
   echo "No tape made, as requested."
   exit 0
 fi

#  Rewind the tape if taring to tape device

if [ x$REMOTE_HOST = "xlocal" ]
then
  mt $mtopt $tardev1 rewind
else
  rsh $REMOTE_HOST mt $mtopt $tardev1 rewind
fi

#  First file contains loading scripts

echo    " " | tee -a $logpath
echo    " " | tee -a $logpath
echo "Writing Load Files" | tee -a $logpath
cd $tmpdir/instal
if [ x$REMOTE_HOST = "xlocal" ]
then
  tar cvf $tardev1 $TapeloadFileLst
else
  rsh $REMOTE_HOST "(cd $tmpdir/instal; tar cvf $tardev1 $TapeloadFileLst)"
fi
tar cvf /dev/null $TapeloadFileLst >> $logpath




#  Second file contains stuff common to both systems  /common

echo    " " | tee -a $logpath
echo    " " | tee -a $logpath
echo "Writing Common Files" | tee -a $logpath
cd $tmpdir/com
if [ x$REMOTE_HOST = "xlocal" ]
then
  tar $taropt $tardev2 $blksiz $TapeComFileLst
else
  rsh $REMOTE_HOST "(cd $tmpdir/com; tar $taropt $tardev2 $blksiz $TapeComFileLst)"
fi
tar $taropt /dev/null $blksiz $TapeComFileLst >> $logpath

#  Fourth file contains SUN-4 stuff

echo    " " | tee -a $logpath
echo    " " | tee -a $logpath
echo "Writing Sun4 Files" | tee -a $logpath

cd $tmpdir/sun4
if [ x$REMOTE_HOST = "xlocal" ]
then
  tar $taropt $tardev4 $blksiz $TapeSun4FileLst
else
  rsh $REMOTE_HOST "(cd $tmpdir/sun4; tar $taropt $tardev4 $blksiz $TapeSun4FileLst)"
fi
tar $taropt /dev/null $blksiz $TapeSun4FileLst >> $logpath

#  Finish by rewinding the tape

if [ x$REMOTE_HOST = "xlocal" ]
then
  mt $mtopt $tardev1 rewind
else
  rsh $REMOTE_HOST mt $mtopt $tardev1 rewind
fi

echo "VnmrS tape complete" | tee -a $logpath
exit 0
