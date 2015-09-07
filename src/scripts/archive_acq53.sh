: /bin/sh
: '@(#)archive_acq53.sh 22.1 03/24/08 1991-1996 '
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
#
# archive_acq
#	Script to archive the sccs directories and files that are used 
#	for building:
#		acqi
#		acqproc
#		autoproc
#		motif	- non-buildable category
#		psg
#		psglib
#		xwin	- non-buildable category
#		autshm
#		decode
#		halbug
#		halmon
#		simul
#		sunview	- non-buildable category
#		xracq
#		xrbug
#		xrconf
#	a portion of:
#		vnmr
#		- errorcodes.h revdate.c (xracq autshm acqproc psg)
#		- acqerrmsges.h asm.h asmfuncs.c data.h whenmask.h 
#		  (acqproc psg acqi)
#		- allocate.c assign.c pvars.c shims.c symtab.c tools.c
#		  variables1.c vcolor.c tools.h (psg acqi)
#		- allocate.h graphics.h dpsdef.h group.h init.h params.h shims.h
#		  symtab.h tools.h variables.h (psg acqi)
#		- fft.c gdevsw.c graphics.c plot_handlers.c (acqi)
#		expproc
#		- shrexpinfo.h (acqproc psg acqi)
#		- expDoneCodes.h (psg acqi)
#		- expQfuncs.c statfuncs.c expQfuncs.h shrstatinfo.h (acqi)
#		ncomm
#		- mfileObj.h (psg acqi)
#		- errLogLib.h ipcKeyDbm.h ipcMsgQLib.h msgQLib.h
#		  shrMLib.h libacqcomm.a libacqcomm.so libacqcomm.so.6.0 (acqi)
#		nacqi
#		- NDCfuncs.c msgqueue.c IPCmsgqfuncs.c acqInterface.h (acqi)
#		gacqproc
#		- GNETfuncs.c (acqi)
#		gapmon
#		- lc_gem.h (acqi)
#		vwacq
#		- acqcmds.h (acqi)
#	for the UnityPlus, Unity, and VXR acquistion system.
#
# Note: This script can be run by anyone in the software group.
#	It uses environmental parameters:
#
#########################################################################

#
# Declarations
#
sccsdir="/vsccs/sccs"
sccs53dir="/vsccs/sccs53"
sol53dir="/vobj/sol53"
ArchiveDir="acq5.3"

echo "Sccsdir: $sccsdir  Archivedir: $sccs53dir. continue? [y]/n "
read answer
if (test x$answer = "xn")
then
   exit
fi

#
# Make archive directory
#
set -x
  if test ! -d $sccs53dir
  then 
    echo "Creating $sccs53dir directory."
    mkdir $sccs53dir
    chmod g+w $sccs53dir
  fi
set +x

#
# Check for confirmation
#
if test $# -lt 1
then 
 echo "Request confirmation for directory? y/n [default=n]: "
 read confirm
else
 confirm=$1
fi

dirnames="acqi acqproc autoproc psg psglib xwin \
	  autshm decode halbug halmon simul sunview xracq xrbug xrconf \
	  expproc nacqi ncomm vnmr gacqproc gapmon vwacq scripts"

echo " "
for dirname in $dirnames
do
      echo Category $dirname
      case x$dirname in
     	 xacqi | xacqproc | xautoproc | xpsg | xpsglib | xxwin | xautshm | xdecode \
	 | xhalbug | xhalmon | xsimul | xsunview | xxracq | xxrbug | xxrconf )
	    if test ! -d $sccsdir/$dirname
	    then
		echo "SCCS directory $sccsdir/$dirname does not exist"
		continue
	    fi
	    if test x$confirm = "xy"
	    then
		echo "Update $sccs53dir/$dirname ? y/n : "
		read answer
	    else
		answer="y"
	    fi
	    if test x$answer = "xy"
	    then
		   if test -d $sccs53dir/$dirname 
		   then 
		      echo "Removing $sccs53dir/$dirname directory."
		      rm -rf $sccs53dir/$dirname;
		   fi
		   echo "Copying $sccsdir/$dirname to $sccs53dir."
		   cp -rp $sccsdir/$dirname $sccs53dir

  		   srcsize=`du -s $sccsdir/$dirname`
  		   trgsize=`du -s $sccs53dir/$dirname`
		   echo Src: $srcsize   Dst: $trgsize
		   echo " "

	    fi
	 ;;

	 xvnmr )
#
#	    vnmr archives only the files that are used by other
#	    acquistion executables.
#
	    filelist="acqerrmsges.h allocate.h asm.h data.h dpsdef.h \
		errorcodes.h graphics.h group.h init.h params.h shims.h \
		symtab.h variables.h whenmask.h allocate.c asmfuncs.c \
		assign.c fft.c gdevsw.c graphics.c plot_handlers.c pvars.c \
		revdate.c shims.c symtab.c tools.c variables1.c vcolor.c tools.h"

	    if test ! -d $sccsdir/$dirname
	    then
		echo "SCCS directory $sccsdir/$dirname does not exist"
		continue
	    fi
	    if test x$confirm = "xy"
	    then
		echo "Update $sccs53dir/$dirname ? y/n : "
		read answer
	    else
		answer="y"
	    fi
	    if test x$answer = "xy"
	    then
		if test ! -d $sccs53dir/$dirname 
		then 
		    mkdir $sccs53dir/$dirname
		    mkdir $sccs53dir/$dirname/SCCS
		    chmod -R g+w $sccs53dir/$dirname
		fi
		rm -f $sccs53dir/$dirname/SCCS/*
		for file in $filelist
		do
		    set -x
		    cp $sccsdir/$dirname/SCCS/s.$file \
				$sccs53dir/$dirname/SCCS
		    set +x
		done
		echo " "
	    fi

	 ;;

	 xexpproc )
#
#	    vnmr archives only the files that are used by other
#	    acquistion executables.
#
	    filelist="expDoneCodes.h expQfuncs.h shrexpinfo.h shrstatinfo.h \
		expQfuncs.c statfuncs.c"

	    if test ! -d $sccsdir/$dirname
	    then
		echo "SCCS directory $sccsdir/$dirname does not exist"
		continue
	    fi
	    if test x$confirm = "xy"
	    then
		echo "Update $sccs53dir/$dirname ? y/n : "
		read answer
	    else
		answer="y"
	    fi
	    if test x$answer = "xy"
	    then
		if test ! -d $sccs53dir/$dirname 
		then 
		    mkdir $sccs53dir/$dirname
		    mkdir $sccs53dir/$dirname/SCCS
		    chmod -R g+w $sccs53dir/$dirname
		fi
		rm -f $sccs53dir/$dirname/SCCS/*
		for file in $filelist
		do
		    set -x
		    cp $sccsdir/$dirname/SCCS/s.$file \
				$sccs53dir/$dirname/SCCS
		    set +x
		done
		echo " "
	    fi

	 ;;

	 xncomm )
#
#	    vnmr archives only the files that are used by other
#	    acquistion executables.
#
	    filelist="errLogLib.h ipcKeyDbm.h ipcMsgQLib.h mfileObj.h  \
		msgQLib.h shrMLib.h"

	    if test ! -d $sccsdir/$dirname
	    then
		echo "SCCS directory $sccsdir/$dirname does not exist"
		continue
	    fi
	    if test x$confirm = "xy"
	    then
		echo "Update $sccs53dir/$dirname ? y/n : "
		read answer
	    else
		answer="y"
	    fi
	    if test x$answer = "xy"
	    then
		if test ! -d $sccs53dir/$dirname 
		then 
		    mkdir $sccs53dir/$dirname
		    mkdir $sccs53dir/$dirname/SCCS
		    chmod -R g+w $sccs53dir/$dirname
		fi
		rm -f $sccs53dir/$dirname/SCCS/*
		for file in $filelist
		do
		    set -x
		    cp $sccsdir/$dirname/SCCS/s.$file \
				$sccs53dir/$dirname/SCCS
		    set +x
		done
		if test ! -d $sol53dir/proglib/ncomm 
		then 
		    mkdir $sol53dir/proglib/ncomm
		    mkdir $sol53dir/proglib/ncomm
		    chmod -R g+w $sol53dir/proglib/ncomm
		fi
	        filelist="libacqcomm.a libacqcomm.so libacqcomm.so.6.0"
		for file in $filelist
		do
		    set -x
		    cp /vobj/sol/proglib/ncomm/$file \
				$sol53dir/proglib/ncomm
		    set +x
		done
		echo " "
	    fi

	 ;;

	 xnacqi )
#
#	    vnmr archives only the files that are used by other
#	    acquistion executables.
#
	    filelist="NDCfuncs.c msgqueue.c IPCmsgqfuncs.c acqInterface.h"

	    if test ! -d $sccsdir/$dirname
	    then
		echo "SCCS directory $sccsdir/$dirname does not exist"
		continue
	    fi
	    if test x$confirm = "xy"
	    then
		echo "Update $sccs53dir/$dirname ? y/n : "
		read answer
	    else
		answer="y"
	    fi
	    if test x$answer = "xy"
	    then
		if test ! -d $sccs53dir/$dirname 
		then 
		    mkdir $sccs53dir/$dirname
		    mkdir $sccs53dir/$dirname/SCCS
		    chmod -R g+w $sccs53dir/$dirname
		fi
		rm -f $sccs53dir/$dirname/SCCS/*
		for file in $filelist
		do
		    set -x
		    cp $sccsdir/$dirname/SCCS/s.$file \
				$sccs53dir/$dirname/SCCS
		    set +x
		done
		echo " "
	    fi

	 ;;

	 xgacqproc )
#
#	    vnmr archives only the files that are used by other
#	    acquistion executables.
#
	    filelist="GNETfuncs.c"

	    if test ! -d $sccsdir/$dirname
	    then
		echo "SCCS directory $sccsdir/$dirname does not exist"
		continue
	    fi
	    if test x$confirm = "xy"
	    then
		echo "Update $sccs53dir/$dirname ? y/n : "
		read answer
	    else
		answer="y"
	    fi
	    if test x$answer = "xy"
	    then
		if test ! -d $sccs53dir/$dirname 
		then 
		    mkdir $sccs53dir/$dirname
		    mkdir $sccs53dir/$dirname/SCCS
		    chmod -R g+w $sccs53dir/$dirname
		fi
		rm -f $sccs53dir/$dirname/SCCS/*
		for file in $filelist
		do
		    set -x
		    cp $sccsdir/$dirname/SCCS/s.$file \
				$sccs53dir/$dirname/SCCS
		    set +x
		done
		echo " "
	    fi

	 ;;

	 xgapmon )
#
#	    vnmr archives only the files that are used by other
#	    acquistion executables.
#
	    filelist="lc_gem.h"
	    if test ! -d $sccsdir/$dirname
	    then
		echo "SCCS directory $sccsdir/$dirname does not exist"
		continue
	    fi
	    if test x$confirm = "xy"
	    then
		echo "Update $sccs53dir/$dirname ? y/n : "
		read answer
	    else
		answer="y"
	    fi
	    if test x$answer = "xy"
	    then
		if test ! -d $sccs53dir/$dirname 
		then 
		    mkdir $sccs53dir/$dirname
		    mkdir $sccs53dir/$dirname/SCCS
		    chmod -R g+w $sccs53dir/$dirname
		fi
		rm -f $sccs53dir/$dirname/SCCS/*
		for file in $filelist
		do
		    set -x
		    cp $sccsdir/$dirname/SCCS/s.$file \
				$sccs53dir/$dirname/SCCS
		    set +x
		done
		echo " "
	    fi

	 ;;

	 xvwacq )
#
#	    vnmr archives only the files that are used by other
#	    acquistion executables.
#
	    filelist="acqcmds.h hostAcqStructs.h"
	    if test ! -d $sccsdir/$dirname
	    then
		echo "SCCS directory $sccsdir/$dirname does not exist"
		continue
	    fi
	    if test x$confirm = "xy"
	    then
		echo "Update $sccs53dir/$dirname ? y/n : "
		read answer
	    else
		answer="y"
	    fi
	    if test x$answer = "xy"
	    then
		if test ! -d $sccs53dir/$dirname 
		then 
		    mkdir $sccs53dir/$dirname
		    mkdir $sccs53dir/$dirname/SCCS
		    chmod -R g+w $sccs53dir/$dirname
		fi
		rm -f $sccs53dir/$dirname/SCCS/*
		for file in $filelist
		do
		    set -x
		    cp $sccsdir/$dirname/SCCS/s.$file \
				$sccs53dir/$dirname/SCCS
		    set +x
		done
		echo " "
	    fi

	 ;;

	 xscripts )
#
#	    vnmr archives only the files that are used by other
#	    acquistion executables.
#
	    filelist="seqgen.sh xseqpreen.sh booleanpreen.sh"
	    if test ! -d $sccsdir/$dirname
	    then
		echo "SCCS directory $sccsdir/$dirname does not exist"
		continue
	    fi
	    if test x$confirm = "xy"
	    then
		echo "Update $sccs53dir/$dirname ? y/n : "
		read answer
	    else
		answer="y"
	    fi
	    if test x$answer = "xy"
	    then
		if test ! -d $sccs53dir/$dirname 
		then 
		    mkdir $sccs53dir/$dirname
		    mkdir $sccs53dir/$dirname/SCCS
		    chmod -R g+w $sccs53dir/$dirname
		fi
		rm -f $sccs53dir/$dirname/SCCS/*
		for file in $filelist
		do
		    set -x
		    cp $sccsdir/$dirname/SCCS/s.$file \
				$sccs53dir/$dirname/SCCS
		    set +x
		done
		echo " "
	    fi

	 ;;

         *)      
	    echo Updating not supported for \'"$dirname"\' ;
	 ;;
      esac
		
done
