: '@(#)installdecomp.sh 22.1 03/24/08 1991-1996 '
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
# This script search the present directory for any tar or 
# compressed tar files of the file name form:
#  *.tar or *.tar.Z
#
# Modification: 3/20/91 copy files to a unique directory, now
#			now multiple installdecomps can run simultaneous
#
# Modification: 10/04/93  No length or substr with expr in SVR4;
#                         necessary to fall back on that old standby, awk

# Obtain all the tar files in sorted order: small to largest
files=`ls -s *.tar* 2>/dev/null | sort -n | awk '{print $2}'`

# Make a unique directory to hold this files as we decompress,tar or ar
decompdir=decomp.$$
mkdir $decompdir
chmod 777 $decompdir

# move all the files into this directory
mv $files $decompdir

# now go their ourselves
cd $decompdir
chmod 666 *

# Obtain just compressed tar and/or ar files in sorted order: small to largest
zfiles=`ls -s *.tar.Z 2>/dev/null | sort -n | awk '{print $2}'`

# Obtain just the normal tar and/or ar files in sorted order: small to largest
nfiles=`ls -s *.tar 2>/dev/null | sort -n | awk '{print $2}'`

if test ! "x$zfiles" = "x"
then
# go through the total sorted list of files and tar them
# echo "start of tar: `date`"
for file in $zfiles
do
#    echo "Tar $file"
    if test ! "x$nmr_adm" = "x"
    then
        (cd ..;su $nmr_adm -c "zcat $decompdir/$file | tar xf -")
    else
        (cd ..;zcat $decompdir/$file | tar xf -)
    fi
    rm -f $file
done
fi 
if test ! "x$nfiles" = "x"
then
# go through the total sorted list of files and tar them
# echo "start of tar: `date`"
for file in $nfiles
do
#    echo "Tar $file"
    if test ! "x$nmr_adm" = "x"
    then
        (cd ..;su $nmr_adm -c "tar xf $decompdir/$file")
    else
        (cd ..;tar xf $decompdir/$file)
    fi
    rm -f $file
done
fi 
cd ..
rmdir $decompdir
#echo "end of tar: `date`"
