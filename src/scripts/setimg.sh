#! /bin/sh
# @(#)setimg.sh 22.1 03/24/08 Copyright (c) 1994-1996 Agilent Technologies
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
######################################################################
# This script links or unlinks the imaging executables for acquisition
# systems prior to UnityPlus.  
# If "setimg" is called: 
# xrxrp.out is moved to xrxrp_std.out and xrxrp.out is soft linked to
# xrxrp_img.out; autshm.out is moved to autshm_std.out and autshm.out is 
# soft linked to autshm_img.out.
# If "setimg unset" is called xrxrp.out is soft linked to xrxrp_std.out
#  and autshm.out is soft linked to autshm_std.out.
# names.

#
# set_img
#
set_img() {

cd "$vnmrsystem"/acq

if ( test ! -f xrxrp_img.out )
then
    echo "$vnmrsystem/acq/xrxrp_img.out not found."
    exit 1
fi

if ( test ! -f xrxrp_std.out)
then
    if ( test -h xrxrp.out )
    then
	echo "$vnmrsystem"/acq/xrxrp_std.out missing and xrxrp.out is a soft link
        exit 1
    fi
    if ( test ! -f xrxrp.out )
    then
	echo Both "$vnmrsystem"/acq/xrxrp_std.out and xrxrp.out are missing
	exit 1
    fi
fi

if ( test ! -f xrxrp_std.out )
then
    mv xrxrp.out xrxrp_std.out
else
    if ( test ! -h xrxrp.out )
    then
	mv xrxrp.out xrxrp.out.bak$$
    else
	rm -f xrxrp.out
    fi
fi

if ( test ! xrxrp_std.out )
then
    echo Could not write file "$vnmrsystem"/acq/xrxrp_std.out
    exit 1
fi
if ( test -f xrxrp.out )
then
    echo Could not move or remove "$vnmrsystem"/acq/xrxrp.out
    exit 1
fi

ln -s xrxrp_img.out xrxrp.out
if ( test ! -h xrxrp.out )
then
    echo Could not create soft link "$vnmrsystem"/acq/xrxrp.out
else
    echo "$vnmrsystem"/acq/xrxrp.out linked to xrxrp_img.out
fi

if ( test ! -f autshm_img.out )
then
    echo "$vnmrsystem/acq/autshm_img.out not found."
    exit 1
fi

if ( test ! -f autshm_std.out )
then
    if (test -h autshm.out )
    then
	echo "$vnmrsystem"/acq/autshm_std.out missing and autshm.out a soft link
        exit 1
    fi
    if ( test ! -f autshm.out )
    then
	echo Both "$vnmrsystem"/acq/autshm_std.out and autshm.out are missing
	exit 1
    fi
fi

if ( test ! -f autshm_std.out )
then
    mv autshm.out autshm_std.out
else
    if ( test ! -h autshm.out )
    then
	mv autshm.out autshm.out.bak$$
    else
	rm -f autshm.out
    fi
fi

if ( test ! autshm_std.out )
then
    echo Could not write file "$vnmrsystem"/acq/autshm_std.out
    exit 1
fi
if ( test -f autshm.out )
then
    echo Could not move or remove "$vnmrsystem"/acq/autshm.out
    exit 1
fi

ln -s autshm_img.out autshm.out
if ( test ! -h autshm.out )
then
    echo Could not create soft link "$vnmrsystem"/acq/autshm.out
else
    echo "$vnmrsystem"/acq/autshm.out linked to autshm_img.out
fi

}
#
# unset_img
#
unset_img() {

cd "$vnmrsystem"/acq

if (test -h xrxrp.out)
then
   if (test -f xrxrp_std.out)
   then
	rm -f xrxrp.out
	if (test -h xrxrp.out)
	then
            echo "unset_img: could not remove link $vnmrsystem/acq/xrxrp.out"
            exit 1
	else
	    ln -s xrxrp_std.out xrxrp.out
	    if (test -f xrxrp.out)
	    then
		echo "$vnmrsystem/acq/xrxrp.out linked to xrxrp_std.out."
	    else
		echo "unset_img: could not move $vnmrsystem/acq/xrxrp_std.out to xrxrp.out."
		exit 1
	    fi
	fi
   else
        echo "unset_img: could not find file $vnmrsystem/acq/xrxrp_std.out"
        exit 1
   fi
else
   echo "set_img: $vnmrsystem/acq/xrxrp.out not a soft link"
   exit 1
fi

if (test -h autshm.out)
then
   if (test -f autshm_std.out)
   then
	rm -f autshm.out
	if (test -h autshm.out)
	then
            echo "unset_img: could not remove link $vnmrsystem/acq/autshm.out"
            exit 1
	else
	    ln -s autshm_std.out autshm.out
	    if (test -f autshm.out)
	    then
		echo "$vnmrsystem/acq/autshm.out linked to autshm_std.out."
	    else
		echo "unset_img: could not move $vnmrsystem/acq/autshm_std.out to autshm.out."
		exit 1
	    fi
	fi
   else
        echo "unset_img: could not find file $vnmrsystem/acq/autshm_std.out"
        exit 1
   fi
else
   echo "set_img: $vnmrsystem/acq/autshm.out not a soft link"
   exit 1
fi

}


######################################################################
#  Start of main script
######################################################################

if (test $# -gt 1 )
then
   echo "Usage: $0 [unset] "
   exit 1
fi
if ( test $# -eq 0 )
then
    set_img;
else
    case $1 in
      unset)
	unset_img;;
      *)
	echo Usage: $0 [unset]
	exit 1;;
    esac
fi
