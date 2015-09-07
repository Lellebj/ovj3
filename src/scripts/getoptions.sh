: '@(#)getoptions.sh 22.1 03/24/08 1991-1996 '
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

common_env() {

#  ostype:  IBM: AIX  Sun: SunOS  SGI: IRIX

    ostype=`vnmr_uname`

    if [ x$ostype = "xAIX" ]
    then
        osver=`uname -v`.`uname -r`
        sysV="y"
        ktype="AIX"
        atype="ibm"
        user=`whoami`
    else if [ x$ostype = "xIRIX" ]
	 then
             osver=`uname -r`
             sysV="y"
             ktype="IRIX"
             atype="sgi"
             user=`whoami`
         else
             osver=`uname -r`
             atype="sun4"
             if [ x$ostype = "xSOLARIS" ]
             then
           	sysV="y"
                ktype="solaris"
	        user=`id | sed -e 's/[^(]*[(]\([^)]*\)[)].*/\1/'`
             else
          	sysV="n"
                ktype=`uname -m`
	        user=`whoami`
             fi
	 fi
    fi
}

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

define_tape() {
  if [ $ostype = "AIX" ]
  then
    tdrive="rmt0"
    ndrive="rmt0.1"
    tapecmd="tctl -f"
    tapeop=xvfb
    blksize=20
  else if [ $ostype = "IRIX" ]
     then
        tdrive="tapens"
        ndrive="nrtapens"
        tapecmd="mt -t"
        tapeop=xvfb
        blksize=20
     else if [ $ostype = "SOLARIS" ]
        then
    	   tdrive="rmt/0mb"
	   ndrive="rmt/0mbn"
	   tapecmd="mt -f"
	   tapeop=xvf
	   blksize=""
        else
    	   tdrive="rst8"
	   ndrive="nrst8"
	   tapecmd="mt -f"
	   tapeop=xvfb
	   blksize=2000
        fi
     fi
  fi

    TAPE_LOC=""
    REMOTE_HOST="NA"
    REMOTE=0
    while [ "$TAPE_LOC" =  "" ]
    do
        echo
        nnl_echo "Enter Drive Location (local or remote) [local]: "
        read TAPE_LOC
        case "$TAPE_LOC" in
            r*) 
		echo
                nnl_echo "Enter hostname of remote tape drive: "
                read REMOTE_HOST
                echo ""
                nnl_echo "Login name for $REMOTE_HOST [vnmr1]: "
                read REMOTE_LOG
	        if [ x$REMOTE_LOG = "x" ]
 	        then
		    REMOTE_LOG=vnmr1
	        fi
                REMOTE=1
                rsh $REMOTE_HOST -n -l $REMOTE_LOG "echo 0 > /dev/null"
                if [ "$?" -ne 0 ]
                then
                   echo "$cmdname : Problem with reaching remote host $REMOTE_HOST"
                   exit 1
                fi
		rtype=`rsh $REMOTE_HOST -l $REMOTE_LOG  uname -s`
                if [ x$rtype = "xIRIX64" ]
                then
                    rtype="IRIX"
                fi
		if [ x$rtype = "xSunOS" ]
		then
		    rosver=`rsh $REMOTE_HOST -l $REMOTE_LOG  uname -r`
		    case "x$rosver" in
			x4*)
			    ;;
		        x*)
			    rtype="SOLARIS"
			    ;;
		    esac
	        fi
		if [ x$rtype = "xAIX" ]
		then
		   tapecmd="tctl -f"
		   tapeop=xvfb
		   blksize=20
		   tdrive="rmt0"
		   ndrive="rmt0.1"
		else if [ x$rtype = "xIRIX" ]
		     then
                        tapecmd="mt -t"
                        tapeop=xvfb
                        blksize=20
                        tdrive="tapens"
                        ndrive="nrtapens"
                     else if [ x$rtype = "xSOLARIS" ]
			then
			    tapecmd="mt -f"
			    tdrive="rmt/0mb"
			    ndrive="rmt/0mbn"
			else
			    tapecmd="mt -f"
			    tdrive="rst8"
			    ndrive="nrst8"
                        fi
                    fi
                fi;;
            l*) ;;
            *)
               TAPE_LOC="local" ;;
        esac
    done
    echo " "
    nnl_echo "Which tape drive for loading? [$tdrive]: "
    read a
    if ( test ! x$a = "x")
    then
      tdrive=$a
      case $tdrive in
        rst*)
            ndrive="n"$tdrive ;;
        rmt*)
	    if ( test x$ostype = "xSOLARIS" -o \
                 "(" x$TAPE_LOC != "xlocal" -a x$rtype = "xSOLARIS" ")" )
            then
                ndrive=$tdrive"n"
            else
                ndrive=$tdrive".1"
            fi
            ;;
        tape*)
            ndrive="nr"$tdrive ;;
        *)
            echo " "
            nnl_echo "Which non-rewind tape drive for loading? [$ndrive]: "
            read a
            if ( test ! x$a = "x")
            then
                ndrive=$a
            fi ;;
      esac
    fi
    tapedrive="/dev/"$tdrive
    ntapedrive="/dev/"$ndrive
}

#  define_arch relies on common_env() having run
#  beforehand so that the variable atype is defined
#
#  it serves to define the variable ttype (target type)

define_arch() {
    echo " "
    echo "System Architecture is a $atype."
    echo " "
    nnl_echo "Load Varian Software for this architecture? (y or n) [y]: "
    read a
    if ( test x$a = "xn" )
    then
        exit 1
    else
        if test $ostype = "SOLARIS"
        then
            atype="sol"
            ttype="sol"
        else
            ttype=$atype
        fi
    fi
}

tape_rew() {
    if [ $REMOTE -eq 0 ]
    then
	$tapecmd $tapedrive rewind
	if [ "$?" -ne 0 ]
	then
	    echo "$cmdname : Problem with $tapedrive"
     	    exit 1
	fi
    else
	rsh $REMOTE_HOST -n -l $REMOTE_LOG $tapecmd $tapedrive rewind
    fi
}

tape_fsf() {
    iter=0
    while [ $iter -lt $fc ]
    do
        if [ $REMOTE -eq 0 ]
        then
	    $tapecmd $ntapedrive fsf 1
        else
	    rsh $REMOTE_HOST -n -l $REMOTE_LOG $tapecmd $ntapedrive fsf 1
        fi
        iter=`expr $iter + 1`
    done
}

tape_nextf() {
    if [ $REMOTE -eq 0 ]
    then
	$tapecmd $ntapedrive fsf 1
    fi
}

tape_getf() {
    if [ $REMOTE -eq 0 ]
    then
        tar xvf $ntapedrive $an
    else
	rsh $REMOTE_HOST -n -l $REMOTE_LOG dd if=$ntapedrive bs=20b | tar $tapeop - $blksize $an
    fi
}

tape_bgetf() {
    if [ $REMOTE -eq 0 ]
    then
	tar $tapeop $ntapedrive $blksize $an
    else
        rsh $REMOTE_HOST -n -l $REMOTE_LOG dd if=$ntapedrive bs=2000b | tar $tapeop - $blksize $an
    fi
}

take_it_apart() {
    kid=0
    ntars=`ls *.tar* 2>/dev/null`
    if test ! "x$ntars" = "x"
    then
        echo "Decompressing $what."
        installdecomp &
        kid=$!
    fi
}

wait_for_decomp() {
    echo "Pausing for decompression of $what to complete."
    while  ntars=`ls *.tar* 2>/dev/null | wc -w`
    do
        if test $ntars -gt 0 
        then
           sleep 1
        else
           break
        fi
    done

    if test $kid -ne 0
    then
      wait $kid
    fi
}

#  Main program starts here

common_env
cmdname=`basename $0`

echo " "
echo "Current working directory is " `pwd`
nnl_echo "Load software options in this directory? (y or n) [y]: "
read a
if ( test x$a = "xn" )
then
    exit 1;
fi


if [ $# -lt 2 ]
then
    define_arch
    define_tape

    tape_rew

    an=""
    tape_getf

    eval `cat Vnmr*`
    if [ x$ostype != x$vnmros ]
    then
        echo " $cmdname must be run in the $vnmros system "
        exit 1
    fi

    if [ x$vnmros = "xSunOS" -o x$vnmros = "xSOLARIS" ]
    then
        tape_nextf
    fi

    sleep 1

    ./getchoices.${atype} ${ttype} getoptional

# put references to variables that may have embedded spaces in quotes
# use double quotes so the reference will be expanded to its value

    an=`cat common.choices`
    if [ "x$an" != "x" ]
    then
        tape_bgetf
        what="common"
        take_it_apart
	if [ x$vnmros = "xSunOS" -o x$vnmros = "xSOLARIS" ]
	then
            tape_nextf
	fi
        wait_for_decomp
    else
        fc=1
        tape_fsf
    fi

    an4=`cat sun4.choices 2>/dev/null`
    anI=`cat ibm.choices 2>/dev/null`
    anSGI=`cat sgi.choices 2>/dev/null`
    ansol=`cat sol.choices 2>/dev/null`
    if [ "x$an4" != "x" -o "x$anI" != "x" -o "x$anSGI" != "x" -o "x$ansol" != "x" ]
    then
	    if [ "x$an4" != "x" ]
	    then
            	an=$an4
	    else
		if [ "x$anI" != "x" ]
		then
		    an=$anI
		else
		    if [ "x$anSGI" != "x" ]
		    then
			an=$anSGI
		    else
			if [ "x$ansol" != "x" ]
			then
			    an=$ansol
			fi
		    fi
		fi
	    fi

        tape_bgetf
        what="objects"
        take_it_apart
        tape_rew
        wait_for_decomp
    else
        tape_rew
    fi

    if (test -f getoptions_load)
    then
        chmod +x getoptions_load
        getoptions_load
        rm getoptions_load
    fi
    rm -f *.choices *.toc getchoices.*
    rm -f loadvnmr finish_load installdecomp makevnmr1 makevnmr2

    if (test -f Vnmr*_?.*)
    then
        rm Vnmr*_?.*
    fi
else

#  fn -  file number
#  fc -  file count
#  an -  archive name(s)

    fn=$1
    shift
    an=$*
    fc=`expr $fn - 1`

    define_tape

    tape_rew

    if [ $fc -gt 0 ]
    then
        tape_fsf
    fi

    tape_getf

    tape_rew
fi
