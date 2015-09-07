: '@(#)setsparc.sh 22.1 03/24/08 1991-1996 '
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

if [ `arch` != "sun4" ]
then
    echo "cannot execute $0 on a "`arch`
else
    cd /vnmr/bin
    ln Vnmr master
fi
