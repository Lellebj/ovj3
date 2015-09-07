: /bin/sh
# '@(#)sol_tarout.sh 22.1 03/24/08 1991-1996 '
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
lognam=VnmrXsol_tarlog`uname -m`
logdirectory=$logdir
if [ x$logdirectory = "x" ]
then
   logdirectory=$sourcedir/complogs
fi

# shared library version number
so_ver=$psg_so_ver

# ---- List of files that go into the various tar or ar images ------

# -- acquisition common files tarred into one tar file.
#  list of file in  acq.tar 
AcqTarLst="			\
	bin/makesuacqproc	\
	bin/execkillacqproc	\
	rc.vnmr			\
	acqqueue/acqinfo	\
	acq/xrxrh.out		\
	acq/xrxrh_img.out	\
	acq/xrxrp.out		\
	acq/xrxrp_img.out	\
	acq/xrop.out		\
	acq/rhmon.out		\
	acq/autshm.out		\
	acq/autshm_img.out	\
	acq/xr.conf"

# -- Gemini acquisition common files tarred into one tar file.
#  list of file in  gacq.tar 
gAcqTarLst="			\
	bin/makesuacqproc	\
	bin/execkillacqproc	\
	rc.vnmr			\
	acqqueue/acqinfo	\
	acq/apmon		\
	acq/autshm		\
	acq/lnc"

# -- misc common files tarred into one tar file.
#  COM.TAR list of file in  com.tar 
ComTarLst="			\
	bootup_message		\
	acq/acqi*		\
	conpar			\
	devicenames		\
	devicetable		\
	asm			\
	nuctables		\
	shimmethods		\
	shims			\
	solvents		\
	-C tape_sol user_templates	\
	xvfonts			\
	fonts			\
	vnmrmenu		\
	varian.xicon"

# -- common bin script files to include on tape  
# --    remember bin is ar so name must 15 chars or less
# COMBIN.TAR List of file in combin.tar 
ComBinScripts2Tar="		\
	bin/adddevices		\
	bin/readbrutape		\
	bin/wtgen		\
	bin/psggen		\
	bin/seqgen		\
	bin/killft3d		\
	bin/killstat		\
	bin/Vn			\
	bin/makeuser		\
	bin/setether		\
	bin/setnoether		\
	bin/setuserpsg		\
	bin/setgem		\
	bin/setuni		\
	bin/getoptions		\
	bin/updateuser		\
	bin/vbg			\
	bin/vxrTool		\
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
	
gComPar2Tar="		\
		gpar/par200	\
		gpar/par300	\
		gpar/par400	\
		gpar/parlib"

uComPar2Tar="		\
		upar/par200	\
		upar/par300	\
		upar/par400	\
		upar/par500	\
		upar/par600	\
		upar/par750	\
		upar/parlib"

#--- directories from PFG common to go into tar file
# pfg.tar
ComPFG2Tar="			\
	parlib			\
	maclib			\
	manual			\
	psglib"

#--- directories from Image common to go into tar file
# uimage.tar
ComImage2Tar="			\
	imaging			\
	parlib			\
	maclib			\
	manual			\
	psglib"			\

#--- directories from IMAGE common to go into tar file
# image.tar
ComIMAGE2Tar="			\
	bin/browser		\
	bin/setimg		\
	help			\
	imaging			\
	parlib			\
	maclib			\
	menulib			\
	nuctables		\
	psglib			\
	vnmrmenu		\
	-C tape_sol user_templates"

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
        acqbin/seqgenmake	\
        bin/iadisplay		\
        bin/vconfig"

# -- files to include in gemini acqbin tar file
# --- gacqbin.tar 
gBinAcq2Tar="acqbin/gAcqproc	\
        acqbin/acqinfo_svc      \
        acqbin/Autoproc         \
        acqbin/send2Vnmr        \
        acqbin/startacqproc     \
        acqbin/killacqproc      \
        acqbin/seqgenmake	\
        bin/catcheaddr		\
        bin/giadisplay		\
        bin/gconfig"

# -- binary common to SunView & X-window to include in bin.tar file 
# --- bin.tar 
BinFiles2Tar="bin/compressfid   \
        bin/convertbru          \
        bin/cpos_cvt            \
        bin/decomp              \
	bin/diffshims		\
        bin/eatchar             \
        bin/expfit              \
	bin/fitspec		\
	bin/ft3d		\
        bin/gin_setup           \
	bin/getplane		\
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

#  removed from above list
#	bin/editdevices	
#	bin/portrait
#	bin/psfilter

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
BinX2Tar="bin/Vnmr           \
	bin/pulsetool		\
	bin/pulsechild		\
	bin/status		\
	bin/enter		\
	bin/Acqstat"

# -- Shared libraries used by the Pulse Sequencies 
# --- psg.tar 
BinPsg2Tar="psg/libpsglib.a       \
        psg/libparam.a          \
	psg/libpsglib.so.$so_ver \
	psg/libparam.so.$so_ver	\
        psg/libparam.so         \
        psg/libpsglib.so        \
        psg/x_ps.o"

# -- Shared libraries used by the Pulse Sequencies 
# --- gpsg.tar 
gBinPsg2Tar="gpsg/libpsglib.a       \
        gpsg/libparam.a          \
	gpsg/libpsglib.so.$so_ver \
	gpsg/libparam.so.$so_ver	\
        gpsg/libparam.so         \
        gpsg/libpsglib.so        \
        gpsg/x_ps.o"

# -- Glide files to tar
# --- glide.tar 
BinGlide2Tar="bin/gadm       \
	bin/glide		\
	-C $commondir glide/vnmrmenu	\
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
# --- uimage.tar 
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


#---- IMAGE binaries to tar
# --- image.tar 
BinIMAGE2Tar="bin/autoshim	\
	bin/cptoconpar		\
	bin/convert		\
	bin/fdfgluer		\
	bin/fdfsplit		\
	bin/ib_ui		\
	bin/ib_graphics		\
	bin/imcalc		\
	bin/imfit		\
	bin/log_mag		\
	bin/plane_decode	\
	bin/tabc		\
	bin/conv1phf		\
	bin/conv2phf		\
	bin/conv2ta		\
	bin/conv3d		\
	bin/imfft3d		\
	bin/disp3d		\
	seqlib/flash		\
	seqlib/flash3d		\
	seqlib/isis		\
	seqlib/mems		\
	seqlib/sediff		\
	seqlib/sems		\
	seqlib/steam"


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

#---- Standard seqlib binaries to tar
# --- seqlib.tar
gBinSeq2Tar="gseqlib/apt         \
          gseqlib/cpmgt2        \
          gseqlib/cosyps        \
          gseqlib/d2pul         \
          gseqlib/dept          \
          gseqlib/dqcosy        \
          gseqlib/het2dj        \
          gseqlib/hetcor        \
          gseqlib/hmqcr          \
          gseqlib/hom2dj        \
          gseqlib/noedif        \
          gseqlib/noesy         \
          gseqlib/ppcal         \
          gseqlib/relayh        \
          gseqlib/s2pul"

Bin4Kermit2Tar="kermit/kermit_sol"

# ------ SV Frame files  ---------------
#    frame_sv.tar
Bin4SVFrame2Tar="			\
		frame/online_manual_sv \
		frame/fontdir          \
		frame/sv"

# ------ X Frame files  ---------------
# frame_xw.tar 
Bin4XFrame2Tar="			\
		frame/online_manual \
		frame/sol"

# ------ GNU C Compiler Files files  ---------------
# gnu.tar 
GNU4Solaris2Tar="                       \
                gnu/cygnus-sol2-2.0"
 
#----- kernels to move int /vtape/kernels  
Kernels2Move="sh		\
		sh.conf"

# ---- List of tar or ar images that go onto the Tape ------

TapeloadFileLst="			\
		VnmrSOL_5.1a	\
        	loadvnmr		\
        	installdecomp		\
        	finish_load		\
		common.toc		\
		sol.toc		\
		gemcommon.toc		\
		gem.toc		\
        	getchoices.sol		\
		makevnmr1		\
		makevnmr2"

TapeComFileLst="			\
			acq.tar.Z	\
			psg.tar.Z		\
			psglib.tar	\
			par.tar.Z	\
			tablib.tar	\
			gacq.tar.Z	\
			gpsg.tar.Z		\
			gpsglib.tar	\
			gpar.tar.Z	\
			com.tar.Z	\
			combin.tar	\
			fidlib.tar	\
			help.tar		\
			maclib.tar.Z	\
			manual.tar.Z	\
			menulib.tar	\
			shapelib.tar	\
			pfg.tar		\
			uimage.tar	\
			image.tar	\
			kermit.tar	\
			userlib.tar"

TapeSun4FileLst="		\
		acqbin.tar 	\
		psg.tar 	\
		seqlib.tar.Z 	\
		gacqbin.tar 	\
		gpsg.tar 	\
		gseqlib.tar.Z 	\
		bin.tar 	\
		binx.tar.Z 	\
		glide.tar 	\
		limnet.tar 	\
		frame_xw.tar.Z 	\
		pfg.tar 	\
		uimage.tar 	\
		image.tar 	\
		kermit.tar	\
                gnu.tar.Z	\
                kernel.tar"

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

#-- tar the common acq scripts into bin tar file ---------
   echo -n "acq  "
   echo "acq.tar " >> $logpath
   tar cf $1/com/acq.tar $AcqTarLst
   ( cd $1/com; du -s acq.tar >> com.sizes; )

#-- tar the gemini acq scripts into bin tar file ---------
   echo -n "gacq  "
   echo "gacq.tar " >> $logpath
   tar cf $1/com/gacq.tar $gAcqTarLst
   ( cd $1/com; du -s gacq.tar >> com.sizes; )

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
   mkdir $1/tmp/upsg
   (cd $commondir; cp -rp psg $1/tmp/upsg)
   cd $1/tmp
   chmod 755   ./upsg
   chmod 755   ./upsg/psg
   chmod 644   ./upsg/psg/*
   ln -s upsg/psg .
   tar cf $1/com/psg.tar *
   (cd $1/com; du -s psg.tar >> com.sizes; )
   rm -rf $1/tmp/*
   mkdir $1/tmp/upsg
   (cd $commondir; cp -rp psglib $1/tmp/upsg)
   chmod 755   ./upsg
   chmod 755   ./upsg/psglib
   chmod 644   ./upsg/psglib/*
   ln -s upsg/psglib .
   tar cf $1/com/psglib.tar *
   (cd $1/com; du -s psglib.tar >> com.sizes; )
   rm -rf $1/tmp/*

   echo "gpsg.tar: psg psglib" 
   echo "gpsg.tar: psg psglib" >> $logpath
   mkdir $1/tmp/gpsg
   (cd $commondir; cp -rp gpsg $1/tmp/gpsg/psg)
   chmod 755   ./gpsg
   chmod 755   ./gpsg/psg
   chmod 644   ./gpsg/psg/*
   ln -s gpsg/psg .
   tar cf $1/com/gpsg.tar *
   (cd $1/com; du -s gpsg.tar >> com.sizes; )
   rm -rf $1/tmp/*
   mkdir $1/tmp/gpsg
   (cd $commondir; cp -rp gpsglib $1/tmp/gpsg/psglib)
   chmod 755   ./gpsg
   chmod 755   ./gpsg/psglib
   chmod 644   ./gpsg/psglib/*
   ln -s gpsg/psglib .
   tar cf $1/com/gpsglib.tar *
   (cd $1/com; du -s gpsglib.tar >> com.sizes; )
   rm -rf $1/tmp/*

   (cd $1/com; compress maclib.tar; compress manual.tar;  compress psg.tar; \
               compress gpsg.tar; compress acq.tar; compress gacq.tar )

#-- tar the par* files into one tar file ---------
   echo " "
   echo "par.tar: `echo $uComPar2Tar | tr -s '\011'`" 
   echo "par.tar: `echo $uComPar2Tar | tr -s '\011'`" >> $logpath
   mkdir $1/tmp/upar
   cd $commondir
   cp -rp $uComPar2Tar $1/tmp/upar
   cd $1/tmp
   chmod 755   ./upar
   chmod 644   ./upar/par??0/stdpar/*/*
   chmod 755   ./upar/par??0/stdpar/*
   chmod 644   ./upar/par??0/tests/*/*
   chmod 755   ./upar/par??0/tests/*
   chmod 644   ./upar/parlib/*/*
   chmod 755   ./upar/par???/*
   chmod 755   ./upar/par???
   ln -s upar/par??? .
   tar cf $1/com/par.tar *
   rm -rf $1/tmp/*
   (cd $1/com; du -s par.tar >> com.sizes; compress par.tar; )
   cd $commondir

#-- tar the gpar* files into one tar file ---------
   echo " "
   echo "gpar.tar: `echo $gComPar2Tar | tr -s '\011'`" 
   echo "gpar.tar: `echo $gComPar2Tar | tr -s '\011'`" >> $logpath
   mkdir $1/tmp/gpar
   cp -rp $gComPar2Tar $1/tmp/gpar
   cd $1/tmp
   chmod 755   ./gpar
   chmod 644   ./gpar/par??0/stdpar/*/*
   chmod 755   ./gpar/par??0/stdpar/*
   chmod 644   ./gpar/par??0/tests/*/*
   chmod 755   ./gpar/par??0/tests/*
   chmod 644   ./gpar/parlib/*/*
   chmod 755   ./gpar/par???/*
   chmod 755   ./gpar/par???
   ln -s gpar/par??? .
   tar cf $1/com/gpar.tar *
   rm -rf $1/tmp/*
   (cd $1/com; du -s gpar.tar >> com.sizes; compress gpar.tar; )
   cd $commondir

#--- tar the PFG common files maclib, manual, psglib
   echo " "
   echo -n "PFG: `echo $ComPFG2Tar | tr -s '\011'`"
   echo "pfg.tar: `echo $ComPFG2Tar | tr -s '\011'`" >> $logpath
   cd PFG
   tar -cf - $ComPFG2Tar | (cd $1/tmp; tar xfBp -)
   cd $1/tmp
   mkdir upar
   mv parlib upar
   chmod 755   ./upar
   chmod 755   ./upar/parlib
   chmod 755   ./upar/parlib/*
   chmod 644   ./upar/parlib/*/*
   tar -cf $1/com/pfg.tar *
   rm -rf *
   (cd $1/com; du -s pfg.tar >> com.sizes; )
   cd $commondir

#--- tar the micro Image common files maclib, manual, parlib imaging
   echo " "
   echo -n "uImage: `echo $ComImage2Tar | tr -s '\011'`"
   echo "uimage.tar: `echo $ComImage2Tar | tr -s '\011'`" >> $logpath
   cd Image
   tar -cf - $ComImage2Tar | (cd $1/tmp; tar xfBp -)
   cd $1/tmp
   mkdir upar
   mv parlib upar
   chmod 755   ./upar
   chmod 755   ./upar/parlib
   chmod 755   ./upar/parlib/*
   chmod 644   ./upar/parlib/*/*
   tar -cf $1/com/uimage.tar *
   rm -rf *
   (cd $1/com; du -s uimage.tar >> com.sizes; )
   cd $commondir

#--- tar the IMAGE common files maclib, manual, parlib imaging
   echo " "
   echo -n "IMAGE: `echo $ComIMAGE2Tar | tr -s '\011'`"
   echo "image.tar: `echo $ComIMAGE2Tar | tr -s '\011'`" >> $logpath
   cd IMAGE
   tar -cf - $ComIMAGE2Tar | (cd $1/tmp; tar xfBp -)
   cd $1/tmp
   mkdir upar
   mv parlib upar
   chmod 755   ./upar
   chmod 755   ./upar/parlib
   chmod 755   ./upar/parlib/*
   chmod 644   ./upar/parlib/*/*
   tar -cf $1/com/image.tar *
   rm -rf *
   (cd $1/com; du -s image.tar >> com.sizes; )
   cd $commondir

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
   echo "Generating Tar Solaris files" | tee -a $logpath
   if test ! -d $1/sun4
   then
     mkdir $1/sun4
   else
     rm -rf $1/sun4	# remove all previous files
     mkdir $1/sun4
   fi
   cd $solobjdir

   echo -n "acqbin  "
   echo "acqbin.tar" >> $logpath
   mkdir $1/tmp/acqbin
   mkdir $1/tmp/bin
   cp -rp $BinAcq2Tar $1/tmp/acqbin
   cp -p $commondir/bin/usetacq $1/tmp/bin
   cd $1/tmp
   mv ./acqbin/iadisplay ./bin/uiadisplay
   mv ./acqbin/vconfig ./bin/uconfig
   mv ./acqbin/Acqproc ./acqbin/uAcqproc
   cd bin
   ln -s uiadisplay iadisplay
   ln -s uconfig vconfig
   ln -s usetacq setacq
   cd ../acqbin
   ln -s uAcqproc Acqproc
   cd ..
   tar -cf $1/sun4/acqbin.tar *
   rm -rf bin acqbin

   cd $solobjdir
   echo -n "gacqbin  "
   echo "gacqbin.tar" >> $logpath
   mkdir $1/tmp/acqbin
   mkdir $1/tmp/bin
   cp -rp $gBinAcq2Tar $1/tmp/acqbin
   cp -p $commondir/bin/gsetacq $1/tmp/bin
   cd $1/tmp
   mv ./acqbin/catcheaddr ./bin/catcheaddr
   mv ./acqbin/giadisplay ./bin/giadisplay
   mv ./acqbin/gconfig ./bin/gconfig
   cd bin
   ln -s giadisplay iadisplay
   ln -s gconfig vconfig
   ln -s gsetacq setacq
   cd ../acqbin
   ln -s gAcqproc Acqproc
   cd ..
   tar -cf $1/sun4/gacqbin.tar *
   rm -rf bin acqbin

   cd $solobjdir
   echo -n "bin  "
   echo "bin.tar" >> $logpath
   tar -cf $1/sun4/bin.tar $BinFiles2Tar

#  echo -n "bins  "
#  echo "bins.tar" >> $logpath
#  tar -cf $1/sun4/bins.tar $BinSV2Tar

   echo -n "binx  "
   echo "binx.tar" >> $logpath
   tar -cf $1/sun4/binx.tar $BinX2Tar

   echo -n "psg  "
   echo "psg.tar" >> $logpath
   tar -cf - $BinPsg2Tar | (cd $1/tmp; tar xfBp -)
   cd $1/tmp
   mkdir upsg
   mv psg upsg
   chmod 755   ./upsg
   chmod 755   ./upsg/psg
   chmod 755   ./upsg/psg/*
   tar -cf $1/sun4/psg.tar upsg
   rm -rf upsg
   cd $solobjdir

   echo "seqlib  "
   echo "seqlib.tar" >> $logpath
   tar -cf - $BinSeq2Tar | (cd $1/tmp; tar xfBp -)
   cd $1/tmp
   mkdir upsg
   mv seqlib upsg
   chmod 755   ./upsg
   chmod 755   ./upsg/seqlib
   chmod 755   ./upsg/seqlib/*
   ln -s upsg/seqlib .
   tar -cf $1/sun4/seqlib.tar *
   rm -rf upsg seqlib
   cd $solobjdir

   echo -n "gpsg  "
   echo "gpsg.tar" >> $logpath
   tar -cf - $gBinPsg2Tar | (cd $1/tmp; tar xfBp -)
   cd $1/tmp
   mv gpsg psg
   mkdir gpsg
   mv psg gpsg
   chmod 755   ./gpsg
   chmod 755   ./gpsg/psg
   chmod 755   ./gpsg/psg/*
   tar -cf $1/sun4/gpsg.tar gpsg
   rm -rf gpsg
   cd $solobjdir

   echo "gseqlib  "
   echo "gseqlib.tar" >> $logpath
   tar -cf - $gBinSeq2Tar | (cd $1/tmp; tar xfBp -)
   cd $1/tmp
   mkdir gpsg
   mv gseqlib gpsg/seqlib
   chmod 755   ./gpsg
   chmod 755   ./gpsg/seqlib
   chmod 755   ./gpsg/seqlib/*
   ln -s gpsg/seqlib .
   tar -cf $1/sun4/gseqlib.tar *
   rm -rf gpsg seqlib
   cd $solobjdir

   echo "limnet  "
   echo "limnet.tar" >> $logpath
   tar -cf $1/sun4/limnet.tar limnet

   echo "Glide "
   echo "glide.tar" >> $logpath
   tar -cf $1/sun4/glide.tar $BinGlide2Tar

   echo "PFG "
   echo "pfg.tar" >> $logpath
   tar -cf - $BinPFG2Tar | (cd $1/tmp; tar xfBp -)
   cd $1/tmp
   mkdir upsg
   mv seqlib upsg
   chmod 755   ./upsg
   chmod 755   ./upsg/seqlib
   chmod 755   ./upsg/seqlib/*
   tar -cf $1/sun4/pfg.tar *
   rm -rf *
   cd $solobjdir

   echo "microImage "
   echo "uimage.tar" >> $logpath
   tar -cf - $BinImage2Tar | (cd $1/tmp; tar xfBp -)
   cd $1/tmp
   mkdir upsg
   mv seqlib upsg
   chmod 755   ./upsg
   chmod 755   ./upsg/seqlib
   chmod 755   ./upsg/seqlib/*
   tar -cf $1/sun4/uimage.tar *
   rm -rf *
   cd $solobjdir

   echo "IMAGE "
   echo "image.tar" >> $logpath
   tar -cf - $BinIMAGE2Tar | (cd $1/tmp; tar xfBp -)
   cd $1/tmp
   mkdir upsg
   mv seqlib upsg
   chmod 755   ./upsg
   chmod 755   ./upsg/seqlib
   chmod 755   ./upsg/seqlib/*
   tar -cf $1/sun4/image.tar *
   rm -rf *
   cd $solobjdir

   echo "kermit "
   echo "kermit.tar" >> $logpath
   cd $commondir
   tar -cf $1/sun4/kermit.tar $Bin4Kermit2Tar

   echo "GNU "
   echo "gnu.tar" >> $logpath
   cd /swamp
   tar -cf $1/sun4/gnu.tar $GNU4Solaris2Tar
 
   cd $solobjdir/proglib/kernel_solaris
   echo "Getting Kernel files from $solobjdir/proglib/kernel_solaris" | tee -a $logpath
   echo "kernel "
   echo "kernel.tar" >> $logpath
   mkdir $1/tmp/solkernel
   cp -rp $Kernels2Move $1/tmp/solkernel
   cd $1/tmp
   tar -cf $1/sun4/kernel.tar solkernel
   rm -rf solkernel

   (cd $1/sun4; rm -f sun4.sizes; du -s *.tar > sun4.sizes; )
   (cd $1/sun4; compress binx.tar; compress seqlib.tar; compress gnu.tar; \
                compress gseqlib.tar )

   echo    " " | tee -a $logpath
   echo    " " | tee -a $logpath
   echo "Generating Frame Tar files" | tee -a $logpath
   echo    " " | tee -a $logpath
   cd $commondir
#  echo -n "sun4/sv "
#  echo "sun4 frame_sv.tar" >> $logpath

#  tar -cf $1/sun4/frame_sv.tar $Bin4SVFrame2Tar
#  (cd $1/sun4; du -s frame_sv.tar >> sun4.sizes; )
#  (cd $1/sun4; compress frame_sv.tar ; )
   echo "sun4/ow "
   echo "sun4 frame_xw.tar" >> $logpath

   tar -cf $1/sun4/frame_xw.tar $Bin4XFrame2Tar
   (cd $1/sun4; du -s frame_xw.tar >> sun4.sizes; )
   (cd $1/sun4; compress frame_xw.tar ; )
   rm -f  exclude.tmp

   echo    " " | tee -a $logpath
   echo    " " | tee -a $logpath
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
   cp -p $sourcedir/sysscripts/solcommon.toc common.toc
   Updatetoc common.toc ../com/com.sizes common.toc.awk
   rm -f common.toc
   mv common.toc.awk common.toc
   echo -n "gemcommon.toc "
   cp -p $sourcedir/sysscripts/gemcommon.toc gemcommon.toc
   Updatetoc gemcommon.toc ../com/com.sizes gemcommon.toc.awk
   rm -f gemcommon.toc
   mv gemcommon.toc.awk gemcommon.toc
   echo -n "sol.toc  "
   cp -p $sourcedir/sysscripts/sol.toc sol.toc
   Updatetoc sol.toc ../sun4/sun4.sizes sol.toc.awk
   rm -f sol.toc
   mv sol.toc.awk sol.toc
   echo -n "gem.toc  "
   cp -p $sourcedir/sysscripts/gem.toc gem.toc
   Updatetoc gem.toc ../sun4/sun4.sizes gem.toc.awk
   rm -f gem.toc
   mv gem.toc.awk gem.toc
   cp -p $solobjdir/proglib/bin/getchoices getchoices.sol
   echo "vnmros=SOLARIS" > VnmrSOL_5.1a
   filelist="loadvnmr finish_load installdecomp makevnmr1 makevnmr2"
   for xfile in $filelist
   do
     cp -p $sourcedir/sysscripts/$xfile $xfile
   done
   echo " "
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

name=`basename $0`
if ( test $name = "sol_tarout" )
then
 echo "Making VnmrX Tar Tape for X-Window support on Solaris"
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
elif ( test $name = "sol_tarfile" )
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
 echo "Making VnmrX Tar File \`$tardev' for X-window support on Solaris"
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
 echo "solaris files from: $solobjdir" | tee -a $logpath
 echo "kernel files from: $solobjdir/proglib/kernel_solaris" | tee -a $logpath
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
   echo "solaris files from env solobjdir: $solobjdir"
   echo "kernel files from env solobjdir/proglib/kernel_solaris: $solobjdir/proglib/kernel_solaris"
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
   echo -n "Specify Directory to place Tar Files [$tmptape/sol]: "
   read tmpdir
   if [ x$tmpdir = "x" ]
   then
     tmpdir=$tmptape/sol
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
   ls -ts $tmpdir/instal $tmpdir/com/*.*ar* $tmpdir/sun4/*.*ar*
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

#  Third file contains SUN-4 Solaris stuff

echo    " " | tee -a $logpath
echo    " " | tee -a $logpath
echo "Writing Solaris Files" | tee -a $logpath

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

echo "VnmrSOL tape complete" | tee -a $logpath
exit 0
