: '@(#)nvcdout.sh 22.1 03/24/08 2003-2007 '
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
# nvcdout.sh
# scripts to make a directory with all the data needed for Nirvana

# Default Declarations
#
#if [ x$vcommondir = "x" ]
#then
#     vcommondir="/vcommon"
#fi


vcommondir="/vcommon"
commondir="/common"
vbin="/sw/vbin"

if [ x$lnxobjdir = "x" ]
then
   lnxobjdir="/vobj/lnx"
fi

if [ x$winobjdir = "x" ]
then
   winobjdir="/vobj/win"
fi

lnxproglib_dir=${lnxobjdir}/proglib
solproglib_dir=${solobjdir}/proglib
winproglib_dir=${winobjdir}/proglib

ShowPermResults=-100

Code="code"
Common="common"
Backproj="backproj"
CSI="csi"
Diff="diffuse"
Encodedir=$vbin
Gmap="gmap"
Gxyz="gxyz"
Gnu="gnu"
Image="imaging"
Inova="inova"
Vnmrs="vnmrs"
Unity="unity"
Kermit="kermit"
LCNMR="lcnmr"
Limnet="limnet"
Linux="linux"
Windows="windows"
Pfg="pfg"
Rht="Rht"
Win="win"
Solaris="solaris"
STARS="stars"
Solids="solids"
 
# Library .so. version definitions
ACQCOMM_VER="2.0"
ACQCOMM_VER6="6.0"
NCOMM_VER=$psg_so_ver

# solNDDSlibDir=/sw/NDDS/ndds.3.0m/lib/sparcSol2.8cc5.2
# solNDDSlibDir=/sw/NDDS/ndds.3.1a/lib/sparcSol2.9cc5.4
# solNDDSManger=/sw/NDDS/ndds.3.0m/bin/sparcSol2.8cc5.0/nddsManager

solNDDSlibDir=/sw/NDDS/build_ndds_ver/lib/SolLibs
solNDDSManger=/sw/NDDS/build_ndds_ver/bin/SolBin/nddsManager
solNDDSInfo=/sw/NDDS/build_ndds_ver/bin/SolBin/nddsInfo
solNDDSSpy=/sw/NDDS/build_ndds_ver/bin/SolBin/nddsSpy

# build_ndds_ver point to (8/24/06) version 3.1c_rev?
# but RedHat 3 cannot deal with this
# for VnmrJ 2.3A we compile on RHEL 4 update 3, or higher
lnxNDDSlibDir=/sw/NDDS/build_ndds_ver/lib/LinuxLibs
lnxNDDSManger=/sw/NDDS/build_ndds_ver/bin/LinuxBin/nddsManager
lnxNDDSInfo=/sw/NDDS/build_ndds_ver/bin/LinuxBin/nddsInfo
lnxNDDSSpy=/sw/NDDS/build_ndds_ver/bin/LinuxBin/nddsSpy

# but RedHat 3 must use 3.1 B 
# lnxNDDSlibDir=/sw/NDDS/ndds.3.1b.rev3/lib/LinuxLibs
# lnxNDDSManger=/sw/NDDS/ndds.3.1b.rev3/bin/LinuxBin/nddsManager
# lnxNDDSInfo=/sw/NDDS/ndds.3.1b.rev3/bin/LinuxBin/nddsInfo
# lnxNDDSSpy=/sw/NDDS/ndds.3.1b.rev3/bin/LinuxBin/nddsSpy

wxpNDDSlibDir=/sw/NDDS/build_ndds_ver/lib/WinLibs
wxpNDDSManger=/sw/NDDS/build_ndds_ver/bin/WinBin/nddsManager
wxpNDDSInfo=/sw/NDDS/build_ndds_ver/bin/WinBin/nddsInfo
wxpNDDSSpy=/sw/NDDS/build_ndds_ver/bin/WinBin/nddsSpy

wxpNDDSlibs=

wsfuNDDSlibDir=/sw/NDDS/build_ndds_ver/lib/WinSFULibs
wsfuNDDSManger=/sw/NDDS/build_ndds_ver/bin/WinSFUBin/nddsManager
wsfuNDDSInfo=/sw/NDDS/build_ndds_ver/bin/WinSFUBin/nddsInfo
wsfuNDDSSpy=

#
# Passwords, extremely secret!!
#
#
# VnmrJ passwords
Gmap_password="gg-lrs"
Gxyz_password="pb-gam"
LCNMR_password="mm-zzj"
Diff_password="pi-poi"
Stars_password="do-wat"
Backproj_password="bd-iee"
CSI_password="rt-bai"
DOSY_password="hl-bcp"
BIR_password="lt-bjs"
AS768_password="sd-dsm"
VAST_password="vn-otf"
FDM_password="sl-jfj"
IMGP_password="hs-ikf"
XRECON_password="pk-mgs"

# for beta testing
# Gmap_password="aa-aaa"
# Gxyz_password="aa-aaa"
# LCNMR_password="aa-aaa"
# Diff_password="aa-aaa"
# Stars_password="aa-aaa"
# Backproj_password="aa-aaa"
# CSI_password="aa-aaa"
# DOSY_password="aa-aaa"
# BIR_password="aa-aaa"
# AS768_password="aa-aaa"
# VAST_password="aa-aaa"
# FDM_password="aa-aaa"
# IMGP_password="aa-aaa"

taroption="xfBp"
cpoption="-rp"

ostype=`uname -s`
if [ x$ostype = "xLinux" ]
then
    ostype="Linux"
    Encodedir=$lnxproglib_dir/bin
    Convert="/usr/bin/convert"
elif [ x$ostype = "xInterix" ]
then
    ostype="Windows"
    Encodedir=$winproglib_dir/bin
    Convert=$winproglib_dir/bin/convert
    taroption="xfB"
    cpoption="-r"
    commondir="/dev/fs/P"
else
    x=`uname -r`
    if [ $x -ge 5.0 ]
    then
       ostype="SOLARIS"
       Convert="/vobj/sol/bin/convert"
    else
       ostype="SUNOS"
    fi
fi

#
# files needed for loading from cd
#
#
# subdirectories in destination directory
# VNMR:    aix, gemini, inova, unity files are unique to that system
#          common files are common to all systems (some do not apply to G2000)
#	   solaris files are common to gemini, inova, unity
#          unity/inova files are common to both inova, unity
#          unity/gemini files are common to both unity, gemini
# options: common files are in the top level
#          aix, gemini, files are unique to that system
#          solaris files are common to gemini, inova, unity
#	   unity files are for unity and/or inova
#
#The below line was removed from SubDirs= , just leave here for awhile
#until we remove the manual section from nvcdout.sh
#		acrobat			\

SubDirs="				\
		backproj		\
		backproj/unity		\
		common			\
		csi			\
		csi/unity		\
		diffuse			\
		gmap			\
		gnu			\
		imaging			\
		imaging/unity		\
		inova			\
		java			\
		lcnmr			\
		limnet			\
		limnet/aix		\
		limnet/solaris		\
		linux			\
		linux_i			\
		kermit			\
		kermit/solaris		\
		kermit/windows		\
		pfg			\
		pfg/common		\
		pfg/inova		\
		pfg/unity		\
		rht			\
		sol			\
		solaris			\
		solids			\
		stars			\
		stars/unity		\
		tmp			\
		uimaging		\
		uimaging/unity		\
		unity			\
		unity/inova		\
		vnmrs			\
		"

SubDirsWindows="                        \
		$SubDirs                \
		vnmrs                   \
		win			\
		win/bin                 \
		windows			\
		windows_i		\
		"

RmOptFiles="				\
		sol/inova.sol		\
		sol/inova.opt		\
		sol/vnmrs.sol		\
		sol/vnmrs.opt		\
		rht/inova.rht		\
		rht/inova.opt		\
		rht/vnmrs.rht		\
		rht/vnmrs.opt		\
		rht/mr400.rht		\
		rht/mr400.opt		\
		win/vnmrs.win		\
		win/vnmrs.opt		\
                win/mr400.win		\
		win/mv400.opt		\
		"
#
# PART I ---- Common File Definitions
#
# -- misc common files tarred into one tar file.
#  COM.TAR list of file in  com.tar 
ComTarLst="			\
	acq/acqi*		\
	acq/dgs*		\
	acq/info		\
	bootup_message		\
	conpar			\
	conpar.400mr		\
	devicenames		\
	devicetable		\
	dicom.cfg		\
	rc.vnmr			\
	solventlist		\
	solventppm		\
	solvents		\
	vnmrmenu		\
	"

nvAcqFiles="			\
	-C nvacq nvScript \
	-C nvacq nvScript.md5 \
	-C nvacq nvScript.ls \
	-C nvacq nvScript.ls.md5 \
	-C nvacq nvScript.solids \
	-C nvacq nvScript.solids.md5 \
	-C nvacq nvScript.rd \
	-C nvacq nvlib.o \
	-C nvacq nvlib.md5 \
	-C nvacq masterexec.o \
	-C nvacq rfexec.o \
	-C nvacq pfgexec.o \
	-C nvacq ddrexec.o \
	-C nvacq lockexec.o \
	-C nvacq gradientexec.o \
	-C nvacq masterexec.md5 \
	-C nvacq rfexec.md5 \
	-C nvacq pfgexec.md5 \
	-C nvacq ddrexec.md5 \
	-C nvacq lockexec.md5 \
	-C nvacq gradientexec.md5 \
	-C nvacq nddslib.o \
	-C nvacq nddslib.md5 \
        "

nvAcq3xFiles="			\
	-C nvacq3x nvScript \
	-C nvacq3x nvScript.md5 \
	-C nvacq3x nvScript.ls \
	-C nvacq3x nvScript.ls.md5 \
	-C nvacq3x nvScript.solids \
	-C nvacq3x nvScript.solids.md5 \
	-C nvacq3x nvScript.rd \
	-C nvacq3x nvlib.o \
	-C nvacq3x nvlib.md5 \
	-C nvacq3x masterexec.o \
	-C nvacq3x rfexec.o \
	-C nvacq3x pfgexec.o \
	-C nvacq3x ddrexec.o \
	-C nvacq3x lockexec.o \
	-C nvacq3x gradientexec.o \
	-C nvacq3x masterexec.md5 \
	-C nvacq3x rfexec.md5 \
	-C nvacq3x pfgexec.md5 \
	-C nvacq3x ddrexec.md5 \
	-C nvacq3x lockexec.md5 \
	-C nvacq3x gradientexec.md5 \
        "
# -- ndds 3.1x -----
nvAcq3xKernelFiles="
	      vxWorks405gpr.bdx	\
	      vxWorks405gpr.bdx.md5 \
        "

# -- ndds 4.1e -----
#nvAcqKernelFiles="
#	vxWorks405gpr.bdx_ndds4x	\
#	vxWorks405gpr.bdx.md5_ndds4x	\
#        "

# -- ndds 4.2e -----
nvAcqKernelFiles="
        vxWorks405gpr.bdx_ndds_4.2e     \
        vxWorks405gpr.bdx.md5_ndds_4.2e \
        "

# -- common bin script files to include on tape  
# --    remember bin is ar so name must 15 chars or less
# COMBIN.TAR List of file in combin.tar 
ComBinScripts2Tar="		\
	bin/Vn			\
	bin/bootr		\
	bin/calcramp		\
	bin/convertgeom         \
	bin/cryoclient		\
	bin/enter		\
	bin/getgroup            \
	bin/getuserinfo         \
	bin/isjpsgup		\
	bin/killft3d		\
	bin/killjpsg		\
	bin/killstat		\
	bin/loginpassword	\
	bin/loginpasswordcheck	\
	bin/loginpasswordVJ     \
	bin/makeuser		\
	bin/managelnxdev	\
	bin/psggen		\
        bin/patchinstall 	\
        bin/patchremove 	\
	bin/protopub		\
	bin/readbrutape		\
	bin/rvnmrj		\
	bin/rvnmrx		\
	bin/seqgen		\
	bin/setuserpsg		\
	bin/spingen		\
	bin/status		\
	bin/sudoins             \
	bin/tryquitjpsg         \
	bin/vbg			\
	bin/vjhelp              \
	bin/vnmr2sc		\
	bin/jdeluser		\
	bin/jvnmruser		\
	bin/jtestgroup		\
	bin/jtestuser		\
        bin/chksudocmd		\
	bin/vnmr_gs		\
	bin/vnmr_jplot		\
	bin/vnmr_accounting	\
	bin/vnmr_cdump		\
	bin/vnmr_color		\
	bin/vnmr_ihelp		\
	bin/vnmr_setgauss	\
	bin/vnmr_showfit	\
	bin/vnmr_singleline	\
	bin/vnmr_textedit	\
	bin/vnmr_uname		\
	bin/vnmr_usemark	\
	bin/vnmr_vi		\
	bin/vnmredit		\
	bin/vnmrlp		\
	bin/vnmrplot		\
	bin/vnmrprint		\
	bin/vnmrshell		\
	bin/wtgen		\
	bin/vxrTool		\
	bin/dicom_store		\
	bin/dicom_ping		\
	bin/protune		\
	"


ComDirs2Tar="			\
	asm				\
	cryo			\
	execpars		\
	fidlib			\
	fonts			\
	help 			\
	maclib 			\
	manual 			\
	menulib 		\
	nuctables		\
	probes			\
	satellites		\
	shimmethods		\
	shims			\
	"

P11Bin2Tar=" \
	-C $solproglib_dir/bin safecp	\
	-C $solproglib_dir/bin chVJlist	\
	-C $solproglib_dir/bin vnmrMD5	\
	-C $solproglib_dir/bin chchsums	\
	-C $solproglib_dir/bin writeAaudit	\
	-C $solproglib_dir/bin writeTrash	\
	-C $solproglib_dir/bin auditcp	\
	"

P11BinScripts2Tar="		\
	bin/auconvert		\
	bin/aureduce		\
	bin/auevent		\
	bin/auinit		\
	bin/aupurge		\
	bin/aupw		\
	bin/auredt		\
	bin/killau		\
	bin/killch		\
	bin/ckDaemon		\
	bin/S99scanlog		\
	bin/setupscanlog	\
	bin/scanlog		\
	bin/arAuditing		\
	"

P11Xml2Tar="	\
	-C $vcommondir/xml     accPolicy		\
	-C $vcommondir/xml     part11Config		\
	-C $vcommondir/xml     AdminMenu.xml.p11	\
	-C $vcommondir/xml     MainMenu.xml.p11		\
	-C $vcommondir/xml     MainMenuData.xml.p11	\
	-C $vcommondir/xml     MainMenuDisplay.xml.p11	\
	-C $vcommondir/xml     MainMenuUtil.xml.p11	\
	-C $vcommondir/xml     DefaultToolBar.xml.p11	\
	-C $vcommondir/xml     audit.xml		\
	-C $vcommondir/xml     saveas.xml		\
	-C $vcommondir/xml     cmdHis.xml		\
	-C $vcommondir/PART11  shuffler			\
	"

AdminFiles2Tar="			\
	automation.conf 		\
	rightsList.xml 			\
	appdirExperimental.txt 		\
	appdirImaging.txt 		\
	appdirLcNmrMs.txt 		\
	appdirWalkup.txt 		\
	AllLiquids.txt 			\
	AllLiquids.xml 			\
	BasicLiquids.txt 		\
	BasicLiquids.xml 		\
	AllSolids.txt 			\
	AllSolids.xml 			\
	protocolListWalkup.xml		\
        "

Solids_PS_2Tar="	\
	br24q		\
	c7inad2d	\
	hetcorlgcp2d	\
	lgcp		\
	mqmas3qzf2d	\
	mqmas5qzf2d	\
	mrev8q		\
	onepul		\
	onepultoss	\
	pisema2d	\
	redor1onepul	\
	redor1tancp	\
	redor2onepul	\
	redor2tancp	\
	ssecho1d	\
	swwhh4		\
	tancpht1	\
	tancpx		\
	tancpxecho	\
	tancpxflip	\
	tancpxfslg	\
	tancpxidref	\
	tancpxt1rho	\
	tancpxtoss	\
	tunerp		\
	twopul		\
	wisetancp2d	\
	wpmlg1d		\
	wpmlg2d		\
	xmx		\
	xx		\
	"

SolidsText2Tar="	\
	maclib		\
	manual		\
	parlib		\
	templates	\
	"

#
# PART II ---- Common File Definitions
#              Common to INOVA, UNITY
#
# -- par200 par300 par400 par500 par600 parlib, 
# --- i.e. par* are tarred as one tar file "par.tar".
# PAR.TAR
ComPar2Tar="			\
	upar/par200		\
	upar/par300		\
	upar/par400		\
	upar/par500		\
	upar/par600		\
	upar/par700		\
	upar/par750		\
	upar/par800		\
	upar/par900		\
	upar/parlib		\
	"

uComDirs2Tar="			\
	imaging			\
	shapelib		\
	tablib 			\
	"


#
# PART III --- Gemini, Inova, Unity
#
# -- binaries common to SunView & X-window to include in bin.tar file 
# -- bin.tar 
BinFiles2Tar="			\
	bin/compressfid		\
        bin/convertbru		\
	bin/createdicom		\
        bin/createdcm		\
        bin/dicomlpr		\
        bin/nmsalign		\
        bin/ptalign		\
        bin/cpos_cvt		\
        bin/decomp		\
	bin/diffparams		\
	bin/diffshims		\
	bin/dps_ps_gen		\
        bin/expandphase		\
        bin/expect		\
        bin/expfit		\
	bin/fdfgluer		\
	bin/fdfsplit		\
	bin/fileowner           \
	bin/findLinks           \
	bin/fitspec		\
	bin/ft3d		\
	bin/getplane		\
        bin/gin_setup		\
	bin/loginvjpassword	\
        bin/Probe_edit		\
        bin/readsctables	\
        bin/showstat		\
        bin/spins		\
        bin/tape		\
        bin/tek_setup		\
        bin/unix_vxr		\
	bin/usrwt.o		\
	bin/vnmr_confirmer	\
	bin/vxr_unix		\
	bin/weight.h		\
	bin/xdcvt		\
	bin/fontselect		\
	bin/convertcmx		\
	bin/nvlocki		\
	-C $solproglib_dir bin/safecp	\
	"

BinFilesPC2Tar="		\
	bin/PboxAdapter		\
	bin/Pbox		\
	bin/Pxfid		\
	bin/Pxsim		\
	bin/Pxspy		\
        bin/convertbru		\
        bin/cptoconpar		\
        bin/diffparams		\
        bin/diffshims		\
        bin/dps_ps_gen		\
        bin/expandphase		\
        bin/expfit		\
	bin/fileowner           \
        bin/findLinks		\
        bin/fitspec		\
        bin/loginvjpassword	\
        bin/readsctables	\
        bin/setGifAspect	\
        bin/spins		\
        bin/startmekillme	\
        bin/send2Vnmr		\
        bin/showconsole		\
	bin/usrwt.o		\
	bin/weight.h		\
	"

BinFilesLinux2Tar="            \
	$BinFilesPC2Tar        \
        bin/Probe_edit		\
        bin/pulsechild		\
        bin/pulsetool		\
	bin/nvlocki		\
	-C $lnxproglib_dir/stat Infostat	\
        -C $lnxproglib_dir/stat showstat	\
        -C $lnxproglib_dir/3D compressfid	\
        -C $lnxproglib_dir/3D ft3d	\
        -C $lnxproglib_dir/3D getplane	\
        -C $lnxproglib_dir/ib fdfgluer 	\
        -C $lnxproglib_dir/ib fdfsplit 	\
        -C $lnxproglib_dir/dicom createdicom 	\
        -C $lnxproglib_dir/dicom createdcm 	\
        -C $lnxproglib_dir/dicom dicomlpr 	\
	"

BinFilesWindows2Tar="            \
	$BinFilesPC2Tar          \
	bin/convert              \
	bin/logonAsService.exe   \
	bin/vnmr_exec_asuser     \
	bin/vnmrj.exe        \
	bin/vnmrj_adm.exe    \
	bin/vnmrj_debug.exe  \
	-C $winproglib_dir/3D compressfid           \
	-C $winproglib_dir/3D ft3d                  \
	-C $winproglib_dir/3D getplane              \
	-C $winproglib_dir/scripts groupadd         \
	-C $winproglib_dir/scripts isAdmin	\
	-C $winproglib_dir/scripts isroot           \
	-C $winproglib_dir/scripts useradd          \
	-C $winproglib_dir/scripts usermod          \
	-C $winproglib_dir/scripts userdel          \
	-C $winproglib_dir/scripts rundbsetup.bat   \
	-C $winproglib_dir/scripts runmanagedb.bat  \
	-C $winproglib_dir/scripts rundbdata.bat    \
	-C $winproglib_dir/scripts runasscript.vbs  \
	-C $winproglib_dir/scripts nopwdexp.vbs  \
	-C $winproglib_dir/scripts uninstallvj.bat  \
	-C $winproglib_dir/stat Infostat	\
        -C $winproglib_dir/nvlocki nvlocki	\
	"

#        -C $winproglib_dir/stat showstat	\

TclLibs2Tar="			\
	lib/libtcl.so		\
	lib/libtcl*.so		\
	lib/libtk.so		\
	lib/libtk*.so		\
	lib/libBLT*		\
	lib/libtix.so		\
	lib/libtix*.so		\
	lib/libtbcload13.so	\
	"

TclLibsLinux2Tar="		\
	-C $vcommondir/tclPro1.5.lnx/linux-ix86 lib/libtbcload1.3.so	\
	-C $vcommondir/BLT/linux lib/libBLT24.so			\
	-C $vcommondir/BLT/linux lib/libBLT24.so.8.4			\
	"

TclLibsWindows2Tar="		\
	-C $vcommondir/tcl.8.4.win lib/libtbcload*.so	\
	"

PboxBin2Tar="			\
	bin/Pbox		\
	bin/Pxfid		\
	bin/Pxsim		\
	bin/Pxspy		\
	bin/PboxAdapter		\
	"

/* this may still be more than needed */
NDDSwxpLibs2Tar="				\
	-C $wxpNDDSlibDir	libndds.dll	\
        -C $wxpNDDSlibDir       libnddscdr.dll	\
        -C $wxpNDDSlibDir       libnddsdiag.dll	\
        -C $wxpNDDSlibDir       libnddsutils.dll	\
        -C $wxpNDDSlibDir       libutilsxx.dll	\
        -C $wxpNDDSlibDir       libutilsip.dll	\
	"


NDDSLinux2Tar="					\
	-C $lnxNDDSlibDir	libndds.so	\
	-C $lnxNDDSlibDir	libnddsutils.so	\
	-C $lnxNDDSlibDir	libnddscdr.so	\
	-C $lnxNDDSlibDir	libutilsxx.so	\
	-C $lnxNDDSlibDir	libutilsip.so	\
	"

# -- binary X-Windows base programs to include in binx.tar file 
# -- binx.tar 
BinX2Tar="			\
	bin/Vnmr	  	\
	bin/pulsetool		\
	bin/pulsechild		\
	bin/Acqstat		\
	bin/Infostat		\
	bin/Acqmeter		\
	bin/convert		\
	bin/gs			\
	-C $vcommondir/tape_sol app-defaults/Vnmr	\
	-C $vcommondir/tape_sol app-defaults/XTerm	\
	-C $vcommondir/tape_sol app-defaults/PulseTool	\
	-C $vcommondir/tape_sol app-defaults/Status	\
	-C $vcommondir/tape_sol app-defaults/Enter	\
	-C $vcommondir/tape_sol app-defaults/Dg		\
	"

Gs2Tar="	\
	gs	\
	"


TclWin2Tar="		\
	bin			\
	bltlibrary		\
	tcllibrary		\
	tklibrary		\
	"

Tcl2Tar="			\
	tcl/bin			\
	tcl/bltlibrary		\
	tcl/tcllibrary		\
	tcl/tixlibrary		\
	tcl/tklibrary		\
	"

TclMore="			\
	vnmrwish		\
	"

# Accouting 
Acct2Tar="					\
	-C $vcommondir adm/bin/acc_vnmr		\
	-C $vcommondir adm/bin/console_acct	\
	-C $vcommondir adm/bin/update_acctng	\
	-C $vcommondir adm/bin/view_acctng	\
	-C $vcommondir adm/bin/xcal		\
	-C $vcommondir adm/accounting		\
	-C $vcommondir adm/log			\
	-C $vcommondir adm/tmp			\
	"

UserTempl2Tar="			\
	user_templates		\
	"

GmapText2Tar="			\
	help			\
	maclib			\
	manual			\
	menulib			\
	"

GmapPars2Tar="			\
	parlib			\
	"

ProtuneText2Tar="		\
	maclib			\
	manual			\
	templates		\
	tune			\
	"

#
# PART IV --- Inova
#
# -- Inova libraries used by the Pulse Sequencies 
# --- psg.tar 
PsgLib2Tar="				\
	nvpsg/libpsglib.a		\
        nvpsg/libparam.a       		\
	nvpsg/libpsglib.so.$psg_so_ver	\
	nvpsg/libparam.so.$psg_so_ver	\
        nvpsg/libparam.so       	\
        nvpsg/libpsglib.so      	\
        nvpsg/x_ps.o			\
	"

PsgLibWin2Tar="				\
	nvpsg/libpsglib.a		\
        nvpsg/libparam.a       		\
        nvpsg/x_ps.o			\
	"

PsgLibLinux2Tar=$PsgLib2Tar

WobbleText="			\
	tune			\
	"

WobbleExec="			\
	bin/autoshim		\
	"

# -- acquisition files tarred into one tar file.
#  list of file in  acq.tar 
AcqTarLst="			\
	acq/xrxrh.out		\
	acq/xrxrp.out		\
	acq/xrop.out		\
	acq/rhmon.out		\
	acq/autshm.out		\
	acq/xr.conf		\
	"

#
# PART  --- Inova 
#
PS_2Tar="		\
	APT		\
	AdequateAD	\
	CIGAR		\
	CIGAR2j3j	\
	COSY		\
	DEPT		\
	DQCOSY		\
	HETCOR		\
	HMBC		\
	HMQC		\
	HMQC_d2		\
	HMQCTOXY	\
	HMQCTOXY_d2	\
	HOMO2DJ		\
	HOMODEC		\
	HSQC		\
	HSQC_d2		\
	HSQCAD		\
	HSQCTOXY	\
	HSQCTOXY_d2	\
	NOESY		\
	NOESY1D		\
	PRESAT		\
	PWXCAL		\
	ROESY		\
	ROESY1D		\
	T1meas		\
	T2meas		\
	TOCSY		\
	TOCSY1D		\
	binom		\
	clubhsqc	\
	cosyps		\
	cpmgt2		\
	cyclenoe	\
	d2pul		\
	gmapz		\
	hcchtocsy	\
	het2dj		\
	hetcor		\
	hetcorps	\
	hmqctoxy3d	\
	hom2dj		\
	hsqcHT		\
	hsqctoxySE	\
	inadqt		\
	inept		\
	jumpret		\
	mqcosy		\
	mrseq		\
	mrsim		\
	mtune		\
	aptunenv	\
	ppcal		\
	presat		\
	pwxcal		\
	relayh		\
	s2pul		\
	selexcit	\
	sh2pul		\
	tncosyps	\
	tndqcosy	\
	tnmqcosy	\
	tnnoesy		\
	tnroesy		\
	tntocsy		\
	tocsyHT		\
	troesy		\
	wetdqcosy	\
	wetnoesy	\
	wetpwxcal	\
	wetrelayh	\
	wettntocsy	\
	wfgtest		\
	"

#	apt		\
#	dept		\
#	dqcosy		\
#	hmqc		\
#	hmqctocsy	\
#	hsqc		\
#	noesy		\
#	roesy		\
#	tocsy		\

#	br24		\
#	cylbr24		\
#	cylmrev		\
#	flipflop	\
#	hetcorcp1	\
#	mrev8		\
#	redor1		\
#	ssecho		\
#	ssecho1		\
#	xnoesysync	\

ProcFam="                       \
        acqbin/nAutoproc        \
        acqbin/Procproc         \
        acqbin/Roboproc         \
        acqbin/Atproc           \
        bin/catcheaddr          \
        bin/findedevices        \
        bin/iiadisplay          \
        bin/send2Vnmr           \
	-C $solproglib_dir/nvexpproc	Expproc		\
	-C $solproglib_dir/nvrecvproc	Recvproc	\
	-C $solproglib_dir/nvsendproc	Sendproc	\
	-C $solproglib_dir/nvinfoproc/sol	Infoproc	\
	-C $solproglib_dir/nvflash	flashia3x	\
	-C $solproglib_dir/nvflash	consoledownload3x	\
	-C $solproglib_dir/nvflash	flashia4x	\
	-C $solproglib_dir/nvflash	consoledownload4x	\
        -C $vcommondir/tape_sol app-defaults/Acqi       \
        "

iProcFam="			\
	acq/tms320dsp.ram       \
	acq/vwAutoScript        \
	bin/ihwinfo             \
	bin/vconfig             \
        -C $vcommondir/tape_sol  app-defaults/Config 	\
	-C $vcommondir 		 spincad		\
        "

iProcLinuxFam="			\
	acq/tms320dsp.ram       \
	acq/vwAutoScript        \
	acq/vwScript		\
	acq/vwScriptPPC		\
	-C $lnxproglib_dir/nautoproc	Autoproc	\
	-C $lnxproglib_dir/nvexpproc	Expproc		\
	-C $lnxproglib_dir/nvinfoproc	Infoproc	\
	-C $lnxproglib_dir/procproc	Procproc	\
	-C $lnxproglib_dir/nvrecvproc	Recvproc	\
	-C $lnxproglib_dir/roboproc	Roboproc	\
	-C $lnxproglib_dir/nvsendproc	Sendproc	\
	-C $lnxproglib_dir/atproc	Atproc		\
        -C $lnxproglib_dir/nvflash      testconf3x	\
        -C $lnxproglib_dir/nvflash      flashia3x	\
        -C $lnxproglib_dir/nvflash      flashia42x	\
        -C $lnxproglib_dir/nvflash      consoledownload3x \
        -C $lnxproglib_dir/nvflash      consoledownload42x \
        -C $lnxproglib_dir/nvflash      testconf42x	\
	-C $vcommondir spincad				\
        "

iProcWindowsFam="			\
	acq/tms320dsp.ram       \
	acq/vwAutoScript        \
	acq/vwScript		\
	acq/vwScriptPPC		\
	-C $winproglib_dir/nautoproc	Autoproc	\
	-C $winproglib_dir/nvexpproc	Expproc		\
	-C $winproglib_dir/nvinfoproc	Infoproc	\
	-C $winproglib_dir/procproc	Procproc	\
	-C $winproglib_dir/nvrecvproc	Recvproc	\
	-C $winproglib_dir/roboproc	Roboproc	\
	-C $winproglib_dir/nvsendproc	Sendproc	\
	-C $winproglib_dir/atproc	Atproc		\
        -C $winproglib_dir/nvflash      flashia		\
        "

Pbox2Tar="		\
	help		\
	wavelib		\
	"

iLibs2Tar="					\
	ncomm/libacqcomm.a			\
	ncomm/libacqcomm.so			\
	ncomm/libacqcomm.so.$ACQCOMM_VER6	\
	ncomm/libncomm.a			\
	ncomm/libncomm.so			\
	ncomm/libncomm.so.$NCOMM_VER		\
	dicom/dicom.dic				\
	"

iLibsLinux2Tar="				\
	ncomm/libacqcomm.so			\
	ncomm/libacqcomm.so.$ACQCOMM_VER6	\
	ncomm/libncomm.so			\
	ncomm/libncomm.so.$NCOMM_VER		\
	"

iLibsWindows2Tar="				\
	ncomm/libacqcomm.so			\
	ncomm/libacqcomm.so.$ACQCOMM_VER6	\
	ncomm/libncomm.so			\
	ncomm/libncomm.so.$NCOMM_VER		\
	"

Cryo2Tar="				 \
	-C $commondir/syscryo	cryo.jar \
	"

Apt2Tar="				\
	java/apt.jar			\
	"

Jplot2Tar="				\
	java/jplot.jar			\
	"

Jpsg2Tar=" \
	-C $commondir/sysjpsg Jpsg			\
	-C $commondir/sysjpsg PSGGo.cps			\
	-C $commondir/sysjpsg PSGSetup.cps		\
	-C $commondir/sysjpsg PSGscan.cps		\
	-C $commondir/sysjpsg PSGerrors.properties	\
	-C $commondir/sysjpsg lib/Jpsg.jar		\
	"

VnmrJJar2Tar=" \
        -C $commondir/sysvnmrj vnmrj.jar			\
        -C $commondir/sysvnmrj vnmrj.jar.dasho			\
        -C $commondir/sysvnmrj libvnmrj.so			\
        -C $vcommondir/vnmrj   libSolarisSerialParallel.so	\
	"

VnmrJJarLinux2Tar=" \
        -C $commondir/sysvnmrj    vnmrj.jar		\
        -C $commondir/sysvnmrj    vnmrj.jar.dasho	\
	"

VnmrJJarWindows2Tar=" \
        -C $commondir/sysvnmrj    vnmrj.jar		\
        -C $commondir/sysvnmrj    vnmrj.jar.dasho	\
	"

VnmrJAdm2Tar=" \
        -C $vcommondir/xml grouplist.xml	\
        -C $vcommondir/xml userlist.xml		\
        -C $vcommondir/xml userDefaults		\
	-C $vcommondir/xml userDefaults.win	\
	-C $vcommondir/xml userlist.xml.win	\
	"

VnmrJAdmJar2Tar=" \
        -C $commondir/sysadmin    VnmrAdmin.jar		\
        -C $commondir/sysmanagedb managedb.jar		\
        -C $commondir/sysmanagedb managedb.jar.dasho	\
	"

VnmrJBin2Tar=" \
        -C $commondir/sysscripts S99pgsql      	\
        -C $commondir/sysscripts vnmrj         	\
        -C $vcommondir/bin       managedb	\
        -C $vcommondir/bin       dbsetup	\
        -C $vcommondir/bin       dbupdate	\
        "

VnmrJPgsql2Tar=" \
        -C $vcommondir      pgsql/bin		\
        -C $vcommondir      pgsql/lib		\
        -C $vcommondir      pgsql/share		\
	-C $vcommondir/bin  create_pgsql_user	\
	-C $vcommondir	    shuffler		\
	"

VnmrJPgsqlLinux2Tar=" \
        -C $vcommondir     pgsql.lnx/bin	\
        -C $vcommondir     pgsql.lnx/lib	\
        -C $vcommondir     pgsql.lnx/share	\
	-C $vcommondir/bin create_pgsql_user	\
	-C $vcommondir	   shuffler		\
	"

VnmrJPgsqlWindows2Tar=" \
        -C $vcommondir     pgsql.win/bin	\
        -C $vcommondir     pgsql.win/lib	\
        -C $vcommondir     pgsql.win/share	\
	-C $vcommondir/bin create_pgsql_user	\
	-C $vcommondir	   shuffler		\
	"

VnmrJ2Tar=" \
        -C $vcommondir/vnmrj maclib		\
        -C $vcommondir       menujlib		\
	"

VnmrsVnmrJTempl2Tar=" \
        -C $vcommondir templates_vnmrs/vnmrj	\
	"

VnmrJTempl2Tar=" \
        -C $vcommondir templates/layout		\
        -C $vcommondir templates/vnmrj		\
        -C $vcommondir templates/themes		\
	"

VnmrJProperties2Tar=" \
        -C $vcommondir/xml cmdResources.properties	\
        -C $vcommondir/xml paramResources.properties	\
        -C $vcommondir/xml filename_templates		\
        -C $vcommondir/xml studyname_templates		\
        -C $vcommondir/xml recConfig			\
        -C $vcommondir/xml labelResources.list		\
        -C $vcommondir/xml labelResources2.list	\
        -C $vcommondir/xml vjLabels.list		\
        -C $vcommondir/xml vjAdmLabels.list		\
        -C $vcommondir/xml tooltipResources.list	\
        -C $vcommondir/xml messageResources.list	\
        "

ChineseFiles2Tar="	\
        -C $vcommondir/xml labelResources_zh_CN.properties	\
        -C $vcommondir/xml labelResources2_zh_CN.properties	\
        -C $vcommondir/xml vjLabels_zh_CN.properties		\
        -C $vcommondir/xml vjAdmLabels_zh_CN.properties	\
        -C $vcommondir/xml tooltipResources_zh_CN.properties	\
        -C $vcommondir/xml messageResources_zh_CN.properties	\
        -C $vcommondir/xml paramResources_zh_CN.properties	\
        "

JapaneseFiles2Tar="	\
        -C $vcommondir/xml labelResources_ja.properties	\
        -C $vcommondir/xml labelResources2_ja.properties	\
        -C $vcommondir/xml vjLabels_ja.properties		\
        -C $vcommondir/xml vjAdmLabels_ja.properties	\
        -C $vcommondir/xml tooltipResources_ja.properties	\
        -C $vcommondir/xml messageResources_ja.properties	\
        -C $vcommondir/xml paramResources_ja.properties	\
        "

VJMolJar2Tar=" \
	-C $sourcedir/sysvnmrj		jmol.jar	\
        -C $sourcedir/sysvnmrj          vjmol.jar	\
	-C $vcommondir                  mollib		\
	"

VJChemPaintJar2Tar=" \
	-C $vcommondir                  jchempaint.jar	\
	"

VJAccountsJar2Tar=" \
	-C $sourcedir/sysjaccount	account.jar		\
	-C $sourcedir/sysjaccount	account.jar.dasho	\
	"

Walkup2Tar=" \
        -C $vcommondir/WALKUP walkup	\
	"

UniBinScripts2Tar="		\
	bin/adddevices		\
	bin/execkillacqproc	\
	bin/fixpsg		\
	bin/makesuacqproc	\
	bin/setether		\
	bin/setnoether		\
	bin/vnmr_spinner	\
	bin/vnmr_temp		\
	bin/loadkernel		\
	bin/rmipcs		\
        "

#
# PART XI --- Options 
#

Dialog2Tar="		\
	dialoglib	\
	"
#--- directories from PFG common to inova, unity go into tar file
# common pfg.tar
ComPFG2Tar="			\
	parlib			\
	maclib			\
	manual			\
	"

#---- Autotest pulse sequences
Autotest_PS_2Tar="AT_lkdec	\
	ATB1profile	\
	ATCNnoesy	\
	ATcancel	\
	ATcpmgt2	\
	ATd2pul		\
	ATdante		\
	ATddec		\
	ATdsh2pul	\
	ATfsqd		\
	ATg2pul		\
	ATgNhmqc	\
	ATgcancel	\
	ATgecho		\
	ATphswitch	\
	ATphtest	\
	ATprofile	\
	ATrfhomo	\
        "

#---- PFG binaries to tar, the list is used by  unity/inova
#                          although three tar-files are created.
# --- pfg.tar 
PFG_PS_2Tar="g2pul	\
	g2pul_ecc	\
	gCOSY		\
	gDQCOSY		\
	gHETCOR		\
	gHMBC		\
	gHMBCAD		\
	gHMQC		\
	gHMQC_d2		\
	gHMQCTOXY	\
	gHSQC		\
	gHSQC_d2		\
	gHSQCAD		\
	gHSQCTOXY	\
	gXHCAL		\
	ghmqcps		\
	ghsqc		\
	gmqcosy		\
	gnoesy		\
	gtnnoesy		\
	gtnroesy		\
	hsqcHT		\
	profile		\
	selexHT		\
	tocsyHT		\
	wetgcosy		\
	wetghmqc		\
	wetghmqcps	\
	wetghsqc		\
	wetgmqcosyps	\
	wet1D	\
	wetNOESY		\
	wetROESY		\
	wetTOCSY		\
	wetgCOSY		\
	wetgDQCOSY	\
	wetgHMBC		\
	wetgHMQC		\
	wetgHSQC		\
	"


#	gcosy		\
#	ghmqc		\
#	ghsqc		\
#	wet1d		\

#--- directories from PFG common to go into tar file
# pfg.tar
gComPFG2Tar="			\
	parlib			\
	maclib			\
	manual			\
	"

#---- gPFG binaries to tar
# --- pfg.tar 
gBinPFG2Tar="gseqlib/g2pul	\
	gseqlib/gcosy		\
	gseqlib/ghmqc		\
	gseqlib/gmqcosy		\
	gseqlib/gnoesy		\
	gseqlib/profile		\
	"

kBinPFG2Tar="                   \
        kseqlib/gCOSY           \
        kseqlib/gDQCOSY         \
	kseqlib/gHETCOR		\
        kseqlib/gHMBC           \
        kseqlib/gHMQC           \
        kseqlib/gHMQCTOXY       \
        kseqlib/gHSQC           \
        kseqlib/gHSQCTOXY       \
        kseqlib/gXHCAL          \
        kseqlib/g2pul           \
        kseqlib/gcosy           \
        kseqlib/ghmqc           \
        kseqlib/glrinept        \
	kseqlib/gmapz		\
        kseqlib/gmqcosy         \
        kseqlib/gnoesy          \
        kseqlib/p2pul		\
        kseqlib/profile         \
        "

#--- directories from kermit common to go into tar file
# kermit.tar
ComKermit2Tar="			\
	kermit/kermit.doc	\
	"

Bin4Kermit2Tar="		\
	kermit/kermit_sol	\
	"

ComWindowsKermit2Tar="			\
	Kermit.XP_version/KERMIT.HLP	\
	"

BinWindows4Kermit2Tar="		\
	Kermit.XP_version/KERMIT.EXE	\
	Kermit.XP_version/MSKERMIT.INI	\
	"

# ------ GNU C Compiler Files files  ---------------
# gnu.tar 
#               gnu/cygnus-sol2-2.0
GNU4Solaris2Tar="		\
        gnu			\
	"
#--- directories from IMAGE common to go into tar file
# image.tar
ComIMAGE2Tar="			\
	CoilTable		\
	fidlib			\
	help			\
	maclib			\
	menulib			\
	nuctables		\
	pulsecal		\
	shapelib		\
	src			\
	tablib			\
	vnmrmenu		\
	imaging			\
	bin			\
        -C tape_sol user_templates      \
	-C $vcommondir/tape_sol app-defaults/EccTool	\
	"
#--- directories from IMAGE unique to VNMRS to go in tar file
VnmrsIMAGE2Tar="		\
	imaging_vnmrs		\
	parlib_vnmrs		\
	parlib_ATP_vnmrs		\
	"

#-- directories from IMAGE2 for HEI sequences
ComIMAGE22Tar="			\
	maclib			\
	"

Dicom2Tar_lnx="			\
	dicom_lnx			\
	"

Dicom2Tar="			\
	dicom			\
	"

#---- IMAGE binaries to tar
# --- image.tar 
BinIMAGE2Tar="			\
	bin/browser		\
	bin/cptoconpar		\
	bin/beccphase		\
	bin/eccdiff		\
	bin/eccdisp		\
	bin/eccphase		\
	bin/eccsend		\
	bin/eccTool		\
	bin/feccphase		\
	bin/fm_calshim		\
	bin/fm_shuffle		\
	bin/ib_ui		\
	bin/ib_graphics		\
	bin/imcalc		\
	bin/imfit		\
	bin/log_mag		\
	bin/plane_decode	\
	bin/rmsAddData		\
	bin/setGifAspect	\
	bin/tabc		\
	bin/disp3d		\
	bin/gsadd		\
	bin/gsbinmulti		\
	bin/gsbin		\
	bin/gsdiff		\
	bin/gsfield		\
	bin/gsft		\
	bin/gsft2d		\
	bin/gsmapmask		\
	bin/gsmean		\
	bin/gshimcalc		\
	bin/gsphdiff		\
	bin/gsphcheck		\
	bin/gsphtofield		\
	bin/gsreformat		\
	bin/gsregrid		\
	bin/gsremap		\
        bin/gscale		\
        bin/gsign		\
	bin/gsvtobin		\
	lib/libddl.a		\
	lib/libddl.so		\
	lib/libddl.so.*		\
	lib/libf2c.a		\
	lib/libf2c.so		\
	lib/libf2c.so.*		\
	lib/libmagical.so	\
	lib/libmagical.so.*	\
	lib/libport3.a		\
	lib/libport3.so		\
	lib/libport3.so.*	\
	"
LibLinuxIMAGE2Tar="			\
	lib/libddl.a		\
	lib/libddl.so		\
	lib/libddl.so.*		\
	lib/libf2c.a		\
	lib/libf2c.so		\
	lib/libf2c.so.*		\
	lib/libmagical.so	\
	lib/libmagical.so.*	\
	lib/libport3.a		\
	lib/libport3.so		\
	lib/libport3.so.*	\
        "

BinLinuxIMAGE2Tar="				\
        -C $lnxproglib_dir/ib browser 		\
        -C $lnxproglib_dir/ib ib_ui 		\
        -C $lnxproglib_dir/ib ib_graphics 	\
        -C $lnxproglib_dir/3Dimg disp3d 	\
	-C $lnxproglib_dir/bin gsadd		\
	-C $lnxproglib_dir/bin gsbinmulti	\
	-C $lnxproglib_dir/bin gsbin		\
	-C $lnxproglib_dir/bin gsdiff		\
	-C $lnxproglib_dir/bin gsfield		\
	-C $lnxproglib_dir/bin gsft		\
	-C $lnxproglib_dir/bin gsft2d		\
	-C $lnxproglib_dir/bin gsmapmask	\
	-C $lnxproglib_dir/bin gsmean		\
	-C $lnxproglib_dir/bin gshimcalc	\
	-C $lnxproglib_dir/bin gsphdiff		\
	-C $lnxproglib_dir/bin gsphcheck	\
	-C $lnxproglib_dir/bin gsphtofield	\
	-C $lnxproglib_dir/bin gsreformat	\
	-C $lnxproglib_dir/bin gsregrid		\
	-C $lnxproglib_dir/bin gsremap		\
        -C $lnxproglib_dir/bin gscale		\
        -C $lnxproglib_dir/bin gsign		\
	-C $lnxproglib_dir/bin gsvtobin		\
	-C $lnxproglib_dir/bin tabc		\
	"

BinWindowsIMAGE2Tar="			\
	lib/libddl.a		\
	lib/libddl.so		\
	lib/libddl.so.*		\
	lib/libf2c.a		\
	lib/libf2c.so		\
	lib/libf2c.so.*		\
	lib/libmagical.so	\
	lib/libmagical.so.*	\
	lib/libport3.a		\
	lib/libport3.so		\
	lib/libport3.so.*	\foreach 
        -C $winproglib_dir/3Dimg disp3d 	\
	"

IMAGE_PS_2Tar=" 	\
	GDACtest	\
	ecc1		\
	flair		\
	fsems_22c      \
	mems_22c       \
	ge3dshim	\
	gsh2pul		\
	mgems		\
	prescanfreq	\
	stems		\
	vnmrs_adcpuls	\
	vnmrs_asl	\
	vnmrs_cpmg	\
	vnmrs_cpmgecho	\
	vnmrs_csi2d	\
	vnmrs_ct3d	\
	vnmrs_essfp	\
	vnmrs_epi	\
	vnmrs_fse3d	\
	vnmrs_fsems	\
	vnmrs_fsemsdw	\
	vnmrs_fssfp	\
	vnmrs_ge3d	\
	vnmrs_ge3dshim	\
	vnmrs_isis	\
	vnmrs_mems	\
	vnmrs_prescanpower	\
	vnmrs_press	\
	vnmrs_profile1d	\
	vnmrs_quickshim	\
	vnmrs_se3d	\
	vnmrs_sems	\
	vnmrs_semsdw	\
	vnmrs_spuls	\
	vnmrs_stepuls	\
	vnmrs_tssfp	\
	vnmrs_t1puls	\
	vnmrs_t2puls	\
	vnmrs_tagcine	\
	"

#removed because of patent issues
#	seqlib/gems		\
#	seqlib/steam		\
#	seqlib/steami		\

UserLib2Tar="			\
	userlib			\
	"

WinSetacq2Tar="        \
        bin             \
        acqbin          \
        tftpserver      \
        "

 
# PART XII --- Passworded options 
 
Diffus2Tar="			\
	maclib			\
	manual			\
	parlib			\
	"

Diffus_PS_2Tar="			\
	g2pulramp	\
	pge		\
	pgeramp		\
	"

DOSY_PS_2Tar="          \
        Dbppste         \
        Dbppste_cc      \
        Dbppste_ghsqcse \
        Dbppste_wg      \
        Dbppsteinept    \
        Dcosyidosy      \
        DgcsteSL        \
        DgcsteSL_cc     \
        DgcsteSL_dpfgse \
        Dgcstecosy      \
        Dgcstehmqc      \
        Dgcstehmqc_ps   \
        Dghmqcidosy     \
        DgsteSL_cc      \
        Dhom2djidosy    \
        Doneshot        \
        Dpfgdste        \
        "

LCNMR2Tar="			\
	lc			\
	maclib			\
	manual			\
	menulib			\
	parlib			\
	shapelib		\
	tablib			\
	"

BinSTARSSol2Tar="		\
	-C $vcommondir/STARS/tape_sol	bin	\
	"

TextSTARS2Tar="			\
	maclib			\
	menulib			\
	templates		\
	"

ComBackproj2Tar="		\
	parlib			\
	maclib			\
	"

BinBackproj2Tar="		\
	bp_2d		\
	bp_3d		\
	bp_ball		\
	bp_mc		\
	bp_sort		\
	"

ComCSI2Tar="			\
	manual			\
	parlib			\
	maclib			\
	imaging			\
	-C tape_sol user_templates	\
	"

BinCSI2Tar="		\
	bin/csi		\
	bin/P_csi	\
	"

Fdm2Tar="		\
	fidlib		\
	manual		\
	"

FdmBin2Tar="		\
	bin/fdm1	\
	bin/fdm2	\
	"

FdmLinux2Tar="	\
	-C $lnxproglib_dir/fdm fdm1	\
	-C $lnxproglib_dir/fdm fdm2	\
	"

#--- directories from IMAGE_patent. Passworded.
ImagePatentFiles="		\
	imaging			\
	maclib			\
	"

VnmrsImagePatentFiles="		\
	imaging_vnmrs		\
	parlib_vnmrs		\
	"


PATENT_PS_2Tar="		\
	vnmrs_steam		\
	vnmrs_gems		\
	vnmrs_gemsir		\
	vnmrs_gemsshim		\
	vnmrs_sgems		\
        "

#	steamcsi		\	for now
#	steami			\	for now
#
# PART XVI --- Installation files and scripts
#
LoadFiles="			\
		loadcd		\
		setup		\
		i_vnmr4		\
		readme.txt	\
		"

LoadDecodeBin="			\
		ejectthecdrom	\
		decode.sol	\
		"

LoadSolFilesBin="		\
		decode.sol	\
		ins.sol		\
		send.sol	\
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
      if [ $ShowPermResults -gt 0 ]
      then
         echo "" 
      fi
      indent=0
   else
      indent=$5
   fi
   
   pars=`(cd $1; ls)`
   for setpermfile in $pars
   do
      #indent to proper place
      if [ $ShowPermResults -gt 0 ]
      then
         spaces=$indent
         pp=""
         while [ $spaces -gt 0 ]
         do
           pp='.'$pp
           spaces=`expr $spaces - 1`
         done
      fi
   
      #test for director, file, executable file
      if [ -d $1/$setpermfile ]
      then
         if [ $ShowPermResults -gt 0 ]
         then
            echo "${pp}chmod $dirperm $setpermfile/"
         fi
         chmod $dirperm $1/$setpermfile
         if [ $ShowPermResults -gt 0 ]
         then
            indent=`expr $indent + 4`
         fi
         setperms $1/$setpermfile $dirperm $fileperm $execperm $indent
         indent=`expr $indent - 4`
      elif [ -f $1/$setpermfile ]
      then
         if [ -x $1/$setpermfile ]
         then
            if [ $ShowPermResults -gt 0 ]
            then
                echo "${pp}chmod $execperm $setpermfile*"
            fi
            chmod $execperm $1/$setpermfile
         else
            if [ $ShowPermResults -gt 0 ]
            then
               echo "${pp}chmod $fileperm $setpermfile"
            fi
            chmod $fileperm $1/$setpermfile
         fi
      else
         echo file:  $1/$setpermfile not modified
      fi
   done
}

set_size_name() {

    Pwd=`pwd`
    cd $dest_dir_code/$1
    if [ x$ostype = 'xSOLARIS' ]
    then
       size_name=`du -k -L -s $2`
    else
       size_name=`du -s $2`
    fi
    tarFileSize=`echo $size_name | awk 'BEGIN { FS = " " } { print $1 }'`
    tarFileName=`echo $size_name | awk 'BEGIN { FS = " " } { print $2 }'`
    cd $Pwd
}

#   set_size_name $Common com.tar
#   make_toc $Common "VNMR" sol/unity.sol        \
#---------------------------------------------------------------------------
#
#This routine is the combination of the previous set_size_name() and make_toc()
#usage: make_TOC  <tarfile>  <dirname>  <category>  <TOCfile TOCfile ...>
#
#	tarfile:   com.tar, jre.tar ..., these are actual NMR sofware packages
#       dirname:   sol, inova ..., directory names which are under $dest_dir_code
#       category:  VNMR, Gradient_shim, userlib ..., Nmr package names to be selected 
#							when loading Nmr software
#	TOCfile:   sol/inova.sol, /sol/unity.sol, ..., these files contain
#					a list of needed sofware for particular system
make_TOC()
{
   ( #usage: make_TOC  <tarfile>  <dirname>  <category>  <TOCfile TOCfile ...>
     tfile=$1
     shift
     dir=$1
     shift
     cat=$1
     shift
     flist=$*

     cd $dest_dir_code/$dir

     #########################################################
     #Solaris 9 special, for some reason -L does not work here
     #########################################################
     if [ x`uname -r` = "x5.9" ]
     then
          size_name=`du -sk $tfile`
     else
          if [ x$ostype = "xSOLARIS" ]
          then
             size_name=`du -k -L -s $tfile`
          else
             size_name=`du -s $tfile`
          fi
     fi

     tarSize=`echo $size_name | awk 'BEGIN { FS = " " } { print $1 }'`
     tarFileName=`echo $size_name | awk 'BEGIN { FS = " " } { print $2 }'`
     cd $Pwd

     for i in $flist
     do
        echo "$cat       $tarSize    $Code/$dir/$tarFileName" >> $dest_dir_code/$i
        systemname=`basename $i`
        #log_this "`basename $systemname`"
        nnl_echo "  $systemname" | tee -a $log_file
     done
     rm -rf $dest_dir_code/tmp/*
   )
}

nnl_echo() {
    
    case x$ostype in

	"x")
            echo "error in echo-no-new-line: ostype not defined"
            exit 1
            ;;

        "xSOLARIS")
            echo "$*\c"
            ;;

        "xLinux")
            echo -n "$*"
            ;;

        *)
            echo -n "$*"
            ;;
    esac
}

log_this(){

   if [ ! -d $dest_dir_code/tmp ]
   then
       mkdir -p $dest_dir_code/tmp
   else
       rm -rf $dest_dir_code/tmp/*
   fi

   echo "" | tee -a $log_file
   echo "" | tee -a $log_file
   nnl_echo "$1" | tee -a $log_file
}

findcore() {
   find . -name core -exec rm {} \;
}

create_support_dirs () {

   cd $1
   nnl_echo "$Code " | tee -a $log_file
   if [ ! -d $Code ]
   then
      mkdir $Code
   fi
   cd $Code
   dirs=$SubDirs
   if [ x$winbuild = "xtrue" ]
   then
      dirs=$SubDirsWindows
   fi
   for file in $dirs
   do
      nnl_echo "$file " | tee -a $log_file
      if [ ! -d $file ]
      then
         mkdir $file
      fi
   done
   echo "" | tee -a $log_file
   echo "" | tee -a $log_file
   echo "Clearing *.opt files and tmp:" | tee -a $log_file
   cd $dest_dir_code
   for file in $RmOptFiles
   do
      nnl_echo "$file " | tee -a $log_file
      rm -rf $file
      touch $file
   done
   rm -rf $dest_dir_code/tmp/*
}                                                                                                 
drop_vnmrs_ () {
   vnmrs_list=`ls vnmrs_*`
   for file in $vnmrs_list 
   do
      newfln=`echo $file | cut -c7-`
      rm -f $newfln
      mv $file $newfln
   done
}


#############################################################
#              MAIN Main main
#############################################################

curr_dir=`pwd`

LoadP11="n"
LoadVnmrJ="y"
RevFileName="vnmrj2.3"

#here for testing, will remove it later on
VNMR_REV_ID="VnmrJ VERSION 2.3 REVISION A"

VnmrRevId=$VNMR_REV_ID

DefaultDasho="y"
DefaultMail="n"

DefaultDestDir="$curr_dir/cdimageNVJ"
DefaultFiniDir="none"
DefaultLogFile="$curr_dir/nvcdoutlog"

winbuild="false"
Vnmr="VNMR"

if [ $# -ge 1 ]
then
   case x$1 in
	xVJ | xvj )

   		DefaultDestDir="/vnmrcd/cdimageNVJ"
   		DefaultFiniDir=`date '+/rdvnmr/.nv_vj%m.%d'`
   		DefaultLogFile="/vnmrcd/nvcdoutlogVJ"
	;;

	xP11 | xp11 ) 
 
   		DefaultDestDir="/vnmrcd/cdimageP11"
   		for=`date '+/rdvnmr/.cdromP11%m.%d'`
   		DefaultLogFile="/vnmrcd/nvcdoutlogP11"
		LoadP11="y"
	;;

	xSFU | xsfu | xXP | xxp ) 
 
   		DefaultDestDir="/vnmrcd/cdimageNVJ"
   		DefaultFiniDir=`date '+/rdvnmr/.nv_vj%m.%d'`
   		DefaultLogFile="/vnmrcd/nvcdoutlogVJ"

                winbuild="true"
                Inova="vnmrs"

                DefaultDestDir="$DefaultDestDir"_win
                DefaultFiniDir="$DefaultFiniDir"_win
	;;

	* )
   		DefaultDestDir="$curr_dir/cdimageNVJ"
   		DefaultFiniDir="none"
   		DefaultLogFile="$DefaultDestDir/nvcdoutlog"
	;;
   esac
fi


if [ $# = 2 -a x$2 = "xwin" ]
then
    winbuild="true"
    Inova="vnmrs"

    DefaultDestDir="$DefaultDestDir"_win
    DefaultFiniDir="$DefaultFiniDir"_win
    DefaultLogFile="$DefaultDestDir/nvcdoutlog_win"
fi

#echo "DefaultDestDir= $DefaultDestDir"
#echo "DefaultFiniDir= $DefaultFiniDir"
#echo "DefaultLogFile= $DefaultLogFile"
#echo "RevFileName=    $RevFileName"
#echo "VnmrRevId=      $VnmrRevId"
#exit 

if [ $# -ge 1 ]
then

   # ask for log filename
   umask 2
   echo "Use an absolute path for log !!"
   echo "This script changed directory many times"
   echo "And will write the log in that directory"
   nnl_echo "Enter destination file for log   [$DefaultLogFile]: "
   read answer
   if [ x$answer = "x" ]
   then
      log_file=$DefaultLogFile
   else
      log_file=$answer
   fi
   if test -f $log_file
   then
      nnl_echo "'$log_file' exists, overwrite? [y]: "
      read answer
      if [ x$answer = "x" ]
      then
         answer="y"
      fi
      if [ x$answer != "xy" ]
      then
         exit
      fi
      rm -rf $log_file
   fi
   echo "Writing log to '$log_file' file"
   echo ""

   # ask for destination  directory
   nnl_echo "Enter destination directory [$DefaultDestDir]:"
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

   nnl_echo "enter Finial directory [$DefaultFiniDir]:"
   read answer
   if [ x$answer = "x" ]
   then
      fini_dir=$DefaultFiniDir
   else
      fini_dir=$answer
   fi

   if [ x$fini_dir = "xnone" ]
   then
      echo "No Write to Finial Directory will be made. " | tee -a $log_file
      echo ""
   else
   
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
         if  [ ! -d $fini_dir ]
         then
	    echo "Could not create Final Directory: $fini_dir, Aborting. " | tee -a $log_file
	    exit 1
         fi
      fi
      echo "Writing results to Final Directory: $fini_dir "| tee -a $log_file
      echo ""
   fi

   nnl_echo "Use Dasho Jars as Defaults (y or n) [$DefaultDasho]:"
   read answer
   if [ x$answer = "x" ]
   then
      useDasho=$DefaultDasho
   else
      useDasho=$answer
   fi

   echo ""
   nnl_echo "Mail SW Group when CD Image for $fini_dir is complete?  (y or n) [$DefaultMail]:"
   read answer
   if [ x$answer = "x" ]
   then
      notifySW=$DefaultMail
   else
      notifySW=$answer
   fi

   #Ask about rebuilding tar files that don't change often

   echo ""
   echo ""
   nnl_echo "Rebuild tar files for '$ComDirs2Tar' [y]: "
   read com_answer
   if [ x$com_answer = "x" ]
   then
      com_answer="y"
   fi
   echo ""
   nnl_echo "Rebuild tar file for parxxx, etc [y]: "
   read par_answer
   if [ x$par_answer = "x" ]
   then
      par_answer="y"
   fi

   echo ""
   nnl_echo "Rebuild tar files for GNU [y]: "
   read gnu_answer
   if [ x$gnu_answer = "x" ]
   then
      gnu_answer="y"
   fi
   echo
   nnl_echo "Rebuild tar files for UserLib [y]: "
   read user_answer
   if [ x$user_answer = "x" ]
   then
      user_answer="y"
   fi

   echo ""
   nnl_echo "Rebuild tar files for Passworded Files [y]: "
   read password_answer
   if [ x$password_answer = "x" ]
   then
      password_answer="y"
   fi

else
   echo "Using default values "

   log_file=$DefaultLogFile
   dest_dir=$DefaultDestDir
   fini_dir=$DefaultFiniDir
   useDasho=y
   notifySW=y
   com_answer=y
   par_answer=y
   gnu_answer=y
   user_answer=y
   password_answer=y

fi

#echo "DefaultLogFile= $DefaultLogFile"
#echo "RevFileName=    $RevFileName"
#echo "VnmrRevId=      $VnmrRevId"


echo ""
dest_dir_code=$dest_dir/$Code

echo
echo "log_file	= $log_file +++++++++++++"
echo "dest_dir	= $dest_dir +++++++++++++"
echo "fini_dir	= $fini_dir +++++++++++++"
echo
echo "useDasho	= $useDasho +++++++++++++"
echo "notifySW	= $notifySW +++++++++++++"
echo "com_answer	= $com_answer +++++++++++++"
echo "par_answer	= $par_answer +++++++++++++"
echo "gnu_answer	= $gnu_answer +++++++++++++"
echo "user_answer	= $user_answer +++++++++++++"
echo "password_answer	= $password_answer +++++++++++++"
echo
echo

if [ ! -d $dest_dir ]
then
   mkdir $dest_dir
fi

if [ ! -r $log_file ]
then
   touch $log_file
fi

echo "Writing files to '$dest_dir'" | tee -a $log_file
echo "" | tee -a $log_file
echo "Creating needed subdirectories:" | tee -a $log_file

create_support_dirs $dest_dir

echo "" | tee -a $log_file
echo `date` | tee -a $log_file
echo "" | tee -a $log_file
echo "M a k i n g   V n m r J   C D R O M   I m a g e" | tee -a $log_file
echo "" | tee -a $log_file

#============== COMMON FILES =============================================
echo "" | tee -a $log_file
log_this  "PART I -- COMMON FILES -- $dest_dir_code/$Common"
# Let's copy and tar the Common files and log it.

#-----------------------------------------------------
# tar some common text files into one tar file
   cd $vcommondir
   log_this "   Tarring com.tar		  for : "
   tar -cf - $ComTarLst | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   chmod 644 ./*
   chmod 755 ./rc.vnmr
   chmod 755 ./acq
   setperms ./acq 755 644 755
   chmod 666 ./acq/info
   cd $dest_dir_code/tmp
   tar cf $dest_dir_code/$Common/com.tar *
   if [ x$winbuild != "xtrue" ]
   then
      make_TOC com.tar $Common $Vnmr sol/inova.sol	\
                                     sol/vnmrs.sol	\
				     rht/inova.rht	\
				     rht/vnmrs.rht	\
				     rht/mr400.rht
   else
      make_TOC com.tar $Common $Vnmr win/vnmrs.win	\
				     win/mr400.win
   fi

#-----------------------------------------------------
# tar the common bin scripts into bin tar file
   log_this "   Tarring combin.tar		  for : "

   cd $vcommondir
   if [ x$LoadP11 = "xy" ]
   then
       ComBinScripts2Tar=$ComBinScripts2Tar" "$P11BinScripts2Tar" "$P11Bin2Tar
   fi

   tar -cf - $ComBinScripts2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp

   if [ x$LoadP11 = "xy" ]
   then
	cp safecp bin
	mkdir -p p11/bin
	mv -f safecp writeTrash writeAaudit p11/bin
	chmod +s p11/bin/*
	mv -f chVJlist vnmrMD5 chchsums auditcp bin
   fi

   chmod -R 755 ./bin
   tar cf $dest_dir_code/$Common/combin.tar *
   if [ x$winbuild != "xtrue" ]
   then
      make_TOC combin.tar $Common $Vnmr sol/inova.sol	\
                                        sol/vnmrs.sol	\
					rht/inova.rht	\
                                        rht/vnmrs.rht	\
                                        rht/mr400.rht
   else
      make_TOC combin.tar $Common $Vnmr win/vnmrs.win	\
                                        win/mr400.win
   fi

#---------------------------------------------------------------------
# tar some common directories straight from source

   for file in $ComDirs2Tar
   do

      if [ x$file = "xshimmethods" ]
      then
         tarfile="shimmeth"
      else
          if [ x$file = "xnuctables" ]
         then
            tarfile="nuctabs"
         else
            if [ x$file = "xsatellites" ]
            then
               tarfile="satlite"
            else
               tarfile=$file
            fi
         fi
      fi

     if [ x$com_answer = "xy" ]
     then

      cd $vcommondir
      log_this "   Tarring $file		  for : "
      tar -cf - $file | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      chmod 755 ./$file
      setperms ./$file 755 644 755

      tar cf $dest_dir_code/$Common/$tarfile.tar $file
      if [ x$winbuild != "xtrue" ]
      then
	make_TOC ${tarfile}.tar $Common $Vnmr sol/inova.sol	\
                                              sol/vnmrs.sol	\
					      rht/inova.rht	\
                                              rht/vnmrs.rht	\
                                              rht/mr400.rht
      else
	make_TOC ${tarfile}.tar $Common $Vnmr win/vnmrs.win	\
                                              win/mr400.win
      fi
    else

      log_this " Skipping $file		  for : "
      if [ x$winbuild != "xtrue" ]
      then
	make_TOC ${tarfile}.tar $Common $Vnmr sol/inova.sol	\
                                              sol/vnmrs.sol	\
					      rht/inova.rht	\
                                              rht/vnmrs.rht	\
                                              rht/mr400.rht
      else
	 make_TOC ${tarfile}.tar $Common $Vnmr win/vnmrs.win	\
                                               win/mr400.win
      fi
    fi
   done

   rm -rf $dest_dir_code/tmp/*

#---------------------------------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
     log_this "   Tarring Solaris NDDS libraries and binaries for :"

     mkdir $dest_dir_code/tmp/lib
     cd $solNDDSlibDir
     tar -cf - * | (cd $dest_dir_code/tmp/lib; tar $taroption -)

     cd $dest_dir_code/tmp
     mkdir bin
     cp $solNDDSManger bin
     cp $solNDDSInfo bin
     cp $solNDDSSpy bin

     tar -cf $dest_dir_code/$Common/ndds.tar *
     make_TOC ndds.tar $Common $Vnmr sol/inova.sol	\
                                     sol/vnmrs.sol
   fi
#---------------------------------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
     log_this "   Tarring Linux NDDS libraries and binaries for :"

     mkdir $dest_dir_code/tmp/lib
     tar -cf - $NDDSLinux2Tar | (cd $dest_dir_code/tmp/lib; tar $taroption -)

     cd $dest_dir_code/tmp
     mkdir bin
     cp $lnxNDDSManger bin
     cp $lnxNDDSInfo bin
     cp $lnxNDDSSpy bin

     tar -cf $dest_dir_code/$Common/nddslnx.tar *
     make_TOC nddslnx.tar $Common $Vnmr rht/inova.rht \
                                        rht/vnmrs.rht	\
                                        rht/mr400.rht
   fi
#---------------------------------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
     log_this "   Tarring Linux JOGL libraries for              :"

     mkdir $dest_dir_code/tmp/lib
     cd $vcommondir/lib.lnx
     tar -cf - * | (cd $dest_dir_code/tmp/lib; tar $taroption -)

     cd $dest_dir_code/tmp

     tar -cf $dest_dir_code/$Common/jogllnx.tar *
     make_TOC jogllnx.tar $Common $Vnmr rht/inova.rht \
                                        rht/vnmrs.rht	\
                                        rht/mr400.rht
   fi
#---------------------------------------------------------------------------
   if [ x$winbuild = "xtrue" ]
   then
     log_this "   Tarring Windows NDDS libraries"
     log_this "   Tarring Windows NDDS binaries 	for : "

     mkdir $dest_dir_code/tmp/lib
     tar -cf - $NDDSwxpLibs2Tar | (cd $dest_dir_code/tmp/lib; tar $taroption -)

     cd $dest_dir_code/tmp
     mkdir bin
     cp $wxpNDDSManger.* bin
     cp $wxpNDDSInfo.* bin
     cp $wxpNDDSSpy.* bin
     cp $wsfuNDDSManger bin
     cp $wsfuNDDSInfo bin

     tar -cf $dest_dir_code/$Common/nddswin.tar *
     make_TOC nddswin.tar $Common $Vnmr win/vnmrs.win	\
                                        win/mr400.win
   fi
#---------------------------------------------------------------------------
#   log_this "   Tarring Gs files		  for : "
#
#   cd $vcommondir
#   tar -cf - $Gs2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
#   cd $dest_dir_code/tmp
#   chmod 755 gs
#   setperms ./gs 755 644 755
#
#   tar -cf $dest_dir_code/$Common/gs.tar *
#   make_TOC gs.tar $Common $Vnmr sol/inova.sol	\
#                                 sol/vnmrs.sol
#
#---------------------------------------------------------------------------
   log_this "   Tarring dialoglib		  for : "

   cd $vcommondir
   tar -cf - $Dialog2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./dialoglib

   tar -cf $dest_dir_code/$Common/dialog.tar *
   if [ x$winbuild != "xtrue" ]
   then
      make_TOC dialog.tar $Common $Vnmr sol/inova.sol	\
                                        sol/vnmrs.sol	\
    			      	        rht/inova.rht	\
                                        rht/vnmrs.rht	\
                                        rht/mr400.rht
   else
     make_TOC dialog.tar $Common $Vnmr win/vnmrs.win	\
                                       win/mr400.win
   fi

#---------------------------------------------------------------------------
   log_this "   Tarring Tcl files		  for : "

   cd $vcommondir
   tar -cf - $Tcl2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   cp $commondir/systcl/sol/spingen.tbc tcl/bin/spingen
   chmod 755 tcl
   setperms ./tcl 755 644 755
   chmod 755 tcl/bin/*
   chmod 755 tcl/*library

   tar -cf $dest_dir_code/$Common/tcl.tar *
   make_TOC tcl.tar $Common $Vnmr sol/inova.sol	\
                                  sol/vnmrs.sol

#---------------------------------------------------------------------------
   log_this "   Tarring Linux Tcl files 	  for : "

   cd $vcommondir
   tar -cf - $Tcl2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   rm -f tcl/bin/vnmr* tcl/bin/spingen tcl/bin/tclsh
   cp $lnxproglib_dir/tcl/spingen.tbc tcl/bin/spingen
   cp $lnxproglib_dir/tcl/vnmrwish tcl/bin/vnmrwish
   (cd tcl/bin; ln vnmrwish vnmrWish)
   setperms ./tcl 755 644 755
   chmod 755 tcl/bin/*
   chmod 755 tcl/*library
   (cd tcl/bin; ln -s /usr/bin/tclsh tclsh)
                                                                                                             
   tar -cf $dest_dir_code/$Linux/tcllnx.tar *
   make_TOC tcllnx.tar $Linux $Vnmr rht/inova.rht	\
                                    rht/vnmrs.rht	\
                                    rht/mr400.rht

#---------------------------------------------------------------------------
   if [ x$winbuild = "xtrue" ]
   then
     log_this "   Tarring Windows Tcl files 	  for : "

     cd $vcommondir/tcl.win
     mkdir $dest_dir_code/tmp/tcl
     tar -cf - $TclWin2Tar | (cd $dest_dir_code/tmp/tcl; tar $taroption -)
     cd $dest_dir_code/tmp/tcl/tklibrary
     mkdir vnmr
     filelist="arrow.bmp arrow2.bmp \
	deck.tk menu2.tk scroll2.tk"
#     echo "tk vnmr library file list: $filelist"
     for xfile in $filelist
     do
        cp -p $sourcedir/systcl/$xfile vnmr
	echo $xfile >> $logpath
     done
     cd $dest_dir_code/tmp/tcl
     filelist="add_printer fileListen pl_color nms xcal2"
#     echo "tk vnmr bin file list: $filelist"
     for xfile in $filelist
     do
        cp -p $sourcedir/systcl/$xfile.tcl bin/$xfile
	echo $xfile >> $logpath
     done
     filelist="at atrecord atregbuilt"
#     echo "tk autotest bin file list: $filelist"
     for xfile in $filelist
     do
        cp -p $sourcedir/systcl/$xfile.tcl bin/.
        cp -p $sourcedir/sysscripts/$xfile bin/.
	echo $xfile >> $logpath
     done
     cd $dest_dir_code/tmp
     mkdir app-defaults
     cp $vcommondir/tape_sol/app-defaults/Enter app-defaults
     setperms ./tcl 755 644 755
     chmod 755 tcl/bin/*
     chmod 755 tcl/*library
     chmod 755 tcl/tklibrary/vnmr
     chmod 644 app-defaults/Enter
     tar -cf $dest_dir_code/$Windows/tclwin.tar *
     make_TOC tclwin.tar $Windows $Vnmr win/vnmrs.win	\
                                        win/mr400.win

   fi

#---------------------------------------------------------------------------
# tar fiddle examples files
   log_this "   Tarring fiddle files   	  for : "

   cd $vcommondir/fiddle
   tar -cf - * | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   chmod 755    ./fidlib ./manual
   setperms	./fidlib 755 644 755
   setperms	./manual 755 644 755

   tar -cf $dest_dir_code/$Common/fiddle.tar *
   if [ x$winbuild != "xtrue" ]
   then
      make_TOC fiddle.tar $Common "Fiddle_Example" sol/inova.sol	\
                                                   sol/vnmrs.sol	\
    			      	     		   rht/inova.rht	\
                                                   rht/vnmrs.rht	\
                                                   rht/mr400.rht
   else
     make_TOC fiddle.tar $Common "Fiddle_Example" win/vnmrs.win	\
                                                  win/mr400.win
   fi


#---------------------------------------------------------------------------
# tar the Solids common files maclib, manual, parlib, templates, psglib
   log_this "   Tarring  Solids Text for : "

   cd $vcommondir/Solids
   tar -cf - $SolidsText2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   setperms    ./maclib    755 644 755
   setperms    ./manual    755 644 755
   setperms    ./parlib    755 644 755
   setperms    ./templates 755 644 755
   mkdir -p $dest_dir_code/tmp/psglib
   cd $solproglib_dir/psglib
   for cfile in $Solids_PS_2Tar
   do
        cp $cfile.c $dest_dir_code/tmp/psglib
   done
   cd $dest_dir_code/tmp
   setperms    ./psglib    755 644 755
   tar -cf $dest_dir_code/$Solids/solids.tar *
   if [ x$winbuild != "xtrue" ]
   then
     make_TOC solids.tar $Solids $Vnmr  sol/vnmrs.sol	\
                                                rht/vnmrs.rht
   else
     make_TOC solids.tar $Solids $Vnmr  win/vnmrs.win
   fi
 
#---------------------------------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
      log_this  "   Tarring Solids seqlib for : "

      mkdir -p $dest_dir_code/tmp/seqlib
      cd $solproglib_dir/nvseqlib
      for cfile in $Solids_PS_2Tar
      do
        cp $cfile $dest_dir_code/tmp/seqlib
      done
      cd $dest_dir_code/tmp
      setperms    ./seqlib    755 644 755
      tar -cf $dest_dir_code/$Solids/solidsobj.tar *
      make_TOC solidsobj.tar $Solids $Vnmr sol/vnmrs.sol
   fi

#---------------------------------------------------------------------------
#Linux:
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Linux Solids seqlib for : "

      mkdir -p $dest_dir_code/tmp/seqlib
      cd $lnxproglib_dir/nvseqlib
      for cfile in $Solids_PS_2Tar
      do
        cp $cfile $dest_dir_code/tmp/seqlib
      done
      cd $dest_dir_code/tmp
      setperms    ./seqlib    755 644 755
      tar -cf $dest_dir_code/$Solids/solidsobj.tar *
      make_TOC solidsobj.tar $Solids $Vnmr rht/vnmrs.rht
   fi
#---------------------------------------------------------------------------
#Windows:
   if [ x$winbuild = "xtrue" ]
   then
     log_this "   Tarring Windows Solids seqlib for : "

     mkdir -p $dest_dir_code/tmp/seqlib
     cd $winproglib_dir/nvseqlib
     for cfile in $Solids_PS_2Tar
     do
       cp $cfile $dest_dir_code/tmp/seqlib
     done
     cd $dest_dir_code/tmp
     setperms    ./seqlib    755 644 755
     tar -cf $dest_dir_code/$Solids/solidsobj.tar *
     make_TOC solidsgobj.tar $Solids $Vnmr win/vnmrs.win
   fi


#============== UNITY INOVA FILES ==================================
echo "" | tee -a $log_file
log_this  "PART II -- UNITY/INOVA FILES -- $dest_dir_code/$Common"
 
#---------------------------------------------------------------------------
# The parameter files are tarred
# par200,par300,par400,par500,par600,par750 and parlib.
# They are stored in /vcommon/upar

  if [ x$par_answer = "xy" ]
  then
     log_this "   Copying parameter files  "

     cd $vcommondir
     cp $cpoption $ComPar2Tar $dest_dir_code/tmp
     cd $dest_dir_code/tmp
     pars=`ls -d par???`

     for file in $pars
     do
       chmod 755 ./$file
       setperms ./$file 755 644 755
     done

     nnl_echo "in /vommon/upar : " | tee -a $log_file
     ls -CF $dest_dir_code/tmp | tee -a $log_file

     echo "" | tee -a $log_file
     nnl_echo "   Tarring parameter files	for : " | tee -a $log_file
     tar cf $dest_dir_code/$Common/params.tar *

  else
     log_this " Skipping parXXX file	  for : "
  fi
  if [ x$winbuild != "xtrue" ]
  then
    make_TOC params.tar $Common $Vnmr sol/inova.sol	\
                                      sol/vnmrs.sol	\
				      rht/inova.rht	\
                                      rht/vnmrs.rht	\
                                      rht/mr400.rht
  else
    make_TOC params.tar $Common $Vnmr win/vnmrs.win	\
                                      win/mr400.win
  fi

#---------------------------------------------------------------------
# tar some common directories straight from source
   log_this "   Tarring wavelib and help	for : "

   cd $vcommondir/Pbox
   tar -cf - $Pbox2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   setperms ./wavelib 755 644 755
   setperms ./help 755 644 755
   tar cf $dest_dir_code/$Common/wavelib.tar *
   if [ x$winbuild != "xtrue" ]
   then
      make_TOC wavelib.tar $Common $Vnmr sol/inova.sol	\
                                         sol/vnmrs.sol	\
    			   	         rht/inova.rht	\
                                         rht/vnmrs.rht	\
                                         rht/mr400.rht
   else
      make_TOC wavelib.tar $Common $Vnmr win/vnmrs.win	\
                                         win/mr400.win
   fi

#---------------------------------------------------------------------
# Pbox, tar some common directories straight from source

   cd $vcommondir
   for file in $uComDirs2Tar
   do
      log_this "   Tarring $file 		for : "

      cd $vcommondir
      tar -cf - $file | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      setperms ./$file 755 644 755
      if [ x$file = "xshapelib" ]
      then
         chmod  644 shapelib/.Pbox_defaults
      fi
      tar cf $dest_dir_code/$Common/${file}.tar $file
      if [ x$winbuild != "xtrue" ]
      then
	make_TOC ${file}.tar $Common $Vnmr sol/inova.sol	\
                                           sol/vnmrs.sol	\
					   rht/inova.rht	\
                                           rht/vnmrs.rht	\
                                           rht/mr400.rht
      else
	make_TOC ${file}.tar $Common $Vnmr win/vnmrs.win	\
                                           win/mr400.win
      fi
   done
 
#---------------------------------------------------------------------
   log_this "   Tarring psglib files		for : "

   mkdir -p $dest_dir_code/tmp/psglib
   cd $solproglib_dir/psglib
   for cfile in $PS_2Tar
   do
        cp $cfile.c $dest_dir_code/tmp/psglib
   done
   cd $dest_dir_code/tmp
   chmod 755   ./psglib
   chmod 644   ./psglib/*
   tar cf $dest_dir_code/$Inova/psglib.tar *
   if [ x$winbuild != "xtrue" ]
   then
      make_TOC psglib.tar $Inova $Vnmr sol/inova.sol	\
                                       sol/vnmrs.sol	\
   			               rht/inova.rht	\
                                       rht/vnmrs.rht	\
                                       rht/mr400.rht
   else 
     make_TOC psglib.tar $Inova $Vnmr win/vnmrs.win	\
                                      win/mr400.win
   fi

#============== UNITY INOVA FILES ==============================
echo  "" | tee -a $log_file
log_this "PART III -- UNITY/INOVA FILES -- $dest_dir_code/$Solaris"
 
#---------------------------------------------------------------------
# tar some common directories straight from source
   if [ x$winbuild != "xtrue" ]
   then
     log_this "   Tarring bin.tar 			for : "

     cd $solobjdir
     tar -cf - $BinFiles2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
     cd $dest_dir_code/tmp
     chmod -R 755 ./bin
     tar -cf $dest_dir_code/$Solaris/bin.tar bin
     make_TOC bin.tar $Solaris $Vnmr sol/inova.sol	\
                                     sol/vnmrs.sol
   fi

#---------------------------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
     log_this "   Tarring binlnx.tar 			for : "

     cd $lnxproglib_dir
     tar -cf - $BinFilesLinux2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
     cd $dest_dir_code/tmp
     mv Infostat showstat compressfid ft3d getplane bin
     mv fdfgluer fdfsplit createdicom createdcm dicomlpr bin
     chmod -R 755 ./bin
     tar -cf $dest_dir_code/$Linux/binlnx.tar bin
     make_TOC binlnx.tar $Linux $Vnmr rht/inova.rht	\
                                      rht/vnmrs.rht	\
                                      rht/mr400.rht
   fi

#---------------------------------------------------------------------
   if [ x$winbuild = "xtrue" ]
   then
     log_this "   Tarring binwin.tar 			for : "
set -x

     cd $winproglib_dir
     tar -cvf - $BinFilesWindows2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
     cd $dest_dir_code/tmp
     mv Infostat nvlocki compressfid ft3d getplane bin
#     mv showstat bin
#     mv fdfgluer fdfsplit createdicom createdcm dicomlpr bin
     mv groupadd isAdmin isroot useradd usermod userdel bin
     mv rundbdata.bat rundbsetup.bat runmanagedb.bat runasscript.vbs nopwdexp.vbs bin
     mv uninstallvj.bat bin
     chmod -R 755 ./bin
     tar -cf $dest_dir_code/$Windows/binwin.tar bin
     make_TOC binwin.tar $Windows $Vnmr win/vnmrs.win	\
                                        win/mr400.win
set +x
   fi

#---------------------------------------------------------------------
# tar some common directories straight from source
   if [ x$winbuild != "xtrue" ]
   then
     log_this "   Tarring tcllib.tar			for : "

     cd $solobjdir
     tar -cf - $TclLibs2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
     cd $dest_dir_code/tmp
     chmod    755 ./lib
     chmod    644 ./lib/*
     tar -cf $dest_dir_code/$Solaris/tcllib.tar lib
     make_TOC tcllib.tar $Solaris $Vnmr sol/inova.sol	\
                                        sol/vnmrs.sol
   fi

#-----------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
     log_this "   Tarring Linux Tcl libs		for : "

     tar -cf - $TclLibsLinux2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
     cd $dest_dir_code/tmp
     (cd lib; ln -s libBLT24.so libBLT.so)
     mkdir app-defaults
     cp $vcommondir/tape_sol/app-defaults/Enter app-defaults
     chmod 644 app-defaults/Enter
     chmod  -R  755 ./lib
     tar -cf $dest_dir_code/$Linux/tclliblnx.tar *
     make_TOC tclliblnx.tar $Linux $Vnmr rht/inova.rht	\
                                         rht/vnmrs.rht	\
                                         rht/mr400.rht
   fi

#-----------------------------------------------------
# tar the common bin scripts into bin tar file
   log_this "   Tarring unibin.tar			for : "

   cd $vcommondir
   tar -cf - $UniBinScripts2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./bin
   if [ x$winbuild != "xtrue" ]
   then
      tar cf $dest_dir_code/$Solaris/unibin.tar bin
      make_TOC unibin.tar $Solaris $Vnmr sol/inova.sol	\
                                         sol/vnmrs.sol	\
   			                 rht/inova.rht	\
                                         rht/vnmrs.rht	\
                                         rht/mr400.rht
   else
     tar cf $dest_dir_code/$Windows/unibin.tar bin
     make_TOC unibin.tar $Windows $Vnmr win/vnmrs.win	\
                                        win/mr400.win
   fi

#
#---------------------------------------------------------------------
# tar some common directories straight from source
#   if [ x$winbuild != "xtrue" ]
#   then
#      log_this "   Tarring binx.tar			for : "
#
#      cd $solobjdir
#      tar -cf - $BinX2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
#      cd $dest_dir_code/tmp
#      chmod -R 755 ./bin
#      chmod 755	./app-defaults
#      chmod 644	./app-defaults/*
#      tar -cf $dest_dir_code/$Solaris/binx.tar *
#      make_TOC binx.tar $Solaris $Vnmr sol/inova.sol	\
#                                       sol/vnmrs.sol
#   fi
#
#---------------------------------------------------------------------------
# just to get vnmrwish
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring TclMore files		for : "

      cd $solproglib_dir/tcl
      mkdir -p $dest_dir_code/tmp/tcl/bin
      cp $TclMore $dest_dir_code/tmp/tcl/bin/
      cd $dest_dir_code/tmp
      chmod -R 755  tcl
      (cd tcl/bin; ln vnmrwish vnmrWish)
      tar -cf $dest_dir_code/$Solaris/tcl2.tar *
      make_TOC tcl2.tar $Solaris $Vnmr sol/inova.sol	\
                                       sol/vnmrs.sol
   fi

#---------------------------------------------------------------------------
#  Accounting scripts and executable 
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Accounting files		for : "

      cd $solobjdir
      tar -cf - $Acct2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      cp $solproglib_dir/accounting/console_login adm/bin
      chmod -R 755 adm
      chmod 777 adm/tmp
      tar -cf $dest_dir_code/$Solaris/adm.tar *
      make_TOC adm.tar $Solaris $Vnmr sol/inova.sol	\
                                      sol/vnmrs.sol
   fi

#---------------------------------------------------------------------------
#Linux: Accounting scripts and executable
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Linux Accounting files	for : "

      cd $solobjdir
      tar -cf - $Acct2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      cp $lnxproglib_dir/accounting/console_login adm/bin
      chmod -R 755 adm
      chmod 777 adm/tmp
      tar -cf $dest_dir_code/$Linux/adm.tar *
      make_TOC adm.tar $Linux $Vnmr rht/inova.rht	\
                                    rht/vnmrs.rht	\
                                    rht/mr400.rht
   fi

#---------------------------------------------------------------------------
#Windows: Accounting scripts and executable
   if [ x$winbuild = "xtrue" ]
   then
     log_this "   Tarring Windows Accounting files	for : "

     cd $solobjdir
     tar -cf - $Acct2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
     cd $dest_dir_code/tmp
     cp $winproglib_dir/accounting/console_login adm/bin
     chmod -R 755 adm
     chmod 777 adm/tmp
     tar -cf $dest_dir_code/$Windows/adm.tar *
     make_TOC adm.tar $Windows $Vnmr win/vnmrs.win	\
                                     win/mr400.win
   fi

#---------------------------------------------------------------------------
   log_this "   Tarring Admin files			for : "

   cd $vcommondir/xml
   tar -cf - $AdminFiles2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   mkdir -p adm/users/operators
   mkdir -p adm/users/profiles
   mkdir -p adm/users/userProfiles
   chmod -R 755 adm
   chmod 644 automation.conf
   chmod 644 rightsList.xml
   chmod 644 protocolListWalkup.xml
   mv automation.conf adm/users/operators
   mv rightsList.xml adm/users/
   mv AllLiquids.txt AllLiquids.xml adm/users/userProfiles
   mv BasicLiquids.txt BasicLiquids.xml adm/users/userProfiles
   mv AllSolids.txt AllSolids.xml adm/users/userProfiles
   mv appdir*.txt adm/users/userProfiles
   chmod 644 adm/users/userProfiles/*
   mv protocolListWalkup.xml adm/users/
   if [ x$winbuild != "xtrue" ]
   then
      tar -cf $dest_dir_code/$Solaris/admfiles.tar *
      make_TOC admfiles.tar $Solaris $Vnmr sol/inova.sol	\
                                           sol/vnmrs.sol	\
   				           rht/inova.rht	\
                                           rht/vnmrs.rht	\
                                           rht/mr400.rht
   else
     tar -cf $dest_dir_code/$Windows/admfiles.tar *
     make_TOC admfiles.tar $Windows $Vnmr win/vnmrs.win		\
                                          win/mr400.win
   fi

#---------------------------------------------------------------------------
# tar some common text files into one tar file
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring templ.tar			for : "

      cd $vcommondir/tape_sol
      tar -cf - $UserTempl2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      setperms ./user_templates 755 644 755
      cd ./user_templates
      rm -f .login.lnx .vnmrenv.lnx .vnmrenvsh.lnx .profile.win .login.win .vnmrenv.win .vnmrenv_ksh.win .vxresource.lnx
      if [ x$LoadVnmrJ = "xy" ]
      then
	ln -s dtj.tar dt.tar
	ln -s dtj2.tar dt2.tar
      else
	ln -s dtc.tar dt.tar
	ln -s dtc2.tar dt2.tar
      fi
      cd ..
      tar cf $dest_dir_code/$Solaris/templ.tar *
      make_TOC templ.tar $Solaris $Vnmr   sol/inova.sol	\
                                          sol/vnmrs.sol
   fi

#---------------------------------------------------------------------------
#Linux
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Linux templ.tar		for : "

      cd $vcommondir/tape_sol
      tar -cf - $UserTempl2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      setperms ./user_templates 755 644 755
      cd user_templates
      rm -f .dtprofile .openwin-init .openwin-menu .login .cshrc .xinitrc .xlogin .Xdefaults .profile.win .login.win .vnmrenv.win .vnmrenv_ksh.win
      mv -f .vnmrenv.lnx .vnmrenv
      mv -f .vnmrenvsh.lnx .vnmrenvsh
      mv -f .login.lnx .login
      mv -f .vxresource.lnx .vxresource

      cd ..
      tar cf $dest_dir_code/$Linux/templ.tar *
      make_TOC templ.tar $Linux $Vnmr rht/inova.rht	\
                                      rht/vnmrs.rht	\
                                      rht/mr400.rht
   fi

#---------------------------------------------------------------------------
#Windows
   if [ x$winbuild = "xtrue" ]
   then
     log_this "   Tarring Windows templ.tar		for : "

     cd $vcommondir/tape_sol
     tar -cf - $UserTempl2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
     cd $dest_dir_code/tmp
     setperms ./user_templates 755 644 755
     cd user_templates
     rm -f .dtprofile .openwin-init .openwin-menu .login .cshrc .xinitrc .xlogin .Xdefaults .login.lnx .vnmrenv.lnx .vnmrenvsh.lnx .vxresource.lnx
     mv -f .vnmrenv.win .vnmrenv
     mv -f .vnmrenv_ksh.win .vnmrenv_ksh
     mv -f .login.win .login
     mv -f .profile.win .profile

     cd ..
     tar cf $dest_dir_code/$Windows/templ.tar *
     make_TOC templ.tar $Windows $Vnmr win/vnmrs.win	\
                                       win/mr400.win
   fi

#---------------------------------------------------------------------------
# tar Gmap help, maclib, manual and menulib files
   log_this "   Tarring Gmap Text			for : "

   cd $vcommondir/Gmap
   tar -cf - $GmapText2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   chmod 755	./help
   chmod 644	./help/*
   chmod 755    ./maclib
   chmod 644    ./maclib/*
   chmod 755    ./manual
   chmod 644    ./manual/*
   chmod 755    ./menulib
   chmod 644    ./menulib/*
   tar -cf $dest_dir_code/$Gmap/gmaptext.tar *
   if [ x$winbuild != "xtrue" ]
   then
      make_TOC gmaptext.tar $Gmap "Gradient_shim" sol/inova.sol	\
                                                  sol/vnmrs.sol	\
						  rht/inova.rht	\
                                                  rht/vnmrs.rht	\
                                                  rht/mr400.rht
   else
     make_TOC gmaptext.tar $Gmap "Gradient_shim" win/vnmrs.win	\
                                                 win/mr400.win
   fi
 
#---------------------------------------------------------------------------
# tar Gmap parlib psglib files
   log_this "   Tarring Gmap par/psglib		for : "

   cd $vcommondir/Gmap
   tar -cf - $GmapPars2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   chmod 755    ./parlib
   setperms ./parlib 755 644 755
   tar -cf $dest_dir_code/$Gmap/gmappars.tar *
   if [ x$winbuild != "xtrue" ]
   then
      make_TOC gmappars.tar $Gmap "Gradient_shim" sol/inova.sol	\
                                                  sol/vnmrs.sol	\
						  rht/inova.rht	\
                                                  rht/vnmrs.rht	\
                                                  rht/mr400.rht
   else
     make_TOC gmappars.tar $Gmap "Gradient_shim" win/vnmrs.win	\
                                                 win/mr400.win
   fi

#---------------------------------------------------------------------------
# tar Protune maclib, manual, templates and tune files
   log_this "   Tarring Protune Text			for : "

   cd $vcommondir/Protune
   tar -cf - $ProtuneText2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   chmod 755    ./maclib
   chmod 644    ./maclib/*
   chmod 755    ./manual
   chmod 644    ./manual/*
   setperms     ./templates 755 644 755
   setperms     ./tune 755 644 755
   tar -cf $dest_dir_code/$Common/protune.tar *
   if [ x$winbuild != "xtrue" ]
   then
      make_TOC protune.tar $Common $Vnmr sol/inova.sol	\
                                             sol/vnmrs.sol	\
					     rht/inova.rht	\
                                             rht/vnmrs.rht	\
                                             rht/mr400.rht
   else
      make_TOC protune.tar $Common $Vnmr win/vnmrs.win	\
                                             win/mr400.win
   fi

#---------------------------------------------------------------------
# tar the motif libraryes UNITY seqlib 
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring motif.tar 2.5.1		for : "

      cd $vcommondir
      tar -cf - lib | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      chmod 755   ./lib
      chmod 755   ./lib/*
      tar -cf $dest_dir_code/$Unity/motif.tar *
      make_TOC motif.tar $Unity $Vnmr sol/inova.sol	\
                                      sol/vnmrs.sol
   fi

#============== UNITY INOVA FILES ====================================
echo ""  | tee -a $log_file
log_this "PART IV -- UNITY/INOVA FILES -- $dest_dir_code/$Unity/$Inova"
 
#---------------------------------------------------------------------------
# binaries for Pbox on UNITYs
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Pbox bin		for : "

      cd $solobjdir
      tar -cf - $PboxBin2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      setperms ./bin 755 644 755
      tar cf $dest_dir_code/$Unity/pboxbin.tar *
      make_TOC pboxbin.tar $Unity $Vnmr sol/inova.sol	\
                                        sol/vnmrs.sol
   fi

#---------------------------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
      log_this  "   Tarring Wobbler files	for : "

      cd $vcommondir
      tar -cf - $WobbleText | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $solobjdir
      tar -cf - $WobbleExec | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      chmod 755 ./tune
      setperms ./tune 755 644 755
      tar -cf $dest_dir_code/$Unity/$Inova/wobbler.tar *
      make_TOC wobbler.tar $Unity/$Inova $Vnmr sol/inova.sol	\
                                               sol/vnmrs.sol
   fi

############################################################

#============== INOVA FILES ========================================
echo ""  | tee -a $log_file
log_this "PART VIII -- INOVA FILES -- $dest_dir_code/$Inova"
 
#---------------------------------------------------------------------
# tar psg sources
   log_this "   Tarring psg source files	for : "

   (cd $solproglib_dir; cp $cpoption nvpsg $dest_dir_code/tmp/psg)
   cd $dest_dir_code/tmp/psg
   cp $lnxproglib_dir/nvpsg/makeuserpsg.lnx .
   if [ x$winbuild = "xtrue" ]
   then
     cp $winproglib_dir/nvpsg/inttypes.h .
   fi
   rm -f lib* *.o makenvpsg seqgen.sh s2pul*
   rm -f asmfuncs.c assign.c allocate.c lockfreqfunc.c pvars.c shims.c symtab.c tools.c variables1.c vfilesys.c
   cd $dest_dir_code/tmp
   chmod 755   ./psg
   chmod 644   ./psg/*
   tar cf $dest_dir_code/$Inova/psg.tar *
   if [ x$winbuild != "xtrue" ]
   then
      make_TOC psg.tar $Inova $Vnmr sol/inova.sol	\
                                    sol/vnmrs.sol	\
				    rht/inova.rht	\
                                    rht/vnmrs.rht	\
                                    rht/mr400.rht
   else
     make_TOC psg.tar $Inova $Vnmr win/vnmrs.win	\
                                   win/mr400.win
   fi
 
#---------------------------------------------------------------------
# tar psg libs
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring psg objects		for : "

      cd $solproglib_dir
      tar -cf - $PsgLib2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      mv nvpsg lib
      chmod 755   ./lib
      chmod 755   ./lib/*
      chmod 644   ./lib/x_ps.o
      tar -cf $dest_dir_code/$Inova/libpsg.tar lib
      make_TOC libpsg.tar $Inova $Vnmr sol/inova.sol	\
                                       sol/vnmrs.sol
   fi

#---------------------------------------------------------------------
# Linux:  Psg libraries
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Linux Psg libs	for : "

      cd $lnxproglib_dir
      tar -cf - $PsgLibLinux2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      mv nvpsg lib
      chmod -R 755 ./lib
      chmod 644    ./lib/x_ps.o

      tar -cf $dest_dir_code/$Linux/libpsg.tar lib
      make_TOC libpsg.tar $Linux $Vnmr rht/inova.rht    \
                                       rht/vnmrs.rht	\
                                       rht/mr400.rht
   fi

#---------------------------------------------------------------------
# Windows:  Psg libraries
   if [ x$winbuild = "xtrue" ]
   then
     log_this "   Tarring Windows Psg libs	for : "

     cd $winproglib_dir
     tar -cf - $PsgLibWin2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
     cd $dest_dir_code/tmp
     mv nvpsg lib
     chmod -R 755 ./lib
     chmod 644    ./lib/x_ps.o

     tar -cf $dest_dir_code/$Windows/libpsg.tar lib
     make_TOC libpsg.tar $Windows $Vnmr win/vnmrs.win	\
                                        win/mr400.win
   fi

#---------------------------------------------------------------------
# tar the standard INOVA seqlib 
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring seqlib.tar		for : "

      mkdir -p $dest_dir_code/tmp/seqlib
      cd $solproglib_dir/nvseqlib
      for cfile in $PS_2Tar
      do
        cp $cfile $dest_dir_code/tmp/seqlib
      done
      cd $dest_dir_code/tmp
      chmod -R 755   ./seqlib
      tar -cf $dest_dir_code/$Inova/seqlib.tar *
      make_TOC seqlib.tar $Inova $Vnmr sol/inova.sol	\
                                       sol/vnmrs.sol

#Linux: Inova psg C files library and Inova binary seqlib
      log_this "   Tarring Linux seqlib.tar		for : "
      mkdir -p $dest_dir_code/tmp/seqlib
      cd $lnxproglib_dir/nvseqlib
      for cfile in $PS_2Tar
      do
        cp $cfile $dest_dir_code/tmp/seqlib
      done
      cd $dest_dir_code/tmp
      chmod -R 755   ./seqlib
      tar -cf $dest_dir_code/$Linux/seqlib.tar *
      make_TOC seqlib.tar $Linux $Vnmr rht/inova.rht	\
                                       rht/vnmrs.rht	\
                                       rht/mr400.rht
               
 #Windows: Inova psg C files library and Inova binary seqlib
   else
     log_this "   Tarring Windows seqlib.tar		for : "
     mkdir -p $dest_dir_code/tmp/seqlib
     if [ -d $winproglib_dir/nvseqlib ]
     then
	cd $winproglib_dir/nvseqlib
	for cfile in $PS_2Tar
	do
	    cp $cfile $dest_dir_code/tmp/seqlib
	done
	cd $dest_dir_code/tmp
	chmod -R 755   ./seqlib
	tar -cf $dest_dir_code/$Windows/seqlib.tar *
	make_TOC seqlib.tar $Windows $Vnmr win/vnmrs.win	\
                                           win/mr400.win
     else
	echo "$winproglib_dir/nvseqlib does not exist"
     fi
   fi

#---------------------------------------------------------------------------
#   if [ x$winbuild != "xtrue" ]
#   then
#      log_this "   Tarring acqbin		for : "
#
#      cd $solobjdir
#      tar -cf - $ProcFam | (cd $dest_dir_code/tmp; tar $taroption -)
#      cd $dest_dir_code/tmp/bin
#      cp  $commondir/sysscripts/nvsetacq .
#      cp  $commondir/sysscripts/slimSetacq .
#      cp  $solobjdir/bin/showconsole .
#      ln -s iiadisplay iadisplay
#      ln -s nvsetacq setacq
#      cd $dest_dir_code/tmp
#      mv Expproc Recvproc Sendproc Infoproc consoledownload flashia acqbin
#      chmod -R 755 ./acqbin
#      chmod -R 755 ./bin
#      chmod 755	./app-defaults
#      chmod 644	./app-defaults/*
#      mv ./acqbin/nAutoproc ./acqbin/Autoproc
#      tar -cf $dest_dir_code/$Inova/acqbin.tar *
#      make_TOC acqbin.tar $Inova $Vnmr sol/inova.sol	\
#                                       sol/vnmrs.sol
#   fi
#
#---------------------------------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Acqbin part 2	for : "

      cd $solobjdir
      tar -cf - $iProcFam | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp/bin
      cp $commondir/systcl/sol/spincad.tbc spincad
      chmod 755 spincad
      cd $dest_dir_code/tmp
      chmod 755    ./acq
      chmod 644    ./acq/*
      chmod -R 755 ./bin
      chmod 755    ./app-defaults
      chmod 644    ./app-defaults/*
      setperms ./spincad 755 644 755
      tar -cf $dest_dir_code/$Inova/acqbin2.tar *
      make_TOC acqbin2.tar $Inova $Vnmr sol/inova.sol	\
                                        sol/vnmrs.sol
   fi

#---------------------------------------------------------------------------

#---------------------------------------------------------------------------
   log_this "   Tarring Nirvana Acq for : "

#   set -x
   cd $lnxobjdir/proglib
   mkdir -p $dest_dir_code/tmp/acq/download
   mkdir -p $dest_dir_code/tmp/acq/download3x
   tar -cf - $nvAcqFiles | (cd $dest_dir_code/tmp/acq/download; tar $taroption -)
   tar -cf - $nvAcq3xFiles | (cd $dest_dir_code/tmp/acq/download3x; tar $taroption -)
   cd $commondir/sysnvacqkernel
   tar -cf - $nvAcqKernelFiles | (cd $dest_dir_code/tmp/acq/download; tar $taroption -)
   tar -cf - $nvAcq3xKernelFiles | (cd $dest_dir_code/tmp/acq/download3x; tar $taroption -)
   cd $dest_dir_code/tmp/acq/download
# -- ndds 4.1e -----
#   mv vxWorks405gpr.bdx.md5_ndds4x vxWorks405gpr.md5
#   mv vxWorks405gpr.bdx_ndds4x vxWorks405gpr.bdx
# -- ndds 4.2e -----
   mv vxWorks405gpr.bdx_ndds_4.2e vxWorks405gpr.bdx
   mv vxWorks405gpr.bdx.md5_ndds_4.2e vxWorks405gpr.md5
   #make a backup copy for the user
   cp nvScript nvScript.std
   cp nvScript.md5 nvScript.std.md5
# -- ndds 3x -----
   cd $dest_dir_code/tmp/acq/download3x
   #make a backup copy for the user
   cp nvScript nvScript.std
   cp nvScript.md5 nvScript.std.md5
   mv vxWorks405gpr.bdx.md5 vxWorks405gpr.md5
# -----------------
   cd $dest_dir_code/tmp
   chmod 755    ./acq
   chmod 755    ./acq/download
   chmod 755    ./acq/download3x
   tar -cf $dest_dir_code/$Inova/nvacq.tar *
   if [ x$winbuild != "xtrue" ]
   then
     make_TOC nvacq.tar $Inova $Vnmr rht/inova.rht	\
                                     rht/vnmrs.rht	\
                                     rht/mr400.rht
   else
     make_TOC nvacq.tar $Inova $Vnmr win/vnmrs.win	\
                                     win/mr400.win
   fi
#   set +x

#---------------------------------------------------------------------------
#Linux:
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring (lnx) acqbin		for : "

      cd $solobjdir
      tar -cf - $iProcLinuxFam | (cd $dest_dir_code/tmp; tar $taroption -)
      mkdir -p $dest_dir_code/tmp/bin
      (cd $dest_dir_code/tmp/bin
       cp $lnxproglib_dir/tcl/spincad.tbc spincad
       cp $vcommondir/bin/lnvsetacq .
       cp $vcommondir/bin/lnvsetacq2 .
       cp $vcommondir/bin/restore3x .
       chmod 755 spincad lnvsetacq lnvsetacq2 restore3x
       ln -s lnvsetacq setacq
      )
      cd $dest_dir_code/tmp
      mkdir acqbin
      mv Atproc Autoproc Expproc Infoproc Procproc Recvproc Roboproc Sendproc \
	   consoledownload3x consoledownload42x 	\
           flashia3x flashia42x testconf3x testconf42x \
           acqbin
      chmod -R 755 acqbin
      chmod 755    ./acq
      chmod 644    ./acq/*
      chmod -R 755 ./bin
      setperms ./spincad 755 644 755
      tar -cf $dest_dir_code/$Linux/acqbinlnx.tar *
      make_TOC acqbinlnx.tar $Linux $Vnmr rht/inova.rht	\
                                          rht/vnmrs.rht	\
                                          rht/mr400.rht
   fi

#---------------------------------------------------------------------------
#Windows: 
   if [ x$winbuild = "xtrue" ]
   then
     log_this "   Tarring (win) acqbin		for : "

     cd $solobjdir
     tar -cf - $iProcWindowsFam | (cd $dest_dir_code/tmp; tar $taroption -)
     mkdir -p $dest_dir_code/tmp/bin
     (cd $dest_dir_code/tmp/bin
      #cp $winproglib_dir/tcl/spincad.tbc spincad
      cp $vcommondir/bin/lnvsetacq .
      chmod 755 spincad lnvsetacq
      ln -s lnvsetacq setacq
     )
     cd $dest_dir_code/tmp
     mkdir acqbin
     mv Atproc Autoproc Expproc Infoproc Procproc Recvproc Roboproc Sendproc \
	  consoledownload flashia acqbin
     chmod -R 755 acqbin
     chmod 755    ./acq
     chmod 644    ./acq/*
     chmod -R 755 ./bin
     #setperms ./spincad 755 644 755
     tar -cf $dest_dir_code/$Windows/acqbinwin.tar *
     make_TOC acqbinwin.tar $Windows $Vnmr win/vnmrs.win	\
                                           win/mr400.win
  fi

#---------------------------------------------------------------------------
#Java Runtime Environment common to both JPSG and VNMRJ
   if [ x$winbuild != "xtrue" ]
   then
#      rm -rf $dest_dir_code/jre
      rm -rf $dest_dir_code/jre.linux
      if [ x$LoadVnmrJ = "xy" ]
      then
#	mkdir $dest_dir_code/jre
#	(cd /vcommon/JRE; tar -cf - * | (cd $dest_dir_code/jre; tar $taroption -))
	mkdir $dest_dir_code/jre.linux
	(cd /vcommon/JRE.linux; tar -cf - * | (cd $dest_dir_code/jre.linux; tar $taroption -))
      fi

#      log_this "   Tarring Solaris JRE 	for : "
#      cd $dest_dir_code/tmp
#      mkdir jre
#      (cd /vcommon/JRE; tar -cf - * | (cd $dest_dir_code/tmp/jre; tar $taroption -))
#      tar cf $dest_dir_code/$Inova/jre.tar jre
#
#      #the real file is a directory,  code/jre
#      make_TOC  jre   ""   $Vnmr    sol/inova.sol	\
#                                    sol/vnmrs.sol
#
#      #odd ball, just want to get the size of tar file info to TOC, don't want the actual file
#      rm $dest_dir_code/$Inova/jre.tar

#Linux:
      log_this "   Tarring Linux JRE 	for : "

      cd $dest_dir_code/tmp
      mkdir jre
      (cd /vcommon/JRE.linux; tar -cf - * | (cd $dest_dir_code/tmp/jre; tar $taroption -))
      tar cf $dest_dir_code/$Linux/jre.tar jre

      #the real file is a directory,  code/jre.linux
      make_TOC jre.linux "" $Vnmr rht/inova.rht	\
                                  rht/vnmrs.rht	\
                                  rht/mr400.rht

      #odd ball, just want to get the size of tar file info to TOC, don't want the actual file
      rm $dest_dir_code/$Linux/jre.tar
   else
#Windows
      log_this "   Tarring JRE 		for : "

      if [ x$LoadVnmrJ = "xy" ]
      then
	mkdir $dest_dir_code/jre.win
	(cd /vcommon/JRE.windows; tar -cf - * | (cd $dest_dir_code/jre.win; tar $taroption -))
      fi

      cd $dest_dir_code/tmp
      mkdir jre
      (cd /vcommon/JRE.windows; tar -cf - * | (cd $dest_dir_code/tmp/jre; tar $taroption -))
      tar cf $dest_dir_code/$Windows/jre.tar jre
      mv jre jre.win
      
      #the real file is a directory,  code/jre.linux
      make_TOC jre.win "" $Vnmr win/vnmrs.win	\
                                win/mr400.win

      #odd ball, just want to get the size of tar file info to TOC, don't want the actual file
      rm $dest_dir_code/$Windows/jre.tar
   fi

#---------------------------------------------------------------------------
    log_this "   Tarring JPSG stuff		for : "

    cd $dest_dir_code/tmp
    mkdir jpsg
    tar -cf - $Jpsg2Tar | (cd $dest_dir_code/tmp/jpsg; tar $taroption -)
    cd $dest_dir_code/tmp
    setperms ./ 755 644 755
    chmod 755 ./jpsg/Jpsg
    tar -cf $dest_dir_code/$Inova/jpsg.tar jpsg
    if [ x$winbuild != "xtrue" ]
    then
	make_TOC jpsg.tar $Inova $Vnmr sol/inova.sol	\
                                       sol/vnmrs.sol	\
                                       rht/inova.rht	\
                                       rht/vnmrs.rht	\
                                       rht/mr400.rht
    else
	make_TOC jpsg.tar $Inova $Vnmr win/vnmrs.win	\
                                       win/mr400.win
    fi

#---------------------------------------------------------------------------
# start VJ Sections
#    set -x
#---------------------------------------------------------------------------
# VJ Section 1
if [ x$LoadVnmrJ = "xy" ]
then
   log_this "   Tarring VJ jar		for : "

   if [ x$winbuild != "xtrue" ]
   then
     cd $dest_dir_code/tmp
     mkdir java
     mkdir lib
     tar -cf - $VnmrJJar2Tar | (cd $dest_dir_code/tmp/java; tar $taroption -)
     setperms  ./java 755 644 755

     #  Just to clearify, the previous tar just copied the appropriate files into
     #  /vnmrcd/cdimageVJ/tmp/java. Both the vnmrj.jar and the vnmrj.jar.dasho
     #  Now on the fly  in the tmp directory, for dasho usage we delete the vnmrj.jar and
     #  move the vnmrj.jar.dasho to vnmrj.jar
     #  This method is used also for managedb jars, see below
   
     if [ $useDasho = "y" ]
     then
	#delete vnmrj.jar and replace it with dasho jar
	rm -f $dest_dir_code/tmp/java/vnmrj.jar
	mv $dest_dir_code/tmp/java/vnmrj.jar.dasho $dest_dir_code/tmp/java/vnmrj.jar
     else
	rm -f $dest_dir_code/tmp/java/vnmrj.jar.dasho
     fi

     tar -cf $dest_dir_code/$Inova/vnmrj.tar *
     make_TOC vnmrj.tar $Inova $Vnmr sol/inova.sol	\
                                     sol/vnmrs.sol

     #Linux stuffs
     log_this "   Tarring VJ jar		for : "
     cd $dest_dir_code/tmp
     mkdir java
     tar -cf - $VnmrJJarLinux2Tar | (cd $dest_dir_code/tmp/java; tar $taroption -)
     setperms  ./java 755 644 755
     if [ $useDasho = "y" ]
     then
	#delete vnmrj.jar and replace it with dasho jar
	rm -f $dest_dir_code/tmp/java/vnmrj.jar
	mv $dest_dir_code/tmp/java/vnmrj.jar.dasho $dest_dir_code/tmp/java/vnmrj.jar
     else
	rm -f $dest_dir_code/tmp/java/vnmrj.jar.dasho
     fi


     tar -cf $dest_dir_code/$Linux/vnmrj.tar *
     make_TOC vnmrj.tar $Linux $Vnmr rht/inova.rht	\
                                     rht/vnmrs.rht	\
                                     rht/mr400.rht
   else
     #Windows stuffs
     log_this "   Tarring VJ jar		for : "
     cd $dest_dir_code/tmp
     mkdir java
     tar -cf - $VnmrJJarWindows2Tar | (cd $dest_dir_code/tmp/java; tar $taroption -)
     setperms  ./java 755 644 755
     if [ $useDasho = "y" ]
     then
	#delete vnmrj.jar and replace it with dasho jar
	rm -f $dest_dir_code/tmp/java/vnmrj.jar
	mv $dest_dir_code/tmp/java/vnmrj.jar.dasho $dest_dir_code/tmp/java/vnmrj.jar
     else
	rm -f $dest_dir_code/tmp/java/vnmrj.jar.dasho
     fi

     tar -cf $dest_dir_code/$Windows/vnmrj.tar *
     make_TOC vnmrj.tar $Windows $Vnmr win/vnmrs.win	\
                                       win/mr400.win
   fi
fi

#---------------------------------------------------------------------------
# VJ Section 2
     if [ x$LoadVnmrJ = "xy" ]
     then
        log_this "   Tarring VJ admin jar		for : "

        cd $dest_dir_code/tmp
        mkdir java
        tar -cf - $VnmrJAdmJar2Tar | (cd $dest_dir_code/tmp/java; tar $taroption -)
        # save VnmrAdmin.jar inside code, 
        # so we do not have to untar this large file twice
	cp java/VnmrAdmin.jar $dest_dir_code
        setperms  ./java 755 644 755
        if [ $useDasho = "y" ]
        then
           #delete vnmrj.jar and replace it with dasho jar
           #set -x
	   rm -f $dest_dir_code/tmp/java/managedb.jar
	   mv $dest_dir_code/tmp/java/managedb.jar.dasho $dest_dir_code/tmp/java/managedb.jar
           #set +x
        else
	   rm -f $dest_dir_code/tmp/java/managedb.jar.dasho
        fi
        tar -cf $dest_dir_code/$Inova/vnmrjadmjar.tar *
	if [ x$winbuild != "xtrue" ]
	then
	    make_TOC vnmrjadmjar.tar $Inova $Vnmr sol/inova.sol	\
                                                  sol/vnmrs.sol	\
						  rht/inova.rht	\
                                                  rht/vnmrs.rht	\
                                                  rht/mr400.rht
	else
	    make_TOC vnmrjadmjar.tar $Inova $Vnmr win/vnmrs.win	\
                                                  win/mr400.win
	fi
     fi

#---------------------------------------------------------------------------
# VJ Section 3
     if [ x$LoadVnmrJ = "xy" ]
     then
        log_this "   Tarring VJ bin		for : "

	if [ x$winbuild != "xtrue" ]
	then
	    cd $dest_dir_code/tmp
	    mkdir bin
	    tar -cf - $VnmrJBin2Tar | (cd $dest_dir_code/tmp/bin; tar $taroption -)
	    cp ./bin/vnmrj ./bin/vnmr
	    cp $solproglib_dir/vnmrbg/Vnmrbg ./bin/Vnmrbg
	    setperms  ./bin 755 644 555
	    tar -cf $dest_dir_code/$Inova/vnmrjbin.tar *
	    make_TOC vnmrjbin.tar $Inova $Vnmr sol/inova.sol	\
                                               sol/vnmrs.sol
   
	    log_this "   Tarring Linux VJ bin		for : "
	    cd $dest_dir_code/tmp
	    mkdir bin
	    tar -cf - $VnmrJBin2Tar | (cd $dest_dir_code/tmp/bin; tar $taroption -)
	    cp ./bin/vnmrj ./bin/vnmr
	    cp $lnxproglib_dir/vnmrbg/Vnmrbg ./bin/Vnmrbg
	    setperms  ./bin 755 644 555
	    tar -cf $dest_dir_code/$Linux/vnmrjlnxbin.tar *
	    make_TOC vnmrjlnxbin.tar $Linux $Vnmr rht/inova.rht	\
                                                  rht/vnmrs.rht	\
                                                  rht/mr400.rht
	else
	    log_this "   Tarring Windows VJ bin		for : "
	    cd $dest_dir_code/tmp
	    mkdir bin
	    tar -cf - $VnmrJBin2Tar | (cd $dest_dir_code/tmp/bin; tar $taroption -)
	    cp ./bin/vnmrj ./bin/vnmr
	    cp $winproglib_dir/vnmrbg/Vnmrbg ./bin/Vnmrbg
	    setperms  ./bin 755 644 555
	    tar -cf $dest_dir_code/$Windows/vnmrjwinbin.tar *
	    make_TOC vnmrjwinbin.tar $Windows $Vnmr win/vnmrs.win	\
                                                    win/mr400.win
	fi
     fi

#---------------------------------------------------------------------------
# VJ Section 4
     if [ x$LoadVnmrJ = "xy" ]
     then
	if [ x$winbuild != "xtrue" ]
	then
#	    log_this "   Tarring VJ postgres		for : "
#	    cd $dest_dir_code/tmp
#	    tar -cf - $VnmrJPgsql2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
#	    mv create_pgsql_user pgsql/bin
#	    setperms ./shuffler 755 644 755
#	    tar -cf $dest_dir_code/$Inova/vnmrjpgsql.tar *
#	    make_TOC vnmrjpgsql.tar $Inova $Vnmr sol/inova.sol	\
#                                                 sol/vnmrs.sol

	    #Linux:
	    log_this "   Tarring VJ postgres		for : "
	    cd $dest_dir_code/tmp
	    tar -cf - $VnmrJPgsqlLinux2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
	    mv pgsql.lnx pgsql
	    mv create_pgsql_user pgsql/bin
	    setperms ./shuffler 755 644 755
	    tar -cf $dest_dir_code/$Inova/vnmrjpgsqllnx.tar *
	    make_TOC vnmrjpgsqllnx.tar $Inova $Vnmr rht/inova.rht	\
                                                    rht/vnmrs.rht	\
                                                    rht/mr400.rht
	else
	    #Windows:
	    log_this "   Tarring VJ postgres		for : "
	    cd $dest_dir_code/tmp
	    tar -cf - $VnmrJPgsqlWindows2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
	    mv pgsql.win pgsql
	    mv create_pgsql_user pgsql/bin
	    setperms ./shuffler 755 644 755
	    tar -cf $dest_dir_code/$Inova/vnmrjpgsqlwin.tar *
	    make_TOC vnmrjpgsqlwin.tar $Inova $Vnmr win/vnmrs.win	\
                                                    win/mr400.win
	fi
     fi

#---------------------------------------------------------------------------
# VJ Section 5
     if [ x$LoadVnmrJ = "xy" ]
     then
        log_this "   Tarring VJ maclib		for : "

        cd $dest_dir_code/tmp
        mkdir -p adm/users/profiles/data
        mkdir -p adm/users/profiles/templates
        mkdir -p adm/groups/profiles
        tar -cf - $VnmrJAdm2Tar | (cd $dest_dir_code/tmp; tar $taroption -)

	if [ x$winbuild != "xtrue" ]
	then
	    mv userDefaults adm/users
	    mv userlist.xml adm/users
            rm -f userDefaults.win userlist.xml.win
	else
	    mv userDefaults.win adm/users/userDefaults
	    mv userlist.xml.win adm/users/userlist.xml
            rm -f userDefaults userlist.xml
	fi

	mv grouplist.xml adm/groups
        setperms ./adm/users 755 644 755
        setperms ./adm/groups 755 644 755
        tar -cf - $VnmrJ2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
        chmod 644 ./maclib/*
        chmod 644 ./menujlib/*

        tar -cf $dest_dir_code/$Inova/vnmrjtxt.tar *
	if [ x$winbuild != "xtrue" ]
	then
	    make_TOC vnmrjtxt.tar $Inova $Vnmr sol/inova.sol	\
                                               sol/vnmrs.sol	\
					       rht/inova.rht	\
                                               rht/vnmrs.rht	\
                                               rht/mr400.rht
	else
	    make_TOC vnmrjtxt.tar $Inova $Vnmr win/vnmrs.win	\
                                               win/mr400.win
	fi
     fi

#---------------------------------------------------------------------------
# VJ Section 6
     if [ x$LoadVnmrJ = "xy" ]
     then
        log_this "   Tarring VJ templates		for : "

        cd $dest_dir_code/tmp
        tar -cf - $VnmrJTempl2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
        tar -cf - $Walkup2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
        tar -cf - $VnmrJProperties2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
	mkdir -p templates/vnmrj/properties
	mv -f cmdResources.properties templates/vnmrj/properties
	mv -f paramResources.properties templates/vnmrj/properties
	mv -f recConfig templates/vnmrj/properties
	mv -f filename_templates templates/vnmrj/properties
	mv -f studyname_templates templates/vnmrj/properties
        mv -f labelResources2.list templates/vnmrj/properties
        mv -f labelResources.list templates/vnmrj/properties
        mv -f vjLabels.list templates/vnmrj/properties
        mv -f vjAdmLabels.list templates/vnmrj/properties
        mv -f tooltipResources.list templates/vnmrj/properties
        mv -f messageResources.list templates/vnmrj/properties

        if [ x$LoadP11 = "xy" ]
        then
            mkdir -p p11
            mkdir -p adm/p11
            touch adm/p11/sysListAll
            mkdir -p adm/users/profiles

            tar -cf - $P11Xml2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
            mv -f accPolicy                adm/users/profiles
            mv -f part11Config             p11
            mv -f AdminMenu.xml.p11        templates/vnmrj/interface/AdminMenu.xml
            mv -f MainMenu.xml.p11         templates/vnmrj/interface/MainMenu.xml
            mv -f MainMenuData.xml.p11     templates/vnmrj/interface/MainMenuData.xml
            mv -f MainMenuDisplay.xml.p11  templates/vnmrj/interface/MainMenuDisplay.xml
            mv -f MainMenuUtil.xml.p11     templates/vnmrj/interface/MainMenuUtil.xml
            mv -f DefaultToolBar.xml.p11   templates/vnmrj/interface/DefaultToolBar.xml
            mv -f audit.xml saveas.xml cmdHis.xml  templates/vnmrj/interface

            setperms ./p11 755 644 755
        fi

        setperms  ./templates 755 644 755
        setperms  ./walkup 755 644 755
        tar -cf $dest_dir_code/$Inova/vnmrjtempl.tar *
	if [ x$winbuild != "xtrue" ]
	then
	    make_TOC vnmrjtempl.tar $Inova $Vnmr   sol/inova.sol	\
                                                   sol/vnmrs.sol	\
						   rht/inova.rht	\
                                                   rht/vnmrs.rht	\
                                                   rht/mr400.rht
	else
	    make_TOC vnmrjtempl.tar $Inova $Vnmr   win/vnmrs.win	\
                                                   win/mr400.win
	fi
     fi

#---------------------------------------------------------------------------
# VJ Section 7
     if [ x$LoadVnmrJ = "xy" ]
     then
        log_this "   Tarring VJ iconlib		for : "

        cd $dest_dir_code/tmp
        cp -r $vcommondir/iconlib/vnmrbg_iconlib iconlib
        chmod 644 ./iconlib/*
        tar -cf $dest_dir_code/$Inova/vnmrjicons.tar *
	if [ x$winbuild != "xtrue" ]
	then
	    make_TOC vnmrjicons.tar $Inova $Vnmr sol/inova.sol	\
                                                 sol/vnmrs.sol	\
						 rht/inova.rht	\
                                                 rht/vnmrs.rht	\
                                                 rht/mr400.rht
	else
	    make_TOC vnmrjicons.tar $Inova $Vnmr win/vnmrs.win	\
                                                 win/mr400.win
	fi
     fi
#---------------------------------------------------------------------------
# VJ Section 8
if [ x$LoadVnmrJ = "xy" ]
then
   log_this " Tarring VJMol jar	  for: "
   cd $dest_dir_code/tmp
   mkdir java
   tar -cf - $VJMolJar2Tar | (cd $dest_dir_code/tmp/java; tar $taroption -)
   setperms  ./java 755 644 755
   mv java/mollib mollib
   setperms  ./mollib 755 644 755

   tar -cf $dest_dir_code/$Inova/vjmol.tar *
   if [ x$winbuild != "xtrue" ]
   then
     make_TOC vjmol.tar $Inova "Jmol" sol/inova.sol	\
                                      sol/vnmrs.sol	\
                                      rht/inova.rht	\
                                      rht/vnmrs.rht	\
                                      rht/mr400.rht
   else
     make_TOC vjmol.tar $Inova "Jmol" win/vnmrs.win	\
                                      win/mr400.win
   fi
fi

#---------------------------------------------------------------------------
# VJ Section 9
if [ x$LoadVnmrJ = "xy" ]
then
   log_this " Tarring JChemPaint jar	  for: "
   cd $dest_dir_code/tmp
   mkdir java
   tar -cf - $VJChemPaintJar2Tar | (cd $dest_dir_code/tmp/java; tar $taroption -)
   setperms  ./java 755 644 755

   tar -cf $dest_dir_code/$Inova/jchempaint.tar *
   if [ x$winbuild != "xtrue" ]
   then
     make_TOC jchempaint.tar $Inova "JChemPaint" sol/inova.sol	\
                                                 sol/vnmrs.sol	\
                                                 rht/inova.rht	\
                                                 rht/vnmrs.rht	\
                                                 rht/mr400.rht
   else
     make_TOC jchempaint.tar $Inova "JChemPaint" win/vnmrs.win	\
                                                 win/mr400.win
   fi
fi

#---------------------------------------------------------------------------
# VJ Section 10
if [ x$LoadVnmrJ = "xy" ]
then
   log_this " Tarring VJ Vnmrs      	  for: "

   cd $dest_dir_code/tmp
   tar -cf - $VnmrsVnmrJTempl2Tar | (cd $dest_dir_code/tmp; tar $taroption -)

   mv templates_vnmrs templates
   setperms  ./templates 755 644 755
   tar -cf $dest_dir_code/$Vnmrs/vnmrsvnmrjtempl.tar *
   if [ x$winbuild != "xtrue" ]
   then
      make_TOC vnmrsvnmrjtempl.tar $Vnmrs $Vnmr  sol/vnmrs.sol	\
                                                 rht/vnmrs.rht
   else
      make_TOC vnmrsvnmrjtempl.tar $Vnmrs $Vnmr  win/vnmrs.win
   fi
fi
#---------------------------------------------------------------------------
# VJ Section 11  accounting removed 
if [ x$LoadVnmrJ = "xy" ]
then
   log_this " Tarring JAccount jar        for: "
   cd $dest_dir_code/tmp
   mkdir java
   tar -cf - $VJAccountsJar2Tar | (cd $dest_dir_code/tmp/java; tar $taroption -)
   setperms  ./java 755 644 755

   if [ $useDasho = "y" ]
   then
        #delete vnmrj.jar and replace it with dasho jar
        rm -f java/account.jar
        mv java/account.jar.dasho java/account.jar
   else
        rm -f java/account.jar.dasho
   fi

   tar -cf $dest_dir_code/$Inova/vjaccounts.tar *
   if [ x$winbuild != "xtrue" ]
   then
     make_TOC vjaccounts.tar $Inova $Vnmr sol/inova.sol \
                                          sol/vnmrs.sol \
                                          rht/inova.rht \
                                          rht/vnmrs.rht \
                                          rht/mr400.rht
   else
     make_TOC vjaccounts.tar $Inova $Vnmr win/vnmrs.win \
                                          win/mr400.win
   fi
fi

#---------------------------------------------------------------------------
# VJ Section 12
if [ x$LoadVnmrJ = "xy" ]
then
   log_this " Tarring Chinese files   for: "
   cd $dest_dir_code/tmp
   tar -cf - $ChineseFiles2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   mkdir -p templates/vnmrj/properties
   mv -f labelResources2_zh_CN.properties templates/vnmrj/properties
   mv -f labelResources_zh_CN.properties templates/vnmrj/properties
   mv -f vjLabels_zh_CN.properties templates/vnmrj/properties
   mv -f vjAdmLabels_zh_CN.properties templates/vnmrj/properties
   mv -f tooltipResources_zh_CN.properties templates/vnmrj/properties
   mv -f messageResources_zh_CN.properties templates/vnmrj/properties
   mv -f paramResources_zh_CN.properties templates/vnmrj/properties

   setperms  ./templates 755 644 755

   tar -cf $dest_dir_code/$Vnmrs/chinese.tar *
   if [ x$winbuild != "xtrue" ]
   then
     make_TOC chinese.tar $Vnmrs "Chinese" sol/vnmrs.sol \
                                             rht/vnmrs.rht \
                                             rht/mr400.rht
   else
     make_TOC chinese.tar $Vnmrs "Chinese" win/vnmrs.win \
                                             win/mr400.win
   fi
fi

#---------------------------------------------------------------------------
# VJ Section 12
if [ x$LoadVnmrJ = "xy" ]
then
   log_this " Tarring Japanese files   for: "
   cd $dest_dir_code/tmp
   tar -cf - $JapaneseFiles2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   mkdir -p templates/vnmrj/properties
   mv -f labelResources2_ja.properties templates/vnmrj/properties
   mv -f labelResources_ja.properties templates/vnmrj/properties
   mv -f vjLabels_ja.properties templates/vnmrj/properties
   mv -f vjAdmLabels_ja.properties templates/vnmrj/properties
   mv -f tooltipResources_ja.properties templates/vnmrj/properties
   mv -f messageResources_ja.properties templates/vnmrj/properties
   mv -f paramResources_ja.properties templates/vnmrj/properties

   setperms  ./templates 755 644 755

   tar -cf $dest_dir_code/$Vnmrs/japanese.tar *
   if [ x$winbuild != "xtrue" ]
   then
     make_TOC japanese.tar $Vnmrs "Japanese" sol/vnmrs.sol \
                                             rht/vnmrs.rht \
                                             rht/mr400.rht
   else
     make_TOC japanese.tar $Vnmrs "Japanese" win/vnmrs.win \
                                             win/mr400.win
   fi
fi

#---------------------------------------------------------------------------
#    set +x
# end VJ Sections
#---------------------------------------------------------------------------
   log_this "   Tarring java cryo stuff	for : "

   cd $dest_dir_code/tmp
   mkdir java
   tar -cf - $Cryo2Tar | (cd $dest_dir_code/tmp/java; tar $taroption -)
   chmod 755 java
   chmod 644 java/cryo.jar
   tar -cf $dest_dir_code/$Inova/cryo.tar java
   if [ x$winbuild != "xtrue" ]
   then
     make_TOC cryo.tar $Inova $Vnmr sol/inova.sol	\
                                    sol/vnmrs.sol	\
				    rht/inova.rht	\
                                    rht/vnmrs.rht	\
                                    rht/mr400.rht
   else
     make_TOC cryo.tar $Inova $Vnmr win/vnmrs.win	\
                                    win/mr400.win
   fi

#---------------------------------------------------------------------------
   log_this "   Tarring Jplot		for : "

   cd $solobjdir
   tar -cf - $Jplot2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   tar -cf $dest_dir_code/$Inova/java.tar java
   if [ x$winbuild != "xtrue" ]
   then
     make_TOC java.tar $Inova $Vnmr sol/inova.sol	\
                                    sol/vnmrs.sol	\
				    rht/inova.rht	\
                                    rht/vnmrs.rht	\
                                    rht/mr400.rht
   else
     make_TOC java.tar $Vnmrs $Vnmr win/vnmrs.win	\
                                    win/mr400.win
   fi

#---------------------------------------------------------------------------
   log_this " Tarring Apt		for : "

   cd $solobjdir
   tar -cf - $Apt2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   tar -cf $dest_dir_code/$Inova/apt.tar java
   if [ x$winbuild != "xtrue" ]
   then
     make_TOC apt.tar $Inova $Vnmr sol/inova.sol	\
                                    sol/vnmrs.sol	\
				    rht/inova.rht	\
                                    rht/vnmrs.rht	\
                                    rht/mr400.rht
   else
     make_TOC apt.tar $Vnmrs $Vnmr win/vnmrs.win	\
                                   win/mr400.win
   fi

#---------------------------------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring libraries		for : "

      cd $solproglib_dir
      tar -cf - $iLibs2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      mv ncomm lib
      mv dicom/* lib
      chmod 755 ./lib/lib*.so*
      chmod 644 ./lib/lib*.a
      chmod 644 ./lib/dicom.dic
      tar -cf $dest_dir_code/$Inova/libs.tar lib
      make_TOC libs.tar $Inova $Vnmr sol/inova.sol	\
                                     sol/vnmrs.sol
   fi

#---------------------------------------------------------------------------
#Linux:
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring NCOMM shared libs	for : "

      cd $lnxproglib_dir
      tar -cf - $iLibsLinux2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      mv ncomm lib
      chmod 755 lib/lib*.so*
      tar -cf $dest_dir_code/$Linux/ncommlibs.tar lib
      make_TOC ncommlibs.tar $Linux $Vnmr rht/inova.rht	\
                                          rht/vnmrs.rht	\
                                          rht/mr400.rht
   fi

#---------------------------------------------------------------------------
#Windows:
   if [ x$winbuild = "xtrue" ]
   then
     log_this "   Tarring NCOMM shared libs	for : "

     cd $winproglib_dir
     tar -cf - $iLibsWindows2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
     cd $dest_dir_code/tmp
     mv ncomm lib
     chmod 755 lib/lib*.so*
     tar -cf $dest_dir_code/$Windows/ncommlibs.tar lib
     make_TOC ncommlibs.tar $Windows $Vnmr win/vnmrs.win	\
                                           win/mr400.win
   fi

#---------------------------------------------------------------------
 
#============== OPTION FILES ========================================
echo ""  | tee -a $log_file
log_this "PART XI -- OPTION FILES -- $dest_dir_code/\`option'"
##---------------------------------------------------------------------------
# tar the PFG common files maclib, manual, psglib
   log_this "   Tarring  PFG Text			for : "

   cd $vcommondir/PFG
   tar -cf - $ComPFG2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   chmod 755   ./parlib
   chmod 755   ./parlib/*
   chmod 644   ./parlib/*/*
   chmod 755   ./maclib
   chmod 644   ./maclib/*
   chmod 755   ./manual
   chmod 644   ./manual/*
   mkdir -p $dest_dir_code/tmp/psglib
   cd $solproglib_dir/psglib
   for cfile in $PFG_PS_2Tar
   do
        cp $cfile.c $dest_dir_code/tmp/psglib
   done
   cd $dest_dir_code/tmp
   chmod 755   ./psglib
   chmod 644   ./psglib/*
   tar -cf $dest_dir_code/$Pfg/$Common/pfg.tar *
   if [ x$winbuild != "xtrue" ]
   then
     make_TOC pfg.tar $Pfg/$Common "PFG"  sol/inova.sol	\
                                          sol/vnmrs.sol	\
					  rht/inova.rht	\
                                          rht/vnmrs.rht	\
                                          rht/mr400.rht
   else
     make_TOC pfg.tar $Pfg/$Common "PFG"  win/vnmrs.win	\
                                          win/mr400.win
   fi
 
#---------------------------------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
      log_this  "   Tarring PFG seqlib			for : "

      mkdir -p $dest_dir_code/tmp/seqlib
      cd $solproglib_dir/nvseqlib
      for cfile in $PFG_PS_2Tar
      do
        cp $cfile $dest_dir_code/tmp/seqlib
      done
      cd $dest_dir_code/tmp
      chmod 755   ./seqlib
      chmod 755   ./seqlib/*
      tar -cf $dest_dir_code/$Pfg/$Unity/pfgobj.tar *
      make_TOC pfgobj.tar $Pfg/$Unity "PFG" sol/inova.sol	\
                                            sol/vnmrs.sol
   fi

#---------------------------------------------------------------------------
#Linux:
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Linux PFG seqlib		for : "

      mkdir -p $dest_dir_code/tmp/seqlib
      cd $lnxproglib_dir/nvseqlib
      for cfile in $PFG_PS_2Tar
      do
        cp $cfile $dest_dir_code/tmp/seqlib
      done
      cd $dest_dir_code/tmp
      chmod 755   ./seqlib
      chmod 755   ./seqlib/*
      tar -cf $dest_dir_code/$Linux/pfgobj.tar *
      make_TOC pfgobj.tar $Linux "PFG" rht/inova.rht	\
                                       rht/vnmrs.rht	\
                                       rht/mr400.rht
   fi
#---------------------------------------------------------------------------
#Windows:
   if [ x$winbuild = "xtrue" ]
   then
     log_this "   Tarring Windows PFG seqlib		for : "

     mkdir -p $dest_dir_code/tmp/seqlib
     if [ -d $winproglib_dir/nvseqlib ]
     then
	cd $winproglib_dir/nvseqlib
	for cfile in $PFG_PS_2Tar
	do
	    cp $cfile $dest_dir_code/tmp/seqlib
	done
	cd $dest_dir_code/tmp
	chmod 755   ./seqlib
	chmod 755   ./seqlib/*
	tar -cf $dest_dir_code/$Windows/pfgobj.tar *
	make_TOC pfgobj.tar $Windows "PFG" win/vnmrs.win	\
                                           win/mr400.win
     else
	echo "$winproglib_dir/nvseqlib does not exist"
     fi
   fi

#---------------------------------------------------------------------------
# tar the Sudo files
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Sudo Files			for : "

      cd $vcommondir
      tar -cf $dest_dir_code/$Common/sudo.tar sudo
      make_TOC sudo.tar $Common $Vnmr sol/inova.sol	\
                                      sol/vnmrs.sol
      
      #Linux
      log_this "   Tarring Sudo Files			for : "

      cd $vcommondir
      tar -cf $dest_dir_code/$Linux/sudo.tar sudo.lnx
      make_TOC sudo.tar $Linux $Vnmr rht/inova.rht	\
                                     rht/vnmrs.rht	\
                                     rht/mr400.rht
   fi

#
#---------------------------------------------------------------------------
# tar the kermit files
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Kermit Text			for : "

      cd $vcommondir
      tar -cf - $ComKermit2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      chmod 755   ./kermit
      chmod 644   ./kermit/*
      tar cf $dest_dir_code/$Kermit/kermit.tar kermit
      make_TOC kermit.tar $Kermit "Kermit" sol/inova.sol	\
                                           sol/vnmrs.sol	
      rm -rf $dest_dir_code/tmp/*

      log_this "   Tarring Kermit Objects		for : "
      cd $vcommondir
      tar -cf - $Bin4Kermit2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      chmod -R 755   ./kermit
      tar -cf $dest_dir_code/$Kermit/$Solaris/kermit.tar kermit
      make_TOC kermit.tar $Kermit/$Solaris "Kermit" sol/inova.sol	\
                                                    sol/vnmrs.sol
   fi
#
#---------------------------------------------------------------------------
# tar the kermit files
   if [ x$winbuild = "xtrue" ]
   then
      log_this "   Tarring Kermit-XP Text		for : "

      cd $vcommondir
      tar -cf - $ComWindowsKermit2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      mv ./Kermit.XP_version kermit
      chmod 755   ./kermit
      chmod 644   ./kermit/*
      tar cf $dest_dir_code/$Kermit/kermit.tar kermit
      make_TOC tclwin.tar $Windows "Kermit" win/vnmrs.win	\
                                            win/mr400.win
      rm -rf $dest_dir_code/tmp/*

      log_this "   Tarring Kermit-XP Objects	for : "
      cd $vcommondir
      tar -cf - $BinWindows4Kermit2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      mv ./Kermit.XP_version kermit
      chmod -R 755   ./kermit
      tar -cf $dest_dir_code/$Kermit/$Windows/kermit.tar kermit
      make_TOC kermit.tar $Kermit/$Windows "Kermit" win/vnmrs.win	\
                                                    win/mr400.win
   fi
#
#---------------------------------------------------------------------------
# tar the GNU files
#  if [ x$winbuild != "xtrue" ]
#  then
#    if [ x$gnu_answer = "xy" ]
#    then
#	log_this "   Tarring GNU Files		for : "
#
#	cd /vcommon
#	tar -cf $dest_dir_code/$Gnu/gnu.tar $GNU4Solaris2Tar
#	make_TOC gnu.tar $Gnu "GNU_Compiler" sol/inova.sol	\
#                                             sol/vnmrs.sol
#
#    else
#	log_this " Skipping GNU		for : "
#	make_TOC gnu.tar $Gnu "GNU_Compiler" sol/inova.sol	\
#                                             sol/vnmrs.sol
#
#    fi
#  fi
# 
#---------------------------------------------------------------------------
# tar the IMAGE common files maclib, manual, imaging
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring IMAGE Text		for : "

      cd $vcommondir/IMAGE
      tar -cf - $ComIMAGE2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $vcommondir/IMAGE2
      tar -cf - $ComIMAGE22Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      mkdir -p $dest_dir_code/tmp/imaging/psglib
      cd $solproglib_dir/psglib
      for cfile in $IMAGE_PS_2Tar
      do
        cp $cfile.c $dest_dir_code/tmp/imaging/psglib
      done
      cd $dest_dir_code/tmp/imaging/psglib
      drop_vnmrs_

      cd $dest_dir_code/tmp
      setperms	./imaging 755 644 755
      setperms	./fidlib 755 644 755
      chmod 755	./help
      chmod 755	./help/help.imaging
      chmod 644	./help/help.imaging/*
      mv ./help/help.imaging ./imaging/help
      rm -rf ./help
      chmod 755    ./maclib
      chmod 755    ./maclib/maclib.imaging
      chmod 644    ./maclib/maclib.imaging/*
      mv ./maclib/maclib.imaging ./imaging/maclib
      rm -rf ./maclib
      chmod 755    ./menulib
      chmod 755    ./menulib/menulib.imaging
      chmod 644    ./menulib/menulib.imaging/*
      mv ./menulib/menulib.imaging ./imaging/menulib
      rm -rf ./menulib
      chmod 755    ./nuctables
      chmod 644    ./nuctables/*
      chmod 755    ./imaging/psglib
      chmod 644    ./imaging/psglib/*
      chmod 755    ./shapelib
      chmod 644    ./shapelib/*
      mv ./shapelib ./imaging
      chmod 755    ./tablib
      chmod 644    ./tablib/*
      mv ./tablib ./imaging
      chmod 755	./bin/*
      chmod 644 ./vnmrmenu
      chmod 644 ./CoilTable
      chmod 644 ./pulsecal
      chmod -R 755   ./user_templates
   
      tar -cf $dest_dir_code/$Image/image.tar *
      make_TOC image.tar $Image "Imaging_or_Triax" sol/inova.sol	\
                                                   sol/vnmrs.sol	\
						   rht/inova.rht	\
                                                   rht/vnmrs.rht
   fi

#---------------------------------------------------------------------------
# tar the IMAGE unique files for VNMRS maclib, manual, parlib imaging
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring IMAGE Vnmrs		for : "

      cd $vcommondir/IMAGE
      tar -cf - $VnmrsIMAGE2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      mv imaging_vnmrs imaging
      mv parlib_vnmrs imaging/parlib
      mv parlib_ATP_vnmrs imaging/ATP/parlib
      setperms ./imaging 755 644 755
      setperms ./imaging/ATP/parlib 755 644 755
      setperms ./imaging/parlib 755 644 755

      tar -cf $dest_dir_code/$Image/vnmrsimage.tar *
      make_TOC vnmrsimage.tar $Image "Imaging_or_Triax" sol/vnmrs.sol	\
						        rht/vnmrs.rht
   fi
#---------------------------------------------------------------------------
# tar the Dicom files
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Dicom Files		for : "

      cd $vcommondir/Dicom
      tar -cf - $Dicom2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      setperms	dicom 755 644 755
      tar -cf $dest_dir_code/$Image/dicom.tar *
      make_TOC dicom.tar $Image "Imaging_or_Triax" sol/inova.sol	\
                                                   sol/vnmrs.sol
   fi

#
#---------------------------------------------------------------------------
# tar Linux Dicom files 
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Dicom Files		for : "

      cd $vcommondir/Dicom
      tar -cf - $Dicom2Tar_lnx | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      mv dicom_lnx dicom 
      setperms	dicom 755 644 755
      tar -cf $dest_dir_code/$Linux/dicom_lnx.tar *
      make_TOC dicom_lnx.tar $Linux "Imaging_or_Triax" rht/inova.rht	\
                                                       rht/vnmrs.rht
   fi

#
#---------------------------------------------------------------------------
# tar the IMAGE common files maclib, manual, parlib imaging
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring IMAGE Objects   for : "
                                                                                
      cd $solobjdir
      tar -cf - $BinIMAGE2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      chmod -R 755   ./bin
      chmod    755   ./lib
      chmod 644   ./lib/*
      ln -s /usr/lib/libC.so.5 lib/libC.so
      tar -cf $dest_dir_code/$Image/$Unity/image.tar *
      make_TOC image.tar $Image/$Unity "Imaging_or_Triax" sol/inova.sol	\
                                                          sol/vnmrs.sol
  fi

#
#---------------------------------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Linux IMAGE Objects   for : "
                                                                                
      cd $lnxobjdir
      tar -cf - $LibLinuxIMAGE2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      mkdir bin user_templates user_templates/ib_initdir
      cd $lnxproglib_dir/ib/ib_initdir
      tar -cf - math | (cd $dest_dir_code/tmp/user_templates/ib_initdir; tar xfBp -)
      cd $dest_dir_code/tmp
      tar -cf - $BinLinuxIMAGE2Tar | (cd $dest_dir_code/tmp/bin; tar $taroption -)
      chmod -R 755   ./bin
      chmod    755   ./lib
      chmod 644   ./lib/*
      chmod -R 755   ./user_templates
      tar -cf $dest_dir_code/$Linux/image2.tar *
      make_TOC image2.tar $Linux "Imaging_or_Triax" rht/inova.rht	\
                                                    rht/vnmrs.rht
   fi
#
#---------------------------------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
      log_this "   Tarring Solaris IMAGE Seqlib		for : "

      mkdir -p $dest_dir_code/tmp/imaging/seqlib
      cd $solproglib_dir/nvseqlib
      for cfile in $IMAGE_PS_2Tar
      do
        cp $cfile $dest_dir_code/tmp/imaging/seqlib
      done
      cd $dest_dir_code/tmp/imaging/seqlib
      drop_vnmrs_

      cd $dest_dir_code/tmp
      chmod    755   ./imaging
      chmod    755   ./imaging/seqlib
      chmod    755   ./imaging/seqlib/*
      tar -cf $dest_dir_code/$Image/$Unity/seqlib.tar *
      make_TOC seqlib.tar $Image/$Unity "Imaging_or_Triax" sol/inova.sol \
                                                           sol/vnmrs.sol

      log_this "   Tarring Linux IMAGE Seqlib	for : "

      mkdir -p $dest_dir_code/tmp/imaging/seqlib
      cd $lnxproglib_dir/nvseqlib
      for cfile in $IMAGE_PS_2Tar
      do
        cp $cfile $dest_dir_code/tmp/imaging/seqlib
      done
      cd $dest_dir_code/tmp/imaging/seqlib
      drop_vnmrs_

      cd $dest_dir_code/tmp
      chmod    755   ./imaging
      chmod    755   ./imaging/seqlib
      chmod    755   ./imaging/seqlib/*
      tar -cf $dest_dir_code/$Linux/lseqlib.tar *
      make_TOC lseqlib.tar $Linux "Imaging_or_Triax" rht/inova.rht	\
                                                     rht/vnmrs.rht
   fi

#
#---------------------------------------------------------------------------
# This stores a dummy file for Imaging. The difference in manual
# size is about 25 Mbyte, to much to leave unaccounted.
   if [ x$winbuild != "xtrue" ]
   then
      cd $dest_dir_code/tmp
      mkdir tmp
      tar -cf $dest_dir_code/$Image/img_man.tar *
      tarFileSize=4000
      make_TOC img_man.tar $Image "Imaging_or_Triax" sol/inova.sol	\
                                                     sol/vnmrs.sol
   fi

#---------------------------------------------------------------------
   log_this "   Tarring Autotest files	for : "

   cd $dest_dir_code/tmp
   mkdir autotest
   (cd $vcommondir/Autotest; cp $cpoption * $dest_dir_code/tmp/autotest)
   setperms ./ 755 644 755
   mkdir -p $dest_dir_code/tmp/autotest/psglib
   cd $solproglib_dir/psglib
   for cfile in $Autotest_PS_2Tar
   do
      cp $cfile.c $dest_dir_code/tmp/autotest/psglib
   done
   cd $dest_dir_code/tmp
   mv ./autotest/maclib ./autotest/maclibold
   mv ./autotest/maclibold/maclib.autotest ./autotest/maclib
   rm -rf ./autotest/maclibold
   chmod 755   ./autotest/psglib
   chmod 644   ./autotest/psglib/*
   tar -cf $dest_dir_code/$Inova/autotest.tar *
   if [ x$winbuild != "xtrue" ]
   then
     make_TOC autotest.tar $Inova $Vnmr sol/inova.sol	\
                                             sol/vnmrs.sol	\
   					     rht/inova.rht	\
                                             rht/vnmrs.rht	\
                                             rht/mr400.rht
   else
     make_TOC autotest.tar $Inova $Vnmr win/vnmrs.win	\
                                             win/mr400.win
   fi
#---------------------------------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
      log_this  "   Tarring Solaris Autotest seqlib			for : "

      mkdir -p $dest_dir_code/tmp/autotest/seqlib
      cd $solproglib_dir/nvseqlib
      for cfile in $Autotest_PS_2Tar
      do
        cp $cfile $dest_dir_code/tmp/autotest/seqlib
      done
      cd $dest_dir_code/tmp
      chmod -R 755   ./autotest
      tar -cf $dest_dir_code/$Inova/autotestobj.tar *
      make_TOC autotestobj.tar $Inova $Vnmr sol/inova.sol	\
                                                 sol/vnmrs.sol
   fi

#
#---------------------------------------------------------------------------
   if [ x$winbuild != "xtrue" ]
   then
      log_this  "   Tarring Linux Autotest seqlib			for : "

      mkdir -p $dest_dir_code/tmp/autotest/seqlib
      cd $lnxproglib_dir/nvseqlib
      for cfile in $Autotest_PS_2Tar
      do
        cp $cfile $dest_dir_code/tmp/autotest/seqlib
      done
      cd $dest_dir_code/tmp
      chmod -R 755   ./autotest
      tar -cf $dest_dir_code/$Linux/lautotestobj.tar *
      make_TOC lautotestobj.tar $Linux $Vnmr rht/inova.rht	\
                                                  rht/vnmrs.rht	\
                                                  rht/mr400.rht
   fi

#---------------------------------------------------------------------------
# tar the userlib option
#    ===>>> INOVA USERLIB <<<===
if [ x$user_answer = "xy" ]
then
      log_this "   Tarring userlib.tar (/vcommon/UserLib.inova)  for : "

      cd /vcommon/UserLib.inova_unity
      tar -cf $dest_dir_code/$Unity/userlib.tar $UserLib2Tar
else
      log_this " Skipping Userlib		for : "
fi

if [ x$winbuild != "xtrue" ]
then
    make_TOC userlib.tar $Unity/ "Userlib"  sol/inova.sol	\
                                            sol/vnmrs.sol	\
					    rht/inova.rht	\
                                            rht/vnmrs.rht	
#                                            rht/mr400.rht
else
    make_TOC userlib.tar $Unity/ "Userlib"  win/vnmrs.win	\
                                            win/mr400.win
fi

#---------------------------------------------------------------------------
# tar the "released" version of chempack
log_this "   Tarring chempack.tar                          for : "
cd /vcommon
tar -cf - chempack | (cd $dest_dir_code/tmp; tar $taroption -)
cd $dest_dir_code/tmp
setperms ./chempack 755 644 755
tar -cf $dest_dir_code/$Linux/chempack.tar chempack
make_TOC chempack.tar $Linux "Chempack" rht/vnmrs.rht

#---------------------------------------------------------------------------
# tar setacq and tftpserver files
   if [ x$winbuild = "xtrue" ]
   then
      log_this "   Tarring setacq/tftpserver             for : "

      cd $vcommondir/ms_tftpserver
      tar -cf - $WinSetacq2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
      tar -cf $dest_dir_code/$Windows/tftp.tar *
      make_TOC tftp.tar $Windows $Vnmr win/vnmrs.win	\
                                       win/mr400.win
   fi

#============== PASSWORDED  FILES ========================================
echo ""  | tee -a $log_file
log_this "PART XII -- PASSWORDED FILES -- $dest_dir_code/"

#---------------------------------------------------------------------------
# tar Diffusion's maclib, manual and parlib files
  if [ x$password_answer = "xy" ]
  then
   log_this "   Tarring Diffusion			for : "

   cd $vcommondir/Diffusion
   tar -cf - $Diffus2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   cd $dest_dir_code/tmp
   chmod 755    ./maclib
   chmod 644    ./maclib/*
   chmod 755    ./manual
   chmod 644    ./manual/*
   chmod 755    ./parlib
   chmod 755    ./parlib/*
   chmod 644    ./parlib/*/*
   mkdir -p $dest_dir_code/tmp/psglib
   cd $solproglib_dir/psglib
   for cfile in $Diffus_PS_2Tar
   do
        cp $cfile.c $dest_dir_code/tmp/psglib
   done
   cd $dest_dir_code/tmp
   chmod 755   ./psglib
   chmod 644   ./psglib/*
   tar -cf - * | $Encodedir/encode $Diff_password > $dest_dir_code/$Diff/diffuse.pwd
 else
   log_this " Skipping Diffusion			for : "
 fi

 if [ x$winbuild != "xtrue" ]
 then
    make_TOC diffuse.pwd $Diff "Diffusion" sol/inova.opt	\
                                           sol/vnmrs.opt	\
					   rht/inova.opt	\
                                           rht/vnmrs.opt
 else
    make_TOC diffuse.pwd $Diff "Diffusion" win/vnmrs.opt
 fi

#---------------------------------------------------------------------------
# tar Diffusion's seqlib files
if [ x$winbuild != "xtrue" ]
then
    if [ x$password_answer = "xy" ]
    then
	log_this "   Tarring Diff Seq			for : "

	mkdir -p $dest_dir_code/tmp/seqlib
	cd $solproglib_dir/nvseqlib
	for cfile in $Diffus_PS_2Tar
	do
	    cp $cfile $dest_dir_code/tmp/seqlib
	done
	cd $dest_dir_code/tmp
	chmod 755   ./seqlib
	chmod 755   ./seqlib/*
	tar -cf - * | $Encodedir/encode $Diff_password > $dest_dir_code/$Diff/diffseq.pwd
    else
	log_this " Skipping Diff Seq			for : "
    fi

    make_TOC diffseq.pwd $Diff "Diffusion" sol/inova.opt	\
                                           sol/vnmrs.opt
fi

#---------------------------------------------------------------------------
#Linux: tar Diffusion's maclib, manual and parlib ... files
if [ x$winbuild != "xtrue" ]
then
    if [ x$password_answer = "xy" ]
    then
	log_this "   Tarring Linux  Diff Seq			for : "

	mkdir -p $dest_dir_code/tmp/seqlib
	cd $lnxproglib_dir/nvseqlib
	for cfile in $Diffus_PS_2Tar
	do
	    cp $cfile $dest_dir_code/tmp/seqlib
	done
	cd $dest_dir_code/tmp
	chmod 755   ./seqlib
	chmod 755   ./seqlib/*
	tar -cf - * | $Encodedir/encode $Diff_password > $dest_dir_code/$Linux/diffuse.pwd
    else
	log_this " Skipping Linux Diffusion seq files	for : "
    fi
    make_TOC diffuse.pwd $Linux "Diffusion" rht/inova.opt	\
                                            rht/vnmrs.opt
fi

#---------------------------------------------------------------------------
#Windows: tar Diffusion's maclib, manual and parlib ... files
if [ x$winbuild = "xtrue" ]
then
    if [ x$password_answer = "xy" ]
    then
	log_this "   Tarring Windows  Diff Seq			for : "

	mkdir -p $dest_dir_code/tmp/seqlib
	if [ -d $winproglib_dir/nvseqlib ]
	then
	    cd $winproglib_dir/nvseqlib
	    for cfile in $Diffus_PS_2Tar
	    do
		cp $cfile $dest_dir_code/tmp/seqlib
	    done
	    cd $dest_dir_code/tmp
	    chmod 755   ./seqlib
	    chmod 755   ./seqlib/*
	    tar -cf - * | $Encodedir/encode $Diff_password > $dest_dir_code/$Windows/diffuse.pwd
	else
	    echo "$winproglib_dir/nvseqlib does not exist"
	fi
    else
	    log_this " Skipping Windows Diffusion seq files	for : "
    fi
    make_TOC diffuse.pwd $Windows "Diffusion" win/vnmrs.opt
fi

#---------------------------------------------------------------------------
# tar LCNMR's files
  if [ x$winbuild != "xtrue" ]
  then 
    if [ x$password_answer = "xy" ]
    then
	log_this "   Tarring common LCNMR		for : "

	cd $vcommondir/LCNMR
	tar -cf - $LCNMR2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
	cd $dest_dir_code/tmp
	chmod 755    ./maclib
	chmod 755    ./maclib/maclib.lc
	chmod 644    ./maclib/maclib.lc/*
	chmod 755    ./manual
	chmod 644    ./manual/*
	chmod 755    ./menulib
	chmod 644    ./menulib/*
	chmod 755    ./parlib
	chmod 755    ./parlib/*
	chmod 644    ./parlib/*/*
	chmod 755    ./shapelib
	chmod 644    ./shapelib/*
	chmod 755    ./tablib
	chmod 644    ./tablib/*
	mkdir lc/psglib
	(cd $solproglib_dir/psglib; cp -f lc1d.c $dest_dir_code/tmp/lc/psglib)
	setperms     ./lc 755 644 755
	chmod 664    ./lc/FlowCal
        mv ./maclib/maclib.lc ./lc/maclib
        mv ./manual ./menulib ./parlib ./shapelib ./tablib ./lc
        rm -rf ./maclib
	tar -cf - * | $Encodedir/encode $LCNMR_password > $dest_dir_code/$LCNMR/lcnmr.pwd
    else
	log_this " Skipping common LCNMR		for : "
    fi
    make_TOC lcnmr.pwd $LCNMR "LC-NMR" sol/inova.opt	\
                                       sol/vnmrs.opt	\
				       rht/inova.opt	\
                                       rht/vnmrs.opt
  fi
#---------------------------------------------------------------------
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
   	log_this "   Tarring Solaris LCNMR seqlib and bin		for : "

   	cd $dest_dir_code/tmp
        mkdir bin lc lc/seqlib 
        (cd $solproglib_dir/nvseqlib; cp -f lc1d $dest_dir_code/tmp/lc/seqlib)
        (cd $solproglib_dir/lcpeaks; cp -f vjLCAnalysis $dest_dir_code/tmp/bin)
	chmod -R 755   ./bin
   	chmod -R 755   ./lc
   	tar -cf - * | $Encodedir/encode $LCNMR_password > $dest_dir_code/$LCNMR/lcseqlib.pwd
    else
   	log_this " Skipping LCNMR seqlib and bin	for : "
    fi
    make_TOC lcseqlib.pwd $LCNMR "LC-NMR" sol/inova.opt	\
                                          sol/vnmrs.opt
  fi
#---------------------------------------------------------------------------
#Linux:
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
      log_this "   Tarring Linux LCNMR seqlib and bin		for : "

      cd $dest_dir_code/tmp
      mkdir bin lc lc/seqlib
      (cd $lnxproglib_dir/nvseqlib; cp -f lc1d $dest_dir_code/tmp/lc/seqlib)
      (cd $lnxproglib_dir/lcpeaks; cp -f vjLCAnalysis $dest_dir_code/tmp/bin)
      chmod -R 755   ./bin
      chmod -R 755   ./lc
      tar -cf - * | $Encodedir/encode $LCNMR_password > $dest_dir_code/$Linux/lcnmr.pwd
    else
      log_this " Skipping Linux LCNMR			for : "
    fi
    make_TOC lcnmr.pwd $Linux "LC-NMR" rht/inova.opt	\
                                       rht/vnmrs.opt
  fi
#---------------------------------------------------------------------------
#Windows:
  if [ x$winbuild = "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
      log_this "   Tarring all LCNMR files		for : "

      cd $dest_dir_code/tmp
      mkdir seqlib
      (cd $winproglib_dir/nvseqlib; cp -f lc1d $dest_dir_code/tmp/seqlib)
      cd $dest_dir_code/tmp
      chmod 755   ./seqlib
      chmod 755   ./seqlib/*
      tar -cf - * | $Encodedir/encode $LCNMR_password > $dest_dir_code/$Windows/lcnmr.pwd
    else
      log_this " Skipping LCNMR			for : "
    fi
    make_TOC lcnmr.pwd $Windows "LC-NMR" win/vnmrs.opt
  fi

#---------------------------------------------------------------------------
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
  	log_this "   Tarring STARS binaries		for : "

   	cd $vcommondir/STARS
   	tar -cf - $BinSTARSSol2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   	cd $dest_dir_code/tmp
   	chmod -R 755 ./bin
   	tar -cf - * | $Encodedir/encode $Stars_password > $dest_dir_code/$STARS/$Unity/stars.pwd
    else
   	log_this " Skipping STARS binaries	for : "
    fi
    make_TOC stars.pwd $STARS/$Unity "STARS" sol/inova.opt	\
                                             sol/vnmrs.opt
  fi
#---------------------------------------------------------------------------
#Linux:
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
      log_this "   Tarring STARS binaries		for : "
                                                                                                             
      mkdir -p $dest_dir_code/tmp/bin
      (cd $lnxproglib_dir/stars; cp starsprg qpar $dest_dir_code/tmp/bin)
      cd $dest_dir_code/tmp
      chmod -R 755 ./bin
      tar -cf - * | $Encodedir/encode $Stars_password > $dest_dir_code/$Linux/lstars.pwd
    else
      log_this " Skipping STARS binaries		for : "
    fi
    make_TOC lstars.pwd $Linux "STARS" rht/inova.opt	\
                                       rht/vnmrs.opt
  fi

#---------------------------------------------------------------------------
#Windows:
  if [ x$winbuild = "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
      log_this "   Tarring STARS binaries		for : "
                                                                                                             
      mkdir -p $dest_dir_code/tmp/bin
      (cd $winproglib_dir/stars; cp starsprg qpar $dest_dir_code/tmp/bin)
      cd $dest_dir_code/tmp
      chmod -R 755 ./bin
      tar -cf - * | $Encodedir/encode $Stars_password > $dest_dir_code/$Windows/lstars.pwd
    else
      log_this " Skipping STARS binaries		for : "
    fi
    make_TOC lstars.pwd $Windows "STARS" win/vnmrs.opt
  fi

#---------------------------------------------------------------------------
  if [ x$password_answer = "xy" ]
  then
   	log_this "   Tarring STARS Text			for : "

   	cd $vcommondir/STARS
   	tar -cf - $TextSTARS2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
   	cd $dest_dir_code/tmp
   	chmod 755    ./maclib*
   	chmod 644    ./maclib/*
   	chmod 755    ./menulib
   	chmod 644    ./menulib/*
   	chmod -R 755 ./templates
   	chmod 644    ./templates/*/*/*
   	tar -cf - * | $Encodedir/encode $Stars_password > $dest_dir_code/$STARS/stars.pwd
  else

   	log_this " Skipping STARS Text			for : "
  fi
  if [ x$winbuild != "xtrue" ]
  then
    make_TOC stars.pwd $STARS "STARS" sol/inova.opt	\
                                      sol/vnmrs.opt	\
				      rht/inova.opt	\
                                      rht/vnmrs.opt
  else
    make_TOC stars.pwd $STARS "STARS" win/vnmrs.opt
  fi
 
#---------------------------------------------------------------------------
# tar Backproj help, maclib, manual and menulib files
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
	log_this "   Tarring Backproj Text	 	for : "

	cd $vcommondir/Backproj
	tar -cf - $ComBackproj2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
	cd $dest_dir_code/tmp
	mkdir psglib
	(cd $solproglib_dir/psglib; cp -f bp_image.c $dest_dir_code/tmp/psglib)
	(cd $solproglib_dir/psglib; cp -f bp3d.c $dest_dir_code/tmp/psglib)
	chmod 755    ./maclib
	chmod 644    ./maclib/*
	chmod 755    ./parlib
	chmod 755    ./parlib/*
	chmod 644    ./parlib/*/*
	chmod 755	./psglib
	chmod 644    ./psglib/*
	tar -cf - * | $Encodedir/encode $Backproj_password > $dest_dir_code/$Backproj/backproj.pwd
    else

	log_this " Skipping Backproj Text			for : "
    fi
    make_TOC backproj.pwd $Backproj "Backprojection" sol/inova.opt	\
                                                     sol/vnmrs.opt
  fi
#---------------------------------------------------------------------------
# tar Backproj's binary files
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
	log_this "   Tarring Backproj binaries		for : "

	cd $solproglib_dir/backproj
        mkdir $dest_dir_code/tmp/bin
	tar -cf - $BinBackproj2Tar | (cd $dest_dir_code/tmp/bin; tar $taroption -)
	cd $dest_dir_code/tmp
	mkdir seqlib
	(cd $solproglib_dir/nvseqlib; cp -f bp_image $dest_dir_code/tmp/seqlib)
	(cd $solproglib_dir/nvseqlib; cp -f bp3d $dest_dir_code/tmp/seqlib)
	chmod -R 755 ./bin
	chmod    755   ./seqlib
	chmod    755   ./seqlib/*
	tar -cf - * | $Encodedir/encode $Backproj_password > $dest_dir_code/$Backproj/$Unity/backproj.pwd
    else

	log_this " Skipping Backproj binaries 		for : "

    fi
    make_TOC backproj.pwd $Backproj/$Unity "Backprojection" sol/inova.opt \
                                                            sol/vnmrs.opt
  fi

#---------------------------------------------------------------------------
# tar CSI user_templates files
  if [ x$password_answer = "xy" ]
  then
     log_this "   Tarring CSI Text			for : "
  
     cd $vcommondir/CSI
     tar -cf - $ComCSI2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
     cd $dest_dir_code/tmp
#     mkdir psglib
#     (cd $solproglib_dir/psglib; cp -f csi2d.c $dest_dir_code/tmp/psglib)
     chmod 755    ./maclib
     chmod 644    ./maclib/*
     chmod 755    ./manual
     chmod 644    ./manual/*
     chmod 755    ./parlib
     chmod 755    ./parlib/*
     chmod 644    ./parlib/*/*
#     chmod 755    ./psglib
#     chmod 644    ./psglib/*
     setperms	./imaging 755 644 755
     mv ./maclib ./manual ./parlib ./imaging
     chmod -R 755   ./user_templates
     tar -cf - * | $Encodedir/encode $CSI_password > $dest_dir_code/$CSI/csi.pwd
  else

     log_this " Skipping CSI Text	  for : "
  fi
  if [ x$winbuild != "xtrue" ]
  then
    make_TOC csi.pwd $CSI "CSI" sol/inova.opt	\
                                sol/vnmrs.opt	\
				rht/inova.opt	\
                                rht/vnmrs.opt
  else
    make_TOC csi.pwd $CSI "CSI" win/vnmrs.opt
  fi
 
#---------------------------------------------------------------------------
# tar CSI's binary files
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
      log_this "   Tarring CSI binaries			for : "

	cd $solobjdir
	tar -cf - $BinCSI2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
	cd $dest_dir_code/tmp
#	mkdir seqlib
#	(cd $solproglib_dir/nvseqlib; cp -f csi2d $dest_dir_code/tmp/seqlib)
	chmod -R 755 ./bin
#	chmod -R 755 ./seqlib
	tar -cf - * | $Encodedir/encode $CSI_password > $dest_dir_code/$CSI/$Unity/csi.pwd
    else
	log_this " Skipping CSI binaries			for : "
    fi
    make_TOC csi.pwd $CSI/$Unity "CSI" sol/inova.opt	\
                                       sol/vnmrs.opt
 
    if [ x$password_answer = "xy" ]
    then
	log_this "   Tarring Linux CSI binaries			for : "

	cd $dest_dir_code/tmp
	mkdir bin
#	mkdir seqlib
#	(cd $lnxproglib_dir/nvseqlib; cp -f csi2d $dest_dir_code/tmp/seqlib)
	(cd $lnxproglib_dir/csi; cp -f csi $dest_dir_code/tmp/bin)
	(cd $lnxproglib_dir/csi; cp -f P_csi $dest_dir_code/tmp/bin)
	chmod -R 755 ./bin
#	chmod -R 755 ./seqlib
	tar -cf - * | $Encodedir/encode $CSI_password > $dest_dir_code/$Linux/lnxcsi.pwd
    else
	log_this " Skipping CSI binaries			for : "
    fi
    make_TOC lnxcsi.pwd $Linux "CSI" rht/inova.opt	\
                                     rht/vnmrs.opt

  else
    if [ x$password_answer = "xy" ]
    then
      log_this "   Tarring Windows CSI binaries			for : "

      cd $dest_dir_code/tmp
      mkdir bin
#      mkdir seqlib
#      (cd $winproglib_dir/nvseqlib; cp -f csi2d $dest_dir_code/tmp/seqlib)
      (cd $winproglib_dir/csi; cp -f csi $dest_dir_code/tmp/bin)
      (cd $winproglib_dir/csi; cp -f P_csi $dest_dir_code/tmp/bin)
      chmod -R 755 ./bin
#      chmod -R 755 ./seqlib
      tar -cf - * | $Encodedir/encode $CSI_password > $dest_dir_code/$Windows/wincsi.pwd
    else
      log_this " Skipping CSI binaries			for : "
    fi
    make_TOC wincsi.pwd $Windows "CSI" win/vnmrs.opt
  fi
 
#---------------------------------------------------------------------
# tar BIR shape files
  if [ x$password_answer = "xy" ]
  then
     log_this "   Tarring BIR shapes			for : "

     cd $dest_dir_code/tmp
     (cd $vcommondir/BIR; cp $cpoption wavelib $dest_dir_code/tmp)
     chmod -R 755   ./wavelib
     chmod 644      ./wavelib/*/*
     tar -cf - * | $Encodedir/encode $BIR_password >$dest_dir_code/$Common/bird.pwd
  else
     log_this " Skipping BIR shapes			for : "
  fi
  if [ x$winbuild != "xtrue" ]
  then
    make_TOC bird.pwd $Common "BIR_Shapes" sol/inova.opt	\
                                           sol/vnmrs.opt	\
					   rht/inova.opt	\
                                           rht/vnmrs.opt
  else
    make_TOC bird.pwd $Common "BIR_Shapes" win/vnmrs.opt
  fi

#---------------------------------------------------------------------
#DOSY common files
  if [ x$password_answer = "xy" ]
  then
     log_this "   Tarring DOSY common files		for : "

     dirlist="fidlib maclib manual parlib templates"
     for dir in $dirlist
     do
        cp $cpoption $vcommondir/DOSY/$dir $dest_dir_code/tmp
     done
     mkdir -p $dest_dir_code/tmp/adm/users
     mkdir -p $dest_dir_code/tmp/psglib
     cd $solproglib_dir/psglib
     for cfile in $DOSY_PS_2Tar
     do
        cp $cfile.c $dest_dir_code/tmp/psglib
     done
     cd $dest_dir_code/tmp
     chmod 755   ./*
     chmod 644   ./*/*
     chmod 755   ./adm/*
     chmod 755   ./parlib/*
     chmod 644   ./parlib/*/*
     chmod 755   ./psglib
     chmod 644   ./psglib/*
     chmod 755   ./fidlib/*
     chmod 755   ./fidlib/*/*
     chmod 644   ./fidlib/*/*/*
     chmod 755   ./templates/*
     chmod 755   ./templates/*/*
     chmod 644   ./templates/*/*/*
     mv templates/*/*/protocolListWalkup.xml.dosy adm/users/protocolListWalkup.xml
     tar -cf - * | $Encodedir/encode $DOSY_password >$dest_dir_code/$Common/dosy.pwd
  else
     log_this " Skipping DOSY common files		for : "
  fi
  if [ x$winbuild != "xtrue" ]
  then
    make_TOC dosy.pwd $Common "DOSY" sol/inova.opt	\
                                     sol/vnmrs.opt	\
				     rht/inova.opt	\
                                     rht/vnmrs.opt	\
                                     rht/mr400.opt
  else
    make_TOC dosy.pwd $Common "DOSY" win/vnmrs.opt	\
                                     win/mr400.opt
  fi

#---------------------------------------------------------------------
# Inova  DOSY user_templates/dg and seqlib binary files
                                                                                 if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
       log_this "   Tarring DOSY seqlib binary files	for : "

       cd $dest_dir_code/tmp
       mkdir -p $dest_dir_code/tmp/seqlib
       cd $solproglib_dir/nvseqlib
       for cfile in $DOSY_PS_2Tar
       do
            cp $cfile $dest_dir_code/tmp/seqlib
       done
       cd $dest_dir_code/tmp
       chmod 755   ./seqlib
       chmod 755   ./seqlib/*
       chmod -R 755 ./seqlib
       tar -cf - * | $Encodedir/encode $DOSY_password >$dest_dir_code/$Solaris/idosy.pwd
    else
       log_this " Skipping DOSY seqlib binary files	for : "
    fi
    make_TOC idosy.pwd $Solaris "DOSY" sol/inova.opt	\
                                       sol/vnmrs.opt
  fi
#---------------------------------------------------------------------
# Linux:
  
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
       log_this "   Tarring DOSY seqlib binary files	for : "

       cd $dest_dir_code/tmp
       mkdir seqlib
       for cfile in $DOSY_PS_2Tar
       do
          cp -p $lnxproglib_dir/nvseqlib/$cfile seqlib
       done
       chmod -R 755 ./seqlib
       tar -cf - * | $Encodedir/encode $DOSY_password >$dest_dir_code/$Linux/idosy.pwd
    else
       log_this " Skipping DOSY seqlib binary files		for : "
    fi
    make_TOC idosy.pwd $Linux "DOSY" rht/inova.opt	\
                                     rht/vnmrs.opt	\
                                     rht/mr400.opt
  fi

#---------------------------------------------------------------------
# Windows:
  if [ x$winbuild = "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
       log_this "   Tarring DOSY seqlib binary files	for : "

       cd $dest_dir_code/tmp
       mkdir seqlib
       for cfile in $DOSY_PS_2Tar
       do
          cp -p $winproglib_dir/nvseqlib/$cfile seqlib
       done
       chmod -R 755 ./seqlib
       tar -cf - * | $Encodedir/encode $DOSY_password >$dest_dir_code/$Windows/idosy.pwd
    else
       log_this " Skipping DOSY seqlib binary files		for : "
    fi
    make_TOC idosy.pwd $Windows "DOSY" win/vnmrs.opt	\
                                       win/mr400.opt
  fi

#---------------------------------------------------------------------
#GXYZ common files
  if [ x$password_answer = "xy" ]
  then
     log_this " Tarring GXYZ common files	  for : "

     dirlist="maclib parlib shimtab templates"
     for dir in $dirlist
     do
        cp $cpoption $vcommondir/Gxyz/$dir $dest_dir_code/tmp
     done
     cd $dest_dir_code/tmp
     mkdir psglib
     (cd $solproglib_dir/psglib; cp -f gmapxyz.c $dest_dir_code/tmp/psglib)
     chmod 755   ./*
     chmod 644   ./*/*
     chmod 755   ./parlib/*
     chmod 644   ./parlib/*/*
     chmod 755   ./templates/layout
     chmod 755   ./templates/layout/*
     chmod 644   ./templates/layout/*/*
     tar -cf - * | $Encodedir/encode $Gxyz_password >$dest_dir_code/$Common/gxyz.pwd
  else
     log_this " Skipping GXYZ common files	  for : "
  fi
  if [ x$winbuild != "xtrue" ]
  then
     make_TOC gxyz.pwd $Common "3D_shimming" sol/inova.opt	\
                                             sol/vnmrs.opt	\
					     rht/inova.opt	\
                                             rht/vnmrs.opt	\
                                             rht/mr400.opt
  else
     make_TOC gxyz.pwd $Common "3D_shimming" win/vnmrs.opt	\
                                             win/mr400.opt
  fi

#---------------------------------------------------------------------
# Inova / Mercury  GXYZ seqlib binary files
                                                                               
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
       log_this " Tarring GXYZ seqlib binary files          for : "
       cd $dest_dir_code/tmp
       mkdir seqlib
       (cd $solproglib_dir/nvseqlib; cp -f gmapxyz $dest_dir_code/tmp/seqlib)
       chmod -R 755 ./seqlib
       tar -cf - * | $Encodedir/encode $Gxyz_password >$dest_dir_code/$Solaris/igxyz.pwd
    else
       log_this " Skipping GXYZ seqlib binary files          for : "
    fi
    make_TOC igxyz.pwd $Solaris "3D_shimming" sol/inova.opt	\
                                              sol/vnmrs.opt
  fi

#---------------------------------------------------------------------
# Linux: Inova / Mercury  GXYZ seqlib binary files
  
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
       log_this "Linux, Tarring GXYZ seqlib binary files          for : "
       cd $dest_dir_code/tmp
       mkdir seqlib
       (cd $lnxproglib_dir/nvseqlib; cp -f gmapxyz $dest_dir_code/tmp/seqlib)
       chmod -R 755 ./seqlib
       tar -cf - * | $Encodedir/encode $Gxyz_password >$dest_dir_code/$Linux/igxyz.pwd
    else
       log_this "Linux, Skipping GXYZ seqlib binary files          for : "
    fi
    make_TOC igxyz.pwd $Linux "3D_shimming" rht/inova.opt	\
                                            rht/vnmrs.opt	\
                                            rht/mr400.opt
  fi

#---------------------------------------------------------------------
# Windows: Inova / Mercury  GXYZ seqlib binary files
  if [ x$winbuild = "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
       log_this "Windows, Tarring GXYZ seqlib binary files          for : "
       cd $dest_dir_code/tmp
       mkdir seqlib
       (cd $winproglib_dir/nvseqlib; cp -f gmapxyz $dest_dir_code/tmp/seqlib)
       chmod -R 755 ./seqlib
       tar -cf - * | $Encodedir/encode $Gxyz_password >$dest_dir_code/$Windows/igxyz.pwd
    else
       log_this "Windows, Skipping GXYZ seqlib binary files          for : "
    fi
    make_TOC igxyz.pwd $Windows "3D_shimming" win/vnmrs.opt	\
                                              win/mr400.opt
  fi

#---------------------------------------------------------------------
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
	log_this "   Tarring 768 AS files			for : "

	cd $dest_dir_code/tmp
	(cd $vcommondir/768AS; cp $cpoption * $dest_dir_code/tmp)
	setperms ./ 755 644 755
	setperms ./asm/info 755 666 755
	setperms ./asm/info/768AS 755 666 755
	chmod 777 ./asm
	chmod 777 ./asm/info
	chmod 777 ./asm/info/768AS
	tar -cf - * | $Encodedir/encode $AS768_password >$dest_dir_code/$Unity/$Inova/768AS.pwd
    else
	log_this " Skipping 768 AS files			for : "
    fi
    make_TOC 768AS.pwd $Unity/$Inova "768_AS" sol/inova.opt	\
                                              sol/vnmrs.opt
  fi

#---------------------------------------------------------------------
#Linux: tar 768 AS files
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
       log_this "   Tarring 768 AS files			for : "

       cd $dest_dir_code/tmp
       (cd $vcommondir/768AS; cp $cpoption * $dest_dir_code/tmp)
       rm -f bin/killroboproc bin/gilalign
       (cp -f $lnxproglib_dir/roboproc/gilalign   bin/)
       (cp -f $lnxproglib_dir/bin/killroboproc    bin/)
       setperms ./ 755 644 755
       setperms ./asm/info 755 666 755
       setperms ./asm/info/768AS 755 666 755
       chmod 777 ./asm
       chmod 777 ./asm/info
       chmod 777 ./asm/info/768AS
       tar -cf - * | $Encodedir/encode $AS768_password >$dest_dir_code/$Linux/768AS.pwd
    else
	log_this " Skipping 768 AS files			for : "
    fi
    make_TOC 768AS.pwd $Linux "768_AS" rht/inova.opt	\
                                       rht/vnmrs.opt
  fi

#---------------------------------------------------------------------
#Windows: tar 768 AS files
  if [ x$winbuild = "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
       log_this "   Tarring 768 AS files			for : "

       cd $dest_dir_code/tmp
       (cd $vcommondir/768AS; cp $cpoption * $dest_dir_code/tmp)
       rm -f bin/killroboproc bin/gilalign
       (cp -f $winproglib_dir/roboproc/gilalign   bin/)
       setperms ./ 755 644 755
       setperms ./asm/info 755 666 755
       setperms ./asm/info/768AS 755 666 755
       chmod 777 ./asm
       chmod 777 ./asm/info
       chmod 777 ./asm/info/768AS
       tar -cf - * | $Encodedir/encode $AS768_password >$dest_dir_code/$Windows/768AS.pwd
    else
       log_this " Skipping 768 AS files			for : "
    fi
    make_TOC 768AS.pwd $Windows "768_AS" win/vnmrs.opt
  fi
 
#---------------------------------------------------------------------
# tar VAST (Gilson) generic files
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
      log_this "   Tarring VAST files			for : "

      cd $dest_dir_code/tmp
      (cd $vcommondir/Gilson; cp $cpoption * $dest_dir_code/tmp)
      rm -rf psglib
      setperms ./ 755 644 755
      setperms ./asm/info 755 666 755
      setperms ./user_templates/dg 755 666 755
      setperms ./templates/ 755 666 755
      chmod 777 ./asm
      chmod 777 ./asm/info
      chmod 755   ./tcl/bin/*
      chmod 755 ./bin/*
      tar -cf - * | $Encodedir/encode $VAST_password >$dest_dir_code/$Unity/$Inova/vast.pwd
    else
      log_this " Skipping VAST files			for : "
    fi
    make_TOC vast.pwd $Unity/$Inova "VAST" rht/vnmrs.opt
  fi

#---------------------------------------------------------------------
#Linux:,  VAST (Gilson) all needed files
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
	log_this "   Tarring VAST all needed files	for : "

	cd $dest_dir_code/tmp
	(cd $vcommondir/Gilson; cp $cpoption * $dest_dir_code/tmp)

	rm -rf psglib
	mkdir psglib
	(cd $solproglib_dir/psglib; cp -f vast1d.c $dest_dir_code/tmp/psglib)
	cp -f $lnxproglib_dir/psglib/vast1d.c     psglib/vast1d.c
	cp -f $lnxproglib_dir/nvseqlib/vast1d       seqlib/vast1d
	cp -f $lnxproglib_dir/roboproc/gilalign   bin/gilalign
	setperms ./ 755 644 755
	setperms ./asm/info 755 666 755
	setperms ./user_templates/dg 755 666 755
	chmod 777 ./asm
	chmod 777 ./asm/info
	chmod 755   ./tcl/bin/*
	chmod 755 ./bin/*
	tar -cf - * | $Encodedir/encode $VAST_password >$dest_dir_code/$Linux/i_vast.pwd
    else
	log_this " Skipping VAST all files			for : "
    fi
    make_TOC i_vast.pwd $Linux "VAST" rht/inova.opt	\
                                      rht/vnmrs.opt
  fi

#---------------------------------------------------------------------
#Windows:,  VAST (Gilson) all needed files
  if [ x$winbuild = "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
	log_this "   Tarring VAST all needed files	for : "

	cd $dest_dir_code/tmp
	(cd $vcommondir/Gilson; cp $cpoption * $dest_dir_code/tmp)

	rm -rf psglib
	mkdir psglib
	(cd $solproglib_dir/psglib; cp -f vast1d.c $dest_dir_code/tmp/psglib)
	cp -f $winproglib_dir/psglib/vast1d.c     psglib/vast1d.c
	cp -f $winproglib_dir/nvseqlib/vast1d       seqlib/vast1d
	cp -f $winproglib_dir/roboproc/gilalign   bin/gilalign
	setperms ./ 755 644 755
	setperms ./asm/info 755 666 755
	setperms ./user_templates/dg 755 666 755
	chmod 777 ./asm
	chmod 777 ./asm/info
	chmod 755   ./tcl/bin/*
	chmod 755 ./bin/*
	tar -cf - * | $Encodedir/encode $VAST_password >$dest_dir_code/$Windows/i_vast.pwd
    else
	log_this " Skipping VAST all files			for : "
    fi
    make_TOC i_vast.pwd $Windows "VAST" win/inova.opt
  fi
      
#---------------------------------------------------------------------
# tar the INOVA VAST (Gilson) seqlib 
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
	log_this "   Tarring GILSON seqlib		for : "

	cd $dest_dir_code/tmp
	mkdir seqlib
	cp -f $solproglib_dir/nvseqlib/vast1d       seqlib/vast1d
	chmod 755   ./seqlib
	chmod 755   ./seqlib/*
	tar -cf - * | $Encodedir/encode $VAST_password > $dest_dir_code/$Unity/$Inova/vastseqlib.pwd
    else
	log_this " Skipping GILSON seqlib			for : "
    fi
    make_TOC vastseqlib.pwd $Unity/$Inova "VAST" sol/inova.opt	\
                                                 sol/vnmrs.opt
  fi

#---------------------------------------------------------------------------
# tar FDM's manual and fidlib files
  if [ x$password_answer = "xy" ]
  then
      log_this "   Tarring FDM				for : "

      cd $vcommondir/FDM
      tar -cf - $Fdm2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
      cd $dest_dir_code/tmp
      chmod 755    ./manual
      chmod 644    ./manual/*
      chmod 755   ./fidlib
      chmod 755   ./fidlib/*
      chmod 644   ./fidlib/*/*
      tar -cf - * | $Encodedir/encode $FDM_password > $dest_dir_code/$Common/fdm.pwd
  else
      echo "" | tee -a $log_file
      log_this " Skipping FDM				for : "
  fi
  if [ x$winbuild != "xtrue" ]
  then
    make_TOC fdm.pwd $Common "FDM" sol/inova.opt	\
                                   sol/vnmrs.opt	\
				   rht/inova.opt	\
                                   rht/vnmrs.opt
  else
    make_TOC fdm.pwd $Common "FDM" win/vnmrs.opt
  fi
 
#---------------------------------------------------------------------------
# tar FDM binary files
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
       log_this "   Tarring FDM binaries			for : "
                                                                                                
       cd $solobjdir
       tar -cf - $FdmBin2Tar | (cd $dest_dir_code/tmp; tar $taroption -)
       cd $dest_dir_code/tmp
       chmod -R 755 ./bin
       tar -cf - * | $Encodedir/encode $FDM_password > $dest_dir_code/$Unity/fdmbin.pwd
    else
                                                                                                
       log_this " Skipping FDM binaries			for : "
    fi
    make_TOC fdmbin.pwd $Unity "FDM" sol/inova.opt	\
                                     sol/vnmrs.opt
  fi

#---------------------------------------------------------------------------
#Linux:  VNMRS
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
       log_this "   Tarring Linux Xrecon/fftw3		for : "

       cd $vcommondir/IMAGE_SENSE
       tar -cf - * | (cd $dest_dir_code/tmp; tar $taroption -)
       cd $dest_dir_code/tmp
       mkdir bin
       cp ${lnxproglib_dir}/xrecon/Xrecon bin
       chmod -R 755 ./bin
       cp /sw/LinuxTools/fftw/fftw-3.1.2.tar.gz imaging/src
       tar -cf - * | $Encodedir/encode $XRECON_password > $dest_dir_code/$Linux/Xrecon.pwd
    else
       log_this " Skipping Linux Xrecon binaries	for : "
    fi
    make_TOC Xrecon.pwd $Linux "Image_Sense" rht/vnmrs.opt
  fi

#---------------------------------------------------------------------------
#Linux:  Inova and Mercury plus, tar FDM binary files
  if [ x$winbuild != "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
       log_this "   Tarring Linux FDM binaries		for : "

       cd $dest_dir_code/tmp
       mkdir bin
       tar -cf - $FdmLinux2Tar | (cd $dest_dir_code/tmp/bin; tar $taroption -)
       chmod -R 755 ./bin
       tar -cf - bin | $Encodedir/encode $FDM_password > $dest_dir_code/$Linux/fdmbin.pwd
    else
       log_this " Skipping Linux FDM binaries		for : "
    fi
    make_TOC fdmbin.pwd $Linux "FDM" rht/inova.opt	\
                                     rht/vnmrs.opt
  fi

#---------------------------------------------------------------------------
#Windows:  Inova and Mercury plus, tar FDM binary files
  if [ x$winbuild = "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
       log_this "   Tarring Windows FDM binaries		for : "

       cd $dest_dir_code/tmp
       mkdir bin
       tar -cf - $FdmWindows2Tar | (cd $dest_dir_code/tmp/bin; tar $taroption -)
       chmod -R 755 ./bin
       tar -cf - bin | $Encodedir/encode $FDM_password > $dest_dir_code/$Windows/fdmbin.pwd
    else
       log_this " Skipping Windows FDM binaries		for : "
    fi
    make_TOC fdmbin.pwd $Windows "FDM" win/vnmrs.opt
  fi
 
#---------------------------------------------------------------------------
# tar Patented Image pulse sequences and supporting files
  if [ x$password_answer = "xy" ]
  then
      log_this "   Tarring IMAGE_patent common files	for : "

      cd $vcommondir/IMAGE_patent
      tar -cf - $ImagePatentFiles | (cd $dest_dir_code/tmp; tar $taroption -)
      mkdir -p $dest_dir_code/tmp/psglib
      cd $solproglib_dir/psglib
      for cfile in $PATENT_PS_2Tar
      do
        cp $cfile.c $dest_dir_code/tmp/psglib
      done
      cd $dest_dir_code/tmp/psglib
      drop_vnmrs_

      cd $dest_dir_code/tmp
      setperms ./imaging 755 644 755
      chmod 755    ./maclib
      chmod 755    ./maclib/maclib.imaging
      chmod 644    ./maclib/maclib.imaging/*
      mv ./maclib/maclib.imaging ./imaging/maclib
      rm -rf ./maclib
      chmod 755 ./psglib
      chmod 644 ./psglib/*
      mv ./psglib ./imaging/psglib
      tar -cf - * | $Encodedir/encode $IMGP_password > $dest_dir_code/$Image/$Unity/img_pat.pwd
  else
      log_this " Skipping IMAGE_patent		for : "
  fi
  if [ x$winbuild != "xtrue" ]
  then
    make_TOC img_pat.pwd $Image/$Unity "Imaging_Sequences" sol/inova.opt  \
                                                           sol/vnmrs.opt  \
							   rht/vnmrs.opt
  else
    make_TOC img_pat.pwd $Image/$Unity "Imaging_Sequences" win/vnmrs.opt
  fi
 
  if [ x$password_answer = "xy" ]
  then
    log_this "   Tarring IMAGE_patent vnmrs files 	for : "
 
    cd $vcommondir/IMAGE_patent
    tar -cf - $VnmrsImagePatentFiles | (cd $dest_dir_code/tmp; tar $taroption -)
    cd $dest_dir_code/tmp
    mv imaging_vnmrs imaging
    mv parlib_vnmrs   imaging/parlib
    mv parlib_ATP_vnmrs   imaging/ATP/parlib
    setperms ./imaging 755 644 755
    tar -cf - * | $Encodedir/encode $IMGP_password > $dest_dir_code/$Image/$Unity/vnmrsimg_pat.pwd
  else
    log_this " Skipping IMAGE_patent vnmrs    for : "
  fi

  if [ x$winbuild != "xtrue" ]
  then
    make_TOC vnmrsimg_pat.pwd $Image/$Unity "Imaging_Sequences" sol/inova.opt  \
                                                           sol/vnmrs.opt  \
                                                           rht/inova.opt  \
                                                           rht/vnmrs.opt
  else
    make_TOC vnmrsimg_pat.pwd $Image/$Unity "Imaging_Sequences" win/vnmrs.opt
  fi

# tar Patented Image pulse sequences and supporting files
  if [ x$password_answer = "xy" ]
  then
      log_this "   Tarring IMAGE_patent sequence files	for : "

      mkdir -p $dest_dir_code/tmp/imaging/seqlib
      cd $solproglib_dir/nvseqlib
      for cfile in $PATENT_PS_2Tar
      do
        cp $cfile $dest_dir_code/tmp/imaging/seqlib
      done
      cd $dest_dir_code/tmp/imaging/seqlib
      drop_vnmrs_

      cd $dest_dir_code/tmp
      chmod -R 755 ./imaging
      tar -cf - * | $Encodedir/encode $IMGP_password > $dest_dir_code/$Image/$Unity/img_patseq.pwd
  else
      log_this " Skipping IMAGE_patent		for : "
  fi
  make_TOC img_patseq.pwd $Image/$Unity "Imaging_Sequences" sol/inova.opt \
                                                            sol/vnmrs.opt

  if [ x$password_answer = "xy" ]
  then
      log_this "   Tarring Linux IMAGE_patent sequence files	for : "

      mkdir -p $dest_dir_code/tmp/imaging/seqlib
      cd $lnxproglib_dir/nvseqlib
      for cfile in $PATENT_PS_2Tar
      do
        cp $cfile $dest_dir_code/tmp/imaging/seqlib
      done
      cd $dest_dir_code/tmp/imaging/seqlib
      drop_vnmrs_

      cd $dest_dir_code/tmp
      chmod -R 755 ./imaging
      tar -cf - * | $Encodedir/encode $IMGP_password > $dest_dir_code/$Linux/lnximg_patseq.pwd
  else
      log_this " Skipping IMAGE_patent		for : "
  fi
  make_TOC lnximg_patseq.pwd $Linux "Imaging_Sequences" rht/inova.opt	\
                                                        rht/vnmrs.opt

  if [ x$winbuild = "xtrue" ]
  then
    if [ x$password_answer = "xy" ]
    then
      log_this "   Tarring Windows IMAGE_patent sequence files	for : "

      mkdir -p $dest_dir_code/tmp/seqlib
      if [ -d $winproglib_dir/nvseqlib ]
      then
	cd $winproglib_dir/nvseqlib
	for cfile in $PATENT_PS_2Tar
	do
	  cp $cfile $dest_dir_code/tmp/seqlib
	done
        cd $dest_dir_code/tmp/seqlib
        drop_vnmrs_

	cd $dest_dir_code/tmp
	setperms ./seqlib 755 644 755
	tar -cf - * | $Encodedir/encode $IMGP_password > $dest_dir_code/$Windows/winimg_patseq.pwd
      else
	echo "$winproglib_dir/nvseqlib does not exist"
      fi
    else
      log_this " Skipping IMAGE_patent		for : "
    fi
    make_TOC winimg_patseq.pwd $Windows "Imaging_Sequences" win/inova.opt
  fi

#============== ACC ====================================================
# copy Solaris patches
#   echo "" | tee -a $log_file
#   log_this "PART XV -- ACC FOR CHEMMAGNETICS -- "
#
#   if [ ! -d $dest_dir/acc ]
#   then
#       mkdir $dest_dir/acc
#   fi
#   cp $vcommondir/acc/* $dest_dir/acc
#   chmod 644 $dest_dir/acc/*
#   chmod 755 $dest_dir/acc/acc
#
#============== INSTALLATION FILES =========================================
# copy some of the installation programs

echo "" | tee -a $log_file
log_this "PART XVI -- INSTALLATION FILES -- $dest_dir"
echo "" | tee -a $log_file
echo "" | tee -a $log_file

if [ x$winbuild != "xtrue" ]
then
    cp $commondir/sysscripts/autoloadcd $dest_dir/load.nmr
    chmod 777 $dest_dir/load.nmr
fi

#   echo "load.std " | tee -a $log_file
#   cp $commondir/sysscripts/loadcd $dest_dir/load.std
#   chmod 777 $dest_dir/load.std

if [ x$LoadVnmrJ != "xy" ]
then
   echo $Code/i_vnmr.3 | tee -a $log_file
   cp $commondir/sysscripts/i_vnmr3 $dest_dir_code/i_vnmr.3
   chmod 777 $dest_dir/code/i_vnmr.3

   echo $Code/i_vnmr.4 | tee -a $log_file
   cp $commondir/sysscripts/i_vnmr4 $dest_dir_code/i_vnmr.4
   chmod 777 $dest_dir/code/i_vnmr.4
fi

echo "checkspace, kill_insvnmr" | tee -a $log_file
(cd $commondir/sysscripts; cp checkspace $dest_dir_code)
(cd $dest_dir_code; chmod 777 checkspace )
if [ x$LoadVnmrJ = "xy" ]
then
   echo "vnmrsetup, dbsetup, bootr, ins_vnmr, kill_insvnmr, mkvnmrjadmin" | tee -a $log_file
   (cd $commondir/sysscripts; cp dbsetup vnmrsetup bootr ins_vnmr kill_insvnmr mkvnmrjadmin $dest_dir_code)
   (cd $dest_dir_code; chmod 777 dbsetup vnmrsetup bootr ins_vnmr kill_insvnmr mkvnmrjadmin)
   if [ x$winbuild = "xtrue" ]
   then
	#(cd $commondir/sysbin; cp setup.exe $dest_dir)
	(cd $winproglib_dir/bin; cp installvnmrj.exe $dest_dir; \
	 cp  vnmrj.exe vnmrj_adm.exe vnmrj_debug.exe $dest_dir_code/win/bin)
	(cd $commondir/sysscripts; cp loadnmr.bat uninstallvj.bat $dest_dir_code)
	(cd $winproglib_dir/scripts; cp groupadd useradd getuserinfo $dest_dir_code/win/bin; \
	cp autorun.inf $dest_dir)
	#(cd $dest_dir; chmod 777 setup.exe)
	(cd $dest_dir; rm setup.exe)
	(cd $dest_dir_code; chmod 777 loadnmr.bat uninstallvj.bat)
	(cd $dest_dir_code/win/bin; chmod 777 vnmrj.exe vnmr_adm.exe vnmrj_debug.exe)
    fi
fi

#Nirvana CD only
touch $dest_dir_code/.nv

#
#  VJ cdrom only
#
   if [ x$LoadVnmrJ = "xy" ]
   then
      if [ x$winbuild != "xtrue" ]
      then
	(cd $dest_dir; rm -f load.nmr; ln -s code/vnmrsetup load.nmr)
      
	for file in $LoadDecodeBin
	do
         echo $Code/$file | tee -a $log_file
         rm -f $dest_dir_code/$file
         cp -p $solproglib_dir/bin/$file $dest_dir_code/$file
         chmod 777 $dest_dir/code/$file
	done

	cp -p $lnxproglib_dir/bin/decode.lnx $dest_dir_code/decode.rht
	chmod 777 $dest_dir_code/decode.rht
	cp -p $vcommondir/linux/acroread-5.08-2.i386.rpm $dest_dir_code/linux
	chmod 777 $dest_dir_code/linux/acroread-5.08-2.i386.rpm
	cp -p $vcommondir/linux/rarpd-ss981107-14.i386.rpm $dest_dir_code/linux
	chmod 777 $dest_dir_code/linux/rarpd-ss981107-14.i386.rpm
	cp -p $vcommondir/linux/rarpd-ss981107-18.x86_64.rpm $dest_dir_code/linux
	chmod 777 $dest_dir_code/linux/rarpd-ss981107-18.x86_64.rpm
	cp -p $vcommondir/linux/tftp-server-0.32-4.i386.rpm $dest_dir_code/linux
	chmod 777 $dest_dir_code/linux/tftp-server-0.32-4.i386.rpm
      else
        (cd $dest_dir; rm -f load.nmr)
	cp -p $winproglib_dir/bin/decode.win $dest_dir_code/decode.win
	chmod 777 $dest_dir_code/decode.win
      fi
   else
 
      for file in $LoadSolFilesBin
      do
         echo $Code/$file | tee -a $log_file
         rm -f $dest_dir_code/$file
         cp -p $solproglib_dir/bin/$file $dest_dir_code/$file
         chmod 777 $dest_dir/code/$file
      done
   fi
 
   echo "copying icons" | tee -a $log_file
   cd $dest_dir_code
   if [ ! -d $dest_dir_code/icon ]
   then
      mkdir -p $dest_dir_code/icon
   fi

   cd icon
   chmod -w *.icon
   chmod -w *.gif
   rm -f datastn.gif
   cp /vcommon/iconlib/datastn.gif .

   Sget bin inova.icon > /dev/null
   Sget bin logo.icon > /dev/null
   chmod +w *.icon
#   mv inova.icon    inova.xpm;
#   $Convert inova.xpm    inova.gif
#   mv inova.xpm     inova.icon
   Sget gif inova.gif > /dev/null
   Sget gif vnmrs.gif > /dev/null
   Sget gif mr400.gif > /dev/null
   Sget gif logo.gif > /dev/null
   chmod +w *.gif
 
   cd $dest_dir_code/../
   echo "" | tee -a $log_file
   echo "" | tee -a $log_file
   rm -f vnmrrev $RevFileName $RevFileName.txt
   echo "Writing Revision File '$RevFileName':"  | tee -a $log_file
   echo $VnmrRevId > vnmrrev
   echo `date '+%B %d, %Y'` >> vnmrrev
   cat vnmrrev | tee -a $log_file
   if [ x$winbuild = "xtrue" ]    # if this works we'l do more
   then
      unix2dos vnmrrev $RevFileName.txt
   else
      ln -s vnmrrev $RevFileName
   fi
   rm -rf license
   cp -r $vcommondir/license . 


#Create a system checksums file to validate Part11 system
if [ x$LoadP11 = "xy" ]
then

    mkdir -p $dest_dir_code/tmp
    cd $dest_dir_code/tmp
     
    tar xvf $dest_dir_code/common/combin.tar
    tar xvf $dest_dir_code/inova/vnmrj.tar
    tar xvf $dest_dir_code/inova/vnmrjbin.tar
    tar xvf $dest_dir_code/inova/java.tar
    tar xvf $dest_dir_code/inova/vnmrjadmjar.tar
    tar xvf $dest_dir_code/inova/wobbler.tar
    tar xvf $dest_dir_code/inova/acqbin2.tar
    tar xvf $dest_dir_code/inova/acqbin.tar
    tar xvf $dest_dir_code/solaris/bin.tar
    tar xvf $dest_dir_code/solaris/unibin.tar
    tar xvf $dest_dir_code/solaris/binx.tar

    mkdir -p adm/p11
    #bin/vnmrMD5 -l /vcommon/p11/sysList vnmrsystem > adm/p11/syschksm

    #pack checksum file together within com.tar
    #tar -rf $dest_dir_code/common/com.tar  adm/p11/syschksm

    cd $dest_dir_code
    rm -rf tmp
fi

#---------------------------------------------------------------------------
# Finally, all done, write out passwd file, clean up some unneeded directories
 
   cd $dest_dir/..
   echo "" | tee -a $log_file
   echo "" | tee -a $log_file
   echo "The passwords used with this install are:" > passwords | tee -a $log_file
   echo "" >> passwords
   #echo "Gradient_shim	   $Gmap_password"  	>> passwords
   echo "Diffusion	   $Diff_password"  	>> passwords
   echo "LC-NMR		   $LCNMR_password" 	>> passwords
   echo "STARS             $Stars_password" 	>> passwords
   echo "Backprojection	   $Backproj_password"  >> passwords
   echo "CSI		   $CSI_password"   	>> passwords
   echo "BIR_Shapes        $BIR_password"   	>> passwords
   echo "DOSY              $DOSY_password"  	>> passwords
   echo "3D_shimming       $Gxyz_password"  	>> passwords
   echo "768_AS            $AS768_password" 	>> passwords
   echo "VAST              $VAST_password"  	>> passwords
   echo "FDM               $FDM_password"   	>> passwords
   echo "Imaging_Sequences $IMGP_password"  	>> passwords
   echo "Xrecon            $XRECON_password"  	>> passwords
   echo "" >> passwords

   cat passwords >> $log_file
   echo " " | tee -a $log_file
   
   if [ x$fini_dir != "xnone" ]
   then
     echo "Write CD Image to Destination Place: $fini_dir" | tee -a $log_file
     cd $dest_dir
     tar -cf - . | (cd $fini_dir; tar $taroption -)
     cp $dest_dir/../passwords $fini_dir.passwords

     if [ x$LoadVnmrJ = "xy" ]
     then
        if [ x$winbuild != "xtrue" ]
        then
           rm -f /rdvnmr/.cdromVJ_latest
           ln -s $fini_dir /rdvnmr/.cdromVJ_latest
        else
           rm -f /rdvnmr/.cdromVJ_latest_win
           ln -s $fini_dir /rdvnmr/.cdromVJ_latest_win
        fi
     else
        rm -f /rdvnmr/.cdrom_latest
        ln -s $fini_dir /rdvnmr/.cdrom_latest
     fi
     if [ x$notifySW = "xy" ]
     then
	mail_list="`cat $vbin/cdout_mail_list`"
        msg1="Subject:  $fini_dir Completed"
        msg2="To: $mail_list"
        msg3a=`echo "FYI,\n"`
        msg3=`echo "CD Image \"$fini_dir\" is Built.\n"`
        msg4=`echo "No Warranty is Expressed or Implied.\n"`
        msg="$msg1\n$msg2\n \n \n$msg3a\n\n$msg3\n$msg4\n\n"
        echo $msg | mail  $mail_list 
     fi
   fi

echo "DONE - nvcdout--------------" | tee -a $log_file
