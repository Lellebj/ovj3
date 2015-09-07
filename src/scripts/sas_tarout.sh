: '@(#)sas_tarout.sh 22.1 03/24/08 1991-1996 '
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
:
#  Version for combined support of SUN-3 and SUN-4

echo "Making Ellis tape for combined SUN-3/SUN-4 support"

#  Rewind the tape

mt -f /dev/rst8 rewind

#  First file contains commands to load the remainder of the tape

cd /common
tar cvfb /dev/nrst8 2000	\
	finish_load		\
	loadsas

#  Second file contains stuff common to both systems

cd /common
tar cvfb /dev/nrst8 2000	\
	sas

#  Third file contains SUN-3 stuff

cd /sun3obj
tar cvfb /dev/nrst8 2000	\
	sas

#  Fourth file contains SUN-4 stuff

cd /sun4obj
tar cvfb /dev/nrst8 2000	\
	sas

#  Finish by rewinding the tape

mt -f /dev/rst8 rewind
echo "SAS tape complete"
