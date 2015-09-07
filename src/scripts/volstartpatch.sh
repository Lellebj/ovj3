: '@(#)volstartpatch.sh 22.1 03/24/08 1999-2002 '
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
#!/bin/ksh
# @(#) volstartpatch.sh 22.1 03/24/08
#
# This is a CD volume start script.  This start script is designed
# to be automatically run when the CD is inserted into a Solaris
# system's CDrom drive.
#
# Note: not all Solaris systems have an auto volstart ability.  If this
# CD is inserted into a CDrom drive of a Solaris system without the
# volstart ability, volstart can also be run manually by executing it
# from either the desktop's file manager or from a Unix command line.

full_name=$0
dir_name=`/usr/bin/dirname $full_name`

if [[ -x /usr/dt/bin/dtaction ]]; then

   # Run the CDrom's installer program

   /usr/dt/bin/dtaction Run $dir_name/load.patches
fi

