: '@(#)setuni.sh 22.1 03/24/08 1991-1996 '
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
:/bin/sh

# First the one on /vnmr
cd $vnmrsystem
# Remove the old links and establish new ones for parameter files
rm -f par200 par300 par400 par500 par600 par750
ln -s upar200 par200
ln -s upar300 par300
ln -s upar400 par400
ln -s upar500 par500
ln -s upar600 par600
ln -s upar750 par750

# Next are the psg psglib and seqlib directories
rm -f psg psglib seqlib
ln -s upsg psg
ln -s usglb gpsglib
ln -s useqlib seqlib

# go to the bin directory and fix up acqi, config and setacq
cd bin
rm -f iadisplay vconfig setacq
ln -s uiadisplay iadisplay
ln -s uconfig vconfig
ln -s usetacq setacq

# Finally in the acqbin directory and fix up Acqproc
cd ../acqbin
rm -f Acqproc
ln -s uAcqproc Acqproc

