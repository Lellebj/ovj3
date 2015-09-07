: '@(#)UpdateKernel.sh 22.1 03/24/08 1991-1996 '
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
: /bin/sh
#
#  update the kernel tape directories 
#  Updatekernel
#  user is prompted for directories
#		Author Greg Brissey 6/19/91

echo " "
echo "UpdateKernel      Date: `date`"
echo " "

# Shared Library Version
so_ver=$psg_so_ver



#  Establish targets for updating, SUN-3, SUN-3x, SUN-4 or SUN-4c

all_targets="sun3 sun4 sun4c"
echo Kernel Targets are: $all_targets
echo -n "Target(s) for updating, or all: "
read answer
if (test "x$answer" = "xall")
then
  chosen_targets=$all_targets
else
  chosen_targets=$answer
fi
echo  -n "Base Directory to obtain new kernels: "
read nkdir
if (test ! -d $nkdir)
then
  echo "Directory $nkdir is not present."
fi

echo
echo "New Kernel files from base directory: $nkdir"
echo "sun3 kernel files to: $sun3kernel"
echo "sun3x kernel files to: $sun3xkernel"
echo "sun4 kernel files to: $sun4kernel"
echo "sun4c kernel files to: $sun4ckernel"
echo    " "
echo    "Target Kernels:    $chosen_targets"
echo    " "
echo -n "The Above Correct? (y or n) "
read answer
if test ! x$answer = "xy"
then
   echo "aborted."
   exit 1
fi

for target in $chosen_targets
do
    if (test x$target = "xsun3")
    then
      targetdir=$sun3kernel
    elif (test x$target = "xsun4")
    then
      targetdir=$sun4kernel
    elif (test x$target = "xsun4c")
    then
      targetdir=$sun4ckernel
    fi
    if (test ! -d $nkdir/${target}kernel)
    then
	echo " "
	echo "Directory $nkdir/${target}kernel is not present."
	echo "Continuing on to next target kernel."
        continue
    fi
    echo " "
    echo "Writing $target Kernel Files"
    SOS_LEVEL=`strings $nkdir/${target}kernel/vmunix \
        | egrep '^Sun UNIX|^SunOS (Release)'`
    echo $SOS_LEVEL

    echo "rm -f $targetdir/${target}kernel/*"
    rm -f $targetdir/${target}kernel/*
    echo "cp -p $nkdir/${target}kernel/* $targetdir/${target}kernel"
    cp -p $nkdir/${target}kernel/* $targetdir/${target}kernel
    (cd $targetdir; ls -Flg ${target}kernel )
done
