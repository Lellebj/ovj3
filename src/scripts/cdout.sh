: /bin/sh
#
# '@(#)cdout.sh 22.1 03/24/08 1991-2006 .'
#
#scripts to make a directory with all the data needed for Nessie
#
# Default Declarations
#
if [ x$vcommondir = "x" ]
then
     vcommondir="/vcommon"
fi

ShowPermResults=-100
Code="code"
#Install_dir="/common/sysscripts"
#
# Archived acquisition files for VXR,Unity,Unity+ 
sol53objdir="/vobj/sol53"
sol53common="/vobj/sol53/vcommon"
if [ x$lnxobjdir = "x" ]
then
   lnxobjdir="/vobj/lnx"
fi
lnxproglib_dir=${lnxobjdir}/proglib
solproglib_dir=${solobjdir}/proglib
#
Aix="aix"
Common="common"
Backproj="backproj"
CSI="csi"
Diff="diffuse"
vbin="/sw/vbin"
Encodedir=$vbin
Gemini="gemini"
Glide="glide"
Glidepack="glidepack"
Gmap="gmap"
Gxyz="gxyz"
Gnu="gnu"
Image="imaging"
Inova="inova"
Irix="irix"
Kermit="kermit"
LCNMR="lcnmr"
Limnet="limnet"
Linux="linux"
Mercury="mercury"
Mvx="mercvx"
Pfg="pfg"
Rht="Rht"
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
#Gmap_password="md-grf"
#LCNMR_password="hc-cpm"
#Diff_password="pi-blv"
#Stars_password="lp-phh"
#Backproj_password="bf-tors"
#CSI_password="fa-lmlk"

# Vnmr 5.3B passwords
#Gmap_password="gg-lrs"
#LCNMR_password="dn-fvt"
#Diff_password="pi-poi"
#Stars_password="mt-poa"
#Backproj_password="bd-iee"
#CSI_password="rt-bai"
#DOSY_password="sg-akm"
#BIR_password="lt-bjs"
#VAST_password="wo-cmm"

# Vnmr 6.1B passwords
#Gmap_password="gg-lrs"
#LCNMR_password="cp-not"
#Diff_password="pi-poi"
#Stars_password="do-wat"
#Backproj_password="bd-iee"
#CSI_password="rt-bai"
#DOSY_password="sg-akm"
#BIR_password="lt-bjs"
#VAST_password="mm-mfv"
#FDM_password="hl-zzb"

# Vnmr 6.1C passwords
#Gmap_password="gg-lrs"
#LCNMR_password="mm-zzj"
#Diff_password="pi-poi"
#Stars_password="do-wat"
#Backproj_password="bd-iee"
#CSI_password="rt-bai"
#DOSY_password="hl-bcp"
#BIR_password="lt-bjs"
#VAST_password="vn-otf"
#FDM_password="ka-sgm"
#IMGP_password="gr-rsj"	# new starting 2002-2-28

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
VAST_password="vn-otf"
FDM_password="sl-jfj"
IMGP_password="hs-ikf"

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
# VAST_password="aa-aaa"
# FDM_password="aa-aaa"
# IMGP_password="aa-aaa"

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
#until we remove the manual section from cdout.sh
#		acrobat			\

SubDirs="				\
		aix			\
        	as768			\
		backproj		\
		backproj/unity		\
		common			\
		csi			\
		csi/unity		\
		gemini			\
		glide			\
		glide/aix		\
		glide/irix		\
		glide/solaris		\
		glidepack		\
		diffuse			\
		gmap			\
		gnu			\
		imaging			\
		imaging/unity		\
		inova			\
		irix			\
		java			\
		lcnmr			\
		limnet			\
		limnet/aix		\
		limnet/solaris		\
		linux			\
		linux_i			\
		kermit			\
		kermit/solaris		\
                mercury			\
		mercvx			\
		pfg			\
		pfg/common		\
		pfg/aix			\
		pfg/gemini		\
		pfg/inova		\
		pfg/irix		\
		pfg/unity		\
		rht			\
		sol			\
		solaris			\
		stars			\
		stars/unity		\
		tmp			\
		uimaging		\
		uimaging/aix		\
		uimaging/irix		\
		uimaging/unity		\
		unity			\
		unity/gemini		\
		unity/inova		\
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
		rht/inova.rht		\
		rht/inova.opt		\
		rht/mercplus.rht	\
		rht/mercplus.opt	\
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
	devicenames		\
	devicetable		\
	dicom.cfg		\
	rc.vnmr			\
	solventlist		\
	solventppm		\
	solvents		\
	vnmrmenu		\
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
	bin/decctool		\
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
	bin/managelnxdev		\
	bin/psggen		\
        bin/patchinstall 	\
        bin/patchremove 	\
	bin/readbrutape		\
	bin/rvnmrj		\
	bin/rvnmrx		\
	bin/seqgen		\
	bin/setuserpsg		\
	bin/spingen		\
	bin/status		\
	bin/sudoins             \
	bin/tryquitjpsg             \
	bin/vbg			\
	bin/vjhelp              \
	bin/vnmr		\
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
	"

ComDirs2Tar="			\
	asm			\
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
	xvfonts			\
	"

P11Bin2Tar=" \
	-C $solobjdir/proglib/bin safecp	\
	-C $solobjdir/proglib/bin chVJlist	\
	-C $solobjdir/proglib/bin vnmrMD5	\
	-C $solobjdir/proglib/bin chchsums	\
	-C $solobjdir/proglib/bin writeAaudit	\
	-C $solobjdir/proglib/bin writeTrash	\
	-C $solobjdir/proglib/bin auditcp	\
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
	bin/makeP11checksums	\
	"

P11Xml2Tar="	\
	-C $vcommondir/xml     accPolicy		\
	-C $vcommondir/xml     part11Config	\
	-C $vcommondir/xml     AdminMenu.xml.p11	\
	-C $vcommondir/xml     MainMenu.xml.p11	\
	-C $vcommondir/xml     MainMenuData.xml.p11	\
	-C $vcommondir/xml     MainMenuDisplay.xml.p11	\
	-C $vcommondir/xml     MainMenuUtil.xml.p11	\
	-C $vcommondir/xml     DefaultToolBar.xml.p11	\
	-C $vcommondir/xml     audit.xml		\
	-C $vcommondir/xml     saveas.xml		\
	-C $vcommondir/xml     cmdHis.xml		\
        -C $vcommondir/xml     locator_statements_default.xml.walkup.p11        \
        -C $vcommondir/xml     MainMenu.xml.walkup.p11          \
        -C $vcommondir/xml     MainMenuData.xml.walkup.p11      \
	-C $vcommondir/PART11  shuffler			\
	"

AdminFiles2Tar="	\
	automation.conf \
	protocolListWalkup.xml \
	rightsList.xml \
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
# -- binary common to SunView & X-window to include in bin.tar file 
# --- bin.tar 
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
	bin/glide		\
	bin/gs			\
	bin/loginvjpassword	\
        bin/readsctables	\
        bin/showstat		\
        bin/spins		\
        bin/tape		\
        bin/tek_setup		\
        bin/unix_vxr		\
	bin/usrwt.o		\
        bin/vn			\
	bin/vnmr_confirmer	\
	bin/vxr_unix		\
	bin/weight.h		\
	bin/xdcvt		\
	bin/fontselect		\
	bin/convertcmx		\
	-C $solobjdir/proglib bin/safecp	\
	"

BinFilesLinux2Tar="		\
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
        bin/fileowner		\
        bin/findLinks		\
        bin/fitspec		\
        bin/loginvjpassword	\
        bin/Probe_edit		\
	bin/pulsetool		\
	bin/pulsechild		\
        bin/readsctables	\
        bin/setGifAspect	\
        bin/spins		\
        bin/startmekillme	\
        bin/send2Vnmr		\
        bin/showconsole		\
        -C $lnxproglib_dir/stat Infostat	\
	"

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
	-C $vcommondir/BLT/linux lib/libBLT24.so	\
	-C $vcommondir/BLT/linux lib/libBLT24.so.8.4	\
	"

PboxBin2Tar="			\
	bin/Pbox		\
	bin/Pxfid		\
	bin/Pxsim		\
	bin/Pxspy		\
	bin/PboxAdapter		\
	"


# -- binary X-Windows base programs to include in binx.tar file 
# --- binx.tar 
BinX2Tar="			\
	bin/Vnmr	  	\
	bin/pulsetool		\
	bin/pulsechild		\
	bin/Acqstat		\
	bin/Infostat		\
	bin/Acqmeter		\
	bin/convert		\
	bin/gs			\
	-C $vcommondir/tape_sol app-defaults/Vnmr		\
	-C $vcommondir/tape_sol app-defaults/XTerm		\
	-C $vcommondir/tape_sol app-defaults/PulseTool	\
	-C $vcommondir/tape_sol app-defaults/Status	\
	-C $vcommondir/tape_sol app-defaults/Enter		\
	-C $vcommondir/tape_sol app-defaults/Dg	\
	"

Gs2Tar="			\
	gs			\
	"


TclBinLinux2Tar="			\
	tcl/bin			\
	tcl/bltlibrary		\
	tcl/tcllibrary		\
	tcl/tixlibrary		\
	tcl/tklibrary		\
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
Acct2Tar="			\
	adm/bin/console_login	\
	-C $vcommondir adm/bin/acc_vnmr	\
	-C $vcommondir adm/bin/console_acct	\
	-C $vcommondir adm/bin/update_acctng	\
	-C $vcommondir adm/bin/view_acctng	\
	-C $vcommondir adm/bin/xcal	\
	-C $vcommondir adm/accounting	\
	-C $vcommondir adm/log		\
	-C $vcommondir adm/tmp		\
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
	psglib			\
	"

ProtuneText2Tar="		\
	maclib			\
	manual			\
	templates		\
	tune			\
	"

#
# PART IV --- Inova, Unity
#
# -- Inova/Unity libraries used by the Pulse Sequencies 
# --- psg.tar 
BinPsg2Tar="			\
	psg/libpsglib.a		\
        psg/libparam.a          \
	psg/libpsglib.so.$psg_so_ver	\
	psg/libparam.so.$psg_so_ver	\
        psg/libparam.so         \
        psg/libpsglib.so        \
        psg/x_ps.o		\
	"

BinPsgLinux2Tar="			\
	psg/libpsglib.a		\
        psg/libparam.a          \
	psg/libpsglib.so.$psg_so_ver	\
	psg/libparam.so.$psg_so_ver	\
        psg/libparam.so         \
        psg/libpsglib.so        \
        psg/x_ps.o              \
	"

#---- Inova/Unity seqlib binaries to tar
# --- seqlib.tar 
BinSeq2Tar="			\
	seqlib/APT		\
	seqlib/COSY		\
	seqlib/DEPT		\
	seqlib/DQCOSY		\
	seqlib/HETCOR		\
	seqlib/HMBC		\
	seqlib/HMQC		\
	seqlib/HMQC_d2		\
	seqlib/HMQCTOXY		\
	seqlib/HMQCTOXY_d2	\
	seqlib/HOMODEC		\
	seqlib/HSQC		\
	seqlib/HSQC_d2		\
	seqlib/HSQCAD		\
	seqlib/HSQCTOXY		\
	seqlib/HSQCTOXY_d2	\
	seqlib/NOESY		\
	seqlib/NOESY1D		\
	seqlib/PRESAT		\
	seqlib/PWXCAL		\
	seqlib/ROESY		\
	seqlib/ROESY1D		\
	seqlib/T1meas		\
	seqlib/TOCSY		\
	seqlib/TOCSY1D		\
	seqlib/apt		\
	seqlib/binom		\
	seqlib/br24		\
	seqlib/cosyps		\
	seqlib/cpmgt2		\
	seqlib/cyclenoe		\
	seqlib/cylbr24		\
	seqlib/cylmrev		\
	seqlib/d2pul		\
	seqlib/dept		\
	seqlib/dqcosy		\
	seqlib/flipflop		\
	seqlib/gmapz		\
	seqlib/hcchtocsy	\
	seqlib/het2dj		\
	seqlib/hetcor		\
	seqlib/hetcorcp1	\
	seqlib/hetcorps		\
	seqlib/hmqc		\
	seqlib/hmqcr		\
	seqlib/hmqctocsy	\
	seqlib/hmqctoxy3d	\
	seqlib/hom2dj		\
	seqlib/hsqc		\
	seqlib/hsqcHT		\
	seqlib/hsqctoxySE	\
	seqlib/inadqt		\
	seqlib/inept		\
	seqlib/jumpret		\
	seqlib/mqcosy		\
	seqlib/mrev8		\
	seqlib/noesy		\
	seqlib/noesy_zq		\
	seqlib/ppcal		\
	seqlib/presat		\
	seqlib/pwxcal		\
	seqlib/qtune		\
	seqlib/redor1		\
	seqlib/relayh		\
	seqlib/roesy		\
	seqlib/s2pul		\
	seqlib/s2pulq		\
	seqlib/s2pulr		\
	seqlib/selexcit		\
	seqlib/sh2pul		\
	seqlib/ssecho		\
	seqlib/ssecho1		\
	seqlib/tncosyps		\
	seqlib/tndqcosy		\
	seqlib/tnmqcosy		\
	seqlib/tnnoesy		\
	seqlib/tnroesy		\
	seqlib/tntocsy		\
	seqlib/tocsy		\
	seqlib/tocsyHT		\
	seqlib/troesy		\
	seqlib/wetdqcosy	\
	seqlib/wetnoesy		\
	seqlib/wetpwxcal	\
	seqlib/wetrelayh	\
	seqlib/wettntocsy	\
	seqlib/wfgtest		\
	seqlib/xnoesysync	\
	seqlib/xpolar		\
	seqlib/xpolar1		\
	seqlib/ztocsy_zq	\
	"

WobbleText="			\
	tune			\
	"

WobbleExec="			\
	bin/qtune_ui		\
	bin/autoshim		\
	-C $vcommondir/tape_sol app-defaults/Qtune	\
	"

#
# PART V --- Gemini, Unity
#
uLibs2Tar="				\
	./libacqcomm.a			\
	./libacqcomm.so			\
	./libacqcomm.so.$ACQCOMM_VER	\
	"

#
# PART VI --- Unity
#
#----- kernels to move from /vtape/kernels  
Kernels2Move="			\
	sh		\
	sh.conf		\
	"

# -- files to include in acqbin tar file
# --- acqbin.tar 
#  Note:  Originally many of these files came from ongoing 5.3 SCCS
#         It was discovered though that most need to come from ongoing
#         (6.1) SCCS

BinAcq2Tar="			\
	-C $solobjdir acqbin/Acqproc		\
        -C $solobjdir acqbin/Autoproc         \
        -C $solobjdir acqbin/startacqproc     \
        -C $solobjdir acqbin/killacqproc      \
        -C $solobjdir acqbin/acqinfo_svc      \
        -C $solobjdir bin/iadisplay		\
        -C $solobjdir bin/send2Vnmr           \
        -C $solobjdir bin/vconfig		\
	-C $solobjdir bin/qtune_data		\
	-C $vcommondir/tape_sol app-defaults/Acqi	\
	-C $vcommondir/tape_sol app-defaults/Config	\
	-C $vcommondir          bin/usetacq		\
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
#	acq/xrxrh_img.out	\
#	acq/xrxrp_img.out	\
#	acq/autshm_img.out	\

#
# PART VII --- Gemini
#
gPar2Tar="		\
	gpar/par200	\
	gpar/par300	\
	gpar/par400	\
	gpar/parlib	\
	"

#  list of file in  gacq.tar 
gAcqTarLst="			\
	acq/apmon		\
	acq/autshm		\
	acq/lnc			\
	"

# -- files to include in gemini acqbin tar file
# --- gacqbin.tar 
gBinAcq2Tar="acqbin/gAcqproc	\
        acqbin/acqinfo_svc      \
        acqbin/Autoproc         \
        acqbin/startacqproc     \
        acqbin/killacqproc      \
        bin/catcheaddr		\
        bin/findedevices	\
        bin/giadisplay		\
        bin/send2Vnmr           \
	-C $vcommondir/tape_sol app-defaults/Acqi	\
	-C $vcommondir          bin/gsetacq		\
	"

# -- Gemini libraries used by the Pulse Sequencies 
# --- gpsg.tar 
gBinPsg2Tar="gpsg/libpsglib.a		\
        gpsg/libparam.a			\
	gpsg/libpsglib.so.$psg_so_ver	\
	gpsg/libparam.so.$psg_so_ver	\
        gpsg/libparam.so		\
        gpsg/libpsglib.so		\
        gpsg/x_ps.o			\
        bin/gconfig			\
	-C $vcommondir/tape_sol app-defaults/Config	\
	"

#---- Standard seqlib binaries to tar
# --- seqlib.tar
gBinSeq2Tar="		\
	gseqlib/APT	\
	gseqlib/COSY	\
	gseqlib/DEPT	\
	gseqlib/DQCOSY	\
	gseqlib/gCOSY	\
	gseqlib/gDQCOSY	\
	gseqlib/gHMBC	\
	gseqlib/gHMQC	\
	gseqlib/gHSQC	\
	gseqlib/gXHCAL	\
	gseqlib/HETCOR	\
	gseqlib/HMBC	\
	gseqlib/HMQC	\
	gseqlib/HOMODEC	\
	gseqlib/HSQC	\
	gseqlib/NOESY	\
	gseqlib/PWXCAL	\
	gseqlib/apt	\
	gseqlib/cpmgt2	\
	gseqlib/cosyps	\
	gseqlib/dept	\
	gseqlib/dqcosy	\
	gseqlib/gmapz	\
	gseqlib/het2dj	\
	gseqlib/hetcor	\
	gseqlib/hmqc	\
	gseqlib/hom2dj	\
	gseqlib/inept	\
	gseqlib/noedif	\
	gseqlib/noesy	\
	gseqlib/ppcal	\
	gseqlib/relayh	\
	gseqlib/s2pul	\
	"

#
# PART VIIb --- Mercury 
#

# -- Mercury script files
# --- mercbin.tar 
    mercBinScripts2Tar="bin/protune	\
        "

# -- Mercury libraries used by the Pulse Sequencies 
# --- kpsg.tar 
kBinPsg2Tar="kpsg/libpsglib.a		\
        kpsg/libparam.a			\
	kpsg/libpsglib.so.$psg_so_ver	\
	kpsg/libparam.so.$psg_so_ver	\
        kpsg/libparam.so		\
        kpsg/libpsglib.so		\
        kpsg/x_ps.o			\
        bin/kconfig			\
	bin/mqtune_data         \
	-C $vcommondir/tape_sol app-defaults/Config	\
	"

kBinPsgLinux2Tar="kpsg/libpsglib.a		\
        	kpsg/libparam.a			\
		kpsg/libpsglib.so.$psg_so_ver	\
		kpsg/libparam.so.$psg_so_ver	\
        	kpsg/libparam.so		\
        	kpsg/libpsglib.so		\
        	kpsg/x_ps.o			\
		"

#---- Standard seqlib binaries to tar
# --- seqlib.tar
kBinSeq2Tar="		\
	kseqlib/APT     \
	kseqlib/CIGAR	\
	kseqlib/CIGAR2j3j \
        kseqlib/COSY    \
        kseqlib/DEPT    \
        kseqlib/DQCOSY  \
        kseqlib/HETCOR  \
        kseqlib/HMBC    \
        kseqlib/HMQC    \
        kseqlib/HMQCTOXY        \
        kseqlib/HOMODEC \
        kseqlib/HSQC    \
        kseqlib/HSQCTOXY        \
        kseqlib/NOESY   \
        kseqlib/NOESY1D \
        kseqlib/PRESAT  \
        kseqlib/PWXCAL  \
        kseqlib/ROESY   \
        kseqlib/ROESY1D	\
        kseqlib/TOCSY  	\
        kseqlib/TOCSY1D \
        kseqlib/apt     \
        kseqlib/aptune  \
        kseqlib/cosyps  \
        kseqlib/cpmgt2  \
	kseqlib/dept	\
	kseqlib/dqcosy	\
	kseqlib/het2dj  \
        kseqlib/hetcor  \
	kseqlib/hmqc	\
	kseqlib/hom2dj  \
	kseqlib/inadqt  \
        kseqlib/inept   \
        kseqlib/noedif  \
        kseqlib/noesy   \
        kseqlib/ppcal   \
	kseqlib/pwxcal	\
        kseqlib/relayh  \
        kseqlib/qtune   \
	kseqlib/roesy	\
	kseqlib/s2pul	\
	kseqlib/s2pulq	\
	kseqlib/selexcit	\
	kseqlib/tocsy	\
	kseqlib/wet1D	\
	kseqlib/xpolar1	\
	"

kPbox2Tar="			\
	help		\
	shapelib	\
	wavelib		\
	"

#  list of file in  kacq.tar 
kAcqTarLst="			\
	acq/kapmon		\
	acq/autshm		\
	acq/lnc			\
	"
kVx2Tar="                      	         \
        acq/vxBoot.big/vxWorks              \
        acq/vxBoot.big/vxWorks.sym          \
        acq/kvxBoot.small/vxWorks       \
        "

kVxObj2Tar="                    \
        acq/kvwhdobj.o          \
        acq/kvwlibs.o           \
        acq/kvwtasks.o          \
        acq/vxBoot.big/vwcom.o  \
        "
kCPMAStemplate="			\
	-C ktape_sol	user_templates	\
	"

#
# PART  --- Inova 
#
PS_2Tar="			\
	APT		\
	AT_lkdec		\
	ATB1profile	\
	ATCNnoesy	\
	ATcancel		\
	ATcpmgt2		\
	ATd2pul		\
	ATdante		\
	ATdsh2pul	\
	ATfsqd		\
	ATg2pul		\
	ATgNhmqc		\
	ATgcancel	\
	ATgecho		\
	ATphswitch	\
	ATphtest		\
	ATprofile	\
	ATrfhomo		\
	CIGAR		\
	CIGAR2j3j	\
	COSY		\
	DEPT		\
	DQCOSY		\
	HETCOR		\
	HMBC		\
	HMQC		\
	HMQC_d2		\
	HMQCTOXY		\
	HMQCTOXY_d2	\
	HOMODEC		\
	HSQC		\
	HSQC_d2		\
	HSQCAD		\
	HSQCTOXY		\
	HSQCTOXY_d2	\
	NOESY		\
	NOESY1D		\
	PRESAT		\
	PWXCAL		\
	ROESY		\
	ROESY1D		\
	T1meas		\
	TOCSY		\
	TOCSY1D		\
	apt		\
	aptune		\
	binom		\
	br24		\
	clubhsqc		\
	cosyps		\
	cpmgt2		\
	cyclenoe		\
	cylbr24		\
	cylmrev		\
	d2pul		\
	dept		\
	dqcosy		\
	flipflop		\
	gmapz		\
	gHSQCAD		\
	hcchtocsy	\
	het2dj		\
	hetcor		\
	hetcorcp1	\
	hetcorps		\
	hmqc		\
	hmqcr		\
	hmqctocsy	\
	hmqctoxy3d	\
	hom2dj		\
	hsqc		\
	hsqcHT		\
	hsqctoxySE	\
	inadqt		\
	inept		\
	jumpret		\
	mqcosy		\
	mrev8		\
	noesy		\
	noesy_zq	\
	ppcal		\
	presat		\
	pwxcal		\
	qtune		\
	redor1		\
	relayh		\
	roesy		\
	s2pul		\
	s2pulq		\
	s2pulr		\
	selexcit		\
	sh2pul		\
	ssecho		\
	ssecho1		\
	tncosyps		\
	tndqcosy		\
	tnmqcosy		\
	tnnoesy		\
	tnroesy		\
	tntocsy		\
	tocsy		\
	tocsyHT		\
	troesy		\
	wetdqcosy	\
	wetnoesy		\
	wetpwxcal	\
	wetrelayh	\
	wettntocsy	\
	wfgtest		\
	xnoesysync	\
	xpolar		\
	xpolar1		\
	ztocsy_zq	\
	"

ProcFam="			\
	acqbin/nAutoproc	\
	acqbin/Expproc		\
	acqbin/Infoproc		\
	acqbin/Procproc		\
	acqbin/Recvproc		\
	acqbin/Roboproc		\
	acqbin/Sendproc		\
	acqbin/Atproc		\
	acqbin/bootpd		\
	acq/bootptab		\
	acq/vwScript		\
	acq/vwScriptPPC		\
        bin/catcheaddr		\
        bin/findedevices	\
        bin/iiadisplay		\
	bin/send2Vnmr		\
	-C $vcommondir/tape_sol app-defaults/Acqi	\
	"

iProcFam="			\
	acq/tms320dsp.ram       \
	acq/vwAutoScript        \
	bin/iqtune_data         \
	bin/ihwinfo             \
	bin/vconfig             \
        -C $vcommondir/tape_sol  app-defaults/Config \
	-C $vcommondir 		spincad	\
        "

iProcLinuxFam="			\
	acq/tms320dsp.ram       \
	acq/vwAutoScript        \
	acq/vwScript		\
	acq/vwScriptPPC		\
	-C $lnxproglib_dir/nautoproc	Autoproc	\
	-C $lnxproglib_dir/expproc	Expproc		\
	-C $lnxproglib_dir/infoproc	Infoproc	\
	-C $lnxproglib_dir/procproc	Procproc	\
	-C $lnxproglib_dir/recvproc	Recvproc	\
	-C $lnxproglib_dir/roboproc	Roboproc	\
	-C $lnxproglib_dir/sendproc	Sendproc	\
	-C $lnxproglib_dir/atproc	Atproc		\
	-C $vcommondir spincad	\
        "

Pbox2Tar="		\
	help		\
	wavelib		\
	"

iLibs2Tar="				\
	ncomm/libacqcomm.a		\
	ncomm/libacqcomm.so		\
	ncomm/libacqcomm.so.$ACQCOMM_VER6	\
	ncomm/libncomm.a			\
	ncomm/libncomm.so			\
	ncomm/libncomm.so.$NCOMM_VER	\
	dicom/dicom.dic			\
	"

iLibsLinux2Tar="				\
	ncomm/libacqcomm.so			\
	ncomm/libacqcomm.so.$ACQCOMM_VER6	\
	ncomm/libncomm.so			\
	ncomm/libncomm.so.$NCOMM_VER		\
	"

iVx2Tar="				\
        acq/vxBoot.small/vxWorks	\
	acq/vxBoot.big/vxWorks		\
	acq/vxBoot.big/vxWorks.sym		\
	"

iVxObj2Tar="			\
	acq/vxBoot.big/vwhdobj.o		\
	acq/vxBoot.big/vwlibs.o		\
	acq/vxBoot.big/vwtasks.o		\
	acq/vxBoot.big/vwcom.o		\
	"

iVxPpc2Tar="				\
        acq/vxBootPPC.small/vxWorks	\
	acq/vxBootPPC.big/vxWorks		\
	acq/vxBootPPC.big/vxWorks.sym		\
	"

iVxPpcObj2Tar="			\
	acq/vxBootPPC.big/vwhdobj.o		\
	acq/vxBootPPC.big/vwlibs.o		\
	acq/vxBootPPC.big/vwtasks.o		\
	acq/vxBootPPC.big/vwcom.o		\
	"

Cryo2Tar="				 \
	-C $sourcedir/syscryo	cryo.jar \
	"

Apt2Tar="				\
	java/apt.jar			\
	"

Jplot2Tar="				\
	java/jplot.jar			\
	"

Jpsg2Tar=" \
	-C $sourcedir/sysjpsg Jpsg			\
	-C $sourcedir/sysjpsg PSGGo.cps		\
	-C $sourcedir/sysjpsg PSGSetup.cps		\
	-C $sourcedir/sysjpsg PSGscan.cps		\
	-C $sourcedir/sysjpsg PSGerrors.properties	\
	-C $sourcedir/sysjpsg lib/Jpsg.jar		\
	"

VnmrJJar2Tar=" \
        -C $sourcedir/sysvnmrj              vnmrj.jar			\
        -C $sourcedir/sysvnmrj              vnmrj.jar.dasho		\
        -C $sourcedir/sysvnmrj              libvnmrj.so			\
        -C $vcommondir/vnmrj                libSolarisSerialParallel.so \
        -C $sourcedir/sysapt                apt.jar			\
	"

VnmrJJarLinux2Tar=" \
        -C $sourcedir/sysvnmrj           vnmrj.jar	\
        -C $sourcedir/sysvnmrj           vnmrj.jar.dasho \
        -C $lnxproglib_dir/vnmrbg	 libvnmrj.so	\
        -C $sourcedir/sysapt             apt.jar			\
	"

VnmrJAdm2Tar=" \
        -C $vcommondir/xml              grouplist.xml		\
        -C $vcommondir/xml              userlist.xml		\
        -C $vcommondir/xml              userDefaults		\
	"

VnmrJAdmJar2Tar=" \
        -C $sourcedir/sysadmin              VnmrAdmin.jar		\
        -C $sourcedir/sysmanagedb           managedb.jar		\
        -C $sourcedir/sysmanagedb           managedb.jar.dasho		\
	"

VnmrJBinLinux2Tar=" \
        -C $lnxproglib_dir/vnmrbg   Vnmrbg	\
	"

VnmrJBin2Tar=" \
        -C $solproglib_dir/vnmrbg   Vnmrbg		\
        -C $sourcedir/sysscripts  S99pgsql      	\
        -C $sourcedir/sysscripts  vnmrj         	\
        -C $vcommondir/bin         managedb		\
        -C $vcommondir/bin         dbsetup		\
        -C $vcommondir/bin         dbupdate		\
        "

VnmrJPgsql2Tar=" \
        -C $vcommondir           pgsql/bin		\
        -C $vcommondir           pgsql/lib		\
        -C $vcommondir           pgsql/share		\
	-C $vcommondir/bin	create_pgsql_user	\
	-C $vcommondir		shuffler		\
	"

VnmrJPgsqlLinux2Tar=" \
        -C $vcommondir           pgsql.lnx/bin		\
        -C $vcommondir           pgsql.lnx/lib		\
        -C $vcommondir           pgsql.lnx/share		\
	-C $vcommondir/bin	create_pgsql_user	\
	-C $vcommondir		shuffler		\
	"

VnmrJ2Tar=" \
        -C $vcommondir/vnmrj     maclib			\
        -C $vcommondir           menujlib			\
	"

InovaVnmrJTempl2Tar="                                   \
        -C $vcommondir           templates_inova/vnmrj	\
	"

VnmrJTempl2Tar=" \
        -C $vcommondir           templates/layout		\
        -C $vcommondir           templates/vnmrj		\
	"

VnmrJProperties2Tar=" \
        -C $vcommondir/xml     cmdResources.properties          \
        -C $vcommondir/xml     paramResources.properties        \
        -C $vcommondir/xml     filename_templates        \
        -C $vcommondir/xml     studyname_templates        \
        -C $vcommondir/xml     recConfig        \
        "
VJMolJar2Tar=" \
	-C $sourcedir/sysvnmrj              jmol.jar			\
        -C $sourcedir/sysvnmrj              vjmol.jar			\
	"
VJChemPaintJar2Tar=" \
	-C $vcommondir                      jchempaint.jar		\
	"
Walkup2Tar=" \
        -C $vcommondir/WALKUP	walkup		\
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
	bin/protune		\
        "

#
# PART XI --- Options 
#
# -- Glide files to tar

GlideText2Tar="			\
	glide/vnmrmenu		\
	glide/adm		\
	glide/def		\
	glide/exp		\
	glide/templates		\
	"

# --- glide.tar 
GlideBin2Tar="
	bin/gadm		\
	"
Dialog2Tar="		\
	dialoglib	\
	"

GlidepackText2Tar="                 \
        glidepack/vnmrmenu          \
        glidepack/adm               \
        glidepack/def               \
        glidepack/cp_uninstall      \
        glidepack/exp               \
        glidepack/templates         \
        "

GlidepackBin2Tar="
        bin/glide               \
        bin/gadm                \
        bin/Probe_edit          \
        "

#--- directories from PFG common to inova, unity go into tar file
# common pfg.tar
ComPFG2Tar="			\
	parlib			\
	maclib			\
	manual			\
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
	gHMQC		\
	gHMQC_d2		\
	gHMQCTOXY	\
	gHSQC		\
	gHSQC_d2		\
	gHSQCAD		\
	gHSQCTOXY	\
	gXHCAL		\
	gcosy		\
	ghmqc		\
	ghmqcps		\
	ghsqc		\
	gmqcosy		\
	gnoesy		\
	gtnnoesy		\
	gtnroesy		\
	hsqcHT		\
	p2pul		\
	profile		\
	selexHT		\
	tocsyHT		\
	wetgcosy		\
	wetghmqc		\
	wetghmqcps	\
	wetghsqc		\
	wetgmqcosyps	\
	wet1D	\
	wet1d	\
	wetNOESY		\
	wetROESY		\
	wetTOCSY		\
	wetgCOSY		\
	wetgDQCOSY	\
	wetgHMBC		\
	wetgHMQC		\
	wetgHSQC		\
	"

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

# ------ GNU C Compiler Files files  ---------------
# gnu.tar 
#               gnu/cygnus-sol2-2.0
GNU4Solaris2Tar="		\
        gnu			\
	"

#--- directories from Image common to go into tar file
# uimage.tar
#ComImage2Tar="			\
#	imaging			\
#	parlib			\
#	maclib			\
#	manual			\
#	psglib			\
#	"

#---- Image binaries for unity/inova
# --- uimage.tar 
#uBinImage2Tar="bin/eccsend	\
#	bin/eccTool		\
#	-C $vcommondir/tape_sol app-defaults/EccTool	\
#	seqlib/center		\
#	seqlib/cssibn		\
#	seqlib/cssish		\
#	seqlib/ecc		\
#	seqlib/gsh2Dpul		\
#	seqlib/gsh2pul		\
#	seqlib/mslicer		\
#	seqlib/zap		\
#	"


#--- directories from IMAGE common to go into tar file
# image.tar
ComIMAGE2Tar="			\
	CoilTable		\
	fidlib			\
	help			\
	maclib			\
	menulib			\
	nuctables		\
	psglib			\
	pulsecal		\
	shapelib		\
	tablib			\
	vnmrmenu		\
	imaging			\
	bin			\
	-C tape_sol user_templates	\
	-C $vcommondir/tape_sol app-defaults/EccTool	\
	"

#--- directories from IMAGE unique to Inova to go in tar file
InovaIMAGE2Tar="			\
	imaging_inova		\
	parlib_inova		\
	"

#-- directories from IMAGE2 for HEI sequences
ComIMAGE22Tar="			\
	maclib			\
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
SeqIMAGE2Tar="			\
	seqlib/GDACtest		\
	seqlib/angio		\
	seqlib/ct3d		\
	seqlib/ecc1		\
	seqlib/epidw		\
	seqlib/epimss		\
	seqlib/epimssn		\
	seqlib/fastestmap	\
	seqlib/fse3d		\
	seqlib/fsems		\
	seqlib/ge3d		\
	seqlib/ge3dangio	\
	seqlib/ge3dshim		\
	seqlib/gsh2pul		\
	seqlib/isis		\
	seqlib/mems		\
	seqlib/prescanfreq	\
	seqlib/press		\
	seqlib/presscsi		\
	seqlib/pressi		\
	seqlib/sems		\
	seqlib/semsdw		\
	seqlib/se3d		\
	seqlib/spuls		\
	"

#removed because of patent issues
#	seqlib/gems		\
#	seqlib/steam		\
#	seqlib/steami		\

UserLib2Tar="			\
	userlib			\
	"

#
# PART XII --- Passworded options 
#
Diffus2Tar="			\
	maclib			\
	manual			\
	parlib			\
	psglib			\
	"

DiffusSeq2Tar="			\
	seqlib/g2pulramp	\
	seqlib/pge		\
	seqlib/pgeramp		\
	"

DOSY_PS_2Tar="			\
	Dbppste	\
	Dbppste_cc	\
	Dbppsteinept	\
	DgcsteSL	\
	DgcsteSL_cc	\
	DgsteSL_cc	\
	Dgcstecosy	\
	Dgcstehmqc		\
	Doneshot		\
	"

LCNMR2Tar="			\
	lc			\
	maclib			\
	manual			\
	menulib			\
	parlib			\
	shapelib		\
	tablib			\
	user_templates		\
	"

LCNMR_PS_2Tar="                 \
	lc1d                    \
	"

GILSONSeq2Tar="			\
	seqlib/vast1d		\
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
	psglib			\
	"

BinBackproj2Tar="		\
	bp_2d		\
	bp_3d		\
	bp_ball		\
	bp_mc		\
	bp_sort		\
	"

ComCSI2Tar="		\
	manual		\
	parlib			\
	maclib			\
	imaging			\
	-C tape_sol user_templates	\
	"

BinCSI2Tar="		\
	bin/csi		\
	bin/P_csi	\
	"

Fdm2Tar="			\
	fidlib			\
	manual			\
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
	bin			\
	imaging			\
	maclib			\
	parlib			\
        psglib/gems_2003-12-30.c \
	psglib/gems.c_2003-12-30	\
	"

InovaImagePatentFiles="		\
	imaging_inova		\
	parlib_inova		\
	"

PATENT_PS_2Tar="                \
        gemsshim                \
        gems              \
        steamcsi                \
        steami                 \
        "

#
# PART XVI --- Installation files and scripts
#
LoadFiles="				\
		loadcd			\
		setup			\
		i_vnmr4			\
		readme.txt		\
		"

LoadDecodeBin="				\
		ejectthecdrom		\
		decode.sol		\
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
#  indent to proper place
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
   
# test for director, file, executable file
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

#---------------------------------------------------------------------------
set_size_name()
{
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
#This routine is the combination of set_size_name() and make_toc()
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
        systemname=`basename $i .sol`
        systemname=`basename $systemname .rht`
        nnl_echo "`basename $systemname` "  | tee -a $log_fln
        #nnl_echo " "  | tee -a $log_fln
     done
     rm -rf $dest_dir_code/tmp/*
   )
}

#---------------------------------------------------------------------------
make_toc_no_rm()
{
   ( dir=$1
     shift
     cat=$1
     shift
     cd $dest_dir_code/$dir
     for i in $*
     do
       echo "$cat	$tarFileSize	$Code/$dir/$tarFileName" >> $dest_dir_code/$i
       systemname=`basename $i .sol`
       systemname=`basename $systemname .rht`
       nnl_echo "`basename $systemname` "  | tee -a $log_fln
     done
   )
}

#---------------------------------------------------------------------------
make_toc()
{
   ( dir=$1
     shift
     cat=$1
     shift
     cd $dest_dir_code/$dir
     for i in $*
     do
       echo "$cat	$tarFileSize	$Code/$dir/$tarFileName" >> $dest_dir_code/$i
       systemname=`basename $i .sol`
       systemname=`basename $systemname .rht`
       nnl_echo "`basename $systemname` "  | tee -a $log_fln
     done

     rm -rf $dest_dir_code/tmp/*
   )
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
            echo -n "$*"
        fi
    fi
}

log_this(){

   if [ ! -d $dest_dir_code/tmp ]
   then
       mkdir -p $dest_dir_code/tmp
   else
       rm -rf $dest_dir_code/tmp/*
   fi

   echo "" | tee -a $log_fln
   echo "" | tee -a $log_fln
   nnl_echo " $1 " | tee -a $log_fln
}

#---------------------------------------------------------------------------
# Routine to remove core files
findcore() {
   find . -name core -exec rm {} \;
}
#-- MAIN Main main----------------------------------------------------------
# Greetings and Salutations
#

LoadVnmrJ="n"
LoadP11="n"
if [ $# = 1 ]
then
   case x$1 in
	xVJ | xvj )

   		LoadFilesDir="/vnmrcd/cdimageVJ/cdrom"
   		DefaultDestDir="/vnmrcd/cdimageVJ"
#   		DefaultFiniDir=`date '+/rdvnmr/.vjisup%m.%d'`
   		DefaultFiniDir=`date '+/rdvnmr/.cdromVJ%m.%d'`
   		DefaultLogFln="/vnmrcd/cdoutlogVJ"
   		RevFileName="vnmrj"
   		VnmrRevId=$VNMRJ_REV_ID
		LoadVnmrJ="y"
	;;

	xP11 | xp11 ) 
 
   		LoadFilesDir="/vnmrcd/cdimageP11/cdrom"
   		DefaultDestDir="/vnmrcd/cdimageP11"
   		DefaultFiniDir=`date '+/rdvnmr/.cdromP11%m.%d'`
   		DefaultLogFln="/vnmrcd/cdoutlogP11"
   		RevFileName="vnmrp11"
   		VnmrRevId=$VNMRJ_REV_ID

		LoadP11="y"
		LoadVnmrJ="y"
	;;

	xlocal ) 
                PWD=`pwd` 
   		LoadFilesDir="$PWD/vnmrcd/cdrom"
   		DefaultDestDir="$PWD/vnmrcd/cdimage"
   		DefaultFiniDir=`date '+$PWD/vnmrcd/cdrom%m.%d'`
   		DefaultLogFln="$PWD/vnmrcd/CDOUTlog"
   		RevFileName="vnmrj"
   		VnmrRevId=$VNMRJ_REV_ID

		LoadP11="y"
		LoadVnmrJ="y"
	;;

	xtest ) 
                PWD=`pwd` 
   		LoadFilesDir="$PWD/cdrom"
   		DefaultDestDir="$PWD/cdimage"
   		DefaultFiniDir="none"
   		DefaultLogFln="$PWD/CDOUTlog"
   		RevFileName="vnmrj"
   		VnmrRevId=$VNMRJ_REV_ID

		LoadP11="y"
		LoadVnmrJ="y"
	;;

	* )
   		LoadFilesDir="/vnmrcd/cdimage/cdrom"
   		DefaultDestDir="/vnmrcd/cdimage"
   		DefaultFiniDir=`date '+/rdvnmr/.vnmr61d%m.%d'`
   		DefaultLogFln="/vnmrcd/cdoutlog"
   		RevFileName="vnmr6.1"
   		VnmrRevId=$VNMR_REV_ID
	;;
   esac
fi


DefaultDasho="n"
DefaultMail="n"

if [ x`uname -s` = "xLinux" ]
then
    ostype="Linux"
    Encodedir="/vobj/lnx/proglib/bin"
    Convert="/usr/bin/convert"
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

echo "" 
echo `date`
if [ x$LoadVnmrJ="xy" ]
then
   echo "M a k i n g   V n m r J   C D R O M   F i l e s" 
else
   echo "M a k i n g   V N M R   C D R O M   F i l e s" 
fi
#
# ask for log filename
#
   umask 2
   echo "Use an absolute path for log !!"
   echo "This script changed directory many times"
   echo "And will write the log in that directory"
   nnl_echo "Enter destination file for log   [$DefaultLogFln]: "
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
   echo "Writing log to '$log_fln' file"
   echo ""
#
# Make nice heading in log file
#
echo ""  > $log_fln
echo `date` >> $log_fln
echo ""  >> $log_fln
echo "L o g   F o r   M a k i n g   C D R O M - I m a g e   F o r   V N M R"  >> $log_fln
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
   echo "Writing files to '$dest_dir'" | tee -a $log_fln
   echo ""
   dest_dir_code=$dest_dir/$Code



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
      echo "No Write to Finial Directory will be made. " | tee -a $log_fln
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
	    echo "Could not create Final Directory: $fini_dir, Aborting. " | tee -a $log_fln
	    exit 1
         fi
      fi
      echo "Writing results to Final Directory: $fini_dir "| tee -a $log_fln
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

# Ask about rebuilding tar files that don't change often

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
  nnl_echo "Rebuild tar file for gparxxx, etc [y]: "
  read gpar_answer
  if [ x$gpar_answer = "x" ]
  then
      gpar_answer="y"
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

  echo
  nnl_echo "Rebuild Gemini 2000 tar files [y]: "
  read gem_answer
  if [ x$gem_answer = "x" ]
  then
      gem_answer="y"
  fi

echo ""
echo "log_fln		= $log_fln +++++++++++++"
echo "dest_dir	= $dest_dir +++++++++++++"
echo "fini_dir	= $fini_dir +++++++++++++"
echo ""
echo "useDasho	= $useDasho +++++++++++++"
echo "notifySW	= $notifySW +++++++++++++"
echo "com_answer	= $com_answer +++++++++++++"
echo "par_answer	= $par_answer +++++++++++++"
echo "gpar_answer	= $gpar_answer +++++++++++++"
echo "gnu_answer	= $gnu_answer +++++++++++++"
echo "user_answer	= $user_answer +++++++++++++"
echo ""
echo "password_answ	= $password_answer +++++++++++++"
echo "gem_answer	= $gem_answer +++++++++++++"

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
      touch $file
   done
   cd $dest_dir_code/tmp
   rm -rf *
   echo "" | tee -a $log_fln
   echo "" | tee -a $log_fln
#============== COMMON FILES =============================================

echo ""
nnl_echo  "PART I -- COMMON FILES -- $dest_dir_code/$Common" | tee -a $log_fln
# Let's copy and tar the Common files and log it.
#
#-----------------------------------------------------
# tar some common text files into one tar file
   cd $vcommondir
   log_this " Tarring com.tar	  for: "
   tar -cf - $ComTarLst | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 644 ./*
   chmod 755 ./rc.vnmr
   chmod 755 ./acq
   setperms ./acq 755 644 755
#   chmod 644 ./acq/*
   chmod 666 ./acq/info
   cd $dest_dir_code/tmp
   tar cf $dest_dir_code/$Common/com.tar *
   make_TOC com.tar $Common "VNMR" sol/unity.sol	\
    			   sol/uplus.sol	\
    			   sol/g2000.sol	\
    			   sol/mercury.sol
   make_TOC com.tar $Common "VNMR" sol/inova.sol	\
    			   sol/mercvx.sol	\
    			   sol/mercplus.sol	\
    			   rht/mercplus.rht	\
    			   rht/inova.rht

#
#-----------------------------------------------------
# tar the common bin scripts into bin tar file
   cd $vcommondir
   log_this " Tarring combin.tar	  for: "

   if [ x$LoadP11 = "xy" ]
   then
       ComBinScripts2Tar=$ComBinScripts2Tar" "$P11BinScripts2Tar" "$P11Bin2Tar
   fi

   tar -cf - $ComBinScripts2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
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
   make_TOC combin.tar $Common "VNMR" sol/unity.sol	\
    			   sol/uplus.sol	\
    			   sol/g2000.sol	\
    			   sol/mercury.sol
   make_TOC combin.tar $Common "VNMR" sol/inova.sol	\
    			   sol/mercvx.sol	\
    			   sol/mercplus.sol	\
    			   rht/mercplus.rht	\
    			   rht/inova.rht

#
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
      log_this " Tarring $file	  for: "
      tar -cf - $file | (cd $dest_dir_code/tmp; tar xfBp -)
      cd $dest_dir_code/tmp
      chmod 755 ./$file
      setperms ./$file 755 644 755

      tar cf $dest_dir_code/$Common/$tarfile.tar $file
      make_TOC ${tarfile}.tar $Common "VNMR" sol/unity.sol	\
       			      		     sol/uplus.sol	\
       			      		     sol/g2000.sol	\
       			      		     sol/mercury.sol
      make_TOC ${tarfile}.tar $Common "VNMR" sol/inova.sol	\
       			      		     sol/mercvx.sol	\
       			      		     sol/mercplus.sol	\
    			      		     rht/mercplus.rht	\
    			      		     rht/inova.rht

    else

      log_this " Skipping $file		  for: "
      make_TOC ${tarfile}.tar $Common "VNMR" sol/unity.sol	\
       			      		     sol/uplus.sol	\
       			      		     sol/g2000.sol	\
       			      		     sol/mercury.sol
      make_TOC ${tarfile}.tar $Common "VNMR" sol/inova.sol	\
       			      		     sol/mercvx.sol	\
       			      		     sol/mercplus.sol	\
    			      		     rht/mercplus.rht	\
    			      		     rht/inova.rht

    fi
   done

   rm -rf $dest_dir_code/tmp/*

#
#---------------------------------------------------------------------------
#
   log_this " Tarring Gs files	  for: "
   cd $vcommondir
   tar -cf - $Gs2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755 gs
   setperms ./gs 755 644 755

   tar -cf $dest_dir_code/$Common/gs.tar *
   make_TOC gs.tar $Common "VNMR" sol/unity.sol	\
       			          sol/uplus.sol	\
       			          sol/g2000.sol	\
       			          sol/mercury.sol
   make_TOC gs.tar $Common "VNMR" sol/inova.sol	\
       			          sol/mercvx.sol	\
       			          sol/mercplus.sol

#---------------------------------------------------------------------------
   log_this " Tarring dialoglib        for: "

   cd $vcommondir
   tar -cf - $Dialog2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./dialoglib

   tar -cf $dest_dir_code/$Common/dialog.tar *
   make_TOC dialog.tar $Common "VNMR" sol/unity.sol	\
       			      	      sol/uplus.sol	\
       			      	      sol/g2000.sol	\
       			      	      sol/mercury.sol
   make_TOC dialog.tar $Common "VNMR" sol/inova.sol	\
       			      	      sol/mercvx.sol	\
       			      	      sol/mercplus.sol	\
    			      	      rht/mercplus.rht	\
    			      	      rht/inova.rht

#---------------------------------------------------------------------------
   log_this " Tarring Tcl files	  for: "

   cd $vcommondir
   tar -cf - $Tcl2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   cp $sourcedir/systcl/sol/spingen.tbc tcl/bin/spingen
   chmod 755 tcl
#     would replace down to the tar
   setperms ./tcl 755 644 755
   chmod 755 tcl/bin/*
   chmod 755 tcl/*library

   tar -cf $dest_dir_code/$Common/tcl.tar *
   make_TOC tcl.tar $Common "VNMR" sol/unity.sol	\
       			      	   sol/uplus.sol	\
       			      	   sol/g2000.sol	\
       			      	   sol/mercury.sol
   make_TOC tcl.tar $Common "VNMR" sol/inova.sol	\
       			      	   sol/mercvx.sol	\
       			      	   sol/mercplus.sol

#---------------------------------------------------------------------------
   log_this " Tarring Linux Tcl files   for: "

   cd $vcommondir
   tar -cf - $Tcl2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   rm -f tcl/bin/vnmr* tcl/bin/spingen tcl/bin/tclsh
   (cd tcl/bin; ln -s /usr/bin/tclsh tclsh)
   cp $lnxproglib_dir/tcl/spingen.tbc tcl/bin/spingen
   cp $lnxproglib_dir/tcl/vnmrwish tcl/bin/vnmrwish
   (cd tcl/bin; ln vnmrwish vnmrWish)
   setperms ./tcl 755 644 755
   chmod -f 755 tcl/bin/*
   chmod 755 tcl/*library
                                                                                                             
   tar -cf $dest_dir_code/$Linux/tcllnx.tar *
   make_TOC tcllnx.tar $Linux "VNMR" rht/mercplus.rht	\
   				     rht/inova.rht

#---------------------------------------------------------------------------
# tar fiddle examples files
   cd $vcommondir/fiddle
   log_this " Tarring fiddle files     for: "
   tar -cf - * | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755    ./fidlib ./manual
#	would replace the chmods
   setperms	./fidlib 755 644 755
   setperms	./manual 755 644 755

   tar -cf $dest_dir_code/$Common/fiddle.tar *
   make_TOC fiddle.tar $Common "Fiddle_Example" sol/unity.sol	\
       			      	     		sol/uplus.sol	\
       			      	     		sol/g2000.sol	\
       			      	     		sol/mercury.sol
   make_TOC fiddle.tar $Common "Fiddle_Example" sol/inova.sol	\
       			      	     		sol/mercvx.sol	\
       			      	     		sol/mercplus.sol	\
    			      	     		rht/mercplus.rht	\
    			      	     		rht/inova.rht

#
#============== UNITY INOVA FILES ==================================
echo "" | tee -a $log_fln
echo ""
nnl_echo "PART II -- UNITY/INOVA FILES -- $dest_dir_code/$Common" | tee -a $log_fln
#
#---------------------------------------------------------------------------
# The parameter files are tarred
# par200,par300,par400,par500,par600,par750 and parlib.
# They are stored in /vcommon/upar

  if [ x$par_answer = "xy" ]
  then

   cd $vcommondir
   log_this " Tarring parameter files  for: "
   cp -rp $ComPar2Tar $dest_dir_code/tmp
   cd $dest_dir_code/tmp
   pars=`ls -d par???`

   for file in $pars
   do
     chmod 755 ./$file
     setperms ./$file 755 644 755
   done

   tar cf $dest_dir_code/$Common/params.tar *

   echo "" >> $log_fln
   nnl_echo "tarring: " >> $log_fln
   ls -CF $dest_dir_code/tmp >> $log_fln
   echo "" >> $log_fln
   nnl_echo "in UNITY : " >> $log_fln
   ls -CF $dest_dir_code/tmp >> $log_fln

   make_TOC params.tar $Common "VNMR" sol/unity.sol	\
    				      sol/uplus.sol
   make_TOC params.tar $Common "VNMR" sol/inova.sol	\
    				      rht/inova.rht

  else

   log_this " Skipping parXXX file	  for: "
   make_TOC params.tar $Common "VNMR" sol/unity.sol	\
    				      sol/uplus.sol
   make_TOC params.tar $Common "VNMR" sol/inova.sol	\
    				      rht/inova.rht

  fi
#
#---------------------------------------------------------------------
# tar some common directories straight from source
   cd $vcommondir/Pbox
   echo "" | tee -a $log_fln
   nnl_echo " Tarring wavelib and help for : " | tee -a $log_fln
   tar -cf - $Pbox2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   setperms ./wavelib 755 644 755
   setperms ./help 755 644 755
   tar cf $dest_dir_code/$Common/wavelib.tar *
   set_size_name $Common wavelib.tar
   make_toc $Common "VNMR" sol/unity.sol	\
   			   sol/uplus.sol
   make_toc $Common "VNMR" sol/inova.sol	\
    			   rht/inova.rht

#---------------------------------------------------------------------
# Pbox, tar some common directories straight from source

   cd $vcommondir
   for file in $uComDirs2Tar
   do
      log_this " Tarring $file            for : "

      cd $vcommondir
      tar -cf - $file | (cd $dest_dir_code/tmp; tar xfBp -)
      cd $dest_dir_code/tmp
      setperms ./$file 755 644 755
      if [ x$file = "xshapelib" ]
      then
         chmod  644 shapelib/.Pbox_defaults
      fi
      tar cf $dest_dir_code/$Common/$file.tar $file
      set_size_name $Common $file.tar
      make_toc $Common "VNMR" sol/unity.sol	\
   			      sol/uplus.sol
      make_toc $Common "VNMR" sol/inova.sol	\
    			      rht/inova.rht
   done
 
#---------------------------------------------------------------------
# tar psglib
   log_this " Tarring Inova psglib files   for : "

   mkdir -p $dest_dir_code/tmp/psglib
   cd $solproglib_dir/psglib
   for cfile in $PS_2Tar
   do
        cp -p $cfile.c $dest_dir_code/tmp/psglib
   done
   cd $dest_dir_code/tmp
   chmod 755   ./psglib
   chmod 644   ./psglib/*
   tar cf $dest_dir_code/$Inova/psglib.tar *
   make_TOC psglib.tar $Inova "VNMR" sol/inova.sol	\
    			             rht/inova.rht

#---------------------------------------------------------------------
# tar psglib to psg
   log_this " Tarring Unity psglib files    for : "
   cd $dest_dir_code/tmp
   mkdir psglib
   (cd $sol53common; cp -rp psglib/*.c $dest_dir_code/tmp/psglib)
   chmod 755   ./psglib
   chmod 644   ./psglib/*
   tar cf $dest_dir_code/$Unity/psglib.tar *
   make_TOC psglib.tar $Unity "VNMR" sol/unity.sol	\
   		 		     sol/uplus.sol
#
#============== UNITY INOVA G2000 FILES ==============================
echo "" | tee -a $log_fln
echo  ""
nnl_echo "PART III -- UNITY/INOVA/G2000 FILES -- $dest_dir_code/$Solaris" | tee -a $log_fln
#
#---------------------------------------------------------------------
# tar some common directories straight from source
   cd $solobjdir
   log_this " Tarring bin.tar  for : "
   tar -cf - $BinFiles2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./bin
   tar -cf $dest_dir_code/$Solaris/bin.tar bin
   make_TOC bin.tar $Solaris "VNMR" sol/unity.sol	\
   				    sol/uplus.sol	\
   				    sol/g2000.sol	\
   				    sol/mercury.sol
   make_TOC bin.tar $Solaris "VNMR" sol/inova.sol	\
   				    sol/mercvx.sol	\
   				    sol/mercplus.sol

#---------------------------------------------------------------------
   log_this " Tarring binlnx.tar  for :"

   cd $lnxproglib_dir
   tar -cf - $BinFilesLinux2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv Infostat bin
   chmod -R 755 ./bin
   tar -cf $dest_dir_code/$Linux/binlnx.tar bin
   make_TOC binlnx.tar $Linux "VNMR" rht/mercplus.rht	\
				     rht/inova.rht

#---------------------------------------------------------------------
# tar some common directories straight from source
   log_this " Tarring tcllib.tar    for : "

   cd $solobjdir
   tar -cf - $TclLibs2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod    755 ./lib
   chmod    644 ./lib/*
   tar -cf $dest_dir_code/$Solaris/tcllib.tar lib
   make_TOC tcllib.tar $Solaris "VNMR" sol/unity.sol	\
   			   		 sol/uplus.sol	\
   			   		 sol/g2000.sol	\
   			   		 sol/mercury.sol
   make_TOC tcllib.tar $Solaris "VNMR" sol/inova.sol	\
   			   		 sol/mercvx.sol	\
   			   		 sol/mercplus.sol

#-----------------------------------------------------
#
   log_this " Tarring Linux Tcl libs   for : "
   tar -cf - $TclLibsLinux2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   (cd lib; ln -s libBLT24.so libBLT.so)
   mkdir app-defaults
   cp $vcommondir/tape_sol/app-defaults/Enter app-defaults
   chmod 644 app-defaults/Enter
   chmod  -R  755 ./lib
   tar -cf $dest_dir_code/$Linux/tclliblnx.tar *
   make_TOC tclliblnx.tar $Linux "VNMR" rht/mercplus.rht	\
				        rht/inova.rht

#-----------------------------------------------------
# tar the common bin scripts into bin tar file
   cd $vcommondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring unibin.tar	  for : " | tee -a $log_fln
   tar -cf - $UniBinScripts2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./bin
   tar cf $dest_dir_code/$Solaris/unibin.tar bin
   set_size_name $Solaris unibin.tar
   make_toc $Solaris "VNMR" sol/unity.sol	\
   			    sol/uplus.sol	\
   			    sol/g2000.sol	\
   			    sol/mercury.sol
   make_toc $Solaris "VNMR" sol/inova.sol	\
   			    sol/mercvx.sol	\
   			    rht/mercplus.rht	\
   			    rht/inova.rht	\
   			    sol/mercplus.sol
#
#---------------------------------------------------------------------
# tar some common directories straight from source
   echo ""
   echo ""
   echo "ENV solobjdir= $solobjdir ----------------------------------------"
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring binx.tar	  for : " | tee -a $log_fln
   tar -cf - $BinX2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./bin
   chmod 755	./app-defaults
   chmod 644	./app-defaults/*
   tar -cf $dest_dir_code/$Solaris/binx.tar *
   set_size_name $Solaris binx.tar
   make_toc $Solaris "VNMR" sol/unity.sol	\
   			    sol/uplus.sol	\
   			    sol/g2000.sol	\
   			    sol/mercury.sol
   make_toc $Solaris "VNMR" sol/inova.sol	\
   			    sol/mercvx.sol	\
   			    sol/mercplus.sol
#
#---------------------------------------------------------------------------
# just to get vnmrwish
   cd $solobjdir/proglib/tcl
   echo "" | tee -a $log_fln
   nnl_echo " Tarring TclMore files    for : " | tee -a $log_fln
   mkdir -p $dest_dir_code/tmp/tcl/bin
   cp $TclMore $dest_dir_code/tmp/tcl/bin/
   cd $dest_dir_code/tmp
   chmod -R 755  tcl
   (cd tcl/bin; ln vnmrwish vnmrWish)
   tar -cf $dest_dir_code/$Solaris/tcl2.tar *
   set_size_name $Solaris tcl2.tar
   make_toc $Solaris "VNMR" sol/unity.sol	\
   			    sol/uplus.sol	\
   			    sol/g2000.sol	\
   			    sol/mercury.sol
   make_toc $Solaris "VNMR" sol/inova.sol	\
   			    sol/mercvx.sol	\
   			    sol/mercplus.sol
 
#---------------------------------------------------------------------------
#  Accounting scripts and executable 
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Accounting files for : " | tee -a $log_fln
   tar -cf - $Acct2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 adm
   chmod 777 adm/tmp
   tar -cf $dest_dir_code/$Solaris/adm.tar *
   make_TOC adm.tar $Solaris "VNMR" sol/unity.sol	\
   				    sol/uplus.sol	\
   				    sol/g2000.sol	\
   				    sol/mercury.sol
   make_TOC adm.tar $Solaris "VNMR" sol/unity.sol	\
   				    sol/inova.sol	\
   				    sol/mercvx.sol	\
   				    sol/mercplus.sol

#---------------------------------------------------------------------------
#Linux: Accounting scripts and executable
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Linux Accounting files for : " | tee -a $log_fln
   tar -cf - $Acct2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   cp $lnxproglib_dir/accounting/console_login adm/bin
   chmod -R 755 adm
   chmod 777 adm/tmp
   tar -cf $dest_dir_code/$Linux/adm.tar *
   make_TOC adm.tar $Linux "VNMR" rht/mercplus.rht	\
				  rht/inova.rht

#---------------------------------------------------------------------------
#  
   cd $vcommondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Admin files for :      " | tee -a $log_fln
   tar -cf - $AdminFiles2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mkdir -p adm/users/operators
   mkdir -p adm/users/profiles
   chmod -R 755 adm
   chmod 644 automation.conf
   chmod 644 protocolListWalkup.xml
   chmod 644 rightsList.xml
   mv automation.conf adm/users/operators
   mv protocolListWalkup.xml adm/users/
   mv rightsList.xml adm/users/
   tar -cf $dest_dir_code/$Solaris/admfiles.tar *
   make_TOC admfiles.tar $Solaris "VNMR" sol/inova.sol	\
				    sol/mercvx.sol	\
   				    sol/mercplus.sol	\
   				    rht/mercplus.rht	\
   				    rht/inova.rht

#---------------------------------------------------------------------------
# tar some common text files into one tar file
   cd $vcommondir/tape_sol
   log_this " Tarring templ.tar	  for : "
   tar -cf - $UserTempl2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   setperms ./user_templates 755 644 755
   cd ./user_templates
   rm -f .login.lnx .vnmrenv.lnx
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
   if [ x$loadVnmrJ != "xy" ]
   then
      make_TOC templ.tar $Solaris "VNMR"   sol/unity.sol	\
   			    		sol/uplus.sol	\
   			    		sol/g2000.sol	\
   			    		sol/mercury.sol
   fi
   make_TOC templ.tar $Solaris "VNMR"   sol/inova.sol \
   			    		sol/mercvx.sol	\
   			    		sol/mercplus.sol

#---------------------------------------------------------------------------
#Linux
   cd $vcommondir/tape_sol
   log_this " Tarring Linux templ.tar	  for : "
   tar -cf - $UserTempl2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   setperms ./user_templates 755 644 755
   cd user_templates
   rm -f .dtprofile .openwin-init .openwin-menu .login .cshrc .xinitrc .xlogin .Xdefaults
   mv -f .vnmrenv.lnx .vnmrenv
   mv -f .vnmrenvsh.lnx .vnmrenvsh
   mv -f .login.lnx .login

   cd ..
   tar cf $dest_dir_code/$Linux/templ.tar *
   make_TOC templ.tar $Linux "VNMR" rht/mercplus.rht	\
				    rht/inova.rht

#---------------------------------------------------------------------------
# tar Gmap help, maclib, manual and menulib files
   cd $vcommondir/Gmap
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Gmap Text	  for : " | tee -a $log_fln
   tar -cf - $GmapText2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755	./help
   chmod 644	./help/*
   chmod 755    ./maclib
   chmod 644    ./maclib/*
   chmod 755    ./manual
   chmod 644    ./manual/*
   chmod 755    ./menulib
   chmod 644    ./menulib/*
   tar -cf $dest_dir_code/$Gmap/gmaptext.pwd *
   set_size_name $Gmap gmaptext.pwd
   make_toc $Gmap "Gradient_shim" sol/unity.sol		\
   			          sol/uplus.sol		\
   			          sol/g2000.sol		\
   			          sol/mercury.sol
   make_toc $Gmap "Gradient_shim" sol/inova.sol		\
   			          sol/mercvx.sol	\
   			          rht/mercplus.rht	\
   			          rht/inova.rht		\
   			          sol/mercplus.sol
#
#---------------------------------------------------------------------------
# tar Gmap parlib psglib files
   cd $vcommondir/Gmap
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Gmap par/psglib  for " | tee -a $log_fln
   tar -cf - $GmapPars2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755    ./parlib
   setperms ./parlib 755 644 755
   setperms ./psglib 755 644 755
   tar -cf $dest_dir_code/$Gmap/gmappars.pwd *
   set_size_name $Gmap gmappars.pwd
   make_toc $Gmap "Gradient_shim" sol/unity.sol		\
   			          sol/uplus.sol		\
   			          sol/g2000.sol		\
   			          sol/mercury.sol
   make_toc $Gmap "Gradient_shim" sol/inova.sol		\
   			          sol/mercvx.sol	\
   			          rht/mercplus.rht	\
   			          rht/inova.rht		\
   			          sol/mercplus.sol

#---------------------------------------------------------------------------
# tar Protune maclib, manual, templates and tune files
   cd $vcommondir/Protune
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Protune Text	  for : " | tee -a $log_fln
   tar -cf - $ProtuneText2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755    ./maclib
   chmod 644    ./maclib/*
   chmod 755    ./manual
   chmod 644    ./manual/*
   setperms     ./templates 755 644 755
   setperms     ./tune 755 644 755
   tar -cf $dest_dir_code/$Common/protune.tar *
   set_size_name $Common protune.tar
   make_toc $Common "VNMR"     sol/inova.sol		\
   			          sol/mercplus.sol	\
   			          rht/inova.rht		\
   			          rht/mercplus.rht

#---------------------------------------------------------------------
# tar the motif libraryes UNITY seqlib 
   cd $vcommondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring motif.tar 2.5.1  for : " | tee -a $log_fln
   tar -cf - lib | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755   ./lib
   chmod 755   ./lib/*
   tar -cf $dest_dir_code/$Unity/motif.tar *
   set_size_name $Unity motif.tar
   make_toc $Unity "VNMR" sol/unity.sol		\
   		          sol/uplus.sol		\
   		          sol/g2000.sol		\
   		          sol/mercury.sol
   make_toc $Unity "VNMR" sol/inova.sol		\
   		          sol/mercvx.sol	\
   		          sol/mercplus.sol
#
#============== UNITY INOVA FILES ====================================
echo "" | tee -a $log_fln
echo ""
nnl_echo "PART IV -- UNITY/INOVA FILES -- $dest_dir_code/$Unity/$Inova" | tee -a $log_fln
#
#---------------------------------------------------------------------------
# binaries for Pbox on UNITYs
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Pbox bin          for : " | tee -a $log_fln
   tar -cf - $PboxBin2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   setperms ./bin 755 644 755
   tar cf $dest_dir_code/$Unity/pboxbin.tar *
   set_size_name $Unity pboxbin.tar
   make_toc $Unity "VNMR" sol/unity.sol		\
   		          sol/uplus.sol		\
   		          sol/mercury.sol
   make_toc $Unity "VNMR" sol/inova.sol		\
   		          sol/mercvx.sol	\
   		          sol/mercplus.sol
 
#---------------------------------------------------------------------
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Wobbler files	  for : " | tee -a $log_fln
   cd $vcommondir
   tar -cf - $WobbleText | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $solobjdir
   tar -cf - $WobbleExec | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755 ./tune
   setperms ./tune 755 644 755
   setperms ./app-defaults 755 644 755
   tar -cf $dest_dir_code/$Unity/$Inova/wobbler.tar *
   set_size_name $Unity/$Inova wobbler.tar
   make_toc $Unity/$Inova "VNMR" sol/inova.sol	\
    				 sol/mercvx.sol	\
    				 sol/mercplus.sol
   make_toc $Unity/$Inova "VNMR" sol/unity.sol	\
    				 sol/uplus.sol
   
#============== UNITY GEMINI 2000 FILES  ===================================
echo "" | tee -a $log_fln
echo ""
nnl_echo "PART V -- UNITY/G2000 FILES -- $dest_dir_code/$Unity/$Gemini" | tee -a $log_fln
#
#---------------------------------------------------------------------------
   cd $dest_dir_code/tmp; mkdir lib
   cd $solobjdir/proglib/vnmr/
   echo "" | tee -a $log_fln
   nnl_echo " Tarring acqcomm library  for : " | tee -a $log_fln
   tar -cf - $uLibs2Tar | (cd $dest_dir_code/tmp/lib; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755 ./lib/lib*.so*
   chmod 644 ./lib/lib*.a
   tar -cf $dest_dir_code/$Unity/$Gemini/libs.tar lib
   set_size_name $Unity/$Gemini libs.tar
   make_toc $Unity/$Gemini "VNMR" sol/unity.sol
   make_toc $Unity/$Gemini "VNMR" sol/uplus.sol
   make_toc $Unity/$Gemini "VNMR" sol/g2000.sol
   make_toc $Unity/$Gemini "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
 
#============== UNITY FILES =========================================
echo "" | tee -a $log_fln
echo ""
nnl_echo "PART VI -- UNITY FILES -- $dest_dir_code/$Unity" | tee -a $log_fln
#
#---------------------------------------------------------------------
# tar psg to psg
   echo "" | tee -a $log_fln
   nnl_echo " Tarring psg files	  for : " | tee -a $log_fln
   (cd $sol53common; cp -rp psg $dest_dir_code/tmp)
   cd $dest_dir_code/tmp
   cp $sol53common/../common/syspsg/seqgenmake ./psg/.
   chmod 755   ./psg
   chmod 644   ./psg/*
   tar cf $dest_dir_code/$Unity/psg.tar *
   set_size_name $Unity psg.tar
   make_toc $Unity "VNMR" sol/unity.sol
   make_toc $Unity "VNMR" sol/uplus.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------
# tar libpsg 
   cd $sol53objdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring psg objects	  for : " | tee -a $log_fln
   tar -cf - $BinPsg2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv psg lib
   chmod 755   ./lib
   chmod 755   ./lib/*
   chmod 644   ./lib/x_ps.o
   tar -cf $dest_dir_code/$Unity/libpsg.tar lib
   set_size_name $Unity libpsg.tar
   make_toc $Unity "VNMR" sol/unity.sol
   make_toc $Unity "VNMR" sol/uplus.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------
# tar the standard UNITY seqlib 
   cd $sol53objdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring seqlib.tar	  for : " | tee -a $log_fln
   tar -cf - $BinSeq2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755	./seqlib
   tar -cf $dest_dir_code/$Unity/seqlib.tar *
   set_size_name $Unity seqlib.tar
   make_toc $Unity "VNMR" sol/unity.sol
   make_toc $Unity "VNMR" sol/uplus.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar the kernal SCSI driver part
   cd $solobjdir/proglib/kernel_solaris
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Kernel driver	  for : " | tee -a $log_fln
   mkdir $dest_dir_code/tmp/solkernel
   cp -rp $Kernels2Move $dest_dir_code/tmp/solkernel
   cd $dest_dir_code/tmp
   chmod 755 ./solkernel
   chmod 644 ./solkernel/*
   tar -cf $dest_dir_code/$Unity/kernel.tar solkernel
   set_size_name $Unity kernel.tar
   make_toc $Unity "VNMR" sol/unity.sol
   make_toc $Unity "VNMR" sol/uplus.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------
# tar acqbin and binstuff
   cd $sol53objdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring acqbin.tar	  for : " | tee -a $log_fln
   mkdir $dest_dir_code/tmp/acqbin
   mkdir $dest_dir_code/tmp/bin
   tar -cf - $BinAcq2Tar | (cd $dest_dir_code/tmp; tar xfBp - )
   cd $dest_dir_code/tmp
   mv ./bin/iadisplay ./bin/uiadisplay
   mv ./bin/vconfig ./bin/uconfig
   mv ./acqbin/Acqproc ./acqbin/uAcqproc
   cd bin
   ln -s uiadisplay iadisplay
   ln -s uconfig vconfig
   ln -s usetacq setacq
   cd ../acqbin
   ln -s uAcqproc Acqproc
   cd ..
   chmod -R 755 ./acqbin
   chmod -R 755 ./bin
   chmod 755	./app-defaults
   chmod 644	./app-defaults/*
   tar -cf $dest_dir_code/$Unity/acqbin.tar *
   set_size_name $Unity acqbin.tar
   make_toc $Unity "VNMR" sol/unity.sol
   make_toc $Unity "VNMR" sol/uplus.sol
   rm -rf $dest_dir_code/tmp/bin $dest_dir_code/tmp/acqbin
#
#---------------------------------------------------------------------
# tar the common acq scripts into bin tar file ---------
#	for 53 archive common dirs are in sol53 directory
   cd $sol53common
   echo "" | tee -a $log_fln
   nnl_echo " Tarring acq.tar	  for :  " | tee -a $log_fln
   tar -cf - $AcqTarLst | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755   ./acq
   chmod 644   ./acq/*
   tar cf $dest_dir_code/$Unity/acq.tar *
   set_size_name $Unity acq.tar
   make_toc $Unity "VNMR" sol/unity.sol
   make_toc $Unity "VNMR" sol/uplus.sol
   rm -rf $dest_dir_code/tmp/*

#============== GEMINI 2000 FILES ===================================
echo "" | tee -a $log_fln
echo ""
nnl_echo "PART VII -- GEMINI 2000 FILES -- $dest_dir_code/$Gemini" | tee -a $log_fln
#
#---------------------------------------------------------------------------
# tar the gpar* files into one tar file
  if [ x$gpar_answer = "xy" ]
  then

   cd $vcommondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring parameter files  for :  " | tee -a $log_fln
   cp -rp $gPar2Tar $dest_dir_code/tmp
   cd $dest_dir_code/tmp
 pars=`ls -d par???`
 for file in $pars
 do
   chmod 755 ./$file
   setperms ./$file 755 644 755
 done

   tar cf $dest_dir_code/$Gemini/gpar.tar *
   set_size_name $Gemini gpar.tar
   make_toc $Gemini "VNMR" sol/g2000.sol
   make_toc $Gemini "VNMR" sol/mercury.sol
   make_toc $Gemini "VNMR" sol/mercvx.sol
   make_toc $Gemini "VNMR" sol/mercplus.sol
   make_toc $Gemini "VNMR" rht/mercplus.rht
   rm -rf $dest_dir_code/tmp/*

  else

   echo "" | tee -a $log_fln
   nnl_echo " Skipping gparXXX file	  for :  " | tee -a $log_fln
   set_size_name $Gemini gpar.tar
   make_toc $Gemini "VNMR" sol/g2000.sol
   make_toc $Gemini "VNMR" sol/mercury.sol
   make_toc $Gemini "VNMR" sol/mercvx.sol
   make_toc $Gemini "VNMR" sol/mercplus.sol
   make_toc $Gemini "VNMR" rht/mercplus.rht

  fi

#
#---------------------------------------------------------------------
# tar psg to gpsg
   echo "" | tee -a $log_fln
  if [ x$gem_answer = "xy" ]
  then

   nnl_echo " Tarring gpsg files	  for :  " | tee -a $log_fln
   (cd $vcommondir; cp -rp gpsg $dest_dir_code/tmp/psg)
   cd $dest_dir_code/tmp
   cp $sourcedir/syspsg/seqgenmake ./psg/.
   chmod 755   ./psg
   setperms ./psg 755 644 755
#   chmod 755   ./psg
#   chmod 644   ./psg/*
   tar cf $dest_dir_code/$Gemini/psg.tar *
   set_size_name $Gemini psg.tar
   make_toc $Gemini "VNMR" sol/g2000.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------
# tar psglib to gpsg
   cd $dest_dir_code/tmp
   echo "" | tee -a $log_fln
   nnl_echo " Tarring gpsglib files	  for :  " | tee -a $log_fln
   (cd $vcommondir; cp -rp gpsglib $dest_dir_code/tmp/psglib)
   chmod 755   ./psglib
   chmod 644   ./psglib/*
   tar cf $dest_dir_code/$Gemini/psglib.tar *
   set_size_name $Gemini psglib.tar
   make_toc $Gemini "VNMR" sol/g2000.sol
   make_toc $Gemini "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar the gemini acq scripts into bin tar file
   cd $vcommondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring gacq.tar	  for :  " | tee -a $log_fln
   tar -cf - $gAcqTarLst | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755    ./acq
   chmod 644    ./acq/*
   tar cf $dest_dir_code/$Gemini/gacq.tar *
   set_size_name $Gemini gacq.tar
   make_toc $Gemini "VNMR" sol/g2000.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar the gemini acqbin into bin tar file
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring gacqbin.tar	  for :  " | tee -a $log_fln
   mkdir $dest_dir_code/tmp/acqbin
   mkdir $dest_dir_code/tmp/bin
   tar -cf - $gBinAcq2Tar | (cd $dest_dir_code/tmp; tar xfBp - )
   cd $dest_dir_code/tmp
   cd bin
   ln -s giadisplay iadisplay
   ln -s gsetacq setacq
   cd ../acqbin
   ln -s gAcqproc Acqproc
   cd ..
   chmod -R 755   ./acqbin
   chmod -R 755   ./bin
   chmod 755	./app-defaults
   chmod 644	./app-defaults/*
   tar -cf $dest_dir_code/$Gemini/gacqbin.tar *
   set_size_name $Gemini gacqbin.tar
   make_toc $Gemini "VNMR" sol/g2000.sol
   make_toc $Gemini "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/bin $dest_dir_code/tmp/acqbin
 
#---------------------------------------------------------------------------
# tar the gpsg* files into one tar file
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring gpsg Objects	  for :  " | tee -a $log_fln
   tar -cf - $gBinPsg2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv gpsg lib
   chmod 755   ./lib
   chmod 755   ./lib/*
   chmod 644   ./lib/x_ps.o
   cd bin
   ln -s gconfig vconfig
   cd ..
   chmod -R 755   ./bin
   tar -cf $dest_dir_code/$Gemini/gpsglibs.tar lib bin
   set_size_name $Gemini gpsglibs.tar
   make_toc $Gemini "VNMR" sol/g2000.sol
   rm -rf $dest_dir_code/tmp/*
 
#---------------------------------------------------------------------------
# tar the gemini seqlib
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring gseqlib.tar	  for :  " | tee -a $log_fln
   tar -cf - $gBinSeq2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv gseqlib seqlib
   chmod 755   ./seqlib
   chmod 755   ./seqlib/*
   tar -cf $dest_dir_code/$Gemini/gseqlib.tar *
   set_size_name $Gemini gseqlib.tar
   make_toc $Gemini "VNMR" sol/g2000.sol
   make_toc $Gemini "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*


  else

   echo "" | tee -a $log_fln
   nnl_echo " Skipping gpsg files	  for :  " | tee -a $log_fln
   set_size_name $Gemini psg.tar
   make_toc $Gemini "VNMR" sol/g2000.sol

   echo "" | tee -a $log_fln
   nnl_echo " Skipping gpsglib files	  for :  " | tee -a $log_fln
   set_size_name $Gemini psglib.tar
   make_toc $Gemini "VNMR" sol/g2000.sol
   make_toc $Gemini "VNMR" sol/mercury.sol

   echo "" | tee -a $log_fln
   nnl_echo " Skipping gacq.tar	  for :  " | tee -a $log_fln
   set_size_name $Gemini gacq.tar
   make_toc $Gemini "VNMR" sol/g2000.sol

   echo "" | tee -a $log_fln
   nnl_echo " Skipping gacqbin.tar	  for :  " | tee -a $log_fln
   set_size_name $Gemini gacqbin.tar
   make_toc $Gemini "VNMR" sol/g2000.sol
   make_toc $Gemini "VNMR" sol/mercury.sol

   echo "" | tee -a $log_fln
   nnl_echo " Skipping gpsg Objects	  for :  " | tee -a $log_fln
   set_size_name $Gemini gpsglibs.tar
   make_toc $Gemini "VNMR" sol/g2000.sol

   echo "" | tee -a $log_fln
   nnl_echo " Skipping gseqlib.tar	  for :  " | tee -a $log_fln
   set_size_name $Gemini gseqlib.tar
   make_toc $Gemini "VNMR" sol/g2000.sol
   make_toc $Gemini "VNMR" sol/mercury.sol

   echo "" | tee -a $log_fln


  fi
#
#============== MERCURY FILES ========================================
echo "" | tee -a $log_fln
echo ""
nnl_echo "PART VIIb -- MERCURY FILES -- $dest_dir_code/$Mercury" | tee -a $log_fln
 
#---------------------------------------------------------------------------
   log_this " Tarring Pbox files     for : "

   cd $vcommondir/kPbox
   tar -cf - $kPbox2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   setperms ./help     755 644 755
   setperms ./shapelib 755 644 755
   setperms ./wavelib  755 644 755
   tar cf $dest_dir_code/$Mercury/kpbox.tar *
   make_TOC kpbox.tar $Mercury "VNMR" sol/mercury.sol \
                                        sol/mercvx.sol \
                                        sol/mercplus.sol \
                                        rht/mercplus.rht
 
#---------------------------------------------------------------------------
# tar kpsg to psg
   log_this " Tarring kpsg files     for : "

   (cd $vcommondir; cp -rp kpsg $dest_dir_code/tmp/psg)
   cd $dest_dir_code/tmp
   cp $sourcedir/syspsg/seqgenmake ./psg/.
   chmod 755   ./psg
   chmod 644   ./psg/*
   tar cf $dest_dir_code/$Mercury/psg.tar *
   make_TOC psg.tar $Mercury "VNMR" sol/mercury.sol \
                                        sol/mercvx.sol \
                                        sol/mercplus.sol

#---------------------------------------------------------------------------
# Linux:  kpsg files to /vnmr/psg Mercury +
   log_this "Linux,  Tarring kpsg files     for : "

   (cd $vcommondir; cp -rp kpsg $dest_dir_code/tmp/psg)
   cd $dest_dir_code/tmp
   cp $sourcedir/syspsg/seqgenmake ./psg/.
   rm -f ./psg/makeuserpsg
   (cd ./psg;  sccs -p/vsccs/sccs/kpsg/SCCS get makeuserpsg.lnx 2>&1 >/dev/null)
   chmod 755   ./psg
   chmod 644   ./psg/*
   tar cf $dest_dir_code/$Linux/kpsg.tar *
   make_TOC kpsg.tar $Linux "VNMR" rht/mercplus.rht
 
#---------------------------------------------------------------------------
# tar the kpsg* files into one tar file
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring kpsg Objects	  for :  " | tee -a $log_fln
   tar -cf - $kBinPsg2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv kpsg lib
   chmod 755   ./lib
   chmod 755   ./lib/*
   chmod 644   ./lib/x_ps.o
   cd bin
   ln -s kconfig vconfig
   ln -s mqtune_data qtune_data
   cd ..
   chmod -R 755   ./bin
   tar -cf $dest_dir_code/$Mercury/kpsglibs.tar lib bin
   set_size_name $Mercury kpsglibs.tar
   make_toc $Mercury "VNMR" sol/mercury.sol
   make_toc $Mercury "VNMR" sol/mercvx.sol
   make_toc $Mercury "VNMR" sol/mercplus.sol
   rm -rf $dest_dir_code/tmp/*

#
#-----------------------------------------------------
# tar the mercury bin scripts into bin tar file
   cd $vcommondir
   log_this " Tarring mercbin.tar	  for: "

   tar -cf - $mercBinScripts2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp

   chmod -R 755 ./bin
   tar cf $dest_dir_code/$Mvx/mercbin.tar *
   set_size_name $Mvx mercbin.tar
   make_TOC mercbin.tar $Mvx "VNMR" sol/mercvx.sol
   make_TOC mercbin.tar $Mvx "VNMR" sol/mercplus.sol

#---------------------------------------------------------------------------
#Linux: kpsg libraries into /vnmr/lib directory

   cd $lnxproglib_dir
   log_this " Tarring Linux kpsg libraries     for : "
   tar -cf - $kBinPsgLinux2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv kpsg lib
   chmod -R 755   ./lib
   chmod 644      ./lib/x_ps.o
   tar -cf $dest_dir_code/$Linux/psglibs.tar lib
   make_TOC psglibs.tar $Linux "VNMR" rht/mercplus.rht

#---------------------------------------------------------------------
#Linux: kpsglib to /vnmr/psglib and kseqlib to /vnmr/seqlib

#   cd $lnxproglib_dir
#   log_this " Tarring kpsglib and kseqlib files     for : "
#   tar -cf - kpsglib kseqlib | (cd $dest_dir_code/tmp; tar xfBp -)
#   cd $dest_dir_code/tmp
#   mv kpsglib psglib
#   mv kseqlib seqlib
#   rm -f psglib/makek*
#   rm -f seqlib/makek* seqlib/errms*
#   chmod -R 755   ./seqlib
#   chmod 755      ./psglib
#   chmod 644      ./psglib/*
#   tar cf $dest_dir_code/$Linux/psgseqlib.tar *
#   make_TOC psgseqlib.tar $Linux "VNMR"  rht/mercplus.rht


#---------------------------------------------------------------------------
#Linux: psg C files library for Mercury +
   log_this "Linux, Tarring kpsgclib.tar     for : "

   mkdir -p $dest_dir_code/tmp/psglib
   cd $lnxproglib_dir/kpsglib
   for cfile in $kBinSeq2Tar
   do
        cp `echo $cfile | awk 'BEGIN {FS="/"} {print $2}'`.c $dest_dir_code/tmp/psglib
   done

   cd $dest_dir_code/tmp
   setperms psglib 755 644 755
   tar -cf $dest_dir_code/$Linux/kpsgclib.tar psglib
   make_TOC kpsgclib.tar $Linux "VNMR" rht/mercplus.rht

#---------------------------------------------------------------------------
#Linux:   Mercury + seqlib
   log_this "Linux, Tarring kseqlib.tar     for : "
   cd $lnxproglib_dir
   tar -cf - $kBinSeq2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv kseqlib seqlib
   chmod -R 755   ./seqlib

   tar -cf $dest_dir_code/$Linux/kseqlib.tar *
   make_TOC kseqlib.tar $Linux "VNMR" rht/mercplus.rht

#---------------------------------------------------------------------
# tar kpsglib 
   cd $dest_dir_code/tmp
   log_this " Tarring psglib.tar     for : "
   (cd $vcommondir; cp -rp kpsglib $dest_dir_code/tmp/psglib)
   chmod 755   ./psglib
   chmod 644   ./psglib/*
   tar cf $dest_dir_code/$Mercury/psglib.tar *
   make_TOC psglib.tar $Mercury "VNMR" sol/mercury.sol \
					sol/mercvx.sol \
					sol/mercplus.sol

#---------------------------------------------------------------------------
# tar the additional seqlib for mercury 
   cd $solobjdir
   log_this " Tarring kseqlib.tar     for : "
   tar -cf - $kBinSeq2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv kseqlib seqlib
   chmod 755   ./seqlib
   chmod 755   ./seqlib/*

   tar -cf $dest_dir_code/$Mercury/kseqlib.tar *
   make_TOC kseqlib.tar $Mercury "VNMR" sol/mercury.sol \
					sol/mercvx.sol \
					sol/mercplus.sol
 
#---------------------------------------------------------------------------
# tar the mercury acq scripts into bin tar file
   cd $vcommondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring kacq.tar	  for :  " | tee -a $log_fln
   tar -cf - $kAcqTarLst | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755    ./acq
   chmod 644    ./acq/*
   mv ./acq/kapmon ./acq/apmon
   tar cf $dest_dir_code/$Mercury/kacq.tar *
   set_size_name $Mercury kacq.tar
   make_toc $Mercury "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
 
#---------------------------------------------------------------------------
#
   cd $vcommondir
   log_this " Tarring vxWorks     for : "
   tar -cf - $kVx2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./acq
   chmod 644    ./acq/vxBoot.big/*.sym
   cd acq
   mv ./kvxBoot.small  ./vxBoot.small
   ln -s vxBoot.small vxBoot
   cd ..
   tar -cf $dest_dir_code/$Mercury/vxworks.tar acq
   make_TOC vxworks.tar $Mercury "VNMR" sol/mercvx.sol \
                                        sol/mercplus.sol \
                                        rht/mercplus.rht
 
#---------------------------------------------------------------------------
   cd $vcommondir
   log_this " Tarring VxWorks' objects     for : "
   tar -cf - $kVxObj2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv ./acq/kvwhdobj.o ./acq/vxBoot.big/vwhdobj.o
   mv ./acq/kvwlibs.o  ./acq/vxBoot.big/vwlibs.o
   mv ./acq/kvwtasks.o ./acq/vxBoot.big/vwtasks.o
   setperms ./acq/vxBoot.big 755 644 755
   tar -cf $dest_dir_code/$Mercury/vxobjs.tar acq
   make_TOC vxobjs.tar $Mercury "VNMR"  sol/mercvx.sol \
                                        sol/mercplus.sol \
                                        rht/mercplus.rht
 
#---------------------------------------------------------------------------
   cd $vcommondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring CP/MAS template  for :  " | tee -a $log_fln
   tar -cf - $kCPMAStemplate | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   tar -cf $dest_dir_code/$Mercury/cpmas.tar *
   set_size_name $Mercury cpmas.tar
   make_toc $Mercury "VNMR" sol/mercvx.sol
   make_toc $Mercury "VNMR" sol/mercplus.sol
   rm -rf $dest_dir_code/tmp/*
#

#============== INOVA FILES ========================================
echo "" | tee -a $log_fln
echo ""
nnl_echo "PART VIII -- INOVA FILES -- $dest_dir_code/$Inova" | tee -a $log_fln
#
#---------------------------------------------------------------------
# tar psg to psg
   echo "" | tee -a $log_fln
   nnl_echo " Tarring psg files	  for :  " | tee -a $log_fln
   (cd $vcommondir; cp -rp psg $dest_dir_code/tmp)
   cd $dest_dir_code/tmp
   cp $sourcedir/syspsg/seqgenmake ./psg/.
   chmod 755   ./psg
   chmod 644   ./psg/*
   tar cf $dest_dir_code/$Inova/psg.tar *
   set_size_name $Inova psg.tar
   make_toc $Inova "VNMR" sol/inova.sol
   rm -rf $dest_dir_code/tmp/*
 
#---------------------------------------------------------------------
# Linux:   Psg files
   log_this " Tarring Linux Psg files     for : "
   (cd $vcommondir; cp -rp psg $dest_dir_code/tmp)
   cd $dest_dir_code/tmp
   cp $sourcedir/syspsg/seqgenmake ./psg/.
   chmod 755   ./psg
   chmod 644   ./psg/*
   tar cf $dest_dir_code/$Linux/psg.tar *
   make_TOC psg.tar $Linux "VNMR" rht/inova.rht    

#---------------------------------------------------------------------
# tar psg libs
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring psg objects         for :  " | tee -a $log_fln
   tar -cf - $BinPsg2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv psg lib
   chmod 755   ./lib
   chmod 755   ./lib/*
   chmod 644   ./lib/x_ps.o
   tar -cf $dest_dir_code/$Inova/libpsg.tar lib
   set_size_name $Inova libpsg.tar
   make_toc $Inova "VNMR" sol/inova.sol
   rm -rf $dest_dir_code/tmp/*
 
#---------------------------------------------------------------------
# Linux:  Psg libraries
   cd $lnxproglib_dir
   echo
   echo "lnxproglib_dir= $lnxproglib_dir"
   pwd
   log_this " Tarring Linux Psg libraries     for : "
   tar -cf - $BinPsgLinux2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv psg lib
   chmod -R 755 ./lib
   chmod 644    ./lib/x_ps.o

   tar -cf $dest_dir_code/$Linux/libpsg.tar lib
   make_TOC libpsg.tar $Linux "VNMR" rht/inova.rht    

 
#---------------------------------------------------------------------
# tar the standard INOVA seqlib 
   log_this "   Tarring seqlib		for : "

   mkdir -p $dest_dir_code/tmp/seqlib
   cd $solproglib_dir/seqlib
   for cfile in $PS_2Tar
   do
        cp -p $cfile $dest_dir_code/tmp/seqlib
   done
   cd $dest_dir_code/tmp
   chmod -R 755   ./seqlib
   tar -cf $dest_dir_code/$Inova/seqlib.tar *
   make_TOC seqlib.tar $Inova "VNMR" sol/inova.sol
 
   log_this "   Tarring Linux seqlib.tar		for : "
   mkdir -p $dest_dir_code/tmp/seqlib
   cd $lnxproglib_dir/seqlib
   for cfile in $PS_2Tar
   do
      cp $cfile $dest_dir_code/tmp/seqlib
   done
   cd $dest_dir_code/tmp
   chmod -R 755   ./seqlib
   tar -cf $dest_dir_code/$Linux/seqlib.tar *
   make_TOC seqlib.tar $Linux "VNMR" rht/inova.rht
#---------------------------------------------------------------------------
   cd $solobjdir
   log_this " Tarring acqbin   for: "
   tar -cf - $ProcFam | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp/bin
   cp  $vcommondir/bin/isetacq .
   cp  $vcommondir/bin/slimSetacq .
   cp  $solobjdir/bin/showconsole .
   ln -s iiadisplay iadisplay
   ln -s isetacq setacq
   cd $dest_dir_code/tmp
   chmod 755    ./acq
   chmod 644    ./acq/*
   chmod -R 755 ./acqbin
   chmod -R 755 ./bin
   chmod 755	./app-defaults
   chmod 644	./app-defaults/*
   mv ./acqbin/nAutoproc ./acqbin/Autoproc
   tar -cf $dest_dir_code/$Inova/acqbin.tar *
   make_TOC acqbin.tar $Inova "VNMR" sol/inova.sol \
   				     sol/mercvx.sol \
    				     sol/mercplus.sol

#---------------------------------------------------------------------------
   cd $solobjdir
   log_this " Tarring Acqbin part 2    for: "
   tar -cf - $iProcFam | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp/bin
   cp $sourcedir/systcl/sol/spincad.tbc spincad
   chmod 755 spincad
   ln -s iqtune_data qtune_data
   cd $dest_dir_code/tmp
   chmod 755    ./acq
   chmod 644    ./acq/*
   chmod -R 755 ./bin
   chmod 755    ./app-defaults
   chmod 644    ./app-defaults/*
   setperms ./spincad 755 644 755
   tar -cf $dest_dir_code/$Inova/acqbin2.tar *
   make_TOC acqbin2.tar $Inova "VNMR" sol/inova.sol

#---------------------------------------------------------------------------
#Linux: 
   cd $solobjdir
   log_this " Tarring acqbin part 2    for: "
   tar -cf - $iProcLinuxFam | (cd $dest_dir_code/tmp; tar xfBp -)
   mkdir -p $dest_dir_code/tmp/bin
   (cd $dest_dir_code/tmp/bin
    cp $lnxproglib_dir/tcl/spincad.tbc spincad
    cp $vcommondir/bin/lsetacq .
    chmod 755 spincad lsetacq
    ln -s lsetacq setacq
   )
   cd $dest_dir_code/tmp
   (cd ./acq; sccs -p/vsccs/sccs/bootpd/SCCS get bootptab 2>&1 >/dev/null)
   mkdir acqbin
   mv Atproc Autoproc Expproc Infoproc Procproc Recvproc Roboproc Sendproc \
	acqbin
   chmod -R 755 acqbin
   chmod 755    ./acq
   chmod 644    ./acq/*
   chmod -R 755 ./bin
   setperms ./spincad 755 644 755
   tar -cf $dest_dir_code/$Linux/acqbinlnx.tar *
   make_TOC acqbinlnx.tar $Linux "VNMR" rht/mercplus.rht	\
					rht/inova.rht
 
#---------------------------------------------------------------------------
#Java Runtime Environment common to both JPSG and VNMRJ

   rm -rf $dest_dir_code/jre $dest_dir_code/jre.linux
   if [ x$LoadVnmrJ = "xy" ]
   then
       mkdir $dest_dir_code/jre
       (cd /vcommon/JRE; tar -cf - * | (cd $dest_dir_code/jre; tar xfBp -))
       mkdir $dest_dir_code/jre.linux
       (cd /vcommon/JRE.linux; tar -cf - * | (cd $dest_dir_code/jre.linux; tar xfBp -))
   fi

   log_this " Tarring Solaris JRE 1.4          for: "
   cd $dest_dir_code/tmp
   mkdir jre
   (cd /vcommon/JRE; tar -cf - * | (cd $dest_dir_code/tmp/jre; tar xfBp -))
   tar cf $dest_dir_code/$Inova/jre.tar jre

   #the real file is a directory,  code/jre
   make_TOC  jre   ""   "VNMR"    sol/inova.sol		\
			  	  sol/mercvx.sol	\
			  	  sol/mercplus.sol

   #odd ball, just want to get the size of tar file info to TOC, don't want the actual file
   rm $dest_dir_code/$Inova/jre.tar

#Linux,
   log_this "Linux, Tarring JRE 1.4          for: "

   cd $dest_dir_code/tmp
   mkdir jre
   (cd /vcommon/JRE.linux; tar -cf - * | (cd $dest_dir_code/tmp/jre; tar xfBp -))
   tar cf $dest_dir_code/$Linux/jre.tar jre

   #the real file is a directory,  code/jre.linux
   make_TOC jre.linux "" "VNMR" rht/mercplus.rht  \
				rht/inova.rht

   #odd ball, just want to get the size of tar file info to TOC, don't want the actual file
   rm $dest_dir_code/$Linux/jre.tar


#---------------------------------------------------------------------------
#JPSG

    log_this " Tarring JPSG stuff	  for: "
    cd $dest_dir_code/tmp
    mkdir jpsg
    tar -cf - $Jpsg2Tar | (cd $dest_dir_code/tmp/jpsg; tar xfBp -)
    cd $dest_dir_code/tmp
    setperms ./ 755 644 755
    chmod 755 ./jpsg/Jpsg
    tar -cf $dest_dir_code/$Inova/jpsg.tar jpsg
    make_TOC jpsg.tar $Inova "VNMR" sol/inova.sol \
      				    rht/inova.rht

#---------------------------------------------------------------------------
# start VJ Sections
#    set -x
#---------------------------------------------------------------------------
# VJ Section 1
if [ x$LoadVnmrJ = "xy" ]
then
   log_this " Tarring VJ jar	  for: "
   cd $dest_dir_code/tmp
   mkdir java
   mkdir lib
   tar -cf - $VnmrJJar2Tar | (cd $dest_dir_code/tmp/java; tar xfBp -)
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
   make_TOC vnmrj.tar $Inova "VNMR" sol/inova.sol	\
      				    sol/mercvx.sol	\
      				    sol/mercplus.sol

   #Linux stuffs
   log_this "Linux, Tarring VJ jar	  for: "
   cd $dest_dir_code/tmp
   mkdir java
   tar -cf - $VnmrJJarLinux2Tar | (cd $dest_dir_code/tmp/java; tar xfBp -)
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
   make_TOC vnmrj.tar $Linux "VNMR" rht/mercplus.rht	\
				    rht/inova.rht
fi

#---------------------------------------------------------------------------
# VJ Section 2
     if [ x$LoadVnmrJ = "xy" ]
     then
        echo "" | tee -a $log_fln
        nnl_echo "  Tarring VJ admin jar	  for :  " | tee -a $log_fln
        cd $dest_dir_code/tmp
        mkdir java
        tar -cf - $VnmrJAdmJar2Tar | (cd $dest_dir_code/tmp/java; tar xfBp -)
# save VnmrAdmin.jar inside code, 
# so we do not have to untar this large file twice
	cp java/VnmrAdmin.jar $dest_dir_code
        setperms  ./java 755 644 755
        if [ $useDasho = "y" ]
        then
#	   delete vnmrj.jar and replace it with dasho jar
#set -x
	   rm -f $dest_dir_code/tmp/java/managedb.jar
	   mv $dest_dir_code/tmp/java/managedb.jar.dasho $dest_dir_code/tmp/java/managedb.jar
#set +x
        else
	   rm -f $dest_dir_code/tmp/java/managedb.jar.dasho
        fi
        tar -cf $dest_dir_code/$Inova/vnmrjadmjar.tar *
        set_size_name $Inova vnmrjadmjar.tar
        make_toc $Inova "VNMR" sol/inova.sol	\
        		       sol/mercvx.sol	\
        		       sol/mercplus.sol	\
        		       rht/mercplus.rht	\
        		       rht/inova.rht
     fi
#---------------------------------------------------------------------------
# VJ Section 3
     if [ x$LoadVnmrJ = "xy" ]
     then
        log_this " Tarring VJ bin		  for: "
        cd $dest_dir_code/tmp
        mkdir bin
        tar -cf - $VnmrJBin2Tar | (cd $dest_dir_code/tmp/bin; tar xfBp -)
        setperms  ./bin 755 644 555
        tar -cf $dest_dir_code/$Inova/vnmrjbin.tar *
        make_TOC vnmrjbin.tar $Inova "VNMR" sol/inova.sol	\
        		       sol/mercvx.sol	\
        		       sol/mercplus.sol	\
        		       rht/mercplus.rht	\
        		       rht/inova.rht
   
        #must be right after VnmrJBin2Tar so that Linux Vnmrbg will replace Solaris one
        log_this "Linux, Tarring VJ bin                 for: "
        cd $dest_dir_code/tmp
        mkdir bin
        tar -cf - $VnmrJBinLinux2Tar | (cd $dest_dir_code/tmp/bin; tar xfBp -)
        setperms  ./bin 755 644 555
        tar -cf $dest_dir_code/$Linux/vnmrjlnxbin.tar *
        make_TOC vnmrjlnxbin.tar $Linux "VNMR" rht/mercplus.rht	\
					       rht/inova.rht
     fi

#---------------------------------------------------------------------------
# VJ Section 4
     if [ x$LoadVnmrJ = "xy" ]
     then
        log_this " Tarring VJ postgres	  for: "
        cd $dest_dir_code/tmp
        tar -cf - $VnmrJPgsql2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
	mv create_pgsql_user pgsql/bin
        setperms ./shuffler 755 644 755
        tar -cf $dest_dir_code/$Inova/vnmrjpgsql.tar *
        make_TOC vnmrjpgsql.tar $Inova "VNMR" sol/inova.sol	\
        		       		      sol/mercvx.sol	\
        		       		      sol/mercplus.sol

        log_this "Linux, Tarring VJ postgres	  for: "
        cd $dest_dir_code/tmp
        tar -cf - $VnmrJPgsqlLinux2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
        mv pgsql.lnx pgsql
	mv create_pgsql_user pgsql/bin
        setperms ./shuffler 755 644 755
        tar -cf $dest_dir_code/$Inova/vnmrjpgsqllnx.tar *
        make_TOC vnmrjpgsqllnx.tar $Inova "VNMR" rht/mercplus.rht	\
						 rht/inova.rht
     fi
#---------------------------------------------------------------------------
# VJ Section 5
     if [ x$LoadVnmrJ = "xy" ]
     then
        log_this " Tarring VJ maclib	  for: "
        cd $dest_dir_code/tmp
        mkdir -p adm/users/profiles/data
        mkdir -p adm/users/profiles/templates
        mkdir -p adm/groups/profiles
        tar -cf - $VnmrJAdm2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
	mv userDefaults adm/users
	mv userlist.xml adm/users
	mv grouplist.xml adm/groups
        setperms ./adm/users 755 644 755
        setperms ./adm/groups 755 644 755
        tar -cf - $VnmrJ2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
        chmod 644 ./maclib/*
        chmod 644 ./menujlib/*

        tar -cf $dest_dir_code/$Inova/vnmrjtxt.tar *
        make_TOC vnmrjtxt.tar $Inova "VNMR" sol/inova.sol	\
        		       sol/mercvx.sol	\
        		       sol/mercplus.sol	\
        		       rht/mercplus.rht	\
        		       rht/inova.rht
     fi
#---------------------------------------------------------------------------
# VJ Section 6
     if [ x$LoadVnmrJ = "xy" ]
     then
        log_this " Tarring VJ templates	  for: "
        cd $dest_dir_code/tmp
        tar -cf - $VnmrJTempl2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
        tar -cf - $Walkup2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
        tar -cf - $VnmrJProperties2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
	mkdir -p templates/vnmrj/properties
	mv -f cmdResources.properties templates/vnmrj/properties
	mv -f paramResources.properties templates/vnmrj/properties
	mv -f recConfig templates/vnmrj/properties
	mv -f filename_templates templates/vnmrj/properties
	mv -f studyname_templates templates/vnmrj/properties

        if [ x$LoadP11 = "xy" ]
        then
            mkdir -p p11
            mkdir -p adm/p11
            touch adm/p11/sysListAll
            mkdir -p adm/users/profiles

            tar -cf - $P11Xml2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
            mv -f accPolicy                adm/users/profiles
            mv -f part11Config             p11
            mv -f AdminMenu.xml.p11        templates/vnmrj/interface/AdminMenu.xml
            mv -f MainMenu.xml.p11         templates/vnmrj/interface/MainMenu.xml
            mv -f MainMenuData.xml.p11     templates/vnmrj/interface/MainMenuData.xml
            mv -f MainMenuDisplay.xml.p11  templates/vnmrj/interface/MainMenuDisplay.xml
            mv -f MainMenuUtil.xml.p11     templates/vnmrj/interface/MainMenuUtil.xml
            mv -f DefaultToolBar.xml.p11   templates/vnmrj/interface/DefaultToolBar.xml
            mv -f audit.xml saveas.xml cmdHis.xml  templates/vnmrj/interface

            mv -f locator_statements_default.xml.walkup.p11     walkup/shuffler/locator_statements_default.xml
            mv -f MainMenu.xml.walkup.p11       walkup/templates/vnmrj/interface/MainMenu.xml
            mv -f MainMenuData.xml.walkup.p11   walkup/templates/vnmrj/interface/MainMenuData.xml
            setperms ./p11 755 644 755
        fi

        setperms  ./templates 755 644 755
        setperms  ./walkup 755 644 755
        tar -cf $dest_dir_code/$Inova/vnmrjtempl.tar *
        make_TOC vnmrjtempl.tar $Inova "VNMR"   sol/inova.sol	\
        				        sol/mercvx.sol	\
        				        sol/mercplus.sol\
        		     		 	rht/mercplus.rht	\
        		     		 	rht/inova.rht
     fi
#---------------------------------------------------------------------------
# VJ Section 7
     if [ x$LoadVnmrJ = "xy" ]
     then
        log_this " Tarring VJ iconlib	  for: "
        cd $dest_dir_code/tmp
        cp -r $vcommondir/iconlib/vnmrbg_iconlib iconlib
        chmod 644 ./iconlib/*
        tar -cf $dest_dir_code/$Inova/vnmrjicons.tar *
        make_TOC vnmrjicons.tar $Inova "VNMR" sol/inova.sol	\
        				       sol/mercvx.sol	\
        				       sol/mercplus.sol	\
        				       rht/mercplus.rht	\
        		     		 	rht/inova.rht
     fi
#---------------------------------------------------------------------------
# VJ Section 8
if [ x$LoadVnmrJ = "xy" ]
then
   log_this " Tarring VJMol jar	  for: "
   cd $dest_dir_code/tmp
   mkdir java
   tar -cf - $VJMolJar2Tar | (cd $dest_dir_code/tmp/java; tar xfBp -)
   setperms  ./java 755 644 755

   tar -cf $dest_dir_code/$Inova/vjmol.tar *
   make_TOC vjmol.tar $Inova "Jmol" rht/inova.rht	\
      				    rht/mercplus.rht	\
      				    sol/inova.sol	\
      				    sol/mercvx.sol	\
      				    sol/mercplus.sol
fi

#---------------------------------------------------------------------------
# VJ Section 9
if [ x$LoadVnmrJ = "xy" ]
then
   log_this " Tarring JChemPaint jar	  for: "
   cd $dest_dir_code/tmp
   mkdir java
   tar -cf - $VJChemPaintJar2Tar | (cd $dest_dir_code/tmp/java; tar xfBp -)
   setperms  ./java 755 644 755

   tar -cf $dest_dir_code/$Inova/jchempaint.tar *
   make_TOC jchempaint.tar $Inova "JChemPaint" rht/inova.rht	\
					    rht/mercplus.rht	\
					    sol/inova.sol	\
					    sol/mercvx.sol	\
					    sol/mercplus.sol
fi

#---------------------------------------------------------------------------
# VJ Section 10
if [ x$LoadVnmrJ = "xy" ]
then
   log_this " Tarring VJ Inova            for: "

   cd $dest_dir_code/tmp
   tar -cf - $InovaVnmrJTempl2Tar | (cd $dest_dir_code/tmp; tar xfBp -)

   mv templates_inova templates
   setperms  ./templates 755 644 755
   tar -cf $dest_dir_code/$Inova/inovavnmrjtempl.tar *
   if [ x$winbuild != "xtrue" ]
   then
      make_TOC inovavnmrjtempl.tar $Inova "VNMR"  sol/inova.sol  \
                                                 rht/inova.rht
   else
      make_TOC inovavnmrjtempl.tar $Inova "VNMR"  win/inova.win
   fi
fi

#---------------------------------------------------------------------------
#    set +x
# end VJ Sections
#---------------------------------------------------------------------------

   log_this " Tarring java cryo stuff for: "

   cd $dest_dir_code/tmp
   mkdir java
   tar -cf - $Cryo2Tar | (cd $dest_dir_code/tmp/java; tar xfBp -)
   chmod 755 java
   chmod 644 java/cryo.jar
   tar -cf $dest_dir_code/$Inova/cryo.tar java
   make_TOC cryo.tar $Inova "VNMR" sol/unity.sol	\
   				   sol/uplus.sol
   make_TOC cryo.tar $Inova "VNMR" sol/inova.sol	\
        		     	   rht/inova.rht

#---------------------------------------------------------------------------
   log_this " Tarring Jplot		for : "

   cd $solobjdir
   tar -cf - $Jplot2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   tar -cf $dest_dir_code/$Inova/java.tar java
   make_TOC java.tar $Inova "VNMR" sol/unity.sol	\
   				   sol/uplus.sol	\
   				   sol/g2000.sol	\
   				   sol/mercury.sol
   make_TOC java.tar $Inova "VNMR" sol/inova.sol	\
   				   sol/mercvx.sol	\
   				   sol/mercplus.sol	\
   				   rht/mercplus.rht	\
        		     	   rht/inova.rht

#---------------------------------------------------------------------------
   log_this " Tarring Apt		for : "

   cd $solobjdir
   tar -cf - $Apt2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   tar -cf $dest_dir_code/$Mvx/apt.tar java
   set_size_name $Mvx apt.tar
   make_TOC apt.tar $Mvx "VNMR" sol/mercvx.sol
   make_TOC apt.tar $Mvx "VNMR" sol/mercplus.sol

#---------------------------------------------------------------------------
   log_this " Tarring libraries	  for :  "

   cd $solobjdir/proglib
   tar -cf - $iLibs2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv ncomm lib
   mv dicom/* lib
   chmod 755 ./lib/lib*.so*
   chmod 644 ./lib/lib*.a
   chmod 644 ./lib/dicom.dic
   tar -cf $dest_dir_code/$Inova/libs.tar lib
   make_TOC libs.tar $Inova "VNMR" sol/inova.sol	\
   					sol/mercvx.sol	\
   					sol/mercplus.sol
 
#---------------------------------------------------------------------------
   log_this "Linux, Tarring NCOMM shared libraries	  for :  "

   cd $lnxproglib_dir
   tar -cf - $iLibsLinux2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv ncomm lib
   chmod 755 lib/lib*.so*
   tar -cf $dest_dir_code/$Linux/ncommlibs.tar lib
   make_TOC ncommlibs.tar $Linux "VNMR" rht/mercplus.rht	\
        		     		rht/inova.rht

#---------------------------------------------------------------------
   log_this " Tarring vxWorks.auto	  for: "

   cd $dest_dir_code/tmp
   mkdir acq
   mkdir acq/vxBoot.auto
   cp /sw/wind/target/config/inova_msr332/mts.vxWorks.auto acq/vxBoot.auto/.
   cp /sw/wind/target/config/inova_msr332/std.vxWorks.auto acq/vxBoot.auto/.
   chmod -R 755 ./acq
   tar -cf $dest_dir_code/$Inova/vxauto.tar acq
   make_TOC vxauto.tar $Inova "VNMR" sol/inova.sol \
                                     rht/inova.rht
 
#---------------------------------------------------------------------
   log_this " Tarring vxWorks	  for: "

   cd $vcommondir
   tar -cf - $iVx2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./acq
   chmod 644    ./acq/vxBoot.big/*.sym
   cd acq
   ln -s vxBoot.small/vxBoot vxBoot
   cd ..
   tar -cf $dest_dir_code/$Inova/vxworks.tar acq
   make_TOC vxworks.tar $Inova "VNMR"   sol/inova.sol	\
					rht/inova.rht
 
#---------------------------------------------------------------------------
   log_this " Tarring VxWorks' objects for: "

   cd $vcommondir
   tar -cf - $iVxObj2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 644    ./acq/vxBoot.big/*
   tar -cf $dest_dir_code/$Inova/vxobjs.tar acq
   make_TOC vxobjs.tar $Inova "VNMR"    sol/inova.sol	\
					rht/inova.rht

#---------------------------------------------------------------------
   log_this " Tarring vxWorksPPC  for: "

   cd $vcommondir
   tar -cf - $iVxPpc2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./acq
   chmod 644    ./acq/vxBootPPC.big/*.sym
   cd acq
   ln -s vxBoot.small    vxBoot
   ln -s vxBootPPC.small vxBootPPC
   cd ..
   tar -cf $dest_dir_code/$Inova/vxppc.tar acq
   make_TOC  vxppc.tar $Inova "VNMR" sol/inova.sol	\
				     rht/inova.rht

#---------------------------------------------------------------------------
   log_this " Tarring VxWorksPPC' objects for: "

   cd $vcommondir
   tar -cf - $iVxPpcObj2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 644    ./acq/vxBootPPC.big/*
   tar -cf $dest_dir_code/$Inova/vxppcobjs.tar acq
   make_TOC vxppcobjs.tar $Inova "VNMR" sol/inova.sol	\
					rht/inova.rht

 
#============== OPTION FILES ========================================
echo "" | tee -a $log_fln
echo ""
nnl_echo "PART XI -- OPTION FILES -- $dest_dir_code/\`option'" | tee -a $log_fln
##---------------------------------------------------------------------------
# Glide files, tar correct version to $dest_dir_code
   cd $vcommondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring GLIDE Text files for :  " | tee -a $log_fln
   tar -cf - $GlideText2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755 ./glide
   chmod 755 ./glide/*
   chmod 644 ./glide/*/*
   chmod 755 ./glide/exp/*
   chmod 644 ./glide/exp/*/*
   chmod 644 ./glide/vnmrmenu
   tar -cf $dest_dir_code/$Glide/glide.tar glide
   set_size_name $Glide glide.tar
   make_toc $Glide "GLIDE" sol/g2000.sol
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Glide Objects    for :  " | tee -a $log_fln
   tar -cf - $GlideBin2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./bin
   tar -cf $dest_dir_code/$Glide/$Solaris/glide.tar bin
   set_size_name $Glide/$Solaris glide.tar
   make_toc $Glide/$Solaris "GLIDE" sol/g2000.sol
   rm -rf $dest_dir_code/tmp/*
#---------------------------------------------------------------------------
# Glide files, tar correct version to $dest_dir_code
   cd $vcommondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring GLIDEPACK  files for :  " | tee -a $log_fln
   tar -cf - $GlidepackText2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv glidepack glide
   chmod 755 ./glide
   chmod 755 ./glide/*
   chmod 644 ./glide/*/*
   chmod 755 ./glide/exp/*
   chmod 644 ./glide/exp/*/*
   chmod 755 ./glide/cp_uninstall/*
   chmod 644 ./glide/cp_uninstall/*/*
   chmod 644 ./glide/vnmrmenu
   tar -cf $dest_dir_code/$Glidepack/glidetxt.tar *
   set_size_name $Glidepack glidetxt.tar
   make_toc $Glidepack "VNMR" sol/inova.sol
   make_toc $Glidepack "VNMR" sol/unity.sol
   make_toc $Glidepack "VNMR" sol/uplus.sol
   make_toc $Glidepack "VNMR" sol/mercplus.sol
   make_toc $Glidepack "VNMR" sol/mercvx.sol
   make_toc $Glidepack "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring GLIDEPACK Object for :  " | tee -a $log_fln
   tar -cf - $GlidepackBin2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./bin
   tar -cf $dest_dir_code/$Glidepack/glidebin.tar bin
   set_size_name $Glidepack glidebin.tar
   make_toc $Glidepack "VNMR" sol/inova.sol
   make_toc $Glidepack "VNMR" sol/unity.sol
   make_toc $Glidepack "VNMR" sol/uplus.sol
   make_toc $Glidepack "VNMR" sol/mercplus.sol
   make_toc $Glidepack "VNMR" sol/mercvx.sol
   make_toc $Glidepack "VNMR" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*
#---------------------------------------------------------------------------
# tar the PFG common files maclib, manual, psglib

   log_this " Tarring  PFG Text   for: "

   cd $vcommondir/PFG
   tar -cf - $ComPFG2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
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
   set_size_name $Pfg/$Common pfg.tar
   make_TOC pfg.tar $Pfg/$Common "PFG"  sol/unity.sol	\
    					sol/uplus.sol	\
    					sol/inova.sol	\
    					rht/inova.rht
 
#---------------------------------------------------------------------------
# tar the PFG seqlib
   echo "" | tee -a $log_fln
   nnl_echo " Tarring PFG Objects	  for :  " | tee -a $log_fln
   mkdir -p $dest_dir_code/tmp/seqlib
   cd $solproglib_dir/seqlib
   for cfile in $PFG_PS_2Tar
   do
      cp $cfile $dest_dir_code/tmp/seqlib
   done
   cd $dest_dir_code/tmp
   chmod 755   ./seqlib
   chmod 755   ./seqlib/*
   tar -cf $dest_dir_code/$Pfg/$Unity/pfgobj.tar *
   set_size_name $Pfg/$Unity pfgobj.tar
   make_toc $Pfg/$Unity "PFG" sol/unity.sol
   make_toc $Pfg/$Unity "PFG" sol/uplus.sol
   make_toc $Pfg/$Unity "PFG" sol/inova.sol
   rm -rf $dest_dir_code/tmp/*


#---------------------------------------------------------------------------
   log_this " Linux, Tarring PFG and PFGCP Objects         for :  "

   mkdir -p $dest_dir_code/tmp/seqlib
   cd $lnxproglib_dir/seqlib
   for cfile in $PFG_PS_2Tar
   do
      cp $cfile $dest_dir_code/tmp/seqlib
   done
   cd $dest_dir_code/tmp
   chmod -R 755   ./seqlib
   tar -cf $dest_dir_code/$Linux/pfgobj.tar *
   make_TOC pfgobj.tar $Linux "PFG" rht/inova.rht

#---------------------------------------------------------------------------
# tar the gPFG common files maclib, manual, psglib
   cd $vcommondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring gPFG Text	  for :  " | tee -a $log_fln
   cd gPFG
   tar -cf - $gComPFG2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755   ./parlib
   chmod 755   ./parlib/*
   chmod 644   ./parlib/*/*
   chmod 755   ./maclib
   chmod 644   ./maclib/*
   chmod 755   ./manual
   chmod 644   ./manual/*
   tar -cf $dest_dir_code/$Pfg/$Gemini/pfg.tar *
   set_size_name $Pfg/$Gemini pfg.tar
   make_toc $Pfg/$Gemini "PFG" sol/g2000.sol
   make_toc $Pfg/$Gemini "PFG" sol/mercury.sol
   make_toc $Pfg/$Gemini "PFG" sol/mercvx.sol
   make_toc $Pfg/$Gemini "PFG" sol/mercplus.sol
   make_toc $Pfg/$Gemini "PFG" rht/mercplus.rht
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar the gPFG seqlib
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring gPFG Objects	  for :  " | tee -a $log_fln
   tar -cf - $gBinPFG2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv gseqlib seqlib
   chmod 755   ./seqlib
   chmod 755   ./seqlib/*
   tar -cf $dest_dir_code/$Pfg/$Gemini/pfgobj.tar *
   set_size_name $Pfg/$Gemini pfgobj.tar
   make_toc $Pfg/$Gemini "PFG" sol/g2000.sol
   rm -rf $dest_dir_code/tmp/*
 
#---------------------------------------------------------------------------
# tar the kPFG seqlib
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring kPFG Objects	  for :  " | tee -a $log_fln
   tar -cf - $kBinPFG2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv kseqlib seqlib
   chmod 755   ./seqlib
   chmod 755   ./seqlib/*
   tar -cf $dest_dir_code/$Mvx/pfgobj.tar *
   set_size_name $Mvx pfgobj.tar
   make_toc $Mvx "PFG" sol/mercplus.sol
   make_toc $Mvx "PFG" sol/mercvx.sol
   make_toc $Mvx "PFG" sol/mercury.sol
   rm -rf $dest_dir_code/tmp/*

#cccccccc
#---------------------------------------------------------------------------
#Linux: the kPFG seqlib
   log_this " Tarring Linux kpfgseqlib.tar     for : "
                                                                                                 
   mkdir -p $dest_dir_code/tmp/seqlib
   cd $lnxproglib_dir
   for xfile in $kBinPFG2Tar
   do
        cp $xfile  $dest_dir_code/tmp/seqlib
   done
                                                                                                 
   cd $dest_dir_code/tmp
   setperms seqlib 755 644 755
   tar -cf $dest_dir_code/$Linux/kpfgseqlib.tar seqlib
   make_TOC kpfgseqlib.tar $Linux "PFG" rht/mercplus.rht

#---------------------------------------------------------------------------
#Linux: the kPFG psglib .c files
   log_this " Tarring Linux kpfgpsglib.tar     for : "
                                                                                                 
   mkdir -p $dest_dir_code/tmp/psglib
   cd $lnxproglib_dir/kpsglib
   for cfile in $kBinPFG2Tar
   do
        cp `echo $cfile | awk 'BEGIN {FS="/"} {print $2}'`.c $dest_dir_code/tmp/psglib
   done
                                                                                                 
   cd $dest_dir_code/tmp
   setperms psglib 755 644 755
   tar -cf $dest_dir_code/$Linux/kpfgpsglib.tar psglib
   make_TOC kpfgpsglib.tar $Linux "PFG" rht/mercplus.rht

#---------------------------------------------------------------------------
# tar the Sudo files

   echo "" | tee -a $log_fln
   nnl_echo " Tarring Sudo Files	  for :  " | tee -a $log_fln

   cd $vcommondir
   tar -cf $dest_dir_code/$Common/sudo.tar sudo
   set_size_name $Common sudo.tar
   make_toc $Common "VNMR" sol/mercvx.sol
   make_toc $Common "VNMR" sol/mercplus.sol
   make_toc $Common "VNMR" sol/inova.sol
#
#---------------------------------------------------------------------------
# tar the kermit files
   cd $vcommondir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Kermit Text	  for :  " | tee -a $log_fln
   tar -cf - $ComKermit2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755   ./kermit
   chmod 644   ./kermit/*
   tar cf $dest_dir_code/$Kermit/kermit.tar kermit
   set_size_name $Kermit kermit.tar
   make_toc $Kermit "Kermit" sol/unity.sol
   make_toc $Kermit "Kermit" sol/uplus.sol
   make_toc $Kermit "Kermit" sol/g2000.sol
   make_toc $Kermit "Kermit" sol/mercury.sol
   make_toc $Kermit "Kermit" sol/mercvx.sol
   make_toc $Kermit "Kermit" sol/mercplus.sol
   make_toc $Kermit "Kermit" sol/inova.sol
   rm -rf $dest_dir_code/tmp/*
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Kermit Objects	  for :  " | tee -a $log_fln
   cd $vcommondir
   tar -cf - $Bin4Kermit2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755   ./kermit
   tar -cf $dest_dir_code/$Kermit/$Solaris/kermit.tar kermit
   set_size_name $Kermit/$Solaris kermit.tar
   make_toc $Kermit/$Solaris "Kermit" sol/unity.sol
   make_toc $Kermit/$Solaris "Kermit" sol/uplus.sol
   make_toc $Kermit/$Solaris "Kermit" sol/g2000.sol
   make_toc $Kermit/$Solaris "Kermit" sol/mercury.sol
   make_toc $Kermit/$Solaris "Kermit" sol/mercvx.sol
   make_toc $Kermit/$Solaris "Kermit" sol/mercplus.sol
   make_toc $Kermit/$Solaris "Kermit" sol/inova.sol
   rm -rf $dest_dir_code/tmp/*
#
#---------------------------------------------------------------------------
# tar the GNU files

  if [ x$gnu_answer = "xy" ]
  then

   log_this " Tarring GNU Files	  for: "
   cd /vcommon
   tar -cf $dest_dir_code/$Gnu/gnu.tar $GNU4Solaris2Tar
   make_TOC gnu.tar $Gnu "GNU_Compiler" sol/unity.sol	\
   					sol/uplus.sol	\
   					sol/g2000.sol	\
   					sol/mercury.sol
   make_TOC gnu.tar $Gnu "GNU_Compiler" sol/inova.sol   \
   					sol/mercvx.sol	\
   					sol/mercplus.sol

 else

   log_this " Skipping GNU	  for: "
   make_TOC gnu.tar $Gnu "GNU_Compiler" sol/unity.sol	\
   					sol/uplus.sol	\
   					sol/g2000.sol	\
   					sol/mercury.sol
   make_TOC gnu.tar $Gnu "GNU_Compiler" sol/inova.sol	\
   					sol/mercvx.sol	\
   					sol/mercplus.sol

 fi
 
#---------------------------------------------------------------------------
# tar the IMAGE common files maclib, manual, imaging
   cd $vcommondir/IMAGE
   log_this " Tarring IMAGE Text	  for: "
   tar -cf - $ComIMAGE2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $vcommondir/IMAGE2
   tar -cf - $ComIMAGE22Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   setperms	./fidlib 755 644 755
   chmod 755	./help
   chmod 755	./help/help.imaging
   chmod 644	./help/help.imaging/*
   chmod 755    ./maclib
   chmod 755    ./maclib/maclib.imaging
   chmod 644    ./maclib/maclib.imaging/*
   chmod 755    ./menulib
   chmod 755    ./menulib/menulib.imaging
   chmod 644    ./menulib/menulib.imaging/*
   chmod 755    ./nuctables
   chmod 644    ./nuctables/*
   chmod 755    ./psglib
   chmod 644    ./psglib/*
   chmod 755    ./shapelib
   chmod 644    ./shapelib/*
   chmod 755    ./tablib
   chmod 644    ./tablib/*
   setperms	./imaging 755 644 755
   chmod 755	./bin/*
   chmod 644    ./vnmrmenu
   chmod 644    ./CoilTable
   chmod 644    ./pulsecal
   chmod -R 755   ./user_templates
   
   tar -cf $dest_dir_code/$Image/image.tar *
   make_TOC image.tar $Image "Imaging_or_Triax" sol/unity.sol	\
   						sol/uplus.sol
   make_TOC image.tar $Image "Imaging_or_Triax" sol/inova.sol
#---------------------------------------------------------------------------
# tar the IMAGE unique files for Inova maclib, manual, parlib imaging
   log_this "   Tarring IMAGE Inova          for : "

   cd $vcommondir/IMAGE
   tar -cf - $InovaIMAGE2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mv parlib_inova parlib
   mv imaging_inova imaging
   setperms ./parlib 755 644 755
   setperms ./imaging 755 644 755

   tar -cf $dest_dir_code/$Image/inovaimage.tar *
   make_TOC inovaimage.tar $Image "Imaging_or_Triax" sol/inova.sol   \
                                                     rht/inova.rht

#---------------------------------------------------------------------------
# tar the Dicom files 
   cd $vcommondir/Dicom
   log_this " Tarring Dicom Files	  for: "
   tar -cf - $Dicom2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   setperms	dicom 755 644 755
   tar -cf $dest_dir_code/$Image/dicom.tar *
   make_TOC dicom.tar $Image "Imaging_or_Triax" sol/inova.sol
#
#---------------------------------------------------------------------------
# tar the IMAGE common files maclib, manual, parlib imaging
   cd $solobjdir
   log_this " Tarring IMAGE Objects	  for: "
   tar -cf - $BinIMAGE2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755   ./bin
   chmod    755   ./lib
   chmod 644   ./lib/*
   ln -s /usr/lib/libC.so.5 lib/libC.so
   tar -cf $dest_dir_code/$Image/$Unity/image.tar *
   make_TOC image.tar $Image/$Unity "Imaging_or_Triax" sol/unity.sol	\
   							sol/uplus.sol
   make_TOC image.tar $Image/$Unity "Imaging_or_Triax" sol/inova.sol
#
#---------------------------------------------------------------------------
# tar the IMAGE files seqlib for unity and inova
   cd $solproglib_dir
   log_this " Tarring IMAGE Seqlib	  for: "
   tar -cf - $SeqIMAGE2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod    755   ./seqlib
   chmod    755   ./seqlib/*
   tar -cf $dest_dir_code/$Image/$Unity/seqlib.tar *
   make_TOC seqlib.tar $Image/$Unity "Imaging_or_Triax" sol/unity.sol	\
   							sol/uplus.sol
   make_TOC seqlib.tar $Image/$Unity "Imaging_or_Triax" sol/inova.sol
#
#---------------------------------------------------------------------------
# This stores a dummy file for Imaging. The difference in manual
# size is about 25 Mbyte, to much to leave unaccounted.
   cd $dest_dir_code/tmp
   mkdir tmp
   tar -cf $dest_dir_code/$Image/img_man.tar *
   set_size_name $Image img_man.tar
   tarFileSize=25000
   make_toc $Image "Imaging_or_Triax" sol/unity.sol
   tarFileSize=25000
   make_toc $Image "Imaging_or_Triax" sol/uplus.sol
   tarFileSize=4000
   make_toc $Image "Imaging_or_Triax" sol/inova.sol
   rm -rf $dest_dir_code/tmp/*
 
#---------------------------------------------------------------------
   log_this " Tarring Autotest files   for:"

   cd $dest_dir_code/tmp
   mkdir autotest
   (cd $vcommondir/Autotest; cp -rp * $dest_dir_code/tmp/autotest)
   setperms ./ 755 644 755
   mv autotest/maclib .
   tar -cf $dest_dir_code/$Inova/autotest.tar *
   make_TOC autotest.tar $Inova "Autotest" sol/inova.sol	\
   					   sol/uplus.sol	\
   					   rht/inova.rht
#
#---------------------------------------------------------------------------
# tar the limnet files out
   cd $solobjdir
   log_this " Tarring limnet.tar	  for: "
   cp -rp limnet $dest_dir_code/tmp/limnet
   cd $dest_dir_code/tmp
   chmod -R 755 limnet
   tar -cf $dest_dir_code/$Limnet/$Solaris/limnet.tar limnet
   make_TOC limnet.tar $Limnet/$Solaris "limNet" sol/unity.sol	\
   						sol/uplus.sol	\
   						sol/g2000.sol	\
   						sol/mercury.sol
   make_TOC limnet.tar $Limnet/$Solaris "limNet" sol/inova.sol  \
   						sol/mercvx.sol	\
   						sol/mercplus.sol\


#---------------------------------------------------------------------------
# tar the userlib option
#    ===>>> Unity, UNIYTplus, UNITY INOVA USERLIB <<<===
if [ x$user_answer = "xy" ]
then
      log_this " Tarring userlib.tar (/vcommon/UserLib.inova_unity)  for: "

      cd /vcommon/UserLib.inova_unity
      tar -cf $dest_dir_code/$Unity/userlib.tar $UserLib2Tar
      make_TOC userlib.tar $Unity/ "Userlib"  sol/unity.sol	\
   					      sol/uplus.sol
      make_TOC userlib.tar $Unity/ "Userlib"  sol/inova.sol	\
        		     		      rht/inova.rht
else
      log_this " Skipping Userlib	  for: "
      make_TOC userlib.tar $Unity/ "Userlib"  sol/unity.sol	\
   					      sol/uplus.sol
      make_TOC userlib.tar $Unity/ "Userlib"  sol/inova.sol	\
        		     		      rht/inova.rht
fi

#---------------------------------------------------------------------------
# tar the userlib option
#    ===>>> MERCURY, GEMINI 2000 USERLIB <<<===
  if [ x$user_answer = "xy" ]
  then
       log_this " Tarring userlib.tar (/vcommon/UserLib.mercury_gemini)  for: "

       cd /vcommon/UserLib.mercury_gemini
       tar -cf $dest_dir_code/$Gemini/userlib.tar $UserLib2Tar
       make_TOC userlib.tar $Gemini/ "Userlib" sol/g2000.sol	\
       					   sol/mercury.sol

       make_TOC userlib.tar $Gemini/ "Userlib" sol/mercvx.sol	\
   					   sol/mercplus.sol	\
   					   rht/mercplus.rht
 else
       log_this " Skipping Userlib	  for: "
       make_TOC userlib.tar $Gemini/ "Userlib" sol/g2000.sol	\
   					   sol/mercury.sol

       make_TOC userlib.tar $Gemini/ "Userlib" sol/mercvx.sol	\
   					   sol/mercplus.sol 	\
   					   rht/mercplus.rht
 fi

#---------------------------------------------------------------------
# tar 768 AS files
   log_this " Tarring 768AS Files	  for: "
   cd $vcommondir/768AS
   tar -cf - * | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   setperms ./ 755 644 755
   setperms ./asm/info 755 666 755
   setperms ./asm/info/768AS 755 666 755
   chmod 777 ./asm
   chmod 777 ./asm/info
   chmod 777 ./asm/info/768AS
   tar -cf $dest_dir_code/as768/as768.tar *
   make_TOC as768.tar as768 "768AS" sol/inova.sol   \
  				    sol/mercvx.sol  \
   				    sol/mercplus.sol

#---------------------------------------------------------------------
#Linux, tar 768 AS files
   log_this "Linux, Tarring 768AS files        for: "

   cd $vcommondir/768AS
   tar -cf - * | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   rm -f bin/killroboproc bin/gilalign bin/Gilscript
   (cp -f $lnxproglib_dir/bin/killroboproc    bin/)
   (cp -f $lnxproglib_dir/roboproc/gilalign   bin/)
   (cp -f $lnxproglib_dir/roboproc/Gilscript  bin/)
   setperms ./ 755 644 755
   setperms ./asm/info 755 666 755
   setperms ./asm/info/768AS 755 666 755
   chmod 777 ./asm
   chmod 777 ./asm/info
   chmod 777 ./asm/info/768AS
   tar -cf $dest_dir_code/$Linux/as768.tar *
   make_TOC as768.tar $Linux "768AS" rht/inova.rht   \
  				     rht/mercvx.rht  \
   				     rht/mercplus.rht

#============== PASSWORDED  FILES ========================================
echo "" | tee -a $log_fln
echo ""
nnl_echo "PART XII -- PASSWORDED FILES -- $dest_dir_code/" | tee -a $log_fln
#---------------------------------------------------------------------------
# tar Diffusion's maclib, manual and parlib files
  if [ x$password_answer = "xy" ]
  then

   cd $vcommondir/Diffusion
   log_this " Tarring Diffusion	  for: "
   tar -cf - $Diffus2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755    ./maclib
   chmod 644    ./maclib/*
   chmod 755    ./manual
   chmod 644    ./manual/*
   chmod 755    ./parlib
   chmod 755    ./parlib/*
   chmod 644    ./parlib/*/*
   tar -cf - * | $Encodedir/encode $Diff_password > $dest_dir_code/$Diff/diffuse.pwd
   make_TOC diffuse.pwd $Diff "Diffusion" sol/unity.opt	\
   					  sol/uplus.opt
   make_TOC diffuse.pwd $Diff "Diffusion" sol/inova.opt
 else
   log_this " Skipping Diffusion  for: "
   make_TOC diffuse.pwd $Diff "Diffusion" sol/unity.opt	\
   					  sol/uplus.opt
   make_TOC diffuse.pwd $Diff "Diffusion" sol/inova.opt
 fi

#---------------------------------------------------------------------------
# tar Diffusion's seqlib files
  if [ x$password_answer = "xy" ]
  then

   cd $solproglib_dir
   log_this " Tarring Diff Seq	  for: "
   tar -cf - $DiffusSeq2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./seqlib
   tar -cf - * | $Encodedir/encode $Diff_password > $dest_dir_code/$Diff/diffseq.pwd
   make_TOC diffseq.pwd $Diff "Diffusion" sol/unity.opt	\
   					  sol/uplus.opt
   make_TOC diffseq.pwd $Diff "Diffusion" sol/inova.opt
 else
   log_this " Skipping Diff Seq	  for: "
   make_TOC diffseq.pwd $Diff "Diffusion" sol/unity.opt	\
   					  sol/uplus.opt
   make_TOC diffseq.pwd $Diff "Diffusion" sol/inova.opt
 fi
 
#---------------------------------------------------------------------------
#Linux, tar Diffusion's maclib, manual and parlib ... files
  if [ x$password_answer = "xy" ]
  then
      log_this "Linux, Tarring all Diffusion files  for: "

      cd $vcommondir/Diffusion
      tar -cf - $Diffus2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
      cd $dest_dir_code/tmp
      mkdir seqlib

      (cd $lnxproglib_dir/psglib; cp -f pge.c pgeramp.c g2pulramp.c \
                       				$dest_dir_code/tmp/psglib)
      (cd $lnxproglib_dir/seqlib; cp -f pge pgeramp g2pulramp \
                                    		 $dest_dir_code/tmp/seqlib)
      chmod 755    ./maclib
      chmod 644    ./maclib/*
      chmod 755    ./manual
      chmod 644    ./manual/*
      chmod 755    ./parlib
      chmod 755    ./parlib/*
      chmod 644    ./parlib/*/*
      tar -cf - * | $Encodedir/encode $Diff_password > $dest_dir_code/$Linux/diffuse.pwd
      make_TOC diffuse.pwd $Linux "Diffusion" rht/inova.opt
    else
      log_this "Linux, Skipping all Diffusion files  for: "
      make_TOC diffuse.pwd $Linux "Diffusion" rht/inova.opt
 fi

#---------------------------------------------------------------------------
# tar LCNMR's files
  if [ x$password_answer = "xy" ]
  then
   cd $vcommondir/LCNMR
   log_this " Tarring LCNMR common files	  for: "
   tar -cf - $LCNMR2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   mkdir -p $dest_dir_code/tmp/psglib
   cd $solproglib_dir/psglib
   for cfile in $LCNMR_PS_2Tar
   do
      cp -p $cfile.c $dest_dir_code/tmp/psglib
   done
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
   chmod 755    ./psglib
   chmod 644    ./psglib/*
   chmod 755    ./shapelib
   chmod 644    ./shapelib/*
   chmod 755    ./tablib
   chmod 644    ./tablib/*
   setperms	./lc 755 644 755
   setperms ./user_templates 755 644 755
   tar -cf - * | $Encodedir/encode $LCNMR_password > $dest_dir_code/$LCNMR/lcnmr.pwd
   make_TOC lcnmr.pwd $LCNMR "LC-NMR" sol/unity.opt	\
   				      sol/uplus.opt
   make_TOC lcnmr.pwd $LCNMR "LC-NMR" sol/inova.opt
 else
   log_this " Skipping LCNMR 	  for: "
   make_TOC lcnmr.pwd $LCNMR "LC-NMR" sol/unity.opt	\
   				      sol/uplus.opt
   make_TOC lcnmr.pwd $LCNMR "LC-NMR" sol/inova.opt
 fi
 
#
#---------------------------------------------------------------------
# tar the INOVA LCNMR seqlib and bin
  if [ x$password_answer = "xy" ]
  then
	mkdir -p $dest_dir_code/tmp/seqlib
	cd $solproglib_dir/seqlib
	for cfile in $LCNMR_PS_2Tar
	do
	     cp -p $cfile $dest_dir_code/tmp/seqlib
	done

   	cd $dest_dir_code/tmp
        mkdir -p bin
        (cd $solproglib_dir/lcpeaks; cp -pf vjLCAnalysis $dest_dir_code/tmp/bin)
	chmod -R 755   ./bin
   	chmod 755   ./seqlib
   	chmod 755   ./seqlib/*
   	tar -cf - * | $Encodedir/encode $LCNMR_password > $dest_dir_code/$LCNMR/lcseqlib.pwd
   	make_TOC lcseqlib.pwd $LCNMR "LC-NMR" sol/inova.opt
 else
   	log_this " Skipping LCNMR seqlib and bin  for: "
   	make_TOC lcseqlib.pwd $LCNMR "LC-NMR" sol/inova.opt
 fi
 
#cccccc

#---------------------------------------------------------------------------
#Linux,  tar LCNMR's files
  if [ x$password_answer = "xy" ]
  then
      log_this "Linux,  Tarring all LCNMR files              for: "

      cd $vcommondir/LCNMR
      tar -cf - $LCNMR2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
      cd $dest_dir_code/tmp
      mkdir seqlib
      (cd $lnxproglib_dir/psglib; cp -f lc1d.c $dest_dir_code/tmp/psglib)
      (cd $lnxproglib_dir/seqlib; cp -f lc1d $dest_dir_code/tmp/seqlib)
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
      setperms     ./lc 755 644 755
      setperms ./user_templates 755 644 755
      tar -cf - * | $Encodedir/encode $LCNMR_password > $dest_dir_code/$Linux/lcnmr.pwd
 else
      log_this "Linux,  Skipping LCNMR      for: "
 fi
      make_TOC lcnmr.pwd $Linux "LC-NMR" rht/inova.opt

#---------------------------------------------------------------------------
# tar STARS's binary files
  if [ x$password_answer = "xy" ]
  then
  	log_this " Tarring STARS binary	  for: "

   	cd $vcommondir/STARS
   	tar -cf - $BinSTARSSol2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   	cd $dest_dir_code/tmp
   	chmod -R 755 ./bin
   	tar -cf - * | $Encodedir/encode $Stars_password > $dest_dir_code/$STARS/$Unity/stars.pwd
   	make_TOC stars.pwd $STARS/$Unity "STARS" sol/unity.opt	\
   					         sol/uplus.opt
   	make_TOC stars.pwd $STARS/$Unity "STARS" sol/inova.opt
 else
   	log_this " Skipping STARS binary	   for: "
   	make_TOC stars.pwd $STARS/$Unity "STARS" sol/unity.opt	\
   					         sol/uplus.opt
   	make_TOC stars.pwd $STARS/$Unity "STARS" sol/inova.opt
 fi

#---------------------------------------------------------------------------
#Linux, tar STARS's binary files
  if [ x$password_answer = "xy" ]
  then
      log_this "Linux, Tarring STARS binary   for: "
                                                                                                             
      mkdir -p $dest_dir_code/tmp/bin
      (cd $lnxproglib_dir/stars; cp starsprg qpar $dest_dir_code/tmp/bin)
      cd $dest_dir_code/tmp
      chmod -R 755 ./bin
      tar -cf - * | $Encodedir/encode $Stars_password > $dest_dir_code/$Linux/lstars.pwd
  else
      log_this " Skipping STARS binary           for: "
  fi
      make_TOC lstars.pwd $Linux "STARS" rht/inova.opt

#---------------------------------------------------------------------------
# tar STARS's text files
  if [ x$password_answer = "xy" ]
  then
   	log_this " Tarring STARS Text	  for : "

   	cd $vcommondir/STARS
   	tar -cf - $TextSTARS2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   	cd $dest_dir_code/tmp
   	chmod 755    ./maclib*
   	chmod 644    ./maclib/*
   	chmod 755    ./menulib
   	chmod 644    ./menulib/*
   	chmod -R 755 ./templates
   	chmod 644    ./templates/*/*/*
   	tar -cf - * | $Encodedir/encode $Stars_password > $dest_dir_code/$STARS/stars.pwd
   	make_TOC stars.pwd $STARS "STARS" sol/unity.opt	\
   					  sol/uplus.opt
   	make_TOC stars.pwd $STARS "STARS" sol/inova.opt	\
					  rht/inova.opt
  else
   	log_this " Skipping STARS Text	 for: "
   	make_TOC stars.pwd $STARS "STARS" sol/unity.opt	\
   					  sol/uplus.opt
   	make_TOC stars.pwd $STARS "STARS" sol/inova.opt	\
					  rht/inova.opt
  fi
 
#---------------------------------------------------------------------------
# tar Backproj help, maclib, manual and menulib files
  if [ x$password_answer = "xy" ]
  then

   cd $vcommondir/Backproj
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Backproj Text	  fro : " | tee -a $log_fln
   tar -cf - $ComBackproj2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755    ./maclib
   chmod 644    ./maclib/*
   chmod 755    ./parlib
   chmod 755    ./parlib/*
   chmod 644    ./parlib/*/*
   chmod 755	./psglib
   tar -cf - * | $Encodedir/encode $Backproj_password > $dest_dir_code/$Backproj/backproj.pwd
   set_size_name $Backproj backproj.pwd
   make_toc $Backproj "Backprojection" sol/unity.opt
   make_toc $Backproj "Backprojection" sol/uplus.opt
   make_toc $Backproj "Backprojection" sol/inova.opt
   rm -rf $dest_dir_code/tmp/*

 else

   echo "" | tee -a $log_fln
   nnl_echo " Skipping Backproj Text	  fro : " | tee -a $log_fln

   set_size_name $Backproj backproj.pwd
   make_toc $Backproj "Backprojection" sol/unity.opt
   make_toc $Backproj "Backprojection" sol/uplus.opt
   make_toc $Backproj "Backprojection" sol/inova.opt

 fi
#
#---------------------------------------------------------------------------
# tar Backproj's binary files
  if [ x$password_answer = "xy" ]
  then

   cd $solproglib_dir/backproj
   echo "" | tee -a $log_fln
   nnl_echo " Tarring Backproj binary  from : " | tee -a $log_fln
   mkdir $dest_dir_code/tmp/bin
   tar -cf - $BinBackproj2Tar | (cd $dest_dir_code/tmp/bin; tar xfBp -)
   cd $dest_dir_code/tmp
   mkdir -p seqlib
   (cd $solproglib_dir/seqlib; cp -pf bp_image $dest_dir_code/tmp/seqlib)
   (cd $solproglib_dir/seqlib; cp -pf bp2d $dest_dir_code/tmp/seqlib)
   (cd $solproglib_dir/seqlib; cp -pf bp3d $dest_dir_code/tmp/seqlib)
   chmod -R 755 ./bin
   chmod    755   ./seqlib
   chmod    755   ./seqlib/*
   tar -cf - * | $Encodedir/encode $Backproj_password > $dest_dir_code/$Backproj/$Unity/backproj.pwd
   set_size_name $Backproj/$Unity backproj.pwd
   make_toc $Backproj/$Unity "Backprojection" sol/unity.opt
   make_toc $Backproj/$Unity "Backprojection" sol/uplus.opt
   make_toc $Backproj/$Unity "Backprojection" sol/inova.opt
   rm -rf $dest_dir_code/tmp/*

 else

   echo "" | tee -a $log_fln
   nnl_echo " Skipping Backproj binary fro : " | tee -a $log_fln

   set_size_name $Backproj/$Unity backproj.pwd
   make_toc $Backproj/$Unity "Backprojection" sol/unity.opt
   make_toc $Backproj/$Unity "Backprojection" sol/uplus.opt
   make_toc $Backproj/$Unity "Backprojection" sol/inova.opt

 fi
#
#---------------------------------------------------------------------------
# tar CSI user_templates files
  if [ x$password_answer = "xy" ]
  then

   cd $vcommondir/CSI
   echo "" | tee -a $log_fln
   nnl_echo " Tarring CSI Text	  fro : " | tee -a $log_fln
   tar -cf - $ComCSI2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mkdir psglib
   (cd $solproglib_dir/psglib; cp -f csi2d.c $dest_dir_code/tmp/psglib)
   chmod 755    ./maclib
   chmod 644    ./maclib/*
   chmod 755    ./manual
   chmod 644    ./manual/*
   chmod 755    ./parlib
   chmod 755    ./parlib/*
   chmod 644    ./parlib/*/*
   chmod 755    ./psglib
   chmod 644    ./psglib/*
   setperms	./imaging 755 644 755
   chmod -R 755   ./user_templates
   tar -cf - * | $Encodedir/encode $CSI_password > $dest_dir_code/$CSI/csi.pwd
   set_size_name $CSI csi.pwd
   make_toc $CSI "CSI" sol/unity.opt
   make_toc $CSI "CSI" sol/uplus.opt
   make_toc $CSI "CSI" sol/inova.opt
   rm -rf $dest_dir_code/tmp/*

 else

   echo "" | tee -a $log_fln
   nnl_echo " Skipping CSI Text	  fro : " | tee -a $log_fln

   set_size_name $CSI csi.pwd
   make_toc $CSI "CSI" sol/unity.opt
   make_toc $CSI "CSI" sol/uplus.opt
   make_toc $CSI "CSI" sol/inova.opt

 fi
#
#---------------------------------------------------------------------------
# tar CSI's binary files
  if [ x$password_answer = "xy" ]
  then

   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring CSI binary	  for : " | tee -a $log_fln
   tar -cf - $BinCSI2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   mkdir seqlib
   (cd $solproglib_dir/seqlib; cp -f csi2d $dest_dir_code/tmp/seqlib)
   chmod -R 755 ./bin
   chmod -R 755 ./seqlib
   tar -cf - * | $Encodedir/encode $CSI_password > $dest_dir_code/$CSI/$Unity/csi.pwd
   set_size_name $CSI/$Unity csi.pwd
   make_toc $CSI/$Unity "CSI" sol/unity.opt
   make_toc $CSI/$Unity "CSI" sol/uplus.opt
   make_toc $CSI/$Unity "CSI" sol/inova.opt
   rm -rf $dest_dir_code/tmp/*

 else

   echo "" | tee -a $log_fln
   nnl_echo " Skipping CSI binary	  for : " | tee -a $log_fln

   set_size_name $CSI/$Unity csi.pwd
   make_toc $CSI/$Unity "CSI" sol/unity.opt
   make_toc $CSI/$Unity "CSI" sol/uplus.opt
   make_toc $CSI/$Unity "CSI" sol/inova.opt

 fi
 
#---------------------------------------------------------------------
# tar BIR shape files
  if [ x$password_answer = "xy" ]
  then
     log_this " Tarring BIR shapes       for : "

     cd $dest_dir_code/tmp
     (cd $vcommondir/BIR; cp -rp wavelib $dest_dir_code/tmp)
     chmod -R 755   ./wavelib
     chmod 644      ./wavelib/*/*
     tar -cf - * | $Encodedir/encode $BIR_password >$dest_dir_code/$Common/bird.pwd
  else
     log_this " Skipping BIR shapes       for : "
  fi
     make_TOC bird.pwd $Common "BIR_Shapes" sol/unity.opt	\
    					    sol/uplus.opt	\
    					    sol/inova.opt	\
				 	    rht/inova.opt

#---------------------------------------------------------------------
#DOSY common files
  if [ x$password_answer = "xy" ]
  then
     log_this " Tarring DOSY common files	  for : "

     cd $dest_dir_code/tmp
     mkdir -p adm/users
     mkdir -p templates/vnmrj/interface
     mkdir -p templates/vnmrj/protocols
     dirlist="fidlib maclib manual parlib templates"
     for dir in $dirlist
     do
        cp -rp $vcommondir/DOSY/$dir $dest_dir_code/tmp
     done
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
     log_this " Skipping DOSY common files	  for : "
  fi
     make_TOC dosy.pwd $Common "DOSY" sol/mercplus.opt  \
      				      sol/mercvx.opt    \
      				      sol/mercury.opt   \
     				      sol/unity.opt	\
				      sol/uplus.opt	\
				      sol/inova.opt	\
				      rht/inova.opt	\
      				      rht/mercury.opt

#---------------------------------------------------------------------
# Inova  DOSY user_templates/dg and seqlib binary files
                                                                                                             
  if [ x$password_answer = "xy" ]
  then
       log_this " Tarring DOSY user_templates/dg and seqlib binary files          for : "
                                                                                                             
       cd $dest_dir_code/tmp
       mkdir user_templates
       cp -r $vcommondir/DOSY/user_templates/dg user_templates
       mkdir -p $dest_dir_code/tmp/seqlib
       cd $solproglib_dir/seqlib
       for cfile in $DOSY_PS_2Tar
       do
          cp $cfile $dest_dir_code/tmp/seqlib
       done
       cd $dest_dir_code/tmp
       chmod -R 755 ./seqlib
       chmod 755   ./user_templates/dg
       chmod 755   ./user_templates/dg/*
       chmod 644   ./user_templates/dg/*/*
       tar -cf - * | $Encodedir/encode $DOSY_password >$dest_dir_code/$Solaris/idosy.pwd
  else
       log_this " Skipping DOSY user_templates/dg and seqlib binary files          for : "
  fi
       make_TOC idosy.pwd $Solaris "DOSY" sol/unity.opt	\
				          sol/uplus.opt	\
				          sol/inova.opt

#---------------------------------------------------------------------
# Linux: Inova  DOSY seqlib binary files

  if [ x$password_answer = "xy" ]
  then
       log_this "Linux, Tarring DOSY seqlib binary files          for : "
                                                                                                             
       cd $dest_dir_code/tmp
       mkdir seqlib
       cd $lnxproglib_dir/seqlib
       for cfile in $DOSY_PS_2Tar
       do
          cp $cfile $dest_dir_code/tmp/seqlib
       done
       cd $dest_dir_code/tmp
       chmod -R 755 ./seqlib
       tar -cf - * | $Encodedir/encode $DOSY_password >$dest_dir_code/$Linux/idosy.pwd
  else
       log_this "Linux, Skipping DOSY seqlib binary files          for : "
  fi
       make_TOC idosy.pwd $Linux "DOSY" rht/inova.opt

#---------------------------------------------------------------------
#Mercury family:  tar DOSY user_templates/dg and seqlib binary files
  if [ x$password_answer = "xy" ]
  then
      log_this " Tarring DOSY user_templates/dg and seqlib binary files       for : "

      cd $dest_dir_code/tmp
      mkdir user_templates seqlib
      cp -rp $vcommondir/DOSY/user_templates/dg user_templates
      filelist=`ls $vcommondir/DOSY/seqlib`
      for file in $filelist
      do
         cp -p /vobj/sol/proglib/kseqlib/$file seqlib
      done
      chmod -R 755 ./seqlib
      chmod 755   ./user_templates/dg
      chmod 755   ./user_templates/dg/*
      chmod 644   ./user_templates/dg/*/*

      tar -cf - * | $Encodedir/encode $DOSY_password >$dest_dir_code/$Solaris/mdosy.pwd
  fi
      make_TOC mdosy.pwd $Solaris "DOSY" sol/mercplus.opt  \
      					 sol/mercvx.opt    \
      					 sol/mercury.opt

#---------------------------------------------------------------------
# Linux:  Mercury+ DOSY seqlib binary files

  if [ x$password_answer = "xy" ]
  then
      log_this "Linux, Tarring DOSY binary seqlib files       for : "

      cd $dest_dir_code/tmp
      mkdir ./seqlib
      filelist=`ls $vcommondir/DOSY/seqlib`
      for file in $filelist
      do
          cp -p $lnxproglib_dir/kseqlib/$file seqlib
      done
      chmod -R 755 ./seqlib

      #if [ ! -d $dest_dir_code/rht ]
      #then 
      #   echo creating dest_dir_code/rht | tee -a $log_fln
      #   mkdir $dest_dir_code/rht
      #fi

      tar -cf - * | $Encodedir/encode $DOSY_password >$dest_dir_code/$Linux/mdosy.pwd
  fi
      make_TOC mdosy.pwd $Linux "DOSY" rht/mercplus.opt

#---------------------------------------------------------------------
#Gxyz common files
  if [ x$password_answer = "xy" ]
  then
     log_this " Tarring Gxyz common files	  for : "

     dirlist="maclib parlib shimtab templates"
     for dir in $dirlist
     do
        cp -rp $vcommondir/Gxyz/$dir $dest_dir_code/tmp
     done
     mkdir psglib
     (cd $solproglib_dir/psglib; cp -f gmapxyz.c $dest_dir_code/tmp/psglib)
     cd $dest_dir_code/tmp
     chmod 755   ./*
     chmod 644   ./*/*
     chmod 755   ./parlib/*
     chmod 644   ./parlib/*/*
     chmod 755   ./templates/layout
     chmod 755   ./templates/layout/*
     chmod 644   ./templates/layout/*/*
     tar -cf - * | $Encodedir/encode $Gxyz_password >$dest_dir_code/$Common/gxyz.pwd
  else
     log_this " Skipping Gxyz common files	  for : "
  fi
     make_TOC gxyz.pwd $Common "3D_shimming" sol/mercplus.opt  \
      				      sol/mercvx.opt    \
				      sol/inova.opt	\
				      rht/inova.opt	\
      				      rht/mercury.opt

#---------------------------------------------------------------------
# Inova / Mercury  Gxyz seqlib binary files
                                                                                                             
  if [ x$password_answer = "xy" ]
  then
       log_this " Tarring Gxyz seqlib binary files          for : "
       cd $dest_dir_code/tmp
       mkdir seqlib
       (cd $solproglib_dir/seqlib; cp -f gmapxyz $dest_dir_code/tmp/seqlib)
       chmod -R 755 ./seqlib
       tar -cf - * | $Encodedir/encode $Gxyz_password >$dest_dir_code/$Solaris/igxyz.pwd
  else
       log_this " Skipping Gxyz seqlib binary files          for : "
  fi
       make_TOC igxyz.pwd $Solaris "3D_shimming" sol/mercplus.opt  \
      				          sol/mercvx.opt    \
				          sol/inova.opt

#---------------------------------------------------------------------
# Linux: Inova / Mercury  Gxyz seqlib binary files

  if [ x$password_answer = "xy" ]
  then
       log_this "Linux, Tarring Gxyz seqlib binary files          for : "
                                                                                                             
       cd $dest_dir_code/tmp
       mkdir seqlib
       (cd $lnxproglib_dir/seqlib; cp -f gmapxyz $dest_dir_code/tmp/seqlib)
       chmod -R 755 ./seqlib
       tar -cf - * | $Encodedir/encode $Gxyz_password >$dest_dir_code/$Linux/igxyz.pwd
  else
       log_this "Linux, Skipping Gxyz seqlib binary files          for : "
  fi
       make_TOC igxyz.pwd $Linux "3D_shimming" rht/inova.opt	\
      				        rht/mercury.opt

#---------------------------------------------------------------------
# tar VAST (Gilson) generic files
  if [ x$password_answer = "xy" ]
  then
   cd $dest_dir_code/tmp
   echo "" | tee -a $log_fln
   nnl_echo " Tarring VAST files	  for : " | tee -a $log_fln
   (cd $vcommondir/Gilson; cp -rp * $dest_dir_code/tmp)
   setperms ./ 755 644 755
   setperms ./asm/info 755 666 755
   setperms ./user_templates/dg 755 666 755
   chmod 777 ./asm
   chmod 777 ./asm/info
   chmod 755   ./tcl/bin/*
   chmod 755 ./bin/*
   tar -cf - * | $Encodedir/encode $VAST_password >$dest_dir_code/$Unity/$Inova/vast.pwd
   set_size_name $Unity/$Inova vast.pwd
   make_toc_no_rm $Unity/$Inova "VAST" sol/inova.opt
 
# Mercruy-VX does not use the psglib (yet)
#
   cd $dest_dir_code/tmp
   rm -rf psglib
   tar -cf - * | $Encodedir/encode $VAST_password >$dest_dir_code/$Mvx/vast.pwd
   set_size_name $Mvx vast.pwd
   make_toc $Mvx "VAST" sol/mercvx.opt
   make_toc $Mvx "VAST" sol/mercplus.opt
   make_toc $Mvx "VAST" rht/mercplus.opt
   rm -rf $dest_dir_code/tmp/*

 else

   echo "" | tee -a $log_fln
   nnl_echo " Skipping VAST files	  for : " | tee -a $log_fln

   set_size_name $Unity/$Inova vast.pwd
   make_toc $Unity/$Inova "VAST" sol/inova.opt
   set_size_name $Mvx vast.pwd
   make_toc $Mvx "VAST" sol/mercvx.opt
   make_toc $Mvx "VAST" sol/mercplus.opt
   make_toc $Mvx "VAST" rht/mercplus.opt

 fi

#---------------------------------------------------------------------
#Linux,  VAST (Gilson) all needed files
  if [ x$password_answer = "xy" ]
  then
     log_this "Linux, Tarring VAST all needed files          for : "
     cd $dest_dir_code/tmp
     (cd $vcommondir/Gilson; cp -rp * $dest_dir_code/tmp)

     cp -f $lnxproglib_dir/psglib/vast1d.c     psglib/vast1d.c
     cp -f $lnxproglib_dir/seqlib/vast1d       seqlib/vast1d
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
     log_this "Linux, Skipping VAST all files          for : "
 fi
     make_TOC i_vast.pwd $Linux "VAST" rht/inova.opt
   
#---------------------------------------------------------------------
#Linux,  Mercury plus, tar VAST (Gilson) generic files
#seqlib/vast1d is still questioning
  if [ x$password_answer = "xy" ]
  then

   cd $dest_dir_code/tmp
   echo "" | tee -a $log_fln
   nnl_echo "Linux, Tarring VAST files          for : " | tee -a $log_fln
   (cd $vcommondir/Gilson; cp -rp * $dest_dir_code/tmp)
   cp $lnxproglib_dir/roboproc/gilalign bin
   rm -rf psglib/*
   rm -rf seqlib/*
   #remove SPARC binary
   rm -f seqlib/vast1d
   setperms ./ 755 644 755
   setperms ./asm/info 755 666 755
   setperms ./user_templates/dg 755 666 755
   chmod 777 ./asm
   chmod 777 ./asm/info
   chmod 755   ./tcl/bin/*
   tar -cf - * | $Encodedir/encode $VAST_password >$dest_dir_code/$Linux/mp_vast.pwd
   set_size_name $Linux mp_vast.pwd
   make_toc $Linux "VAST" rht/mercplus.opt
   rm -rf $dest_dir_code/tmp/*

 else

   echo "" | tee -a $log_fln
   nnl_echo " Skipping VAST files         for : " | tee -a $log_fln
   set_size_name $Linux mp_vast.pwd
   make_toc $Linux "VAST" rht/mercplus.opt
 fi

#---------------------------------------------------------------------
# tar the INOVA VAST (Gilson) seqlib 
  if [ x$password_answer = "xy" ]
  then

   cd $solproglib_dir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring GILSON seqlib	  for : " | tee -a $log_fln
   tar -cf - $GILSONSeq2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755   ./seqlib
   chmod 755   ./seqlib/*
   tar -cf - * | $Encodedir/encode $VAST_password > $dest_dir_code/$Unity/$Inova/vastseqlib.pwd
   set_size_name $Unity/$Inova vastseqlib.pwd
   make_toc $Unity/$Inova "VAST" sol/inova.opt
   rm -rf $dest_dir_code/tmp/*

 else

   echo "" | tee -a $log_fln
   nnl_echo " Skipping GILSON seqlib	  for : " | tee -a $log_fln

   set_size_name $Unity/$Inova vastseqlib.pwd
   make_toc $Unity/$Inova "VAST" sol/inova.opt
 fi
 
#---------------------------------------------------------------------------
# tar FDM's manual and fidlib files
  if [ x$password_answer = "xy" ]
  then

   cd $vcommondir/FDM
   echo "" | tee -a $log_fln
   nnl_echo " Tarring FDM	  for : " | tee -a $log_fln
   tar -cf - $Fdm2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod 755    ./manual
   chmod 644    ./manual/*
   chmod 755   ./fidlib
   chmod 755   ./fidlib/*
   chmod 644   ./fidlib/*/*
   tar -cf - * | $Encodedir/encode $FDM_password > $dest_dir_code/$Common/fdm.pwd
   set_size_name $Common fdm.pwd
   make_toc $Common "FDM" sol/g2000.opt
   make_toc $Common "FDM" sol/mercury.opt
   make_toc $Common "FDM" sol/mercvx.opt
   make_toc $Common "FDM" sol/mercplus.opt
   make_toc $Common "FDM" sol/unity.opt
   make_toc $Common "FDM" sol/uplus.opt
   make_toc $Common "FDM" rht/mercplus.opt
   make_toc $Common "FDM" sol/inova.opt	\
			  rht/inova.opt
   rm -rf $dest_dir_code/tmp/*

 else

   echo "" | tee -a $log_fln
   nnl_echo " Skipping FDM        for : " | tee -a $log_fln

   set_size_name $Common fdm.pwd
   make_toc $Common "FDM" sol/g2000.opt
   make_toc $Common "FDM" sol/mercury.opt
   make_toc $Common "FDM" sol/mercvx.opt
   make_toc $Common "FDM" sol/mercplus.opt
   make_toc $Common "FDM" sol/unity.opt
   make_toc $Common "FDM" sol/uplus.opt
   make_toc $Common "FDM" rht/mercplus.opt
   make_toc $Common "FDM" sol/inova.opt	\
			rht/inova.opt

 fi
 
#---------------------------------------------------------------------------
# tar FDM binary files
  if [ x$password_answer = "xy" ]
  then
                                                                                                
   cd $solobjdir
   echo "" | tee -a $log_fln
   nnl_echo " Tarring FDM binary  for :  " | tee -a $log_fln
   tar -cf - $FdmBin2Tar | (cd $dest_dir_code/tmp; tar xfBp -)
   cd $dest_dir_code/tmp
   chmod -R 755 ./bin
   tar -cf - * | $Encodedir/encode $FDM_password > $dest_dir_code/$Unity/fdmbin.pwd
   set_size_name $Unity fdmbin.pwd
   make_toc $Unity "FDM" sol/g2000.opt
   make_toc $Unity "FDM" sol/mercury.opt
   make_toc $Unity "FDM" sol/mercvx.opt
   make_toc $Unity "FDM" sol/mercplus.opt
   make_toc $Unity "FDM" sol/unity.opt
   make_toc $Unity "FDM" sol/uplus.opt
   make_toc $Unity "FDM" sol/inova.opt
   rm -rf $dest_dir_code/tmp/*
                                                                                                
 else
                                                                                                
   echo "" | tee -a $log_fln
   nnl_echo " Skipping FDM binary  for : " | tee -a $log_fln
                                                                                                
   set_size_name $Unity fdmbin.pwd
   make_toc $Unity "FDM" sol/g2000.opt
   make_toc $Unity "FDM" sol/mercury.opt
   make_toc $Unity "FDM" sol/mercvx.opt
   make_toc $Unity "FDM" sol/mercplus.opt
   make_toc $Unity "FDM" sol/unity.opt
   make_toc $Unity "FDM" sol/uplus.opt
   make_toc $Unity "FDM" sol/inova.opt
 fi

#---------------------------------------------------------------------------
#Linux,  Inova and Mercury plus, tar FDM binary files
  if [ x$password_answer = "xy" ]
  then
       log_this " Tarring Linux FDM binary  for :  "
       cd $dest_dir_code/tmp
       mkdir bin
       tar -cf - $FdmLinux2Tar | (cd $dest_dir_code/tmp/bin; tar xfBp -)
       chmod -R 755 ./bin
       tar -cf - bin | $Encodedir/encode $FDM_password > $dest_dir_code/$Linux/fdmbin.pwd
       make_TOC fdmbin.pwd $Linux "FDM" rht/mercplus.opt	\
					rht/inova.opt
 else
       log_this " Skipping Linux FDM binary  for :  "
       make_TOC fdmbin.pwd $Linux "FDM" rht/mercplus.opt  \
					rht/inova.opt
 fi
 
#---------------------------------------------------------------------------
# tar Patented Image pulse sequences and supporting files
  if [ x$password_answer = "xy" ]
  then

   cd $vcommondir/IMAGE_patent
   echo "" | tee -a $log_fln
   nnl_echo " Tarring IMAGE_patent for :     " | tee -a $log_fln
   tar -cf - $ImagePatentFiles | (cd $dest_dir_code/tmp; tar xfBp -)
   mkdir -p $dest_dir_code/tmp/seqlib
   cd $solproglib_dir
   for cfile in $PATENT_PS_2Tar
   do
     cp psglib/$cfile.c $dest_dir_code/tmp/psglib
     cp seqlib/$cfile   $dest_dir_code/tmp/seqlib
   done
   cd $dest_dir_code/tmp
   setperms ./bin 755 644 755
   setperms ./imaging 755 644 755
   setperms ./maclib  755 644 755
   setperms ./parlib  755 644 755
   setperms ./psglib 755 644 755
   setperms ./seqlib 755 644 755
   tar -cf - * | $Encodedir/encode $IMGP_password > $dest_dir_code/$Image/$Unity/img_pat.pwd
   set_size_name $Image/$Unity img_pat.pwd
   make_toc $Image/$Unity "Imaging_Sequences" sol/inova.opt
   rm -rf $dest_dir_code/tmp/*

 else

   echo "" | tee -a $log_fln
   nnl_echo " Skipping IMAGE_patent for :  " | tee -a $log_fln

   set_size_name $Image/$Unity img_pat.pwd
   make_toc $Image/$Unity "Imaging_Sequences" sol/inova.opt
 fi

  if [ x$password_answer = "xy" ]
  then
    nnl_echo " Tarring IMAGE_patent inova files for : "	| tee -a $log_fln
 
    cd $vcommondir/IMAGE_patent
    tar -cf - $InovaImagePatentFiles | (cd $dest_dir_code/tmp; tar xfBp -)
    cd $dest_dir_code/tmp
    mv imaging_inova imaging
    mv parlib_inova  parlib
    setperms ./imaging 755 644 755
    setperms ./parlib  755 644 755
    tar -cf - * | $Encodedir/encode $IMGP_password > $dest_dir_code/$Image/$Unity/inovaimg_pat.pwd
    set_size_name $Image/$Unity inovaimg_pat.pwd
    make_toc $Image/$Unity "Imaging_Sequences" sol/inova.opt
    rm -rf $dest_dir_code/tmp/*
  else
    echo "" | tee -a $log_fln
    nnl_echo " Skipping IMAGE_patent for :  " | tee -a $log_fln

    set_size_name $Image/$Unity inovaimg_pat.pwd
    make_toc $Image/$Unity "Imaging_Sequences" sol/inova.opt
  fi
#
#============== ACC ====================================================
# copy Solaris patches
   echo "" | tee -a $log_fln
   echo ""
   nnl_echo "PART XV -- ACC FOR CHEMMAGNETICS -- " | tee -a $log_fln
   if [ ! -d $dest_dir/acc ]
   then
       mkdir $dest_dir/acc
   fi
   cp $vcommondir/acc/* $dest_dir/acc
   chmod 644 $dest_dir/acc/*
   chmod 755 $dest_dir/acc/acc
#
#============== INSTALLATION FILES =========================================
# copy some of the installation programs
   echo "" | tee -a $log_fln
   echo ""
   nnl_echo "PART XVI -- INSTALLATION FILES -- $dest_dir" | tee -a $log_fln
#
#---------------------------------------------------------------------------
#
   echo "" | tee -a $log_fln
   echo " Making copies in '$LoadFilesDir'" | tee -a $log_fln

   cp $sourcedir/sysscripts/autoloadcd $dest_dir/load.nmr
   chmod 777 $dest_dir/load.nmr

#   echo "load.std " | tee -a $log_fln
#   cp $sourcedir/sysscripts/loadcd $dest_dir/load.std
#   chmod 777 $dest_dir/load.std

   if [ x$LoadVnmrJ != "xy" ]
   then
      echo $Code/i_vnmr.3 | tee -a $log_fln
      cp $sourcedir/sysscripts/i_vnmr3 $dest_dir_code/i_vnmr.3
      chmod 777 $dest_dir/code/i_vnmr.3

      echo $Code/i_vnmr.4 | tee -a $log_fln
      cp $sourcedir/sysscripts/i_vnmr4 $dest_dir_code/i_vnmr.4
      chmod 777 $dest_dir/code/i_vnmr.4
   fi

   echo "checkspace, kill_insvnmr" | tee -a $log_fln
   (cd $sourcedir/sysscripts; cp checkspace $dest_dir_code)
   (cd $dest_dir_code; chmod 777 checkspace )
   if [ x$LoadVnmrJ = "xy" ]
   then
      echo "vnmrsetup, dbsetup, bootr, ins_vnmr, kill_insvnmr, mkvnmrjadmin" | tee -a $log_fln
      (cd $sourcedir/sysscripts; cp dbsetup vnmrsetup bootr ins_vnmr kill_insvnmr mkvnmrjadmin $dest_dir_code)
      (cd $dest_dir_code; chmod 777 dbsetup vnmrsetup bootr ins_vnmr kill_insvnmr mkvnmrjadmin)
   fi

#
#   for VJ cdrom only
#
   if [ x$LoadVnmrJ = "xy" ]
   then
      (cd $dest_dir; rm -f load.nmr; ln -s code/vnmrsetup load.nmr)
      for file in $LoadDecodeBin
      do
         echo $Code/$file | tee -a $log_fln
         rm -f $dest_dir_code/$file
         cp -p $solobjdir/proglib/bin/$file $dest_dir_code/$file
         chmod 777 $dest_dir/code/$file
      done

      cp -p $lnxproglib_dir/bin/decode.lnx $dest_dir_code/decode.rht
      chmod 777 $dest_dir_code/decode.rht
      #bootpd and tftp-server packages for Linux
      cp -p $vcommondir/linux/bootp-2.4.3-7.i386.rpm $dest_dir_code/linux
      chmod 777 $dest_dir_code/linux/bootp-2.4.3-7.i386.rpm
      cp -p $vcommondir/linux/tftp-server-0.32-4.i386.rpm $dest_dir_code/linux
      chmod 777 $dest_dir_code/linux/tftp-server-0.32-4.i386.rpm
      cp -p $vcommondir/linux/acroread-5.08-2.i386.rpm $dest_dir_code/linux
      chmod 777 $dest_dir_code/linux/acroread-5.08-2.i386.rpm

   else
 
      for file in $LoadSolFilesBin
      do
         echo $Code/$file | tee -a $log_fln
         rm -f $dest_dir_code/$file
         cp -p $solobjdir/proglib/bin/$file $dest_dir_code/$file
         chmod 777 $dest_dir/code/$file
      done
   
    
   fi
 
   echo "copying icons" | tee -a $log_fln
   cd $dest_dir_code
   if [ ! -d $dest_dir_code/icon ]
   then
      mkdir -p $dest_dir_code/icon
   fi
   cd icon
   chmod -w *.icon
   chmod -w *.gif
   rm -f datastn.gif mercpluslnx.gif
   cp /vcommon/iconlib/datastn.gif .
   cp /vcommon/iconlib/mercpluslnx.gif .

   Sget bin inova.icon > /dev/null
   Sget bin g2000.icon > /dev/null
   Sget bin unity.icon > /dev/null
   Sget bin uplus.icon > /dev/null
   Sget bin mercury.icon > /dev/null
   Sget bin mercvx.icon > /dev/null
   Sget bin mercplus.icon > /dev/null
   Sget bin logo.icon > /dev/null
   chmod +w *.icon

   Sget gif inova.gif > /dev/null
   Sget gif g2000.gif > /dev/null
   Sget gif unity.gif > /dev/null
   Sget gif uplus.gif > /dev/null
   Sget gif mercury.gif > /dev/null
   Sget gif mercvx.gif > /dev/null
   Sget gif mercplus.gif > /dev/null
   Sget gif logo.gif > /dev/null

#   mv inova.icon    inova.xpm;
#   mv g2000.icon    g2000.xpm;
#   mv unity.icon    unity.xpm;
#   mv uplus.icon    uplus.xpm;
#   mv mercury.icon  mercury.xpm;
#   mv mercvx.icon   mercvx.xpm;
#   mv mercplus.icon mercplus.xpm;

#   $Convert inova.xpm    inova.gif
#   $Convert g2000.xpm    g2000.gif
#   $Convert unity.xpm    unity.gif
#   $Convert uplus.xpm    uplus.gif
#   $Convert mercury.xpm  mercury.gif
#   $Convert mercvx.xpm   mercvx.gif
#   $Convert mercplus.xpm mercplus.gif

#   mv inova.xpm     inova.icon
#   mv g2000.xpm     g2000.icon
#   mv unity.xpm     unity.icon
#   mv uplus.xpm     uplus.icon
#   mv mercury.xpm   mercury.icon
#   mv mercvx.xpm    mercvx.icon
#   mv mercplus.xpm  mercplus.icon

 
   #cd $Install_dir
   #echo $Code/readme.txt | tee -a $log_fln
   #cp readme.txt $dest_dir/readme.txt
   #chmod 644 $dest_dir/readme.txt
   #cp readme.txt $dest_dir/../READ.ME
   #chmod 644 $dest_dir/../READ.ME

   cd $dest_dir_code/../
   echo "" | tee -a $log_fln
   echo "" | tee -a $log_fln
   rm -f vnmrrev $RevFileName
   echo "Writing Revision File '$RevFileName':"  | tee -a $log_fln
   echo $VnmrRevId > vnmrrev
   echo `date '+%B %d, %Y'` >> vnmrrev
   cat vnmrrev | tee -a $log_fln
   ln -s vnmrrev $RevFileName


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
    tar xvf $dest_dir_code/unity/pboxbin.tar
    tar xvf $dest_dir_code/unity/inova/wobbler.tar
    tar xvf $dest_dir_code/imaging/unity/seqlib.tar
    tar xvf $dest_dir_code/imaging/unity/image.tar
    tar xvf $dest_dir_code/glidepack/glidebin.tar

    mkdir -p adm/p11
    #bin/vnmrMD5 -l /vcommon/p11/sysList vnmrsystem > adm/p11/syschksm

    #pack checksum file together within com.tar
    #tar -rf $dest_dir_code/common/com.tar  adm/p11/syschksm

    cd $dest_dir_code
    rm -rf tmp

fi

#
#---------------------------------------------------------------------------
# Finally, all done, write out passwd file, clean up some unneeded directories
#
   cd $dest_dir/..
   echo "" | tee -a $log_fln
   echo "" | tee -a $log_fln
   echo "The passwords used with this install are:" > passwords | tee -a $log_fln
   echo "" >> passwords
#   echo "Gradient_shim	   $Gmap_password"  >> passwords
   echo "Diffusion	   $Diff_password"  >> passwords
   echo "LC-NMR		   $LCNMR_password" >> passwords
   echo "STARS             $Stars_password" >> passwords
   echo "Backprojection	   $Backproj_password"   >> passwords
   echo "CSI		   $CSI_password"   >> passwords
   echo "BIR Shapes        $BIR_password"   >> passwords
   echo "DOSY              $DOSY_password"  >> passwords
   echo "3D_shimming       $Gxyz_password"  >> passwords
   echo "VAST              $VAST_password"  >> passwords
   echo "FDM               $FDM_password"   >> passwords
   echo "Imaging_Sequences $IMGP_password"  >> passwords
   echo "" >> passwords

   cat passwords >> $log_fln
   echo " " | tee -a $log_fln
   
   if [ x$fini_dir != "xnone" ]
   then
     echo "Write CD Image to Destination Place: $fini_dir" | tee -a $log_fln
     cd $dest_dir
     tar -cf - . | (cd $fini_dir; tar xfBp -)
     cp $dest_dir/../passwords $fini_dir.passwords

     if [ x$LoadVnmrJ = "xy" ]
     then
        rm -f /rdvnmr/.cdromVJ_latest
        ln -s $fini_dir /rdvnmr/.cdromVJ_latest
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
        msg3=`echo "CD Image \"$fini_dir\" is Ready.\n"`
        msg="$msg1\n$msg2\n \n \n$msg3a\n\n$msg3\n\n"
        echo $msg | mail  $mail_list 
     fi
    fi

echo "DONE - cdout--------------" | tee -a $log_fln
