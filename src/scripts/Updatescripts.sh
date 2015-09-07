: /bin/sh
# '@(#)Updatescripts.sh 22.1 03/24/08 1993-1996 '
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
# script to update scripts in /sw/vbin taht are used by the software group 
#
filelist="Updatetape.sh Updateobj.sh Updatetape53.sh	\
	  Updateobj53.sh Updatetoc.sh Updatemanuals.sh	\
	  vnmr_tarout.sh vnmrx_tarout.sh ibm_tarout.sh	\
	  sgi_tarout.sh sol_tarout.sh Updatescripts.sh	\
	  cdout.sh cdout2.sh cdpatchout.sh mancdout.sh  \
	  nvcdout.sh Updatelnx.sh envLnx.sh Updatewin.sh \
          tclprocomp.sh	tclfixtbc.sh"
set -x
cd /sw/vbin
set +x
for xfile in $filelist
do
  echo "Sget scripts $xfile "
  /usr/ccs/bin/sccs -p/vsccs/sccs/scripts/SCCS get $xfile
  zfile=`echo $xfile | sed 's/.sh//'`
  echo "make $zfile"
  make $zfile
  chmod 775 $zfile
done
