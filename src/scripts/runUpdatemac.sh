: '@(#)runUpdatemac.sh 22.1 03/24/08 2003-2004 '
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
#!/bin/sh
echo " $0 -------------------------"
sccsdir=/vsccs/sccs
sccsjdir=/vsccs/jsccs
macobjdir=/vobj/mac
export sccsdir sccsjdir macobjdir

echo "PATH1=$PATH "
echo "path1=$path "

VNMR_REV_ID="VnmrJ_Mac VERSION 2.1 REVISION A_Development"
VNMRJ_REV_ID="VnmrJ_Mac VERSION 2.1 REVISION A_Development"
VNMRLNX_REV_ID="VnmrJ_Mac VERSION 2.1 REVISION A_Development"
VNMRBG_REV_ID="VnmrJ_Mac VERSION 2.1 REVISION A_Development"
JPSG_REV_ID="JPSG VERSION 1.1 REVISION D"
VNMR_REV_DATE="`date '+%B %e, %Y'`"
psg_so_ver="6.0"

export psg_so_ver VNMR_REV_ID VNMRJ_REV_ID VNMRLNX_REV_ID VNMRBG_REV_ID JPSG_REV_ID VNMR_REV_DATE

PATH=/usr/bin:/bin:/usr/X11R6/bin:/usr/local/bin:$PATH
export PATH

echo "PATH=$PATH "
echo "path=$path "
which make
which cc
echo "  -------------------------"
echo ""
echo ""

rm -rf /vobj/mac/proglib/*

(cd /sw/vbin; \
 Sget scripts Updatemac.sh; \
 make Updatemac \
)

/sw/vbin/Updatemac <<+
y
+

cp /tmp/Updatemac.log /common/complogs/Objlogd_Power-Macintosh
~
~
