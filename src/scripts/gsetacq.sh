: '@(#)gsetacq.sh 22.1 03/24/08 1991-1997 '
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

vnmrsystem=/vnmr
cons_eadd="2:cf:1f:e1:36:82"
cons_name="gemcon"
cons_ip="10.0.0"
enet2_name="wormhole"
reboot=0
etc=/etc

#-----------------------------------------------------------------
make_etc_files () {

# this creates the acqpresent file in /etc

    (cd $etc; cat /dev/null >acqpresent)

# this creates the statpresent file in /etc

    (cd $etc; cat /dev/null >statpresent)
}

#-----------------------------------------------------------------
# Main main MAIN
#
# Login the user as a root user
# Use the "su" command to ask for password and run the installer
#
#-----------------------------------------------------------------
notroot=0
userId=`/bin/id | awk 'BEGIN { FS = " " } { print $1 }'`
if [ $userId != "uid=0(root)" ]; then
  notroot=1
  echo
  echo "To install VNMR you will need to be the system's root user."
  echo "Or type cntrl-C to exit.\n"
  echo
  s=1
  t=3
  while [ $s = 1 -a ! $t = 0 ]; do
     echo "Please enter this system's root user password \n"
     su root -c "/vnmr/bin/setacq ${ARGS}";
     s=$?
     t=`expr $t - 1`
     echo " "
  done
  if [ $t = 0 ]; then
      echo "Access denied. Type cntrl-C to exit this window."
      echo "Type $0 to start the installation program again \n"
  fi
  exit
fi
echo "One moment please..."


#-----------------------------------------------------------------
# Operating System               
# Note that Solaris (on sun hardware) calls itself SunOS
# use OS revision to distinguish between the two
# This sould be Solaris ONLY
#-----------------------------------------------------------------
OS_NAME=`uname -s`               
if (test ! $OS_NAME = "SunOS")   
then                             
   echo "$0 suitable for Sun-based systems only"
   echo "$0 exits"               
   exit 1                        
fi                               

#-----------------------------------------------------------------
# tell the user to stop Acqproc if it is running
#-----------------------------------------------------------------
findacqproc="ps -e  | grep Acqproc | awk '{ printf(\"%d \",\$1) }'"
npids=`eval $findacqproc`
if (test x"$npids" != "x" )
then
   echo ""
   echo "You must stop 'Acqproc' to run $0"
   echo "Please type 'su acqproc', then restart $0"
   echo ""
   exit 1
fi

#-----------------------------------------------------------------
# tell the user to exit all Vnmr 
#-----------------------------------------------------------------
findacqproc="ps -e  | grep Vnmr | awk '{ printf(\"%d \",\$1) }'"
npids=`eval $findacqproc`
if (test x"$npids" != "x" )
then
   echo ""
   echo "You must exit all 'Vnmr'-s to run $0"
   echo "Please type 'exit' in the Vnmr input window,"
   echo "or use 'ps-e | grep Vnmr' and 'kill' to exit Vnmr-s."
   echo "Then restart $0"
   echo ""
   exit 1
fi

#-----------------------------------------------------------------
# kill any in.rarpd deamons that are running, otherwhise they will answer
# before this program can catch the ethernet address.
#-----------------------------------------------------------------
findrarpds="ps -e | awk '/rarpd/ { printf(\"%d \",\$1) }'"
npids=`eval $findrarpds`
for rarpdpid in $npids
  do
    kill -9 $rarpdpid > /dev/null 2> /dev/null
    sleep 5             # give time for kill message to show up.
  done
# Double check to see if any are still running.
npids=`eval $findrarpds`
if (test x$npids != "x" )
then 
   for rarpdpid in $npids
   do 
      echo "Unable to kill in.rarpd (pid=$rarpdpid)"
   done
fi

#-----------------------------------------------------------------
# To support both the 10 Mbit ethernet and 100 Mbit ethernet
# we must distinguish between the hostname.le? and hostname.hme?
# If /etc/hostname.hme0 exists the primary net is 100/10 Mbit
# autosensing, and the secondary net will be in /etc/hostname.le0
# Otherwhise the names are /etc/hostname.le0 and /etc/hostname.le1
# If the second net ever becomes 100 Mbit, we have to ask.
#
# UltraPCI: the prtconf command failed to report the name of the
# ethernet interface(s).  So we invoked an old rule: when you
# want something done right, do it yourself, and wrote a program,
# findedevices, that probes for possible ethernet interfaces
#
# Next, as of 2/14/01 we must support the eri device. Lots of 
# choices, lots of permutations. The solution does not cover 
# all possibilities (eg, three devices) but is easily adjusted
#
# Blade 1500 introduces the bge Ethernet device
# GigaSwift 10/100/1000 Ethernet introduces the Ethernet ce device
#
#-----------------------------------------------------------------
n_bge=`$vnmrsystem/bin/findedevices /dev/bge | wc -l` 
n_ce=`$vnmrsystem/bin/findedevices /dev/ce | wc -l` 
# the next line is to work around a bug, where if there is no /dev/ce
# the system claims there are 5; certain Solaris 8 version only
if [ $n_ce -gt 4 ] 
then
    n_ce=0
fi
n_eri=`$vnmrsystem/bin/findedevices /dev/eri | wc -l` 
n_hme=`$vnmrsystem/bin/findedevices /dev/hme | wc -l` 
case $n_bge in
  *2) driver1="bge0"
      driver2="bge1"
      ;;
  *1) driver1="bge0"
      if [ $n_eri -gt 0 ]
      then
        driver2="eri0"
      elif [ $n_ce -gt 0 ]
        then
          driver2="ce0"
        elif [ $n_hme -gt 0 ]
          then
            driver2="hme0"
          else
            driver2="le0"
      fi
      ;;
  *)
      case $n_eri in
        *2) driver1="eri0"
            driver2="eri1"
            ;;
        *1) driver1="eri0"
            if [ $n_ce -gt 0 ]
            then
              driver2="ce0"
            elif [ $n_hme -gt 0 ]
              then
                driver2="hme0"
              else
                driver2="le0"
            fi
            ;;
         *)
            case $n_hme in
              *2) driver1="hme0"
                  driver2="hme1"
                  ;;
              *1) driver1="hme0"
                  driver2="le0"
                  ;;
              *)
                  driver1="le0"
                  driver2="le1"
                  ;;
            esac
            ;;
      esac
      ;;
esac

#----------------------------------------------------------------
# Ask the user to reboot the console now,
# then select hme0, hme1, le0 or le1 as interface
#-----------------------------------------------------------------
echo " "
echo "Please reboot the console."
echo " "
echo "Then select from the options below:"
echo "1. Your SUN is attached to the console via the standard ethernet"
echo "   port"
echo "2. Your SUN is attached to the console via the second ethernet"
echo "   port."
echo " "
echo "What is your configuration? (1 or 2) [1]: \c"
read enet_type
if ( test x$enet_type != "x2" )
then
   enet_type=1
fi

#-----------------------------------------------------------------
# check that the default IP is not the main net IP
#-----------------------------------------------------------------
host_net=`grep -w \`uname -n\` $etc/hosts | awk 'BEGIN { FS = "." } \
                { printf("%d.%d.%d",$1,$2,$3) }'`
first_net_byte=`echo $host_net | awk 'BEGIN { FS = "." } \
                { printf("%d",$1) }'`
if [ x$enet_type = "x2" ]
then
   if [ x$first_net_byte = "x10" ]
   then
      cons_ip=172.16.0
   fi
else
   cons_ip=$host_net
fi

#-----------------------------------------------------------------
# we now allow only 'subspace' and 'wormhole' as second ethernet name
# the latter is mostly for manufacturing, to allow UNITY and
# G2000/mercury on the same SUN system
#-----------------------------------------------------------------
if [ x$enet_type = "x1" ]
then
      name=`cat /etc/hostname.$driver1`
else
   if [ -f /etc/hostname.$driver2 ]
   then
      name=`cat /etc/hostname.$driver2`
   else
      name="x"
   fi
   if [ x$name = "xwormhole" ]
   then
       hostname2_ok="1"
   else
       name=$enet2_name
       hostname2_ok="0"
   fi
fi
enet2_name=$name

#-----------------------------------------------------------------
# check hostname.le1, create if needed
#-----------------------------------------------------------------
if [ x$hostname2_ok = "x0" ]
then
   if [ x$enet_type = "x2" ]
   then
      echo $enet2_name > $etc/hostname.$driver2
      reboot=1

# next two commands "turn on" the ethernet interface,
# so catcheaddr can receive the broadcast RARP packet
# ifconfig commands taken from /etc/init.d/rootusr

      /sbin/ifconfig $driver2 plumb
      /sbin/ifconfig $driver2 inet "$cons_ip.1" netmask + \
						broadcast + -trailers up \
						2>&1 > /dev/null
   else
      enet2_name=`uname -n`
   fi
fi

# catch the ethernet address
if [ x$enet_type = "x1" ]
then
   cons_eadd=`/vnmr/bin/catcheaddr $driver1 G2000`
else
   cons_eadd=`/vnmr/bin/catcheaddr $driver2 G2000`
fi

#-----------------------------------------------------------------
# Because we have an install base with 160.0.160.0 as the console IP
# address, we must delete those entries in /etc/hosts
# We will then replace the IP net with 10.0.0.0, as specified in
# RFC1597 the following net numbers are reserved for private networks
# 10.0.0.0      - 10.255.255.255
# 172.16.0.0    - 172.31.255.255
# 192.168.0.0   - 192.168.255.255
# If the replacement is done, one needs to reboot the SUN to make
# it effective
#-----------------------------------------------------------------
if [ x$enet_type = "x2" ]
then
   tmp=`grep -w gemcon $etc/hosts |  awk 'BEGIN { FS = "." } \
                { printf("%d.%d.%d",$1,$2,$3) }'`
   if [ x$tmp != "x" ]
   then
      if [ $tmp != $cons_ip ]
      then
         grep -v $tmp $etc/hosts > /tmp/hosts
         cp /tmp/hosts $etc/hosts	
         rm /tmp/hosts
         reboot=1
      fi
   fi
   tmp=`grep -w $enet2_name $etc/hosts |  awk 'BEGIN { FS = "." } \
                { printf("%d.%d.%d",$1,$2,$3) }'`
   if [ x$tmp != "x" ]
   then
      if [ $tmp != $cons_ip ]
      then
         grep -v $tmp $etc/hosts > /tmp/hosts
         cp /tmp/hosts $etc/hosts
         rm /tmp/host
         reboot=1
      fi
   fi
fi

#-----------------------------------------------------------------
# deal with the /etc/ethers file
# if the ethernet address already exist, remove it
#-----------------------------------------------------------------
grep -s $cons_eadd $etc/ethers > /dev/null
if [ $? -eq 0 ]
then
   ether_name=`grep $cons_eadd $etc/ethers | tr \t " " |  \
		awk 'BEGIN { FS=" " } {print $2}'`
   grep -v $ether_name $etc/ethers > /tmp/ethers
   cp /tmp/ethers $etc/ethers
   rm /tmp/ethers
fi
if [ -f $etc/ethers ]
then
   chmod +w $etc/ethers
   echo "$cons_eadd\t$cons_name" >> $etc/ethers
   chmod -w $etc/ethers
else
   echo "$cons_eadd\t$cons_name" > $etc/ethers
fi


#-----------------------------------------------------------------
# add to /etc/hosts if needed, /etc/hosts should always exist
#-----------------------------------------------------------------
chmod +w $etc/hosts
grep -w $enet2_name  $etc/hosts > /dev/null
if [ $? -ne 0 ]
then
   echo "$cons_ip.1\t$enet2_name" >> $etc/hosts
   reboot=1
fi
grep -w $cons_name $etc/hosts > /dev/null
if [ $? -ne 0 ]
then
   echo "$cons_ip.21\t$cons_name" >> $etc/hosts
   reboot=1
fi
chmod -w $etc/hosts


#-----------------------------------------------------------------
# fix /etc/inetd.conf so tftpd gets started
#-----------------------------------------------------------------
grep -w "#tftp" $etc/inetd.conf > /dev/null
if [ $? -eq 0 ]
then
   chmod +w $etc/inetd.conf
   cat $etc/inetd.conf | sed -e 's/#tftp/tftp/' > $etc/inetd.conf.tmp
   cp $etc/inetd.conf.tmp $etc/inetd.conf
   rm $etc/inetd.conf.tmp
   chmod -w $etc/inetd.conf
   reboot=1
fi

#-----------------------------------------------------------------
# finally fix /etc/nsswitch.conf to continue looking locally
#-----------------------------------------------------------------
chmod +w $etc/nsswitch.conf
cat $etc/nsswitch.conf | sed -e						\
's/hosts:      nis \[NOTFOUND=return\]/hosts:      nis/' | sed -e 	\
's/hosts:      xfn nis \[NOTFOUND=return\]/hosts:      nis/' | sed -e 	\
's/ethers:     nis \[NOTFOUND=return\]/ethers:     nis/' 		\
						> $etc/nsswitch.conf.tmp
cp $etc/nsswitch.conf.tmp $etc/nsswitch.conf
rm $etc/nsswitch.conf.tmp
chmod -w $etc/nsswitch.conf

#-----------------------------------------------------------------
#create /tftpboot if needed, copy apmon,autshm,lnc
#-----------------------------------------------------------------
if [ ! -d /tftpboot ]
then
   mkdir /tftpboot
   reboot=1
fi
cp /vnmr/acq/apmon  /tftpboot/apmon
chmod 666 /tftpboot/apmon
cp /vnmr/acq/autshm /tftpboot/autshm
chmod 666 /tftpboot/autshm
cp /vnmr/acq/lnc    /tftpboot/lnc
chmod 666 /tftpboot/lnc

#-----------------------------------------------------------------
# Arrange for Acqproc to start at system bootup
#-----------------------------------------------------------------
cp -p /vnmr/rc.vnmr $etc/init.d
(cd $etc/rc3.d; if [ ! -h S19rc.vnmr ]; then 
                   ln -s ../init.d/rc.vnmr S19rc.vnmr; fi)
(cd $etc/rc0.d; if [ ! -h K19rc.vnmr ]; then
                   ln -s ../init.d/rc.vnmr K19rc.vnmr; fi)
make_etc_files

#-----------------------------------------------------------------
# Check if we need to create a default router
# This would stop in.routed from being started at bootup
#-----------------------------------------------------------------
if [ x$enet_type = "x2" ]
then
   if [ -f $etc/defaultrouter ]
   then
       n=`wc -l $etc/defaultrouter | awk '{ printf("%d",$1) }'`
       if [ $n -ne 0 ]
       then
          echo ""
       else
         reboot=1
         line=`netstat -r -n | grep default`
         echo $line | awk 'BEGIN { FS = " " } { print $2 }' > $etc/defaultrouter
       fi
   else
      reboot=1
      line=`netstat -r -n | grep default`
      echo $line | awk 'BEGIN { FS = " " } { print $2 }' > $etc/defaultrouter
   fi
fi
#-----------------------------------------------------------------
# Also, create /etc/notrouter, so that no matter how the install
# is done (e.g. incomplete nets) the system does not become a router
#-----------------------------------------------------------------
if [ ! -f /etc/notrouter ]
then
   touch $etc/notrouter
fi

#-----------------------------------------------------------------
# report names and numbers
#-----------------------------------------------------------------
echo "Console name:      $cons_name"	>  /vnmr/acq/console_name
echo "Console IP#:       $cons_ip.1"	>> /vnmr/acq/console_name
echo "2nd Ethernet name: $enet2_name"	>> /vnmr/acq/console_name
echo "2nd Ethernet IP#:  $cons_ip.21"	>> /vnmr/acq/console_name


echo "VNMR Console software installation complete"
#-----------------------------------------------------------------
# Do we need to reboot the SUN? If not, restart rarpd
#-----------------------------------------------------------------
if [ $reboot -eq 1 ]
then
   echo " "
   echo "You must reboot Solaris for these changes to take effect"
   echo "As root type 'reboot' to reboot Solaris"
else
   /usr/sbin/in.rarpd -a
fi

