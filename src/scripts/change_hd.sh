: '@(#)change_hd.sh 22.1 03/24/08 1991-1996 '
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
if (test ! $USER = "root")
then
	echo "You are not root, permission denied!"
        rm -f /etc/change_hd
        exit
fi
cd /etc
if (test ! -s fstab)
then 
	echo "ERROR: file /etc/fstab does not exist or it is empty"
        echo "Warning! Do not change any hard disk jumpers." 
        rm -f /etc/change_hd
        exit
fi 
cp fstab fstab.bk

if (test -s /tmp/dsk.info)
then   rm -f /tmp/dsk.info
fi

awk '
	$1 ~ /^\/dev\/sd/ { 
 		n=substr($1, 8, 1)
		x[n]++ }
END {
       i = 0
       while (i <= 6)
       {  if (x[i] >= 1)
              printf("%d ", i) >"/tmp/dsk.info"
          i++
       }
    }
' fstab
if (test ! -s /tmp/dsk.info)
then  echo "Error: could not find any scsi hard disk in /etc/fstab"
      echo "Warning! Do not change any hard disk jumpers." 
      rm -f /etc/change_hd
      exit
fi 

d0=0
d2=0
d4=0
d6=0
set `cat /tmp/dsk.info`
#echo "There are $# scsi hard disks in this system "
#echo -n "They are: sd"
#cat /tmp/dsk.info
rm -f /tmp/dsk.info
for i
do case $i in
	0) d0=1;;
	2) d2=1;;
	4) d4=1;;
	6) d6=1;;
	*) ;;
   esac
done
if (test ! $d6 = "1")
then
	 echo "** sd6 does not exist **"
	 echo
#	 echo "The target ID 3 is available for Varian Acquisition machine"
	 echo
         echo "Warning! Do not change any hard disk jumpers." 
         rm -f /etc/change_hd
         exit
fi

if (test ! $d0 = "1")
then  dd=0
      ID=0
      UN=0
else if (test ! $d2 = "1")
     then dd=2
	  ID=1
	  UN=8
     else if (test ! $d4 = "1")
	  then dd=4
   	       ID=2
	       UN=10
          else
		echo "There are $# disks in this system, target ID 0, 1, 2, and 3 are all occupied"
                echo
                echo "Warning! Do not change any hard disk jumpers." 
		echo
                rm -f /etc/change_hd
                exit
	  fi
     fi
fi

sed -e "s/^\/dev\/sd6/\/dev\/sd$dd/g" fstab >fstab.new
mv fstab.new fstab
eeprom bootdev="sd(0,$UN,0)"
cd /dev
MAKEDEV sd$dd
echo
echo "Shutdown system and change hard disk ID from 3 to $ID" 
echo
rm -f /etc/change_hd
