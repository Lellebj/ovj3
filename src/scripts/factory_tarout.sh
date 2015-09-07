: '@(#)factory_tarout.sh 22.1 03/24/08 1991-1996 '
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
#  Factory Tar Version for combined support of SUN-3 and SUN-4
#  9-01-89 added additional call name factory_tarfile to generate tar
#  tape image on disk.
#
echo " "
echo "Current working directory is " `pwd`
echo -n "Type <cr> to continue, ^C to quit: "
read a
abort=n

# check for directories that will be needed for loading.
dirlist="load common sun3 sun4"
for file in $dirlist
do
if test ! -d $file
then
  echo "Directory '$file' does not exist, Must be present for tarout."
  abort=y
fi
done

# quit if any of the above files are missing
if ( test $abort = "y" )
then
  exit 1
fi

# check for kernel directories
nokernels=no
dirlist="Ksun3 Ksun3x Ksun4 Ksun4c"
for file in $dirlist
do
if test ! -d $file
then
  echo "Directory '$file' does not exist."
  nokernels=yes
fi
done
if test $nokernels = "yes"
then
   echo "Tape or Tarfile will be in orignal format (no kernel files)"
else
   echo "Tape or Tarfile will be in new format (kernel files)"
fi

name=`basename $0`
if ( test $name = "factory_tarout" )
then
 echo " "
 echo "Making VNMR Tar Tape for combined SUN-3/SUN-4 support"
 taropt=cvfb
 blksiz=2000
 tardev=/dev/nrst8
 tardev1=/dev/nrst8
 tardev2=/dev/nrst8
 tardev3=/dev/nrst8
 tardev4=/dev/nrst8
 tardev5=/dev/nrst8
 tardev6=/dev/nrst8
 tardev7=/dev/nrst8
 tardev8=/dev/nrst8
elif ( test $name = "factory_tarfile" )
then
 taropt=cvf
 blksiz=""
 date=`date +%y%m%d.%H:%M`
 tardev=../factory_tarfile.${date}
 filelist="Loadscripts Com Sun3 Sun4 KSUN3 KSUN3X KSUN4 KSUN4C"
 for file in $filelist
 do
 if test -s $file
 then
   echo "File $file Exists, Delete (rm) or Rename (mv)"
   abort=y
 fi
 done
 if ( test $abort = "y" )
 then
   exit 1
 fi
 tardev1=../Loadscripts
 tardev2=../Com
 tardev3=../Sun3
 tardev4=../Sun4
 tardev5=../KSUN3
 tardev6=../KSUN3X
 tardev7=../KSUN4
 tardev8=../KSUN4C
 echo "Making VNMR Tar File \`$tardev' for combined SUN-3/SUN-4 support"
else
  echo "Illegal Call Name: $name"
  exit 1
fi

#  Rewind the tape if taring to tape device

if ( test $tardev = "/dev/nrst8" )
then
  mt -f /dev/nrst8 rewind
fi

#  First file contains loading scripts 
cd load
echo "Tar out load scripts."
tar cvf $tardev1 *

#  Second file contains stuff common to both systems
cd ../common
echo "Tar out Common Files ."
#tar cvfb /dev/nrst8 2000 *
tar $taropt $tardev2 $blksiz *

# if tar file then copy separate tar files into One
if (test ! $tardev = "/dev/nrst8")
then
 ( cd ..; \
 tar -cvf `basename $tardev` `basename $tardev1`; \
 rm -f `basename $tardev1`; \
 tar -rvf `basename $tardev` `basename $tardev2`; \
 rm -f `basename $tardev2` )
fi

#  Third file contains SUN-3 stuff

cd ../sun3
echo "Tar out Sun3 Object Files ."
#tar cvfb /dev/nrst8 2000 *
tar $taropt $tardev3 $blksiz *

if (test ! $tardev = "/dev/nrst8")
then
 ( cd ..; \
 tar -rvf `basename $tardev` `basename $tardev3`; \
 rm -f `basename $tardev3` )
fi
 
#  Fourth file contains SUN-4 stuff

cd ../sun4
echo "Tar out Sun4 Object Files ."
#tar cvfb /dev/nrst8 2000 *
tar $taropt $tardev4 $blksiz *

if (test ! $tardev = "/dev/nrst8")
then
 ( cd ..; \
 tar -rvf `basename $tardev` `basename $tardev4`; \
 rm -f `basename $tardev4` )
fi
 
if test $nokernels = "no"
then
#  Fifth file contains Kernel 3 stuff

 cd ../Ksun3
 echo "Tar out Sun3 Kernel Files ."
 tar $taropt $tardev5 $blksiz *

 if (test ! $tardev = "/dev/nrst8")
 then
  ( cd ..; \
  tar -rvf `basename $tardev` `basename $tardev5`; \
  rm -f `basename $tardev5` )
 fi
 
#  Sixth file contains Kernel 3x stuff

 cd ../Ksun3x
 echo "Tar out Sun3x Kernel Files ."
 tar $taropt $tardev6 $blksiz *
 
 if (test ! $tardev = "/dev/nrst8")
 then
  ( cd ..; \
  tar -rvf `basename $tardev` `basename $tardev6`; \
  rm -f `basename $tardev6` )
 fi
 
#  Seventh file contains Kernel 4 stuff

 cd ../Ksun4
 echo "Tar out Sun4 Kernel Files ."
 tar $taropt $tardev7 $blksiz *

 if (test ! $tardev = "/dev/nrst8")
 then
  ( cd ..; \
  tar -rvf `basename $tardev` `basename $tardev7`; \
  rm -f `basename $tardev7` )
 fi
 
#  eighth file contains Kernel 4c stuff

 cd ../Ksun4c
 echo "Tar out Sun4c Kernel Files ."
 tar $taropt $tardev8 $blksiz *
 
 if (test ! $tardev = "/dev/nrst8")
 then
  ( cd ..; \
  tar -rvf `basename $tardev` `basename $tardev8`; \
  rm -f `basename $tardev8` )
 fi

fi

#  Finish by rewinding the tape

if ( test $tardev = "/dev/nrst8" )
then
  echo "Rewinding Tape."
  mt -f /dev/nrst8 rewind
  echo "Tape complete"
else
 ( cd ..; \
 chmod 440 `basename $tardev` )
 echo "Tar File $tardev complete"
fi
