: '@(#)vmake.sh 22.1 03/24/08 1991-1997 '
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

:		Author:  Greg Brissey
:  "make a vnmr for the user from the libraries"
:  "vmake aliases - creates the aliases of vmake"
#
:  "vmake vnmr - defaults in creating a FPC  Vnmr"
:  "vmake dbx - creates a FPC dbx version of Vnmr"
:  "vmake prof - creates a FPC profiling version of Vnmr"
:  "vmakefpa - creates a Floating Point Accelerator Vnmr"
:  "vmakefpa dbx - creates a FPA dbx version of Vnmr"
:  "vmakefpa prof - creates a FPA profiling version of Vnmr"
:  "vmakeap - creates an Array Processor Vnmr"
:  "vmakeap dbx - creates an AP dbx version of Vnmr"
:  "vmakeap prof - creates an AP profiling version of Vnmr"
:  "vmakefpaap - creates a Floating Point Accelerator and Array Processor Vnmr"
:  "vmakefpaap dbx - creates a FPA & AP dbx version of Vnmr"
:  "vmakefpaap prof - creates a FPA & AP profiling version of Vnmr"
:  "xmake vnmr - defaults in creating a FPC  Vnmr"
:  "xmake dbx - creates a FPC dbx version of Vnmr"
:  "xmake nessie - creates a NDC version of Vnmr for X windows"
:  "xmake inova  - same as xmake nessie"

# "vnmrdir is an environment variable"
# "only export FLOAT_OPTION if on a SUN3"
# "should remove definition below, but that is more complex
# "the export command is the key"

#  removed SCCSGET -  used to define GETSCRS for makevnmr to use,
#  but makevnmr no longer uses it.
#
#  New for Solaris/SunOS
#     svr4          is this a SVR4 or a BSD system
#     ostype        exact type of OS
#
#     get_arch      shell function which duplicates SunOS command arch
#     get_mach      shell function which duplicates SunOS command mach

common_env()
{
    ostype=`uname -s`
    osmajor=`uname -r | awk 'BEGIN { FS = "." } { print $1 }'`

    if [ $osmajor -lt  5 ]
    then
        svr4="n"
    else
        svr4="y"
        ostype="solaris"
    fi
}

get_arch()
{
    uname -m | awk '{ print substr( $0, 1, 4 ) }'
}

get_mach()
{
    if [ x$svr4 = "xy" ]
    then
        uname -p
    else
        mach
    fi
}

common_env

VNMRDIR=$vnmrdir

if (test x$svr4 = "xy")
then
  LIBDIR=$solobjdir/proglib/vnmr
  ARCHDIR=$solobjdir/proglib
  APNORMLIBS='-lXol -lXt -lX11 -ll -lm -lsocket -lnsl'
  NORMLIBS='-lXol -lXt -lX11 -ll -lm -lsocket -lnsl'
  PROFLIBS='-lXol -lXt -lX11 -ll -lm -lsocket -lnsl'
  echo "SOLARIS libraries in $LIBDIR will be Used."
  echo
elif (test `get_arch` = "sun3")
then
  LIBDIR=$sun3objdir/proglib/vnmr
  ARCHDIR=$sun3objdir/proglib
  APNORMLIBS='-lcurses -ltermlib -lsuntool -lsunwindow -lpixrect -lwarlib -ll -lm'
  NORMLIBS='-lcurses -ltermlib -lsuntool -lsunwindow -lpixrect -ll -lm'
  PROFLIBS='-lcurses -ltermlib -lsuntool -lsunwindow -lpixrect -ll -lm'
#  PROFLIBS='-lcurses -ltermlib -lsuntool_p -lsunwindow_p -lpixrect_p -ll -lm'
  export FLOAT_OPTION
  echo "SUN3 libraries in $LIBDIR will be Used."
  echo
else
  LIBDIR=$sun4objdir/proglib/vnmr
  ARCHDIR=$sun4objdir/proglib
  APNORMLIBS='-lcurses -ltermlib -lsuntool -lsunwindow -lpixrect -ll -lm'
  NORMLIBS='-lcurses -ltermlib -lsuntool -lsunwindow -lpixrect -ll -lm'
  PROFLIBS='-lcurses -ltermlib -lsuntool -lsunwindow -lpixrect -ll -lm'
#  PROFLIBS='-lcurses -ltermlib -lsuntool_p -lsunwindow_p -lpixrect_p -ll -lm'
  echo "SUN4 libraries in $LIBDIR will be Used."
  echo
fi

#  SVLIBS is the list of libraries for SunView (SunOS 4.1.x only)
#  OWLIBS is the list of libraries for OpenWindows.
#     The exact list changes, SunOS and Solaris
#  MLIBS is the (expected) list for Motif
#
#  INCDIR is now set to search only the current working directory.
#     For VNMR source files the make file makevnmr is expected to
#     create links to the source directory for any required include
#     files.  For other source files you are on your own.

SVLIBS="-lcurses -ltermlib -lsuntool -lsunwindow -lpixrect -ll -lm"

if (test x$svr4 = "xy")
then
    OWLIBS="-lXol -lXt -lX11 -ll -lm -lsocket -lnsl"
else
    OWLIBS="-lcurses -ltermlib -lXol -lXt -lX11 -ll -lm"
fi
MLIBS="-lXm -lXt -lX11 -ll -lm -lsocket -lnsl"
INCDIR='-I.'

SCCSCAT=vnmr
MAKEFILE=makevnmr

#export FLOAT_OPTION
LIBS="$SVLIBS"
name=`basename $0`
case x$name in
     xvmake)	
                FPO="-DFPC"
		FLOAT_OPTION=f68881
		LIBSUFIX=
		LIBSKY=
		OPLINKFLG=
		;;
     xxmake)	
                FPO="-DFPC"
		FLOAT_OPTION=f68881
		LIBSUFIX=
		LIBSKY=
		OPLINKFLG=
		LIBS="$MLIBS"
	        XVIEW="yes"
		;;
     xvmakefpa)	
                FPO='-Dfpa -DFPA'
		FLOAT_OPTION=ffpa
		LIBSUFIX=fpa
		LIBSKY=
		OPLINKFLG=
		;;
     xvmakeap)	
                FPO="-Dap -DAP"
		FLOAT_OPTION=f68881
		LIBSUFIX=ap
		LIBSKY="$ARCHDIR/ap/skyaplib.a -lwarlib"
		OPLINKFLG="-align _skywar"
		;;
     xvmakefpaap)	
                FPO="-Dfpa -DFPA -DAP -Dap"
		FLOAT_OPTION=ffpa
		LIBSUFIX=fpaap
		LIBSKY="$ARCHDIR/ap/skyfpaaplib.a -lwarlib"
		OPLINKFLG="-align _skywar"
		;;

        *)      
		echo illegal compilation type \'"$1"\' 
		exit 1 ;;
esac
if ( test $# -lt 1 )
then
   echo 'usage- vmake      target user_cflags'
   echo '       vmakeap    target user_cflags'
   echo '       vmakefpa   target user_cflags'
   echo '       vmakefpaap target user_cflags'
   echo ' '
   echo '	target = vnmr,dbx,prof'
   echo ' '
   echo '  e.g. vmake vnmr -DSIS, where -DSIS is a C compiler option'
   echo ' '
   echo '         If vmake tries to get your .c file out of sccs and fails '
   echo '       because it is writable (as you would expect), just touch'
   echo '       the file and redo the vmake.'
   echo ' '
   echo '       If aliases of vmake are not present, then '
   echo '       "vmake aliases" will make them. '
   echo ' '
   echo ' Install in the $vnmrdir/bin directory, for PAID $vnmrdir=/jaws'
   exit 1
else
   case x$1 in
     xaliases)	
		ln -s vmake vmakefpa
		ln -s vmake vmakeap
		ln -s vmake vmakefpaap
		ln -s vmake xmake
		exit 1
		;;

     xnessie | xinova)
	        if (test x$XVIEW = "xyes")
	        then
		  PROGNAM=Vnmr_ow
		  LIBU=$LIBDIR/unmrlib.ow.a
		  LIBM=$LIBDIR/magiclib.ow.a
		  LIBN=$ARCHDIR/ncomm/libacqcomm.a
 		  LIBS=$MLIBS
		  CCOPTIONS="-O -fsingle -DMOTIF -DBSDACQ -DNESSIE -I$(OPENWINHOME)/include -I/usr/dt/include"
		  CPPOPTIONS="-DSUN -DX11"
		  LPCCOPTIONS="-O4 -fsingle -dalign" 
		  LDOPTIONS="-L$(OPENWINHOME)/lib -L/usr/dt/lib -L/vnmr/lib -R /vnmr/lib:/usr/openwin/lib"
		  LIBINC=''
		  LNVAL=_ow
		else
		  PROGNAM=Vnmr${LIBSUFIX}
		  LIBU=$LIBDIR/unmrlib${LIBSUFIX}.a
		  LIBM=$LIBDIR/magiclib${LIBSUFIX}.a
		  LIBN=$ARCHDIR/ncomm/libacqcomm.a
 		  LIBS=$SVLIBS
		  CCOPTIONS="-O -fsingle -DBSDACQ -DNESSIE"
		  LPCCOPTIONS="-O4 -fsingle -dalign" 
		  LNVAL=$LIBSUFIX
		fi
		OPTIMIZES="-S -O"
		LIBINC=''

		;;

     xvnmr)	
	        if (test x$XVIEW = "xyes")
	        then
		  PROGNAM=Vnmr_ow
		  LIBU=$LIBDIR/unmrlib.ow.a
		  LIBM=$LIBDIR/magiclib.ow.a
		  LIBN=$LIBDIR/libacqcomm.a
 		  LIBS=$OWLIBS
		  CCOPTIONS="-O -fsingle -DMOTIF -DBSDACQ -I$(OPENWINHOME)/include -I/usr/dt/include"
		  CPPOPTIONS="-DSUN -DX11"
		  LPCCOPTIONS="-O4 -fsingle -dalign" 
		  LDOPTIONS="-L$(OPENWINHOME)/lib"
		  LIBINC=''
		  LNVAL=_ow
		else
		  PROGNAM=Vnmr${LIBSUFIX}
		  LIBU=$LIBDIR/unmrlib${LIBSUFIX}.a
		  LIBM=$LIBDIR/magiclib${LIBSUFIX}.a
		  LIBN=$LIBDIR/libacqcomm.a
 		  LIBS=$SVLIBS
		  CCOPTIONS="-O -fsingle -DBSDACQ"
		  LPCCOPTIONS="-O4 -fsingle -dalign" 
		  LNVAL=$LIBSUFIX
		fi
		OPTIMIZES="-S -O"
		LIBINC=''
		;;

#-------------- Debugging with DBXTOOL compile flags 
     xdbx)	
	        if (test x$XVIEW = "xyes")
	        then
		  PROGNAM=Vnmr_ow_dbx
		  LIBU=$LIBDIR/unmrlib_dbx.ow.a
		  LIBM=$LIBDIR/magiclib_dbx.ow.a
		  LIBN=$LIBDIR/libacqcomm.a
 		  LIBS=$OWLIBS
		  CCOPTIONS="-g -fsingle -Bstatic -DDBXTOOL -DMOTIF -DBSDACQ -I$(OPENWINHOME)/include -DDEBUG"
		  CPPOPTIONS="-DSUN -DX11"
		  LPCCOPTIONS="-g -fsingle -Bstatic -DDBXTOOL -DBCDACQ -DDEBUG" 
		  LDOPTIONS="-g -Bstatic -L$(OPENWINHOME)/lib -N"
		  LIBINC=''
		  LNVAL=_ow_dbx
		else
		  PROGNAM=Vnmr_dbx
		  LIBU=$LIBDIR/unmrlib_dbx.a
		  LIBM=$LIBDIR/magiclib_dbx.a
		  LIBN=$LIBDIR/libacqcomm.a
 		  LIBS=$SVLIBS
		  CCOPTIONS="-g -fsingle -Bstatic -DDBXTOOL  -DDEBUG -DBSDACQ"
		  CPPOPTIONS="-DDBXTOOL -DDEBUG"
		  LPCCOPTIONS="-g -fsingle -Bstatic -DDBXTOOL -DBCDACQ -DDEBUG" 
		  LDOPTIONS="-g -Bstatic $OPLINKFLG -N"
		  LIBINC=''
		  LNVAL=${LIBSUFIX}_dbx
		fi

		  OPTIMIZES="-S -g"
		;;

#-------------- gprof profiling compile flags 
     xprof)	
		PROGNAM=Vnmr${LIBSUFIX}_p
		CPPOPTIONS="-DPROFILE"
		CCOPTIONS="-pg -O"
		LPCCOPTIONS="-pg -O4 -dalign"
		OPTIMIZES="-S -pg -O"
		LDOPTIONS="-Bstatic $OPLINKFLG"
		LIBU=$LIBDIR/unmrlib${LIBSUFIX}_p.a
		LIBM=$LIBDIR/magiclib${LIBSUFIX}_p.a
		LIBN=$LIBDIR/libacqcomm.a
 		LIBS=$PROFLIBS
		LNVAL=${LIBSUFIX}_p
		;;
        *)      
		echo illegal target \'"$1"\' 
		echo 'legal targets vnmr,dbx,prof,inova,nessie' 
		exit 1 ;;
   esac
fi
if (test -f $VNMRDIR/sysvnmr/make_in_progress)
then
    echo 'W A R N I N G:  A make of the vnmr libraries is in progress'
    echo 'This vmake may not succeed.'
fi

# determine if any of the sources have been change since last library update

newerU=`find $sourcedir/sysvnmr  -newer $LIBU -print | wc -l`
newerM=`find $sourcedir/sysvnmr  -newer $LIBM -print | wc -l`
newerN=`find $sourcedir/sysvnmr  -newer $LIBN -print | wc -l`
if (test $newerU -gt 0) || (test $newerM -gt 0) || (test $newerN -gt 0)
then
echo '========================================================================='
echo 'W A R N I N G:  These Sources have been changed since Last Library Update.'
echo " "
find $sourcedir/sysvnmr  -newer $LIBU -print
#find $sourcedir/sysvnmr  -newer $LIBM -print
find $sourcedir/sysvnmr  -newer $LIBN -print
echo '========================================================================='
fi

#

if test -f makevnmr
then
    MAKEVNMR=$MAKEFILE
else
    MAKEVNMR=$sourcedir/sys${SCCSCAT}/${MAKEFILE}
fi

rm -f Vnmr
shift 1
if (test x$svr4 = "xy")
then
    make -f $MAKEVNMR fromlibs \
 "OBJ=`ls -C *.c | sed s/\\\.c/\\\.o/g | tr '\012' ' '`" \
 "OBJS=`ls -C *.s| sed s/\\\.s/\\\.o/g | tr '\012' ' '`" \
 "LEXOBJ=`ls -C magic.lex.l| sed s/lex\\\.l/lex\\\.o/g | tr '\012' ' '`" \
 "GRAMOBJ=`ls -C magic.gram.y| sed s/gram\\\.y/gram\\\.o/g | tr '\012' ' '`" \
 "CFLAGS= -DSOLARIS $CCOPTIONS $*" "SCFLAGS= $OPTIMIZES $*" \
 "LPCFLAGS= $LPCCOPTIONS $*"	\
 "LDFLAGS= $LDOPTIONS" \
 "CPPFLAGS=$INCDIR $CPPOPTIONS $FPO -DSUN -D`get_arch` -D`get_mach`" \
 "REV_DATE=`date '+%h %d, %y'`" \
 "COMDATE=Compiled: `date '+%m/%d/%y %H:%M'`" \
 "Vnmr=$PROGNAM" \
 "ld_LIBS=$LIBS" \
 "LIBINC=$LIBINC" \
 "YACCDIR=/vobj/sol" \
 "UNMRLIB= $LIBU" "MAGICLIB= $LIBM" "SKYLIB= $LIBSKY" "ACQCOMMLIB= $LIBN"
else
    make -f $MAKEVNMR fromlibs \
 "OBJ=`ls -C *.c | sed s/\\\.c/\\\.o/g | tr '\012' ' '`" \
 "OBJS=`ls -C *.s| sed s/\\\.s/\\\.o/g | tr '\012' ' '`" \
 "LEXOBJ=`ls -C magic.lex.l| sed s/lex\\\.l/lex\\\.o/g | tr '\012' ' '`" \
 "GRAMOBJ=`ls -C magic.gram.y| sed s/gram\\\.y/gram\\\.o/g | tr '\012' ' '`" \
 "CFLAGS= $CCOPTIONS $*" "SCFLAGS= $OPTIMIZES $*" \
 "LPCFLAGS= $LPCCOPTIONS $*"	\
 "LDFLAGS= $LDOPTIONS" \
 "CPPFLAGS=$INCDIR $CPPOPTIONS $FPO -DSUN -D`get_arch` -D`get_mach`" \
 "REV_DATE=`date '+%h %d, %y'`" \
 "COMDATE=Compiled: `date '+%m/%d/%y %H:%M'`" \
 "Vnmr=$PROGNAM" \
 "ld_LIBS=$LIBS" \
 "LIBINC=$LIBINC" \
 "YACCDIR=/vobj/`get_arch`" \
 "UNMRLIB= $LIBU" "MAGICLIB= $LIBM" "SKYLIB= $LIBSKY" \
 "ACQCOMMLIB= $LIBN"
fi

set -x
if ( test $LNVAL )
then
ln Vnmr${LNVAL} Vnmr
fi
