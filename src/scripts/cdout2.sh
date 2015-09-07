: '@(#)cdout2.sh 22.1 03/24/08 1991-1994 '
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
: '@(#)cdout.sh 13.1 10/10/97 1991-1997 .'
: /bin/sh
#scripts to make a directory with all the data needed for Nessie
#
# Default Declarations
#
Code="code"
Install_dir="/usr24/frits/nessie/bin"
RevFileName="vnmr6.1"
#
#DefaultDestDir="/export/home/frits/cdout/cdimage2"
#DefaultFiniDir=`date '+/rdvnmr/cdmerc%m.%d'`
#DefaultLogFln="/export/home/frits/cdout/cdoutlog2"
DefaultDestDir="/export/t2/vnmrcd/cdimage2"
DefaultFiniDir=`date '+/rdvnmr/.cdrom%m.%d'`
DefaultLogFln="/export/t2/vnmrcd/cdoutlog2"
Mercury="mercvx"
Glide="glide"
#
# Library .so. version definitions
ACQCOMM_VER="2.0"
ACQCOMM_VER6="6.0"
NCOMM_VER=$psg_so_ver

#
# files needed for loading from cd
#
#
# subdirectories in destination directory
# VNMR:    aix, gemini, ibm, inova, unity files are unique to that system
#          common files are common to all systems (some do not apply to G2000)
#	   solaris files are common to gemini, inova, unity
#          unity/inova files are common to both inova, unity
#          unity/gemini files are common to both unity, gemini
# options: common files are in the top level
#          aix, gemini, ibm, files are unique to that system
#          solaris files are common to gemini, inova, unity
#	   unity files are for unity and/or inova
#
SubDirs="				\
		acrobat/online		\
		glide			\
                mercvx			\
		sol			\
		tmp			\
		"
RmSubDirs="				\
		tmp			\
		"
RmOptFiles="				\
		sol/mercvx.sol		\
		sol/mercvx.opt		\
		"
#
# PART I ---- Common File Definitions
BinX2Tar="			\
	Vnmr		\
	"

ComDirs2Tar="			\
	manual/glrinept		\
	Gmap/maclib		\
	"

UniBinScripts2Tar="		\
	bin/patchinstall	\
	bin/rmipcs		\
	bin/vnmr		\
	"

kBinPsg2Tar="kpsg/libpsglib.a		\
        kpsg/libparam.a			\
	kpsg/libpsglib.so.$psg_so_ver	\
	kpsg/libparam.so.$psg_so_ver	\
	kpsg/libpsglib.so		\
	kpsg/libparam.so		\
        kpsg/x_ps.o			\
        bin/kconfig			\
	-C $commondir/tape_sol app-defaults/Config	\
	bin/dps_ps_gen			\
	"

kBinSeq2Tar="		\
	kseqlib/APT	\
	kseqlib/COSY	\
	kseqlib/DEPT	\
	kseqlib/DQCOSY	\
	kseqlib/HETCOR	\
	kseqlib/HMBC	\
	kseqlib/HMQC	\
	kseqlib/HMQCTOXY	\
	kseqlib/HOMODEC	\
	kseqlib/HSQC	\
	kseqlib/HSQCTOXY	\
	kseqlib/NOESY	\
	kseqlib/NOESY1D	\
	kseqlib/PRESAT	\
	kseqlib/PWXCAL	\
	kseqlib/ROESY	\
	kseqlib/TOCSY	\
	kseqlib/TOCSY1D	\
	kseqlib/apt	\
	kseqlib/cosyps	\
	kseqlib/cpmgt2	\
	kseqlib/dept	\
	kseqlib/dqcosy	\
	kseqlib/gmapz	\
	kseqlib/noesy	\
	kseqlib/het2dj	\
	kseqlib/hetcor	\
	kseqlib/hmqc	\
	kseqlib/hom2dj	\
	kseqlib/inadqt	\
	kseqlib/inept	\
	kseqlib/noedif	\
	kseqlib/noesy	\
	kseqlib/ppcal	\
	kseqlib/relayh	\
	kseqlib/qtune	\
	kseqlib/roesy	\
	kseqlib/s2pul	\
	kseqlib/s2pulq	\
	kseqlib/tocsy	\
	"

iProcFam="			\
	acqbin/nAutoproc	\
	acqbin/Expproc		\
	acqbin/Infoproc		\
	acqbin/Procproc		\
	acqbin/Recvproc		\
	acqbin/Roboproc		\
	acqbin/Sendproc		\
	acqbin/bootpd		\
	acq/bootptab		\
	acq/vwScript		\
        bin/iiadisplay		\
	bin/autoshim		\
	bin/findedevices	\
	bin/send2Vnmr		\
	-C $commondir/tape_sol app-defaults/Acqi	\
	"

iLibs2Tar="				\
	ncomm/libacqcomm.a		\
	ncomm/libacqcomm.so		\
	ncomm/libacqcomm.so.$ACQCOMM_VER6	\
	ncomm/libncomm.a			\
	ncomm/libncomm.so			\
	ncomm/libncomm.so.$NCOMM_VER	\
	"


kVx2Tar="				\
	acq/vxBoot/vxWorks		\
	acq/vxBoot/vxWorks.sym		\
        acq/kvxBoot.small/vxWorks	\
	"

kVxObj2Tar="			\
	acq/kvwacq.o		\
	acq/kvwhdobj.o		\
	acq/kvwlibs.o		\
	acq/kvwtasks.o		\
	acq/vwcom.o		\
	"

Tcl2Tar="			\
	tcl/bin			\
	-C $commondir/tape_sol app-defaults/Dg	\
	"

TclMore="			\
	vnmrwish		\
	"

#
# PART II --- Options 
#
#---- PFG binaries to tar
kBinPFG2Tar="			\
	kseqlib/gCOSY		\
	kseqlib/gDQCOSY		\
	kseqlib/gHMBC		\
	kseqlib/gHMQC		\
	kseqlib/gHMQCTOXY	\
	kseqlib/gHSQC		\
	kseqlib/gHSQCTOXY	\
	kseqlib/gXHCAL		\
	kseqlib/g2pul		\
	kseqlib/gcosy		\
	kseqlib/ghmqc		\
	kseqlib/glrinept	\
	kseqlib/gmqcosy		\
	kseqlib/gnoesy		\
	kseqlib/profile		\
	"

kComPFG2Tar="                   \
        maclib                  \
        "


#
# -- Glide files to tar
GlideText2Tar="                 \
        glidepack/vnmrmenu          \
        glidepack/adm               \
        glidepack/def               \
        glidepack/exp               \
        glidepack/templates         \
	dialoglib		\
	maclib			\
	menulib			\
	manual			\
	probes			\
	tape_sol2/user_templates/dg	\
        "

# --- glide.tar
GlideBin2Tar="
	bin/glide		\
        bin/gadm                \
	bin/Probe_edit		\
        "
GlidePars2Tar="			\
	gpar/par200		\
	gpar/par300		\
	gpar/par400		\
	gpar/parlib		\
	"
UserLib2Tar="                   \
        userlib                 \
        "

#
# PART III --- Patch  files
#
PatchList="			\
	6.1AbinSOLall101.Readme	\
	6.1AbinSOLall101.tar.Z	\
	6.1AgenSOLgem101.Readme	\
	6.1AgenSOLgem101.tar.Z	\
	6.1AgenSOLino101.Readme	\
	6.1AgenSOLino101.tar.Z	\
	6.1AgenSOLuni101.Readme	\
	6.1AgenSOLuni101.tar.Z	\
	6.1AgenSOLmer101.Readme	\
	6.1AgenSOLmer101.tar.Z	\
	6.1AgenSOLino102.Readme	\
	6.1AgenSOLino102.tar.Z	\
	6.1AgenSOLuni102.Readme	\
	6.1AgenSOLuni102.tar.Z	\
	patchinstall		\
	"

ChemMagAcc="			\
	acc			\
	chemagnetics_acc_V3.5.2.README	\
	"

#
# PART IV --- Installation files and scripts
#
LoadSolFilesBin="			\
		decode.sol		\
		ins.sol			\
		send.sol		\
		"

#---------------------------------------------------------------------------
set_size_name()
{
   cd $dest_dir_code/$1
   if [ x$ostype = 'xSOLARIS' ]
   then
      size_name=`du -k -s $2`
   else
      size_name=`du -s $2`
   fi
   tarFileSize=`echo $size_name | awk 'BEGIN { FS = " " } { print $1 }'`
   tarFileName=`echo $size_name | awk 'BEGIN { FS = " " } { print $2 }'`
}

#---------------------------------------------------------------------------
make_toc()
{
   (cd $dest_dir_code/$1
   echo "$2	$tarFileSize	$Code/$1/$tarFileName" >> $dest_dir_code/$3
   systemname=`basename $3 .sol`
   systemname=`basename $systemname .ibm`
   systemname=`basename $systemname .sgi`
   nnl_echo "`basename $systemname` "  | tee -a $log_fln)
}


#---------------------------------------------------------------------------
nnl_echo() {
    if [ x$ostype = "x" ]
    then
        echo "error in echo-no-new-line: ostype not defined"
        exit 1
    fi

    if [ x$ostype = "xSOLARIS" ]
    then
        if [ $# -lt 1 ]
        then
            echo
        else
            echo "$*\c"
        fi
    else
        if [ $# -lt 1 ]
        then
            echo
        else
            echo -n $*
        fi
    fi
}

#---------------------------------------------------------------------------
# Routine to remove core files
findcore() {
   find . -name core -exec rm {} \;
}
#-- MAIN Main main----------------------------------------------------------
# Greetings and Salutations
#

x=`uname -r`
if [ $x -ge 5.0 ]
then
   ostype="SOLARIS"
else
   ostype="SUNOS"
fi

echo "" 
echo "M a k i n g   P a t c h   C D R O M   F i l e s" 
echo "" 
#
# ask for log filename
#
   umask 2
   echo "Use an absolute path for log !!"
   echo "This script changed directory many times"
   echo "And will write the log in that directory"
   nnl_echo "Enter destination for log   [$DefaultLogFln]: "
   read answer
   if [ x$answer = "x" ]
   then
      log_fln=$DefaultLogFln
   else
      log_fln=$answer
   fi
   if test -f $log_fln
   then
      nnl_echo "'$log_fln' exists, overwrite? [y]: "
      read answer
      if [ x$answer = "x" ]
      then
         answer="y"
      fi
      if [ x$answer != "xy" ]
      then
         exit
      fi
      rm -rf $log_fln
   fi
   echo "Writing log to '$log_fln'"
   echo ""
#
# Make nice heading in log file
#
echo ""  > $log_fln
echo "L o g   F o r   M a k i n g   C D R O M - I m a g e   F o r   P A T C H" >> $log_fln
echo ""  >> $log_fln
#
#
# ask for destination  directory
#
   nnl_echo "enter destination directory [$DefaultDestDir]:"
   read answer
   if [ x$answer = "x" ]
   then
      dest_dir=$DefaultDestDir
   else
      dest_dir=$answer
   fi
   if  test -d $dest_dir
   then
      nnl_echo "'$dest_dir' exists, overwite? [y]:"
      read answer
      if [ x$answer = "x" ]
      then
         answer="y"
      fi
      if [ x$answer != "xy" ]
      then
         abort
      fi
   else
      mkdir -p $dest_dir
   fi
   echo ""
   echo "Writing files to '$dest_dir'" | tee -a $log_fln
   dest_dir_code=$dest_dir/$Code



   nnl_echo "enter Finial directory [$DefaultFiniDir]:"
   read answer
   if [ x$answer = "x" ]
   then
      fini_dir=$DefaultFiniDir
   else
      fini_dir=$answer
   fi
   if  test  -d $fini_dir
   then
      echo "'$fini_dir' exists, overwite? [y]:"
      read answer
      if [ x$answer = "x" ]
      then
         answer="y"
      fi
      if [ x$answer != "xy" ]
      then
         abort
      fi
   else
      mkdir -p $fini_dir
   fi
   echo ""
   echo "Writing results to Final Directory: $fini_dir "| tee -a $log_fln
# Ask about rebuilding tar files that don't change often

  nnl_echo "Rebuild tar files for acrobat [y]: "
  read acro_answer
  if [ x$acro_answer = "x" ]
  then
      acro_answer="y"
  fi



   
   echo "" | tee -a $log_fln
   echo "Creating needed subdirectories:" | tee -a $log_fln
   cd $dest_dir
   nnl_echo "$Code " | tee -a $log_fln
   if [ ! -d $Code ]
   then
      mkdir $Code
   fi
   cd $Code
   for file in $SubDirs
   do
      nnl_echo "$file " | tee -a $log_fln
      if [ ! -d $file ]
      then
         mkdir -p $file
      fi
   done
   echo "" | tee -a $log_fln
   echo "" | tee -a $log_fln
   echo "Clearing *.opt files and tmp:" | tee -a $log_fln
   cd $dest_dir_code
   for file in $RmOptFiles
   do
      nnl_echo "$file " | tee -a $log_fln
      rm -rf $file
   done
   cd $dest_dir_code/tmp
   rm -rf *
   echo "" | tee -a $log_fln
   echo "" | tee -a $log_fln
#============== COMMON FILES =============================================
nnl_echo  "PART I -- MERCURY/VX FILES -- $dest_dir_code/$Mercury" | tee -a $log_fln
# Let's copy and tar the Common files and log it.
#
#---------------------------------------------------------------------
# tar some common directorys straigh from source
   cd /sw/Vnmr61A_Patchs/tmp/vnmr.mvx
   echo "" | tee -a $log_fln
   nnl_echo " Tarring binx.tar         for " | tee -a $log_fln
   tar -cf - $BinX2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mkdir bin
   mv Vnmr bin/
   chmod -R 755 ./bin
   chmod 6755 ./bin/Vnmr
   tar -cf $dest_dir_code/$Mercury/binx.tar *
   set_size_name $Mercury binx.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#-----------------------------------------------------
# tar the common bin scripts into bin tar file
   cd $commondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring unibin.tar	  for " | tee -a $log_fln
   tar -cf - $UniBinScripts2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./bin
   tar cf $dest_dir_code/$Mercury/unibin.tar bin
   set_size_name $Mercury unibin.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------
# tar some common directorys straigh from source
   cd $commondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring maclib           for " | tee -a $log_fln
   tar -cf - $ComDirs2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv Gmap/maclib maclib
   rm -rf Gmap
   chmod  755    ./manual
   chmod  644    ./manual/*
   chmod  755    ./maclib
   chmod  644    ./maclib/*
   tar cf $dest_dir_code/$Mercury/manual.tar manual maclib
   set_size_name $Mercury manual.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar psg to kpsg
   echo "" | tee -a $log_fln
   nnl_echo " Tarring kpsg files	  for " | tee -a $log_fln
   (cd $commondir; cp -rp kpsg $dest_dir_code/tmp/psg)
   cd $dest_dir_code/tmp
   chmod 755   ./psg
   chmod 644   ./psg/*
   tar cf $dest_dir_code/$Mercury/psg.tar *
   set_size_name $Mercury psg.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar the kpsg* files into one tar file
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring kpsg Objects	  for " | tee -a $log_fln
   tar -cf - $kBinPsg2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv kpsg lib
   chmod 755   ./lib
   chmod 755   ./lib/*
   chmod 644   ./lib/x_ps.o
   cd bin
   ln -s kconfig vconfig
   cd ..
   chmod -R 755   ./bin
   tar -cf $dest_dir_code/$Mercury/kpsglibs.tar lib bin
   set_size_name $Mercury kpsglibs.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------
# tar kpsglib 
   cd $dest_dir_code/tmp
   echo "" | tee -a $log_fln
   nnl_echo " Tarring kpsglib files	  for " | tee -a $log_fln
   (cd $commondir; cp -rp kpsglib $dest_dir_code/tmp/psglib)
   chmod 755   ./psglib
   chmod 644   ./psglib/*
   tar cf $dest_dir_code/$Mercury/kpsglib.tar *
   set_size_name $Mercury kpsglib.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar the additional seqlib for mercvx 
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring kseqlib.tar	  for " | tee -a $log_fln
   tar -cf - $kBinSeq2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv kseqlib seqlib
   chmod 755   ./seqlib
   chmod 755   ./seqlib/*
   tar -cf $dest_dir_code/$Mercury/kseqlib.tar *
   set_size_name $Mercury kseqlib.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring acqbin		  for " | tee -a $log_fln
   tar -cf - $iProcFam | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   cp -p $commondir/bin/isetacq $dest_dir_code/tmp/bin
   cp -p $solobjdir/bin/showconsole $dest_dir_code/tmp/bin
   cd bin
   ln -s iiadisplay iadisplay
   ln -s isetacq setacq
   cd $dest_dir_code/tmp
   chmod 755    ./acq
   chmod 644    ./acq/*
   chmod -R 755 ./acqbin
   chmod -R 755 ./bin
   chmod 6755   ./acqbin/Expproc
   chmod 755	./app-defaults
   chmod 644	./app-defaults/*
   chmod 6755   ./bin/send2Vnmr
   mv ./acqbin/nAutoproc ./acqbin/Autoproc
   tar -cf $dest_dir_code/$Mercury/acqbin.tar *
   set_size_name $Mercury acqbin.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#   
#---------------------------------------------------------------------------
   cd $solobjdir/proglib
   echo "" | tee -a $log_fln
   nnl_echo " Tarring libraries	  for " | tee -a $log_fln
   tar -cf - $iLibs2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv ncomm lib
   chmod 755 ./lib/lib*.so*
   chmod 644 ./lib/lib*.a
   tar -cf $dest_dir_code/$Mercury/libs.tar lib
   set_size_name $Mercury libs.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------
   cd $commondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring vxWorks	  for " | tee -a $log_fln
   tar -cf - $kVx2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./acq
   chmod 644    ./acq/vxBoot/*.sym
   cd acq
   mv ./kvxBoot.small  ./vxBoot.small
   mv ./vxBoot ./vxBoot.big
   ln -s vxBoot.small vxBoot
   cd ..
   tar -cf $dest_dir_code/$Mercury/vxworks.tar acq
   set_size_name $Mercury vxworks.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
   cd $commondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring VxWorks' objects for " | tee -a $log_fln
   tar -cf - $kVxObj2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 644    ./acq/*
   mv ./acq/kvwacq.o ./acq/vwacq.o
   mv ./acq/kvwhdobj.o ./acq/vwhdobj.o
   mv ./acq/kvwlibs.o ./acq/vwlibs.o
   mv ./acq/kvwtasks.o ./acq/vwtasks.o
   tar -cf $dest_dir_code/$Mercury/vxobjs.tar acq
   set_size_name $Mercury vxobjs.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#---------------------------------------------------------------------------
#
   cd $commondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Tcl files	  for " | tee -a $log_fln
   tar -cf - $Tcl2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755 tcl
   chmod 755 tcl/*
   chmod 755 tcl/bin/*
   chmod 755	./app-defaults
   chmod 644	./app-defaults/*
   tar -cf $dest_dir_code/$Mercury/tcl.tar *
   set_size_name $Mercury tcl.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# just to get vnmrwish
   cd $solobjdir/proglib/tcl
   echo "" | tee -a $log_fln
   nnl_echo " Tarring TclMore files    for " | tee -a $log_fln
   mkdir -p $dest_dir_code/tmp/tcl/bin
   cp $TclMore $dest_dir_code/tmp/tcl/bin/
   cd $dest_dir_code/tmp
   chmod -R 755  tcl
   (cd tcl/bin; ln vnmrwish vnmrWish)
   tar -cf $dest_dir_code/$Mercury/tcl2.tar *
   set_size_name $Mercury tcl2.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
#============== OPTION FILES ========================================
echo "" | tee -a $log_fln
nnl_echo "PART II -- OPTION FILES -- $dest_dir_code/\`option'" | tee -a $log_fln
#---------------------------------------------------------------------------
# Acroread online directory is copied so it can be read from the CDROM

  if [ x$acro_answer = "xy" ]
  then
   echo "" | tee -a $log_fln
   if test ! -d $commondir/online
   then
    echo "Cannot find '$xxx'" | tee -a $log_fln
   fi
   if test -w $dest_dir_code/acrobat/online
   then
      rm -rf  $dest_dir_code/acrobat/online/*
   fi
   nnl_echo " Tarring Online_Manuals	  for " | tee -a $log_fln
   cp -r /vcommon/online/menu.pdf $dest_dir_code/acrobat/online/menu.pdf
   cp -r /vcommon/online/files.txt $dest_dir_code/acrobat/online/files.txt
   cp -r /vcommon/online/mercvx $dest_dir_code/acrobat/online/
   cp -r /vcommon/online/common $dest_dir_code/acrobat/online/
   chmod 755 $dest_dir_code/acrobat/online/
   chmod 755 $dest_dir_code/acrobat/online/*
   chmod 644 $dest_dir_code/acrobat/online/menu.pdf
   chmod 755 $dest_dir_code/acrobat/online/*/??_index
   chmod 755 $dest_dir_code/acrobat/online/*/??_index/*
   set_size_name "" acrobat/online/menu.pdf
   make_toc "" "Online_Manuals" sol/mercvx.sol
   echo "" | tee -a $log_fln

   nnl_echo "         Online_Manuals	  for " | tee -a $log_fln
   set_size_name "" acrobat/online/common
   make_toc "" "Online_Manuals" sol/mercvx.sol
   echo "" | tee -a $log_fln

   nnl_echo "         Online_Manuals	  for " | tee -a $log_fln
   set_size_name "" acrobat/online/mercvx
   make_toc "" "Online_Manuals" sol/mercvx.sol
   echo "" | tee -a $log_fln
#
# Just copying, not to any TOC
#
   echo " Copying Online_Manuals   for G2000" | tee -a $log_fln
   cp -r /vcommon/online/g2000 $dest_dir_code/acrobat/online/
   echo " Copying Online_Manuals   for INOVA" | tee -a $log_fln
   cp -r /vcommon/online/inova $dest_dir_code/acrobat/online/
   echo " Copying Online_Manuals   for Mercury" | tee -a $log_fln
   cp -r /vcommon/online/mercury $dest_dir_code/acrobat/online/

#
#---------------------------------------------------------------------------
# Acroread object code, tar correct version to $dest_dir_code
   echo "" | tee -a $log_fln
   nnl_echo " Tarring ACRO object code for " | tee -a $log_fln
   cd /vcommon
   cp -r acrobat $dest_dir_code/acrobat
   chmod 644 $dest_dir_code/acrobat/acrobat/*
   chmod 755 $dest_dir_code/acrobat/acrobat/install
   set_size_name acrobat/acrobat ssolr.tar
   make_toc acrobat/acrobat "Online_Manuals" sol/mercvx.sol
   echo "" | tee -a $log_fln

   nnl_echo "         ACRO object code for " | tee -a $log_fln
   set_size_name acrobat/acrobat ssols.tar
   make_toc acrobat/acrobat "Online_Manuals" sol/mercvx.sol
   echo "" | tee -a $log_fln


 else

   echo "" | tee -a $log_fln
   nnl_echo " Skipping Online_Manuals for " | tee -a $log_fln
   set_size_name "" acrobat/online/menu.pdf
   make_toc "" "Online_Manuals" sol/mercvx.sol
   echo "" | tee -a $log_fln
   nnl_echo "          Online_Manuals for " | tee -a $log_fln
   set_size_name "" acrobat/online/common
   make_toc "" "Online_Manuals" sol/mercvx.sol
   echo "" | tee -a $log_fln
   nnl_echo "          Online_Manuals for " | tee -a $log_fln
   set_size_name "" acrobat/online/mercvx
   make_toc "" "Online_Manuals" sol/mercvx.sol
   echo "" | tee -a $log_fln

   nnl_echo " Skipping ACRO objects   for " | tee -a $log_fln
   set_size_name acrobat/acrobat ssolr.tar
   make_toc acrobat/acrobat "Online_Manuals" sol/mercvx.sol
   echo "" | tee -a $log_fln
   nnl_echo "          ACRO objects   for " | tee -a $log_fln
   set_size_name acrobat/acrobat ssols.tar
   make_toc acrobat/acrobat "Online_Manuals" sol/mercvx.sol
   echo "" | tee -a $log_fln

   echo "" | tee -a $log_fln
   nnl_echo " Skipping Online_Manuals for G2000" | tee -a $log_fln
   echo "" | tee -a $log_fln
   nnl_echo " Skipping Online_Manuals for INOVA" | tee -a $log_fln
   echo "" | tee -a $log_fln
   nnl_echo " Skipping Online_Manuals for Mercury" | tee -a $log_fln

 fi

#---------------------------------------------------------------------------
# Glide files, tar correct version to $dest_dir_code
   cd $commondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring GLIDE Text files for " | tee -a $log_fln
   tar -cf - $GlideText2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv glidepack glide
   chmod 755 ./glide
   chmod 755 ./glide/*
   chmod 644 ./glide/*/*
   chmod 755 ./glide/exp/*
   chmod 644 ./glide/exp/*/*
   chmod 644 ./glide/vnmrmenu
   chmod -R 755 ./dialoglib
   chmod 755 ./maclib
   chmod 644 ./maclib/*
   chmod 755 ./menulib
   chmod 644 ./menulib/*
   chmod 755 ./manual
   chmod 644 ./manual/*
   chmod 755 ./probes
   chmod 644 ./probes/*
   mv tape_sol2/user_templates user_templates
   rm -r tape_sol2
   chmod 755 user_templates
   chmod 755 user_templates/dg
   chmod 755 user_templates/dg/*
   chmod 644 user_templates/dg/*/*
   tar -cf $dest_dir_code/$Glide/glidetxt.tar *
   set_size_name $Glide glidetxt.tar
   make_toc $Glide "GLIDE" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#---------------------------------------------------------------------------
# Glide parlib, tar correct version to $dest_dir_code
   cd $commondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring GLIDE parlib     for " | tee -a $log_fln
   tar -cf - $GlidePars2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv gpar/parlib parlib
   mv gpar/par200 par200
   mv gpar/par300 par300
   mv gpar/par400 par400
   rm -r gpar
   chmod 644   ./par??0/stdpar/*/*
   chmod 755   ./par??0/stdpar/*
   chmod 644   ./par??0/tests/*/*
   chmod 755   ./par??0/tests/*
   chmod 644   ./parlib/*/*
   chmod 755   ./par???/*
   chmod 755   ./par???
   tar -cf $dest_dir_code/$Glide/glidepar.tar *
   set_size_name $Glide glidepar.tar
   make_toc $Glide "GLIDE" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#---------------------------------------------------------------------------
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring GLIDE Objects    for " | tee -a $log_fln
   tar -cf - $GlideBin2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./bin
   tar -cf $dest_dir_code/$Glide/glidebin.tar bin
   set_size_name $Glide glidebin.tar
   make_toc $Glide "GLIDE" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#---------------------------------------------------------------------------
# tar the gPFG seqlib
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring gPFG Objects	  for " | tee -a $log_fln
   tar -cf - $kBinPFG2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv kseqlib seqlib
   chmod 755   ./seqlib
   chmod 755   ./seqlib/*
   tar -cf $dest_dir_code/$Mercury/pfgobj.tar *
   set_size_name $Mercury pfgobj.tar
   make_toc $Mercury "PFG" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar the gPFG common files maclib, manual, psglib
   cd $commondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring gPFG Text        for " | tee -a $log_fln
   cd gPFG
   tar -cf - $kComPFG2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755   ./maclib
   chmod 644   ./maclib/*
   tar -cf $dest_dir_code/$Mercury/pfg.tar *
   set_size_name $Mercury pfg.tar
   make_toc $Mercury "PFG" sol/mercvx.sol
   rm -rf $dest_dir_code/tmp/*
#---------------------------------------------------------------------------
# tar the userlib option
#    ===>>> MERCURY, GEMINI 2000 USERLIB <<<===
   cd /vcommon/UserLib.mercury_gemini
   echo "" | tee -a $log_fln
   nnl_echo " Tarring userlib.tar         for " | tee -a $log_fln
   tar -cf $dest_dir_code/$Mercury/userlib.tar $UserLib2Tar
   set_size_name $Mercury/ userlib.tar
   make_toc $Mercury/ "Userlib" sol/mercvx.sol
#
#===================== PATCH FILES =========================================
# copy the patch files from /rdvnmr/patches
   echo "" | tee -a $log_fln
   echo "PART III -- PATCH FILES -- $dest_dir" | tee -a $log_fln
#---------------------------------------------------------------------------
   echo "vnmrpatch files"
   cd $dest_dir
   if [ ! -d vnmrpatches ]
   then
      mkdir vnmrpatches
   fi
   for file in $PatchList
   do
     cp /rdvnmr/patches/$file $dest_dir/vnmrpatches
   done
#
#---------------------------------------------------------------------------
#
   echo "ChemMagnetics' Acc files"
   cd $dest_dir
   if [ ! -d acc ]
   then
      mkdir acc
   fi
   for file in $ChemMagAcc
   do
     cp /vcommon/acc/$file $dest_dir/acc
   done
#
#---------------------------------------------------------------------------
#
   echo "Userlib-s"
   cd $dest_dir
   if [ ! -d userlib ]
   then
      mkdir userlib
   fi
   cd userlib
   rm -rf *
   cp -r /vcommon/UserLib.inova_unity/userlib userlib.inova_unity
   cp -r /vcommon/UserLib.mercury_gemini/userlib userlib.mercury_gemini

#
#============== INSTALLATION FILES =========================================
# copy some of the installation programs
   echo "" | tee -a $log_fln
   nnl_echo "PART IV -- INSTALLATION FILES -- $dest_dir" | tee -a $log_fln
#
#---------------------------------------------------------------------------
#
   echo "" | tee -a $log_fln
#
   echo "load.nmr " | tee -a $log_fln
   cp $sourcedir/sysscripts/loadcd2 $dest_dir/load.nmr
   chmod 777 $dest_dir/load.nmr
   echo $Code/i_vnmr.3 | tee -a $log_fln
   cp $sourcedir/sysscripts/i_vnmr1 $dest_dir_code/i_vnmr.3
   chmod 777 $dest_dir/code/i_vnmr.3
   echo $Code/readme.txt | tee -a $log_fln
   cp $sourcedir/sysscripts/readme2.txt $dest_dir_code/../readme.txt
   chmod 666 $dest_dir/code/../readme.txt
#
   cd $dest_dir_code/tmp
   for file in $LoadSolFilesBin
   do
      rm -f $file
      cp -p $solobjdir/proglib/bin/$file $file
   done
   echo $Code/decode.sol | tee -a $log_fln
   cp decode.sol $dest_dir_code/decode.sol
   chmod 777 $dest_dir/code/decode.sol
   echo $Code/ins.sol | tee -a $log_fln
   cp ins.sol $dest_dir_code/ins.sol
   chmod 777 $dest_dir/code/ins.sol
   echo $Code/send.sol | tee -a $log_fln
   cp send.sol $dest_dir_code/send.sol
   chmod 777 $dest_dir/code/send.sol
#
#
   echo "copying icons" | tee -a $log_fln
   cd $dest_dir_code
   if [ ! -d $dest_dir_code/icon ]
   then
      mkdir -p $dest_dir_code/icon
   fi
   cd icon
   Sget bin mercvx.icon > /dev/null
   Sget bin logo.icon > /dev/null

   cd $dest_dir_code/../
   echo "" | tee -a $log_fln
   echo "" | tee -a $log_fln
   echo "Writing Revision File '$RevFileName':"  | tee -a $log_fln
   echo $VNMR_REV_ID > $RevFileName
   echo $VNMR_REV_DATE >> $RevFileName
   cat $RevFileName | tee -a $log_fln
#
#---------------------------------------------------------------------------
# Finally, all done, write out passwd file, clean up some unneeded directorys
#
   cd $dest_dir_code
   echo " " | tee -a $log_fln
   echo "Deleting unneeded subdirectories:" | tee -a $log_fln
   for file in $RmSubDirs
   do
      nnl_echo "$file " | tee -a $log_fln
      rm -r $file
   done
   echo "" | tee -a $log_fln
   echo "" | tee -a $log_fln

   echo "Write CD Image to Destination Place: $fini_dir" | tee -a $log_fln
   cd $dest_dir
   tar -cf - . | (cd $fini_dir; tar xfBp -)
