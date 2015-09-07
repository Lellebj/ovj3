: '@(#)gnu_fix.sh 22.1 03/24/08 1999-2002 '
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
#!/usr/bin/perl
#cd /bin-perl/bin-perl 
#then run the below command
#perl rmk
#
#!/usr/bin/perl

########first edit ##########Comment not in
########second edit #####
########3rd edit ##### will do delget no -y
########4th edit ##### will  -y$comment
########5th edit ##### will  -y$comment again


$this_file = $ARGV[0];

#open (EP, "/etc/passwd");
#while (<EP>) {
#   chomp;
#   print "\t $_ \n";
#}

open (fd1, $this_file);
while (<fd1>) {
   #chomp;

   #print $_;

   if ( $_ =~ /^\#ifdef/ ) {
      print $_;

   } elsif ( $_ =~ /^\#else/ ) {
      print "#else \n"

   } elsif ( $_ =~ /^\#endif/ ) {
      print "#endif \n";

   } else {
      print "$_";
   }

   #$ss = substr ("$_", 0, 6);
   #if ("$ss" ne "./lib/") {
   #    print "$ss\n";
   #    doEdit ($_);
   #}
}
close(fd1);

exit

#There are 5 Makefile(s) don't have JAVA_HOME set
#use j_home to track it

#\icc\Workflow\Makefile
#\icc\samples\PropertyBrowser\Makefile
#\icc\Nuphone\phoneclient\Makefile
#\icc\Isql\Makefile
#\icc\crm\intergration\octane\Makefile

#sub doEdit {
#
#        $mkfile = "\/iCC\/" . "$_";
#
#        print "$mkfile\n";
#        #return;
#
#	open (fd2, "$mkfile");
#	open (fd3, "> /tmp/ifSeePleaseRemoveMe");
#        $j_home = 0;
#
#	while (<fd2>) {
#	   #chomp;
#
#	   $jhome_index   = index( $_, "JAVA_HOME");
#	   $comp_index    = index( $_, "COMPBIN =");
#	   $jar_index     = index( $_, "jar cf");
#	   $jsgner_index  = index( $_, "jarsigner");
#	   $rmic_index    = index( $_, "rmic ");
#	   $javah_index   = index( $_, "javah ");
#
#	   if ($jhome_index == 0) {
#	        print fd3 "JAVA_HOME = \$(DPLROOT)/jdk\n";
#                $j_home = 1;
#	   } elsif ($comp_index == 0) {
#  	        print fd3 "COMPBIN = \$(JAVA_HOME)/bin/javac\n";
#	   } elsif ($jar_index == 1) {
#                substr($_, 1, 3) = "\$(JAVA_HOME)/bin/jar";
#  	        print fd3 "$_";
#	   } elsif ($jsgner_index == 1) {
#                substr($_, 1, 9) = "\$(JAVA_HOME)/bin/jarsigner";
#  	        print fd3 "$_";
#	   } elsif ($rmic_index == 1) {
#                substr($_, 1, 4) = "\$(JAVA_HOME)/bin/rmic";
#  	        print fd3 "$_";
#	   } elsif ($javah_index == 1) {
#                substr($_, 1, 5) = "\$(JAVA_HOME)/bin/javah";
#  	        print fd3 "$_";
#	   } else {
#	        print fd3 "$_";
#	   }
#
#
#	   $jhome_index   = -1;
#	   $comp_index    = -1;
#	   $jar_index     = -1;
#	   $jsgner_index  = -1;
#	   $rmic_index    = -1;
#	   $javah_index   = -1;
#	}
#
#	close(fd2);
#	close(fd3);
#
#	rename("/tmp/ifSeePleaseRemoveMe", "$mkfile")
#	                    || die "Can't rename xx! \n";
#
#
##Must be a better way doing this
##Also modify iCC\Makefile -No good- need manually reverse it
#
#	if ($j_home == 0) {
#
#                print "File missing JAVA_HOME : $mkfile\n";
#
#        	open (fd2, "$mkfile");
#        	open (fd3, "> /tmp/ifSeePleaseRemoveMe");
#
#		print fd3 "\n";
#		print fd3 "!ifndef JAVA_HOME\n";
#		print fd3 "JAVA_HOME = \$(DPLROOT)/jdk\n";
#		print fd3 "!endif\n";
#		print fd3 "\n";
#
#         	while (<fd2>) {
#	            #chomp;
#	            print fd3 "$_";
#                }
#
#		close(fd2);
#		close(fd3);
#
#	        rename("/tmp/ifSeePleaseRemoveMe", "$mkfile")
#	                    || die "Can't rename yy! \n";
#        }
#}
