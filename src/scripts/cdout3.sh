: '@(#)cdout3.sh 22.1 03/24/08 1999-2000 '
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
: /bin/sh
#scripts to make a directory with all the data needed for 
# M-Series Performa II/DOSY and Mercury-Vx CP/MAS
#
# Default Declarations
#
Code="code"
#Install_dir="/common/sysscripts"
#
# Archived acquisition files for VXR,Unity,Unity+ 
sol53objdir="/vobj/sol53"
sol53common="/vobj/sol53/vcommon"
vpatch="/vpatch/patch103/patches/inova"
#
Aix="aix"
Common="common"

Backproj="backproj"
CSI="csi"
Diff="diffuse"
Encodedir="/sw/vbin"
Gemini="gemini"
Glide="glide"
Glidepack="glidepack"
Gmap="gmap"
Gnu="gnu"
Image="imaging"
Inova="inova"
Irix="irix"
Kermit="kermit"
LCNMR="lcnmr"
Limnet="limnet"
Mercury="mercury"
Mvx="mercvx"
Pfg="pfg"
Solaris="solaris"
STARS="stars"
# Uimaging="uimaging"
Unity="unity"
#
# Library .so. version definitions
ACQCOMM_VER="2.0"
ACQCOMM_VER6="6.0"
NCOMM_VER=$psg_so_ver
#
# Passwords, extremely secret!!
#
# Vnmr 6.1C passwords
Gmap_password="gg-lrs"
LCNMR_password="mm-zzj"
Diff_password="pi-poi"
Stars_password="do-wat"
IBM_password="cn-hhw"
SGI_password="cs-hrr"
Backproj_password="bd-iee"
CSI_password="rt-bai"
DOSY_password="hl-bcp"
BIR_password="lt-bjs"
VAST_password="vn-otf"
FDM_password="ka-sgm"

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
		common			\
                mercury			\
		mercvx			\
		sol			\
		tmp			\
		"

RmSubDirs="				\
		tmp			\
		"

RmOptFiles="				\
		sol/g2000.sol		\
		sol/g2000.opt		\
		sol/inova.sol		\
		sol/inova.opt		\
		sol/mercury.sol		\
		sol/mercury.opt		\
		sol/mercvx.sol		\
		sol/mercvx.opt		\
		sol/mercplus.sol	\
		sol/mercplus.opt	\
		sol/unity.sol		\
		sol/unity.opt		\
		sol/uplus.sol		\
		sol/uplus.opt		\
		"
#
# PART I ---- Common File Definitions for Patch 103
#
kMvx2Tar="			\
	acqbin/Expproc		\
	-C $commondir	bin/isetacq     	\
	"

kMer2Tar="			\
	bin/gsetacq		\
	"
kMSer2Tar="			\
	bin/Acqstat		\
	bin/Pbox		\
	bin/Vnmr		\
	bin/findedevices	\
	bin/patchinstall	\
	"

Acct2Tar="                      \
        adm/bin/acc_vnmr  \
        adm/bin/update_acctng     \
        adm/bin/view_acctng       \
        adm/bin/console_login   \
        "

Dialog2Tar="				\
	dialoglib/CARBON/acquire.def	\
	"

Glide2Tar="				\
	glide/exp/AuCexp/plot.def	\
	glide/exp/AuCexp/process.def	\
	glide/exp/AuH4nuc/plot.def	\
	glide/exp/AuH4nuc/process.def	\
	"

Maclib2Tar="				\
	maclib/Autosetgpar		\
	maclib/ds_setint			\
	maclib/fdm1			\
	maclib/files_loadshims		\
	maclib/setpower			\
	manual/substr			\
	"

Templ2Tar="				\
	user_templates/dg/HSQC/dg.sequence  \
	user_templates/dg/default/dg.conf   \
	user_templates/dg/gHSQC/dg.sequence \
	"

Userlib2Tar="				\
	userlib/extract			\
	userlib/extract.README		\
	"

#
# PART VIIb --- Mercury 
#
# -- Mercury libraries used by the Pulse Sequencies 
# --- kpsg.tar 

kCPMAS2Tar="				\
	kpsglib/xpolar1.c		\
	maclib/fixpar			\
	maclib/make_array		\
	manual/make_array		\
	-C gpar		parlib/xpolar1.par	\
	-C gpar		par300/tests/hmb.par	\
	-C gpar		par400/stdpar/H2.par	\
	-C gpar		par400/tests/hmb.par	\
	-C ktape_sol	user_templates		\
	"

kCPMASBin2Tar="				\
	kseqlib/xpolar1			\
	"

kVx2Tar="                      	        \

        acq/vxBoot.big/vxWorks          \
        acq/vxBoot.big/vxWorks.sym      \
        acq/kvxBoot.small/vxWorks       \
        "

kBinPsg2Tar="kpsg/libpsglib.a		\
	kpsg/libparam.a                 \
	kpsg/libpsglib.so.$psg_so_ver   \
	kpsg/libparam.so.$psg_so_ver	\
	kpsg/libparam.so                \
	kpsg/libpsglib.so               \
	bin/kconfig			\
	"


kVxObj2Tar="                    \
        acq/kvwhdobj.o          \
        acq/kvwlibs.o           \
        acq/kvwtasks.o          \
        acq/vwcom.o             \
        "

#
# PART XII --- Passworded options
#
Diffus2Tar="                    \
        maclib                  \
        manual                  \
        parlib                  \
        psglib                  \
        "

DiffusSeq2Tar="			\
	seqlib/g2pulramp	\
	seqlib/pge		\
	seqlib/pgeramp		\
	"


#
# PART XVI --- Installation files and scripts
#
LoadFiles="				\
		loadcd			\
		setup			\
		i_vnmr3			\
		i_vnmr4			\
		readme.txt		\
		"

LoadSolFilesBin="			\
		decode.sol		\
		ins.sol			\
		send.sol		\
		"

#---------------------------------------------------------------------------

setperms()
{
   if [ $# -lt 4 ]
   then
     echo 'Usage - setperms "directory name" "dir permissions" "file permissions" "executable permissions"'
     echo ' E.g. "setperms /sw2/cdimage/code/tmp/wavelib 775 655 755" or "setperms /common/wavelib g+rx g+r g+x" '
     exit 0
   fi
   dirperm=$2
   fileperm=$3
   execperm=$4
   
   if [ $# -lt 5 ]
   then
     echo "" 
     indent=0
   else
     indent=$5
   fi
   
   pars=`(cd $1; ls)`
   for setpermfile in $pars
   do
#  indent to proper place
      spaces=$indent
      pp=""
      while [ $spaces -gt 0 ]
      do
        pp='.'$pp
        spaces=`expr $spaces - 1`
      done
   
# test for director, file, executable file
     if [ -d $1/$setpermfile ]
     then
       echo "${pp}chmod $dirperm $setpermfile/"
       chmod $dirperm $1/$setpermfile
       indent=`expr $indent + 4`
       setperms $1/$setpermfile $dirperm $fileperm $execperm $indent
       indent=`expr $indent - 4`
     elif [ -f $1/$setpermfile ]
     then
       if [ -x $1/$setpermfile ]
       then
         echo "${pp}chmod $execperm $setpermfile*"
         chmod $execperm $1/$setpermfile
       else
         echo "${pp}chmod $fileperm $setpermfile"
         chmod $fileperm $1/$setpermfile
       fi
     else
      echo file:  $1/$setpermfile not modified
     fi
   done
}

#---------------------------------------------------------------------------
set_size_name()
{
   cd $dest_dir_code/$1
   if [ x$ostype = 'xSOLARIS' ]
   then
      size_name=`du -k -L -s $2`
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

MakeBase="/usr25/frits/kr/cdout"

if [ $# = 1 ]
then
# ## do VJ
   LoadFilesDir=$MakeBase/cdimageVJ/cdrom
   DefaultDestDir=$MakeBase/cdimageVJ
   DefaultFiniDir=`date '+/rdvnmr/.cdromVJ%m.%d'`
   DefaultLogFln=$MakeBase/cdoutlogVJ
   RevFileName="vnmrj"
   VnmrRevId=$VNMRJ_REV_ID
else
   LoadFilesDir=$MakeBase/cdimage/cdromM
   DefaultDestDir=$MakeBase/cdimageM
   DefaultFiniDir=`date '+/rdvnmr/.cdromM%m.%d'`
   DefaultLogFln=$MakeBase/cdoutlogM
   RevFileName="vnmr6.1"
   VnmrRevId=$VNMR_REV_ID
fi



   ostype="SOLARIS"

echo ""  | tee -a $log_fln
echo "M a k i n g   S u p p l e m e n t   V n m r   C D R O M   F i l e s" | tee -a $log_fln
echo "" | tee -a $log_fln
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
echo "L o g   f o r   M a k i n g   C D R O M - I m a g e   F o r  S u p p l e m e n t"
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
         mkdir $file
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
#============== PATCH103 FILES =============================================
nnl_echo  "PART I -- PATCH103 FILES -- $dest_dir_code/$Common" | tee -a $log_fln
#
#---------------------------------------------------------------------------
# extract for userlib
   cd /vpatch/patch103/patches/inova
   echo "" | tee -a $log_fln
   nnl_echo " Tarring extract files       for " | tee -a $log_fln
   tar -cf - $Userlib2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./userlib
   chmod    644 ./userlib/*
   tar -cf $dest_dir_code/$Common/userlib.tar *
   set_size_name $Common userlib.tar
   make_toc $Common "VNMR" sol/mercplus.sol
   make_toc $Common "VNMR" sol/mercvx.sol
   make_toc $Common "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# User_templates
   cd $vpatch
   echo "" | tee -a $log_fln
   nnl_echo " Tarring templates files     for " | tee -a $log_fln
   tar -cf - $Templ2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./user_templates
   chmod    644 ./user_templates/dg/*/*
   tar -cf $dest_dir_code/$Common/templ.tar *
   set_size_name $Common templ.tar
   make_toc $Common "VNMR" sol/mercplus.sol
   make_toc $Common "VNMR" sol/mercvx.sol
   make_toc $Common "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# Maclib and Manual fixes
   cd $vpatch
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Maclib files        for " | tee -a $log_fln
   tar -cf - $Maclib2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./maclib ./manual
   chmod    644 ./maclib/* ./manual/*
   tar -cf $dest_dir_code/$Common/maclib.tar *
   set_size_name $Common maclib.tar
   make_toc $Common "VNMR" sol/mercplus.sol
   make_toc $Common "VNMR" sol/mercvx.sol
   make_toc $Common "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# Glide fixes
   cd $vpatch
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Glide files         for " | tee -a $log_fln
   tar -cf - $Glide2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 glide
   chmod    644 glide/exp/*/*
   tar -cf $dest_dir_code/$Common/glide.tar *
   set_size_name $Common glide.tar
   make_toc $Common "VNMR" sol/mercplus.sol
   make_toc $Common "VNMR" sol/mercvx.sol
   make_toc $Common "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# Dialoglib fixes
   cd $vpatch
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Dialoglib files     for " | tee -a $log_fln
   tar -cf - $Dialog2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   tar -cf $dest_dir_code/$Common/dialog.tar *
   set_size_name $Common dialog.tar
   make_toc $Common "VNMR" sol/mercplus.sol
   make_toc $Common "VNMR" sol/mercvx.sol
   make_toc $Common "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
#  Accouting scripts and executable 
   cd $vpatch
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Accounting files    for " | tee -a $log_fln
   tar -cf - $Acct2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 adm
   tar -cf $dest_dir_code/$Common/adm.tar *
   set_size_name $Common adm.tar
   make_toc $Common "VNMR" sol/mercplus.sol
   make_toc $Common "VNMR" sol/mercvx.sol
   make_toc $Common "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
#
#============== UPGRADE FILES =============================================
echo "" | tee -a $log_fln
nnl_echo  "PART III -- UPGRADE FILES -- $dest_dir_code/$Common" | tee -a $log_fln
#
#-----------------------------------------------------
   cd $commondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring VxWorks' objects    for " | tee -a $log_fln
   tar -cf - $kVxObj2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 644    ./acq/*
   mkdir -p acq/vxBoot.big
   mv ./acq/kvwhdobj.o ./acq/vxBoot.big/vwhdobj.o
   mv ./acq/kvwlibs.o  ./acq/vxBoot.big/vwlibs.o
   mv ./acq/kvwtasks.o ./acq/vxBoot.big/vwtasks.o
   mv ./acq/vwcom.o    ./acq/vxBoot.big
   tar -cf $dest_dir_code/$Mercury/vxobjs.tar acq
   set_size_name $Mercury vxobjs.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   make_toc $Mercury "VNMR" sol/mercplus.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
   cd $commondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring vxWorks             for " | tee -a $log_fln
   tar -cf - $kVx2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./acq
   chmod 644    ./acq/vxBoot.big/*.sym
   cd acq
   mv ./kvxBoot.small  ./vxBoot.small
   ln -s vxBoot.small vxBoot
   cd ..
   tar -cf $dest_dir_code/$Mercury/vxworks.tar acq
   set_size_name $Mercury vxworks.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   make_toc $Mercury "VNMR" sol/mercplus.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar the setacq* files into one tar file
   cd $vpatch
   echo "" | tee -a $log_fln
   nnl_echo " Tarring binary Objects      for " | tee -a $log_fln
   tar -cf - $kMSer2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755   ./bin
   tar -cf $dest_dir_code/$Mercury/binmser.tar *
   set_size_name $Mercury binmser.tar
   make_toc $Mercury "VNMR" sol/mercplus.sol
   make_toc $Mercury "VNMR" sol/mercvx.sol
   make_toc $Mercury "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar the setacq* files into one tar file
   cd $commondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring gsetacq Objects     for " | tee -a $log_fln
   tar -cf - $kMer2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755   ./bin
   tar -cf $dest_dir_code/$Mercury/binmer.tar *
   set_size_name $Mercury binmer.tar
   make_toc $Mercury "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar the Expproc, setacq, findedevices files into one tar file
   cd $vpatch
   echo "" | tee -a $log_fln
   nnl_echo " Tarring bin Objects         for " | tee -a $log_fln
   tar -cf - $kMvx2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755   ./acqbin
   chmod -R 755   ./bin
   tar -cf $dest_dir_code/$Mvx/binmvx.tar *
   set_size_name $Mvx binmvx.tar
   make_toc $Mvx "VNMR" sol/mercvx.sol
   make_toc $Mvx "VNMR" sol/mercplus.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar the kpsg* files into one tar file
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring kpsg Objects        for " | tee -a $log_fln
   tar -cf - $kBinPsg2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv kpsg lib
   chmod 755   ./lib
   chmod 755   ./lib/*
   chmod -R 755   ./bin
   tar -cf $dest_dir_code/$Mercury/kpsglibs.tar *
   set_size_name $Mercury kpsglibs.tar
   make_toc $Mercury "VNMR" sol/mercplus.sol
   make_toc $Mercury "VNMR" sol/mercvx.sol
   make_toc $Mercury "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar psg to kpsg
   echo "" | tee -a $log_fln
   nnl_echo " Tarring kpsg files          for " | tee -a $log_fln
   mkdir $dest_dir_code/tmp/psg
   (cd $commondir; cp -rp kpsg/gradient.c $dest_dir_code/tmp/psg)
   (cd $commondir; cp -rp kpsg/meat.c     $dest_dir_code/tmp/psg)
   (cd $commondir; cp -rp kpsg/array.c    $dest_dir_code/tmp/psg)
   (cd $commondir; cp -rp kpsg/convert.c  $dest_dir_code/tmp/psg)
   cd $dest_dir_code/tmp
   chmod 755   ./psg
   chmod 644   ./psg/*
   tar cf $dest_dir_code/$Mercury/psg.tar *
   set_size_name $Mercury psg.tar
   make_toc $Mercury "VNMR" sol/mercplus.sol
   make_toc $Mercury "VNMR" sol/mercvx.sol
   make_toc $Mercury "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar cp/mas sequence and macros
   echo "" | tee -a $log_fln
   nnl_echo " Tarring PFG files           for " | tee -a $log_fln
   mkdir $dest_dir_code/tmp/psglib
   mkdir $dest_dir_code/tmp/maclib
   mkdir $dest_dir_code/tmp/parlib
   mkdir $dest_dir_code/tmp/seqlib
   (cd $commondir; cp -rp kpsglib/p2pul.c   	$dest_dir_code/tmp/psglib)
   (cd $commondir; cp -rp Gmap/maclib/gmapz    	$dest_dir_code/tmp/maclib)
   (cd $commondir; cp -rp gPFG/maclib/profile	$dest_dir_code/tmp/maclib)
   (cd $commondir; cp -rp gPFG/maclib/grecovery	$dest_dir_code/tmp/maclib)
   (cd $commondir; cp -rp maclib/config		$dest_dir_code/tmp/maclib)
   (cd $commondir; cp -rp gPFG/parlib/p2pul.par	$dest_dir_code/tmp/parlib)
   (cd $solobjdir; cp -rp proglib/kseqlib/p2pul	$dest_dir_code/tmp/seqlib)
   (
   cd $dest_dir_code/tmp
   chmod 755   ./psglib ./maclib ./parlib ./seqlib
   chmod 644   ./psglib/* ./maclib/*
   chmod 755   ./parlib/* ./seqlib/*
   chmod 644   ./parlib/*/*
   tar cf $dest_dir_code/$Mercury/pfg.tar *
   set_size_name $Mercury pfg.tar
   make_toc $Mercury "VNMR" sol/mercplus.sol
   make_toc $Mercury "VNMR" sol/mercvx.sol
   make_toc $Mercury "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
   )
#
#---------------------------------------------------------------------------
# tar cp/mas from vcommon
   echo "" | tee -a $log_fln
   nnl_echo " Tarring cp/mas files        for " | tee -a $log_fln
   cd $commondir
   tar -cf - $kCPMAS2Tar | ( cd $dest_dir_code/tmp; tar xfBp  -)
   cd $dest_dir_code/tmp
   mv ./kpsglib psglib
   chmod -R 755 ./psglib ./maclib ./manual ./parlib ./par300 ./par400
   chmod    644 ./psglib/* ./maclib/* ./manual/*
   chmod    644 ./parlib/*/* ./par300/tests/*/* ./par400/tests/*/*
   chmod    644 ./user_templates/dg/xpolar1/*
   tar cf $dest_dir_code/$Mercury/cpmas.tar *
   set_size_name $Mercury cpmas.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   make_toc $Mercury "VNMR" sol/mercplus.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar cp/mas from vobj/sol
   echo "" | tee -a $log_fln
   nnl_echo " Tarring cp/mas seqlib       for " | tee -a $log_fln
   cd $solobjdir
   tar -cf - $kCPMASBin2Tar | ( cd $dest_dir_code/tmp; tar xfBp  -)
   cd $dest_dir_code/tmp
   mv ./kseqlib ./seqlib
   chmod -R 755 ./seqlib
   tar cf $dest_dir_code/$Mercury/cpmas2.tar *
   set_size_name $Mercury cpmas2.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   make_toc $Mercury "VNMR" sol/mercplus.sol
   rm -rf $dest_dir_code/tmp/*
#
#============== PASSWORDED  FILES ========================================
echo "" | tee -a $log_fln
nnl_echo "PART II -- PASSWORDED FILES -- $dest_dir_code/" | tee -a $log_fln
#---------------------------------------------------------------------------
# tar DOSY files
#   if [ $# = 2 ] 
#   then
      cd $dest_dir_code/tmp
      echo "" | tee -a $log_fln
      nnl_echo " Tarring DOSY files	     for " | tee -a $log_fln
      (cd $commondir/DOSY; cp -rp * $dest_dir_code/tmp)
      chmod 755   ./*
      chmod 644   ./*/*
      chmod 755   ./parlib/*
      chmod 644   ./parlib/*/*
      chmod 755   ./psglib
      chmod 644   ./psglib/*
      chmod 755   ./fidlib/*
      chmod 755   ./fidlib/*/*
      chmod 644   ./fidlib/*/*/*
      chmod 755   ./user_templates/dg
      chmod 755   ./user_templates/dg/*
      chmod 644   ./user_templates/dg/*/*
   
      chmod 755	./seqlib
      filelist=`ls $commondir/DOSY/seqlib`
      rm seqlib/*
   
      for file in $filelist 
      do
          cp -p /vobj/sol/proglib/kseqlib/$file seqlib
      done
      chmod 755	./seqlib/*
   
      tar -cf - * | $Encodedir/encode $DOSY_password >$dest_dir_code/$Common/dosy.pwd
         set_size_name $Common dosy.pwd
      make_toc $Common "DOSY" sol/mercplus.opt
      make_toc $Common "DOSY" sol/mercvx.opt
      make_toc $Common "DOSY" sol/mercury.opt
      rm -rf $dest_dir_code/tmp/*
#   fi
#
#============== PATCH  FILES ========================================
echo "" | tee -a $log_fln
nnl_echo "PART III -- PATCH FILES -- $dest_dir_code/" | tee -a $log_fln
echo "" | tee -a $log_fln
#---------------------------------------------------------------------------
#
   cd $dest_dir
   if [ ! -d vnmr_patches ]
   then
      mkdir vnmr_patches
   fi
   cd vnmr_patches
   cp -p /rdvnmr/patches/6.1CallSOLgem103.Readme .
   cp -p /rdvnmr/patches/6.1CallSOLgem103.tar.Z  .
   cp -p /rdvnmr/patches/6.1CallSOLino103.Readme .
   cp -p /rdvnmr/patches/6.1CallSOLino103.tar.Z  .
   echo "list of files in patch directory:"  | tee -a $log_fln
   ls -F | tee -a $log_fln
#
#============== INSTALLATION FILES =========================================
# copy some of the installation programs
   echo "" | tee -a $log_fln
   nnl_echo "PART XVI -- INSTALLATION FILES -- $dest_dir" | tee -a $log_fln
#
#---------------------------------------------------------------------------
#
   cd $dest_dir
   echo "" | tee -a $log_fln
   echo " Making copies in '$LoadFilesDir'" | tee -a $log_fln

   echo "volstart " | tee -a $log_fln
   cp $sourcedir/sysscripts/volstart $dest_dir/volstart
   chmod 777 $dest_dir/volstart

   echo "load.nmr " | tee -a $log_fln
   cp $sourcedir/sysscripts/loadcd3.sh $dest_dir/
   cd $dest_dir
   make loadcd3
   mv loadcd3 load.nmr
   rm -f loadcd3.sh
   chmod 777 $dest_dir/load.nmr

   echo $Code/i_vnmr.3 | tee -a $log_fln
   cp $sourcedir/sysscripts/i_vnmr3 $dest_dir_code/i_vnmr.3
   chmod 777 $dest_dir/code/i_vnmr.3

   echo $Code/i_vnmr.4 | tee -a $log_fln
   cp $sourcedir/sysscripts/i_vnmr4 $dest_dir_code/i_vnmr.4
   chmod 777 $dest_dir/code/i_vnmr.4

#
#   for VJ cdrom only
#
   if [ $# = 1 ]
   then
      (cd $dest_dir; rm -f load.nmr; ln -s vnmrsetup load.nmr)
   fi
 
   for file in $LoadSolFilesBin
   do
      echo $Code/$file | tee -a $log_fln
      rm -f $dest_dir_code/$file
      cp -p $solobjdir/proglib/bin/$file $dest_dir_code/$file
      chmod 777 $dest_dir/code/$file
   done

 
   echo "copying icons" | tee -a $log_fln
   cd $dest_dir_code
   if [ ! -d $dest_dir_code/icon ]
   then
      mkdir -p $dest_dir_code/icon
   fi
   cd icon
   chmod -w *.icon
   Sget bin inova.icon > /dev/null
   Sget bin g2000.icon > /dev/null
   Sget bin unity.icon > /dev/null
   Sget bin uplus.icon > /dev/null
   Sget bin mercury.icon > /dev/null
   Sget bin mercvx.icon > /dev/null
   Sget bin mercplus.icon > /dev/null
   Sget bin sgi.icon > /dev/null
   Sget bin ibm.icon > /dev/null
   Sget bin logo.icon > /dev/null
   chmod +w *.icon
 
   #cd $Install_dir
   #echo $Code/readme.txt | tee -a $log_fln
   #cp readme.txt $dest_dir/readme.txt
   #chmod 644 $dest_dir/readme.txt
   #cp readme.txt $dest_dir/../READ.ME
   #chmod 644 $dest_dir/../READ.ME

   cd $dest_dir_code/../
   echo "" | tee -a $log_fln
   echo "" | tee -a $log_fln
   rm -f vnmrrev
   echo "Writing Revision File '$RevFileName':"  | tee -a $log_fln
   echo $VnmrRevId > vnmrrev
   echo `date '+%B %d, %Y'` >> vnmrrev
   cat vnmrrev | tee -a $log_fln
   ln -s vnmrrev $RevFileName

# And now the piece de resistance, the Readme file
   Sget scripts Readme.61c.suppl
   mv Readme.61c.suppl Readme
   chmod 644 Readme

#
#---------------------------------------------------------------------------
# Finally, all done, write out passwd file, clean up some unneeded directories
#
   cd $dest_dir/..
   echo "" | tee -a $log_fln
   echo "" | tee -a $log_fln
   echo "The passwords used with this install are:" > passwords | tee -a $log_fln
   echo "" >> passwords
#   echo "Gradient_shim	$Gmap_password"  >> passwords
   echo "Diffusion	$Diff_password"  >> passwords
   echo "LC-NMR		$LCNMR_password" >> passwords
   echo "STARS          $Stars_password" >> passwords
#   echo "VNMR for IBM	$IBM_password"   >> passwords
#   echo "VNMR for SGI	$SGI_password"   >> passwords
   echo "Backprojection	$Backproj_password"   >> passwords
   echo "CSI		$CSI_password"   >> passwords
   echo "DOSY           $DOSY_password"  >> passwords
   echo "BIR Shapes     $BIR_password"   >> passwords
   echo "VAST           $VAST_password"  >> passwords
   echo "FDM            $FDM_password"   >> passwords
   echo "" >> passwords

   cat passwords >> $log_fln
   
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
   cp $dest_dir/../passwords $fini_dir.passwords
