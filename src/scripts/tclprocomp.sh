: '@(#)tclprocomp.sh 22.1 03/24/08 1999-2000 '
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
#!/bin/sh

if [ $# -ne 0 ]
then
#    (su chin -c "/sw/TclPro1.3/solaris-sparc/bin/procomp $*")
    cd /common/systcl
    /sw/TclPro1.3/solaris-sparc/bin/procomp $*
    chmod 775 *.tbc

else
    echo "\n    Usage: $0  myfile.tcl [myfile1.tcl] [myfile2.tcl] [myfil...]\n"
    exit 1
fi
