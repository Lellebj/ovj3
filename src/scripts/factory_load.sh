: '@(#)factory_load.sh 22.1 03/24/08 1991-1996 '
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
:
#  Command file for factory loading a distribution tape for SUN-3 or SUN-4.
#  Assumes the tape has 4 ``tar'' files; the 1st contains the loading scripts,
#  the second contains stuff common to both system, the third contains SUN-3 
#  specific stuff, the fourth has SUN-4 stuff.  
#  The command file ignores the first file on the tape
#
#  Assumes the user is sitting in proper release directory 
#
#  THIS FILE IS FOR STREAMING TAPE DEVICE /dev/nrst8 ONLY
#
#  Modified 11/09/89 for Tapes with kernel files
#
abort=n
echo "Loading product for Factory"
echo " "
echo "Current working directory is " `pwd`
echo -n "Type <cr> to continue, ^C to quit: "
read a

# determine if this tape has seperate kernel files
echo -n "Is this Tape a Release > 2.2a (y or n): "
read a
if test x$a = "xy"
then
  skipkernels=no
  dirlist="load common sun3 sun4 Ksun3 Ksun3x Ksun4 Ksun4c"
else
  skipkernels=yes
  dirlist="load common sun3 sun4"
fi

# check for directories that will be loaded.
for file in $filelist
do
if test -r $file
then
  echo "File or Directory '$file' exists, Remove (rm) or Rename (mv)."
  abort=y
fi
done

if ( test $abort = "y" )
then
  exit 1
fi

name=`basename $0`
if ( test $name = "factory_load" )
then
 echo "Loading from VNMR Tar Tape"
 taropt=xvfb
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
elif ( test $name = "factory_loadfile" )
then
 tardev=../factory_tarfile.${date}
 echo "Loading from VNMR Tar File"
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
 taropt=xvf
 blksiz=""
 echo -n "Enter Tar File Name to extract from: ^C to quit: "
 read tardev
 date=`date +%y%m%d.%H:%M`
 tardev1=../Loadscripts
 tardev2=../Com
 tardev3=../Sun3
 tardev4=../Sun4
 tardev5=../KSUN3
 tardev6=../KSUN3X
 tardev7=../KSUN4
 tardev8=../KSUN4C
 echo "Loading VNMR Tar File \`$tardev'"
else
  echo "Illegal Call Name: $name"
  exit 1
fi

if ( test $abort = "y" )
then
   exit 1
fi

echo "Creating "$dirlist" directories..."
mkdir $dirlist
#
#  Rewind the tape if taring from tape device
#  to place it at a known position
#
if ( test $tardev = "/dev/nrst8" )
then
  mt -f /dev/nrst8 rewind
else
  tar xvf $tardev		# extract the tar files
fi

cd load
echo "Loading Scripts into directory 'load'."
tar xvf $tardev1 		# load loading scripts 
if ( test $tardev = "/dev/nrst8" )
then
  mt -f /dev/nrst8 fsf 1		# skip past eof mark to next tar file 
fi

cd ../common
echo "Loading Common Files into directory 'common'."
tar $taropt $tardev2 $blksiz 	# load common files
if ( test $tardev = "/dev/nrst8" )
then
  mt -f /dev/nrst8 fsf 1		# skip past eof mark to next tar file 
fi

cd ../sun3
echo "Loading sun3 Object Files into directory 'sun3'."
tar $taropt $tardev3 $blksiz 	# load object files for proper machine
if ( test $tardev = "/dev/nrst8" )
then
  mt -f /dev/nrst8 fsf 1	# skip past sun3 objects if necessary
fi

cd ../sun4
echo "Loading sun4 Object Files into directory 'sun4'."
tar $taropt $tardev4 $blksiz    # load object files for proper machine
if ( test $tardev = "/dev/nrst8" )
then
  mt -f /dev/nrst8 fsf 1	# skip past sun3 objects if necessary
fi

# skip the kernel files 
if test $skipkernels = "no"
then
  cd ../Ksun3
  echo "Loading Kernel Sun3 Files into directory 'Ksun3'."
  tar $taropt $tardev5 $blksiz 	# load object files for proper machine
  if ( test $tardev = "/dev/nrst8" )
  then
    mt -f /dev/nrst8 fsf 1	# skip past sun3 objects if necessary
  fi

  cd ../Ksun3x
  echo "Loading Kernel Sun3x Files into directory 'Ksun3x'."
  tar $taropt $tardev6 $blksiz 	# load object files for proper machine
  if ( test $tardev = "/dev/nrst8" )
  then
    mt -f /dev/nrst8 fsf 1	# skip past sun3 objects if necessary
  fi

  cd ../Ksun4
  echo "Loading Kernel Sun4 Files into directory 'Ksun4'."
  tar $taropt $tardev7 $blksiz 	# load object files for proper machine
  if ( test $tardev = "/dev/nrst8" )
  then
    mt -f /dev/nrst8 fsf 1	# skip past sun3 objects if necessary
  fi

  cd ../Ksun4c
  echo "Loading Kernel Sun4c Files into directory 'Ksun4c'."
  tar $taropt $tardev8 $blksiz 	# load object files for proper machine

fi

if ( test $tardev = "/dev/nrst8" )
then
  echo "Rewinding Tape."
  mt -f /dev/nrst8 rewind	# done rewind tape 
fi
echo "Load Complete."

