: '@(#)i_vnmr4.sh 22.1 03/24/08 1991-1996 '
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
:  /bin/sh
#

######################################################################
#  These two scripts functions add a name to the password file
#  and a group to the group file
######################################################################

add_to_passwd() {

# make backup copy of password file
# scan password file for largest user-id
# add one to that user-id to obtain id for vnmr1
# insert before last line in password file
# keep user-id number within bounds of positive 16-bit numbers,
#  that is, less than 32768

	awk '
BEGIN {N=0
       AlreadyExists=0
       NewUser="'$nmr_name'"
       FS=":"
      }
{
if ($3>N && $3<32768) N=$3
if ($1==NewUser) AlreadyExists=1
}
END {if (AlreadyExists==0)
          printf "%s::%d:'$nmr_group_no':%s:'$nmr_home'/%s:/bin/csh\n",NewUser,N+1,NewUser,NewUser}
' < /etc/passwd >/tmp/newuser

#  Insert new entry before the last line in the password file

	if test -s /tmp/newuser
	then
		cp /etc/passwd /etc/passwd.bk
		read stuff </tmp/newuser
		(sed '$i\
'"$stuff"'' /etc/passwd >/tmp/newpasswd)
		mv /tmp/newpasswd /etc/passwd
		rm /tmp/newuser
	fi
}
 
######################################################################

add_to_group() {

   cp /etc/group /etc/group.bk
   if [ x$ostype = "xAIX" ]
   then
      (sed '$i\
'"$nmr_group"':!:'"$nmr_group_no"':'"$nmr_name"'' /etc/group >/tmp/newgroup)
   else
	(sed '$i\
'"$nmr_group"':*:'"$nmr_group_no"':'"$nmr_name"'' /etc/group >/tmp/newgroup)
   fi
	mv /tmp/newgroup /etc/group
}

######################################################################
#  Start of main script
######################################################################

#  Figure out System V vs. SunOS
#  Only works on Sun systems ...  not IBM
#  required for nnl_echo program

if [ x$ostype = "xAIX" -o x$ostype = "xIRIX" -o x$ostype = "xSOLARIS" ]
then
    sysV="y"
else
    sysV="n"
fi

if test $# -ne 3
then
    echo i_vnmr.4: number of arguments must be 3, is $#, exiting i_vnmr.4.
    exit 1
fi

nmr_name=$1
nmr_group=$2
nmr_home=$3
nmr_group_no=30

#  Only copy the group file if there is no nmr group

date=`date +%y%m%d.%H:%M`
my_file="/tmp/my.file."$date
touch $my_file
chgrp $nmr_group $my_file 2>/dev/null
if [ $? -ne 0 ]
then
    add_to_group
fi
rm -f $my_file

#  Only copy the passwd file if there is no nmr_name account

date=`date +%y%m%d.%H:%M`
my_file="/tmp/my.file."$date
touch $my_file
chown $nmr_name $my_file 2>/dev/null
if [ $? -ne 0 ]
then
    add_to_passwd
fi
rm -f $my_file

# special stuff for Solaris

if (test x$ostype = "xSOLARIS")
then
    if touch /etc/shadow
    then
        if grep -s $nmr_name /etc/shadow >/dev/null
        then
            :
        else
            echo "$nmr_name:::0:::::" >>/etc/shadow
        fi
    else
        echo "Cannot add $name to the shadow file"
    fi
fi
