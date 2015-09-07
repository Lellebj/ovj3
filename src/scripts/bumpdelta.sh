: '@(#)bumpdelta.sh 22.1 03/24/08 1991-2006 '
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
#
#  bump delta level up to next whole number after a software release
#  Author  Greg Brissey  4/9/90
#
#  5/7/96 Updatedate for Inova release 5.2F  GMB
#


echo " "
echo " This script bumps the SCCS delta level (i.e, 4.# to 5.1)"
echo " This processes is done after a release of Vnmr software. "
echo " The user selects the Software Release, categories to be bumped"
echo " The user is interactivily given the maximum delta of the"
echo " category and the New Delta Level is requested."
echo " A standard comment is used in the delta processes derived from"
echo " the Software Release and Delta Level."
echo " "
echo "Date: `date`"
echo " "

# test for tmp directory ---------------------------------
if (test -d bumprel_tmp)
then
  echo "Directory bumprel_tmp exits."
  echo "Directory contains:"
  ls -C bumprel_tmp
  echo -n "Delete Direcory (y, n): "
  read ans
  if (test ! "x$ans" = "xy")
  then
    echo "Move to another directory and restart."
    exit 1
  else
    rm -rf bumprel_tmp
  fi
fi
echo Making tmp directory bumprel_tmp.
mkdir bumprel_tmp
cd bumprel_tmp

relmdir="/vsccs"
datestamp="`date +'%a %h %d %Y  (%m/%d/%y)`"

# --------------------------   10/1/97     ------------------------------------
# categories are:
# 3D		expproc		kpsg		procproc	userp
# 3Dimg		gacqi		kpsglib		prom		vms
# OLDSCCS	gacqproc	kvwacq		psg		vnmr
# accounting	gapmon		lib7		psglib		vwacq
# acqi		glide		limnet		recvproc	vwacqkernel
# acqproc	glnc		limnet_ibm	roboproc	vwauto
# autoproc	gpsg		limnet_solaris	sas		vwautokernel
# autshm	gpsglib		maclib		scripts		vwcom
# backproj	gshim		manual		sendproc	vwtests
# bin		halbug		map2		shapelib	xracq
# bootg+	halmon		menulib		shimproms	xrbug
# bootpd	help		motif		simul		xrconf
# csi		ib		nacqi		stars		xview
# ddl		infoproc	nautoproc	stat		xwin
# decode	iso		ncomm		sunview		yacc
# diffusion	kapmon		npsg		tcl
# dsp		kernel_solaris	nvnmr		tune

#
# categories for 6.1A Inova, U+, Unity, VXR, Gemini 2000, Mercury, (SGI, IBM) 10/1/97
#
#chosen_categories="3D 3Dimg accounting acqi acqproc autoproc autshm backproj bin  \
#		    bootg+ bootpd csi ddl dsp expproc gacqi gacqproc gapmon  \
#		    glide glnc gpsg gpsglib gshim help ib \
#		    infoproc kapmon kpsg kpsglib \
#		    maclib manual menulib motif nacqi nautoproc ncomm \
#		    procproc psg psglib recvproc roboproc scripts sendproc shapelib \
#		    stat tcl tune vnmr vwacq vwacqkernel vwauto vwautokernel \
#		    vwcom xracq xrconf xview xwin"


# --------------------------   12/8/98     ------------------------------------
# categories are:
# 3D              gacqi           kpsg            nvnmr           tune
# 3Dimg           gacqproc        kpsglib         procproc        userp
# OLDSCCS         gapmon          kspin           prom            vms
# accounting      glide           kvwacq          psg             vnmr
# acqi            glnc            kvwacqkernel    psglib          vwacq
# acqproc         gpsg            lib7            recvproc        vwacqkernel
# autoproc        gpsglib         limnet          roboproc        vwacqkernelppc
# autshm          gs              limnet_ibm      sas             vwauto
# backproj        gshim           limnet_solaris  scripts         vwautokernel
# bin             halbug          maclib          sendproc        vwcom
# bootg+          halmon          manual          shapelib        vwtests
# bootpd          help            map2            shimproms       xracq
# csi             ib              menulib         simul           xrbug
# ddl             infoproc        motif           specials        xrconf
# decode          iso             nacqi           stars           xview
# diffusion       kapmon          nautoproc       stat            xwin
# dsp             kbin            ncomm           sunview         yacc
# expproc         kernel_solaris  npsg            tcl

# removed from list: OLDSCCS iso kernel_solaris lib7 map2 sas simul specials sunview userp autshm
#		     vms vwacqkernelppc vwtests npsg nvnmr prom halmon halbug shimproms xrbug"

#  also gacqi has nothing in it

#chosen_categories="3D kpsg tune 3Dimg gacqproc kpsglib procproc \
#		   gapmon kspin accounting glide kvwacq psg vnmr  \
# 		   acqi glnc kvwacqkernel psglib vwacq acqproc gpsg recvproc \
#		   vwacqkernel autoproc gpsglib limnet roboproc autshm gs limnet_ibm  \
#		   vwauto backproj gshim limnet_solaris  scripts vwautokernel bin maclib  \
#		   sendproc vwcom bootg+ manual shapelib bootpd help xracq csi ib menulib \
#	           ddl infoproc motif xrconf decode nacqi stars xview diffusion kapmon \
#		   nautoproc stat xwin dsp kbin ncomm yacc expproc tcl"

# --------------------------   8/29/2000  Vnmr6.1C   ------------------------------------ 
# categories are:
# 3D              ddl             halmon          limnet_solaris  roboproc        vms
# 3Dimg           decode          help            maclib          sas             vnmr
# OLDSCCS         diffusion       ib              manual          sccs            vnmrbg
# TNT             dsp             infoproc        map2            scripts         vwacq
# accounting      expproc         iso             menulib         sendproc        vwacqkernel
# acqi            fdm             kapmon          motif           shapelib        vwacqkernelppc
# acqproc         gacqi           kbin            nacqi           shimproms       vwauto
# autoproc        gacqproc        kernel_solaris  nautoproc       simul           vwautokernel
# autshm          gapmon          kpsg            ncomm           specials        vwcom
# backproj        glide           kpsglib         npsg            spincad         vwtests
# bin             glnc            kspin           nvnmr           stars           xracq
# bootg+          gpsg            kvwacq          procproc        stat            xrbug
# bootpd          gpsglib         kvwacqkernel    prom            sunview         xrconf
# chin_test       gs              lib7            psg             tcl             xview
# csi             gshim           limnet          psglib          tune            xwin
# dbmanager       halbug          limnet_ibm      recvproc        userp           yacc
# 
# Jlf category
# categories are:
# acode       ihwcntrl    menujlib    rtvar       sun_bin     sun_test    vnmrj.old
# admin       jplot       parse       seqvar      sun_bo      sun_ui      vnmrjdoc
# arrayps     jpsg        proccom     shrexpinfo  sun_build   sun_util    waveform
# console     jpsgdoc     psgelem     shuffler    sun_shuf    util        xml
# iconsole    managedb    rttable     sun_        sun_store   vnmrj       xprssn
#
# added to previous list: fdm, spincad, vwacqkernelppc
#chosen_categories="3D kpsg tune 3Dimg gacqproc kpsglib procproc \
#		   gapmon kspin accounting glide kvwacq psg vnmr  \
# 		   acqi glnc kvwacqkernel psglib vwacq acqproc gpsg recvproc \
#		   vwacqkernel autoproc gpsglib limnet roboproc autshm gs limnet_ibm  \
#		   vwauto backproj gshim limnet_solaris  scripts vwautokernel bin maclib  \
#		   sendproc vwcom bootg+ manual shapelib bootpd help xracq csi ib menulib \
#	           ddl infoproc motif xrconf decode nacqi stars xview diffusion kapmon \
#		   nautoproc stat xwin dsp kbin ncomm yacc expproc tcl fdm spincad vwacqkernelppc"
#
# for java category
# was just jplot, added: acode, arrayps, copnsole, iconsole, ihwcntrl, jpsg, parse, proccom,
#	                 psgelem rttable, rtvar, seqvar, shreexpinfo, util, waveform, xprssn

# for sccs53
# not done autshm halbug xrbug halmon simul sunview decc
#
# chosen_categories="acqi expproc ncomm scripts vnmr \
#		   acqproc gacqproc psg  vwacq  xrconf \
#		   autoproc  decode  gapmon  nacqi  psglib  xracq   xwin"
#

# --------------------------   10/23/22002  VnmrJ 1.1B  ------------------------------------ 
# sccs categories
# categories are:
# 3D  y            ddl y            halmon n         maclib  y        sccs  n          vwacq y
# 3Dimg  y         decode  n        help  y          manual  y        scripts y        vwacqkernel y
# OLDSCCS  n       dicom   y        ib    y          map2    n        sendproc y       vwacqkernelppc y
# TNT   n          diffusion y      infoproc  y      menulib  y       shapelib y       vwauto y
# accounting  y    dsp y            iso  n           motif y          shimproms n      vwautokernel y
# acqi y           expproc y        kapmon n         nacqi y          simul  n         vwcom y
# acqproc ?        fdm  y           kbin  y          nautoproc  y     specials n       vwtests n
# aip y            gacqi  y         kernel_solaris n ncomm y          spincad  y       xracq n
# autoproc  y      gacqproc y       kpsg  y          npsg  y          stars  y         xrbug n
# autshm n         gapmon  n        kpsglib  y       nvnmr  y         stat  y          xrconf n
# backproj y       glide  y         kspin  y         procproc y       sunview n        xview n
# bin y            glnc  y          kvwacq  y        prom  n          tcl y            xwin y
# bootg+  n        gpsg  y          kvwacqkernel y   psg   y          tune  y          yacc n
# bootpd  y        gpsglib y        lib7 n           psglib  y        userp n
# chin_test n      gs y             limnet n         recvproc y       vms n
# csi y            gshim  y         limnet_ibm n     roboproc y       vnmr y
# dbmanager y      halbug n         limnet_solaris n sas  n          vnmrbg y
#
# Jlf category
# acode y      ihwcntrl y    menujlib y    ptui y        shuffler y    sun_shuf n    util y        xml y
# admin y      jplot y       p11 y         rttable y     sun_ n        sun_store n   vnmrj y       xprssn y
# arrayps y    jpsg y        parse y       rtvar y       sun_bin n     sun_test n    vnmrj.old
# console y    jpsgdoc y     proccom y     seqvar y      sun_bo n      sun_ui n      vnmrjdoc y
# iconsole y   managedb y    psgelem y     shrexpinfo y  sun_build n   sun_util n    waveform y
#
#
#sccs_categories=" 3D 3Dimg accounting acqi acqproc aip autoproc backproj bin bootpd csi \
#		   ddl dicom diffusion dsp expproc fdm gacqi qacqproc glide glnc gpsg gpsglib gs gshim \
#		   help ib infoproc kbin kpsg kpsglib kpsin kvwacq kvwacqkernel \
#		   maclib manual menulib motif nacqi nautoproc ncomm npsg nvnmr procproc psg psglib recvproc roboproc \
#		   scripts sendproc shapelib spincad stars stat tcl tune vnmr vnmrbg \
#		   vwacq vwacqkernel vwacqkernelppc vwauto vwautokernel vwcom xwin"
#SCCSdir="/vsccs/sccs"
#JSCCSdir="/vsccs/jsccs"
#
#
#jsccs_categories="acode admin arrayps console iconsole \
#		  ihwcntrl jplot jpsg jpsgdoc managedb \
#		  menujlib p11 parse proccom psgelem \
#		  ptui rttable rtvar seqvar shrexpinfo \
#		  shuffler util vnmrj vnmrjdoc waveform \
#		  xml xprssn"
#
# --------------------------   03/31/2003  VnmrJ 1.1C  ------------------------------------ 
# categories are:
# 3D y            csi y          gpsg y          kspin y          ncomm y          simul           vwauto y
# 3Dimg  y        dbmanager y    gpsglib y       kvwacq y         npsg  y          specials        vwautokernel y
# OLDSCCS         ddl  y         gs   y          kvwacqkernel y   nvnmr y          spincad y       vwcom y
# TNT             decode         gshim y         lcpeaks y        procproc y       stars y         vwtests
# accounting  y   dicom y        halbug          lib7             prom             stat  y         xracq
# acqi  y         dicom_old      halmon          limnet           psg    y         sunview         xrbug
# acqproc  y      diffusion y    help y          limnet_ibm       psglib y         tcl y           xrconf
# aip   y         dsp  y         ib   y          limnet_solaris   recvproc y       tune y          xview
# autoproc  y     expproc y      infoproc y      maclib y         roboproc y       userp           xwin y
# autshm          fdm   y        iso             manual  y        sas              vms             yacc
# backproj  y     gacqi          kapmon          map2             sccs             vnmr y
# bin    y        gacqproc y     kbin  y         menulib y        scripts y        vnmrbg y
# bootg+          gapmon         kernel_solaris  motif y          sendproc  y      vwacq y
# bootpd  y       glide  y       kpsg  y         nacqi y          shapelib y       vwacqkernel y
# chin_test       glnc    y      kpsglib  y      nautoproc y      shimproms        vwacqkernelppc y
#
# Jlf category
# acode y      ihwcntrl y    menujlib y    ptui y        shuffler y    sun_shuf n    util y        xml y
# admin y      jplot y       p11 y         rttable y     sun_ n        sun_store n   vnmrj y       xprssn y
# arrayps y    jpsg y        parse y       rtvar y       sun_bin n     sun_test n    vnmrj.old
# console y    jpsgdoc y     proccom y     seqvar y      sun_bo n      sun_ui n      vnmrjdoc y
# iconsole y   managedb y    psgelem y     shrexpinfo y  sun_build n   sun_util n    waveform y
#

#sccs_categories=" 3D 3Dimg accounting acqi acqproc aip autoproc backproj bin bootpd csi \
#		   ddl dicom diffusion dsp expproc fdm gacqproc glide glnc gpsg gpsglib gs gshim \
#		   help ib infoproc kbin kpsg kpsglib kspin kvwacq kvwacqkernel lcpeaks \
#		   maclib manual menulib motif nacqi nautoproc ncomm npsg nvnmr procproc psg psglib recvproc roboproc \
#		   scripts sendproc shapelib spincad stars stat tcl tune vnmr vnmrbg \
#		   vwacq vwacqkernel vwacqkernelppc vwauto vwautokernel vwcom xwin"

#SCCSdir="/vsccs/sccs"
#JSCCSdir="/vsccs/jsccs"


#jsccs_categories="acode admin arrayps console iconsole \
#		  ihwcntrl jplot jpsg jpsgdoc managedb \
#		  menujlib p11 parse proccom psgelem \
#		  ptui rttable rtvar seqvar shrexpinfo \
#		  shuffler util vnmrj vnmrjdoc waveform \
#		  xml xprssn"

# --------------------------   03/31/2003  VnmrJ 1.1C  ------------------------------------ 

# --------------------------   06/25/2004  VnmrJ 1.1D  ------------------------------------ 
#sccs_categories=" 3D 3Dimg TNT accounting acqi acqproc aip atproc autoproc backproj bin bootpd csi \
#		   dbmanager ddl dicom dicom_store diffusion dsp expproc fdm gacqproc gapmon \
#                  glide glnc gpsg gpsglib gs gshim help ib infoproc kpsg kpsglib kspin kvwacq \
#                   kvwacqkernel lcpeaks maclib manual menulib motif nacqi nautoproc ncomm \
#                   npsg nvnmr procproc psg psglib recvproc roboproc \
# 		  scripts sendproc shapelib spincad stars stat tcl tune vnmr vnmrbg \
#		   vwacq vwacqkernel vwacqkernelppc vwauto vwautokernel vwcom xwin"

#SCCSdir="/vsccs/sccs"
#JSCCSdir="/vsccs/jsccs"


#jsccs_categories="acode admin arrayps console cryo iconsole \
#		  ihwcntrl jplot jpsg jpsgdoc managedb \
#		  menujlib p11 parse proccom psgelem \
#		  ptui rttable rtvar seqvar shim3d shrexpinfo \
#		  shuffler util vnmrj vnmrjdoc waveform \
#		  xml xprssn"


# --------------------------   06/25/2004  VnmrJ 1.1D  ------------------------------------ 



# --------------------------   01/12/2006  VnmrJ 2.1B  ------------------------------------ 
#sccs_categories=" 3D 3Dimg TNT accounting acqi acqproc aip atproc autoproc backproj bin bootg+ bootpd csi \
#		   dbmanager ddl dicom dicom_store diffusion dsp expproc fdm gacqproc gapmon gif \
#                  glide glnc gpsg gpsglib gs gshim help ib infoproc kapmon kbin kpsg kpsglib kspin kvwacq \
#                   kvwacqkernel lcpeaks limnet limnet_solaris maclib manual menulib motif nacqi nautoproc ncomm \
#                   npsg nvacq nvacqkernel nvdiag nvdsp nvexpproc nvflash nvfpga nvinfoproc \
#		   nvnmr nvpsg nvpsg2 nvrecvproc nvsendproc nvvnmrbg nvvware nvzlib 
#		   procproc psg psglib recvproc roboproc sas \
# 		  scripts sendproc shapelib spincad stars stat tcl tune userp vnmr vnmrbg \
#	          vwacq vwacqkernel vwacqkernelppc vwauto vwautokernel vwcom xwin"
#
##SCCSdir="/vsccs/sccs"
##JSCCSdir="/vsccs/jsccs"
#

#jsccs_categories="acode admin apt arrayps console cryo hermes iconsole \
#		  ihwcntrl jplot jpsg jpsgdoc managedb \
#		  menujlib p11 parse proccom psgelem \
#		  ptui rttable rtvar seqvar shim3d shrexpinfo \
#		  shuffler util vnmrj vnmrjdoc waveform \
#		  xml xprssn"
#

# --------------------------   01/12/2064  VnmrJ 2.1B  ------------------------------------ 

# --------------------------   7/09/2007  VnmrJ 2.2C  ------------------------------------ 
#
#sccs_categories=" 3D 3Dimg TNT accounting acqi acqproc aip atproc autoproc backproj bin bootg+ bootpd csi \
#		   dbmanager ddl dicom dicom_store diffusion dsp expproc fdm gacqproc gapmon gif \
#                  glide glnc gpsg gpsglib gs gshim help ib infoproc \
#                  lcpeaks maclib manual menulib motif nacqi nautoproc ncomm \
#                   npsg nvacq nvacqkernel nvdiag nvdsp nvexpproc nvflash nvfpga nvinfoproc \
#		   nvnmr nvpsg nvrecvproc nvsendproc nvvnmrbg nvvware nvzlib \
#		   procproc psg psglib recvproc roboproc sas \
# 		  scripts sendproc shapelib spincad stars stat tcl tune userp vnmr vnmrbg \
#	          vwacq vwacqkernel vwacqkernelppc vwauto vwautokernel vwcom xwin"
#
#
#
#SCCSdir="/vsccs/sccs"
#JSCCSdir="/vsccs/jsccs"
#
#
#jsccs_categories="acode admin apt arrayps console cryo hermes iconsole \
#		  ihwcntrl jaccount jplot jpsg jpsgdoc managedb \
#		  menujlib p11 parse proccom psgelem \
#		  ptui rttable rtvar seqvar shim3d shrexpinfo \
#		  shuffler util vnmrj vnmrjdoc waveform \
#		  xml xprssn"
#
#
#
# --------------------------   7/09/2007  VnmrJ 2.2C  ------------------------------------ 


# --------------------------   3/21/2008  VnmrJ 2.3A  ------------------------------------ 


sccs_categories=" 3D 3Dimg TNT accounting acqi acqproc aip atproc autoproc backproj bin csi \
		   dbmanager ddl dicom dicom_store diffusion expproc fdm gif \
                  glide glnc gpsg gpsglib gs gshim help ib infoproc \
                  lcpeaks maclib manual menulib motif nacqi nautoproc ncomm \
                   nvacq nvacqkernel nvdiag nvdsp nvexpproc nvflash nvfpga nvinfoproc \
		   nvnmr nvpsg nvrecvproc nvsendproc nvvnmrbg nvvware nvzlib \
		   procproc psg psglib recvproc roboproc sas \
 		  scripts sendproc shapelib spincad stars stat tcl tune userp vnmr vnmrbg \
	          xrecon xwin"



SCCSdir="/vsccs/sccs"
JSCCSdir="/vsccs/jsccs"


jsccs_categories="acode admin apt arrayps console cryo hermes iconsole \
		  ihwcntrl jaccount jplot jpsg jpsgdoc managedb \
		  menujlib p11 parse proccom psgelem \
		  ptui rttable rtvar seqvar shim3d shrexpinfo \
		  shuffler util vnmrj vnmrjdoc waveform \
		  xml xprssn"



# --------------------------   3/21/2008  VnmrJ 2.3A  ------------------------------------ 
#chosen_categories="$sccs_categories"
#sccsdir="$SCCSdir"

#chosen_categories="$jsccs_categories"
#sccsdir="$JSCCSdir"


echo ' Previous releases are: '
ls -C $relmdir/releases
echo ' '
echo -n 'Software Release for this SCCS Level Bump: '
read relnum
if (test ! -d $relmdir/releases/$relnum)
then
   echo "Software Release $relnum is not known"
   exit 1
fi

echo ' '
echo -n 'Automatically Bump SCCS Level 1 above the Max present Delta?(y/n): '
read auto

defyr="`date +'%Y`"

echo ' '
echo -n "New year for update: (1989,1990,1991,etc) default $defyr: "
read yr
if (test "x$yr" = "x")
then
   yr="$defyr"
fi

if test $# -lt 1
then 
 echo Categories are:
 echo $chosen_categories
 echo -n "Category for updating, or all: "
 read answer
else
 answer=$1
 shift 1
fi

if (test ! "x$answer" = "xall")
then
   chosen_categories=$answer
fi

for category in $chosen_categories
do
   echo " "
   echo "Category: $category"

   if (test -d$sccsdir/$category )
   then
    rm -rf *		# remove any files present

# ------ determine max & min delta of SCCS category ------------------
maxldelt=`/usr/ccs/bin/prs -d":R:" ${sccsdir}/${category}/SCCS | awk 'BEGIN { maxrel = 0; minrel = 9999; files = 0;} { if ($1 > maxrel) { maxrel = $1; } if ($1 < minrel) { minrel = $1; } files += 1; } END { printf("%s",maxrel); }'`

echo "Max Level Delta for ${category}: $maxldelt "

# ------ extract all files from SCCS category ------------------
#    sccs  -d/usr24/greg/sccstest get -s SCCS/		# get all files
    sccs  -d$sccsdir/$category get -s SCCS/	# get all files
    filelist=`ls *`
    filecnt=`ls * | wc -w`
    echo " "
    echo "$filecnt SCCS files extracted: "
    ls -C .
    echo " "
    srclines=`cat $filelist | wc -l`
    echo "$srclines Source Lines present."

#   chngCR2 $yr $category

# ------  determine maximum delta present  ----------------
    if (test ! "x$filelist" = "x")
    then
     maxdelta=`what $filelist | awk '$2 > max { max = $2 }; END { print max }'`

     echo " "
     echo "Maximum Delta for present Category $category is $maxdelta"
     if ( test "x$auto" = "xy" )
     then
       newlevel=`expr $maxldelt + 1`
     else
       echo " "
       echo -n "Specifiy New Release Level (e.g., 4, 5, 6, 7, 8, 9, 10, etc.): "
       read newlevel
     fi
     comment="New SCCS Level $newlevel for Software Release $relnum   $datestamp"
     echo " "
     echo $comment
     echo " "
     echo -n "Proceed with Delta Level Change? (y, n) "
     read ans
     if (test "x$ans" = "xy")
     then
#
#  ------ Yank out all files from SCCS for editing with new Level -------
#
       sccs -d$sccsdir/$category get -s -e -r$newlevel SCCS/
#
#  ------- for Each File Mode the Copyright date -------
#
#    if ( test $category != "vnmr") # just used for assemble routines
#    then
#       alycon="y"
#    fi

#    echo -n "Proceed with Copyright Update ? (y, n) "
##    read ans
#    if (test "x$ans" = "xy")
#    then
#     updateCR $yr 
#    fi
 
#
#  ------ Back into SCCS with New Copyright date and comment ----
#
     echo " "
     echo -n "Proceed with Delta ? (last chance to stop) (y, n) "
     read ans
     if (test "x$ans" = "xy")
     then
       sccs -d$sccsdir/$category delta -s -y"$comment" SCCS/
     else
       sccs -d$sccsdir/$category unedit *.[chspyl] make*
     fi
#       sccs -d/usr24/greg/sccstest get -s -e -r$newlevel SCCS/
#       sccs -d/usr24/greg/sccstest delta -s -y"$comment" SCCS/
     else
       echo "Delta Level Change Skipped for Category $category"
     fi
    else
     echo "No files present in Category $category"
    fi
   else
    echo "Category: $category is not present."
   fi
done
cd ..
echo " "
echo "Removing temporary directory: bumprel_tmp."
rm -rf bumprel_tmp		# remove tmp directory
echo " "
echo "Date: `date`"
echo " "
