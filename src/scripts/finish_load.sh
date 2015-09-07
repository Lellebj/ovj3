: '@(#)finish_load.sh 22.1 03/24/08 1991-1996 '
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
: /bin/sh
#
#  Store name of command, so it can remove itself when complete.
#
#  Added option of `norewind', expressed as an optional argument.
#  Use is with VNMR, for that tape now has 6 files; the two extra
#  are required because the SPARCstation 1 has a different kernel
#  from the other SPARC systems.
#

#  a system-independent echo w/no-new-line
#  Note:  insists on an environmental variable sysV being defined.

nnl_echo() {
    if test x$sysV = "x"
    then
        echo "error in echo-no-new-line: sysV not defined"
        exit 1
    fi

    if test $sysV = "y"
    then
        if test $# -lt 1
        then
            echo
        else
            echo "$*\c"
        fi
    else
        if test $# -lt 1
        then
            echo
        else
            echo -n $*
        fi
    fi
}

#-------------------------------------------------------
# double check for ar or tar files
# wait till they've been moved, then continue

wait_for_tars_to_move() {
        while  ntars=`ls *.*ar* 2>/dev/null | wc -w`
        do
            if test $ntars -gt 0 
            then
               sleep 1
            else
               break
            fi
        done
}

#-------------------------------------------------------
#  Main program starts here
#
#  Note:  Use basename command to get name of command;
#  it avoids nonsense like ./finish_load as the name of the command

cmdname=`basename $0`

#-------------------------------------------------------
#  Figure out System V vs. SunOS
#  Only works on Sun systems ...  not IBM

if [ x$ostype = "xAIX" -o x$ostype = "xIRIX" -o x$ostype = "xSOLARIS" ]
then
   sysV="y"
else
   sysV="n"
fi

rewind=1
if test $# -eq 1
then
   if test $1 = "norewind"
   then
       rewind=0
   fi
fi

#-------------------------------------------------------
#  Program assumes it receives tapedrive and ntapedrive
#  as exports from parent.  If not defined, use default
#  value of /dev/rst8 for tapedrive, /dev/nrst8 for
#  ntapedrive (no-rewinding tape drive)

if [ x$tapedrive = "x" ]
then
   if [ x$ostype = "xAIX" ]
   then
       tapedrive="/dev/rmt0"
       ntapedrive="/dev/rmt0.1"
       tapecmd="tctl -f"
       tapeop=xvfB
       blksize=""
   else if [ x$ostype = "xIRIX" ]
	then
	   tapedrive="/dev/tapens"
	   ntapedrive="/dev/nrtapens"
	   tapecmd="mt -t"
           tapeop=xvfb
           blksize=20
	else
	   tapedrive="/dev/rst8"
	   ntapedrive="/dev/nrst8"
	   tapecmd="mt -f"
	   tapeop=xvfb
	   blksize=2000
	fi
   fi
fi

#-------------------------------------------------------
#  Program assumes it receives atype, ktype and osver 
#  as exports from parent.  If not define, use default
#  value of "sun4" for atype; "none" for ktype
#
#  Starting with Solaris-compatible, we default to "sun4"

if [ x$atype = "x" ]
then
    if [ x$ostype = "xAIX" ]
    then
         atype="ibm"
    else if [ x$ostype = "xIRIX" ]
	 then
            atype="sgi"
	 else
            atype="sun4"
	 fi
    fi
fi

if ( test x$ktype = "x" )
then
    ktype="none"
fi

if ( test x$vnmros = "x" )
then
    vnmros="SunOS"
    if (test -f VnmrI_5.1a)
    then
        vnmros="AIX"
    else if (test -f VnmrSGI_5.1a)
         then
             vnmros="IRIX"
         fi
    fi
fi

if [ $vnmros = "SunOS" -o $vnmros = "SOLARIS" ]
then
    fskip=1
else
    fskip=0
fi

if ( test $ktype != "none" )
then
#  Tape has two sun4c 4.1.3 kernels.  ndma version is for older Unity systems
#  interfaces with the non-DMA HAL version.  Program asks if it cannot decide
    if [ $ktype = "sun4c" -a $osver = "4.1.3_U1" ]
    then
        if [ x$uplus != "xy" ]
         then
            nnl_echo "Does your system have a DMA HAL board? (y or n) [y]: "
            read a
            if ( test x$a = "xn" )
            then
               ktype=${ktype}_ndma
            fi
        fi
    fi
fi
 
ow3="y"
if ( test x$vnmros = "xSunOS" )
then
  if (test -f VnmrX_5.1a)
  then
    if [ $osver = "4.1.1" -o $osver = "4.1.2" ]
    then
       echo " "
       nnl_echo "Will OpenWindows Ver. 3 (rather than Ver. 2) be used? (y or n) [y]: "
       read ow3
    fi
  fi
fi

echo " "
echo "Current working directory is " `pwd`
nnl_echo "Start software installation in this directory? (y or n) [y]: "
read a
if ( test x$a = "xn" )
then
    exit 1;
fi
#
#  rewind the tape, to place it at a known position
#
#-------------------------------------------------------
#  Program assumes it receives REMOTE, REMOTE_HOST 
#  as exports from parent.  If not define, use default
#  value of 0 for REMOTE; "" for REMOTE_HOST

if [ x$REMOTE_HOST = "x" ]
then
   REMOTE_HOST="NA"
   REMOTE_LOG="nobody"
   REMOTE=0
fi

if [ $REMOTE -eq 0 ]
then
 $tapecmd $tapedrive rewind
 if [ "$?" -ne 0 ]
 then
     echo "$cmdname : Problem with $tapedrive"
     exit 1
 fi
 $tapecmd $ntapedrive fsf 1             # skip first tar file
 if [ "$?" -ne 0 ]
 then
     echo "$cmdname : Problem with $ntapedrive"
     exit 1
 fi
else
 rsh $REMOTE_HOST -n -l $REMOTE_LOG $tapecmd $tapedrive rewind
 rsh $REMOTE_HOST -n -l $REMOTE_LOG $tapecmd $ntapedrive fsf 1
fi

echo "Loading Common Files."
if [ $REMOTE -eq 0 ]
then
 tar $tapeop $ntapedrive $blksize `cat common.choices`  # load common files
 $tapecmd $ntapedrive fsf $fskip        # skip past eof mark to next tar file
else
 rsh $REMOTE_HOST -n -l $REMOTE_LOG dd if=$ntapedrive bs=2000b | tar $tapeop - $blksize `cat common.choices`
# no need to fsf tape with dd
fi

kid=0
ntars=`ls *.*ar* 2>/dev/null`
if test ! "x$ntars" = "x"
then
  echo "Decompressing common."
  ./installdecomp &
  kid=$!
fi

# double check for ar or tar files,
# wait till they've been moved, then continue

wait_for_tars_to_move

echo "Loading Object Files."
if [ $REMOTE -eq 0 ]
then
    if ( test $ktype != "none" )
    then
       tar $tapeop $ntapedrive $blksize `cat ${ctype}.choices` ${ktype}_${osver}.tar
    else
       tar $tapeop $ntapedrive $blksize `cat ${ctype}.choices`
    fi
else
    if ( test $ktype != "none" )
    then
       rsh $REMOTE_HOST -n -l $REMOTE_LOG dd if=$ntapedrive bs=2000b | tar $tapeop - $blksize `cat ${ctype}.choices` ${ktype}_${osver}.tar
    else
       rsh $REMOTE_HOST -n -l $REMOTE_LOG dd if=$ntapedrive bs=2000b | tar $tapeop - $blksize `cat ${ctype}.choices`
    fi
fi

kid2=0
ntars=`ls *.*ar* 2>/dev/null`
if test ! "x$ntars" = "x"
then
  echo "Decompressing Objects."
  ./installdecomp &
  kid2=$!
fi

if test $rewind -ne 0
then
    echo "Rewinding the Tape"
    if [ $REMOTE -eq 0 ]
    then
      $tapecmd $tapedrive rewind     # rewind tape for good measure
    else
      rsh $REMOTE_HOST -n -l $REMOTE_LOG $tapecmd $tapedrive rewind
    fi
fi
rm *.choices

if test $kid -ne 0
then
  echo "Pausing for decompression of common to complete."
  wait $kid
fi

if ( test x$ow3 = "xn" )
then
    cp user_templates/openwin-init_ow2 user_templates/.openwin-init
    cp user_templates/openwin-menu_ow2 user_templates/.openwin-menu
    cp user_templates/xinitrc_ow2 user_templates/.xinitrc
fi

if test $kid2 -ne 0
then
  echo "Pausing for decompression of objects to complete."
  wait $kid2
fi

rm Vnmr*_*

echo "Load Complete."
echo " "
echo "Reconfiguring files... "
echo " "
rm -f installdecomp		# remove decompression command
rm $cmdname			# remove this command
exit 0
