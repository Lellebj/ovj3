: '@(#)limnet_tarout.sh 22.1 03/24/08 1991-1996 '
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

echo "Making limnet tape for combined SUN-3/SUN-4 support"

#  Rewind the tape

mt -f /dev/rst8 rewind

#  First file contains commands to load the remainder of the tape

cd /common
tar cvfb /dev/nrst8 2000	\
	finish_load		\
	loadlimnet

#  Second file contains stuff common to both systems

cd /common
tar cvfb /dev/nrst8 2000	\
	bin/dnode		\
	bin/eread		\
	bin/ewrite		\
	limnet/makelimnet1

#  Third file contains SUN-3 stuff

cd /sun3obj
tar cvfb /dev/nrst8 2000	\
	bin/decomp		\
	bin/eaddr		\
	bin/elist		\
	bin/limnets1		\
	bin/unix_vxr		\
	bin/vxr_unix		\
	limnet/in.limnet	\
	limnet/limnetd

#  Fourth file contains SUN-4 stuff

cd /sun4obj
tar cvfb /dev/nrst8 2000	\
	bin/decomp		\
	bin/eaddr		\
	bin/elist		\
	bin/limnets1		\
	bin/unix_vxr		\
	bin/vxr_unix		\
	limnet/in.limnet	\
	limnet/limnetd

#  Finish by rewinding the tape

mt -f /dev/rst8 rewind
echo "limNET tape complete"
