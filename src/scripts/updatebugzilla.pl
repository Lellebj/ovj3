 @(#)updatebugzilla.pl 22.1 03/24/08 Copyright (c) 2003-2005 Agilent Technologies All Rights Reserved
#
# Copyright (c) 1999-2000 Agilent Technologies All Rights Reserved.
# This software contains proprietary and confidential
# information of Agilent Technologies and its contributors.
# Use, disclosure and reproduction is prohibited without
# prior consent.
#
# @(#)updatebugzilla.pl 22.1 03/24/08 Copyright (c) 2003-2005 Agilent Technologies All Rights Reserved
#
# Copyright (c) 1999-2000 Agilent Technologies All Rights Reserved.
# This software contains proprietary and confidential
# information of Agilent Technologies and its contributors.
# Use, disclosure and reproduction is prohibited without
# prior consent.
#
#!c:/perl/bin/perl.exe
#!/usr/bin/perl

#Usage: perl t0             for 6.1 and others
#		perl t0 VJ.Beta     for VJ, this arg1 is $nmr_ver will go to "version" column of bugs table
#		perl t0 VJ1         for VJ1 released
#
#	Be sured new version actually in the table (by editting components) before running this script

use strict;
use DBI;

my ($Y, $M, $D) = (localtime)[5,4,3];
my $today = sprintf("%04d-%02d-%02d", ($Y)+1900 , ($M)+1 , $D);

    my @splitline;
    my @priority_words;
    my $fullsum_multi_lines_count=0;
    my $workaround_multi_lines_count=0;
    my $dash_line_count=0;
    my $start_detailed_bugs=0;

    my $keyword_cnt=1;
    my $short_summary_cnt=0;
	my $related_cnt=0;
    my $full_summary_cnt=0;
    my $bad_version_cnt=0;
    my $sun_software_cnt=0;
    my $spectrometer_cnt=0;
    my $fixed_version_cnt=0;
    my $reported_by_cnt=0;
    my $date_cnt=0;
    my $confirmed_by_cnt=0;
    my $severity_cnt=0;
    my $priority_cnt=0;
    my $workaround_cnt=0;

	my $keyword = "";
	my $nmr_bug_id = "";
	my $short_summary = "";
	my $full_summary = "";
	my $related = "";
	my $orig_bad_version = "";
	my $fixed_version = "";
	my $reported_by = "";
	my $date = "";
	my $confirmed_by = "";
	my $severity = "";
	my $priority = "";
	my $workaround = "";

	my ($nmr_ver, $host_os, $nmr_product);

#have to do the below for this script to talk to DB
#mysql> grant all on bugs.*  to bugs@10.190.50.29 identified by "bugs";

	my $db_host = "10.190.50.42";        #bugzilla
	my $db_name = "bugs";
	my $db_user = "bugs";
	my $db_pass = "bugs";

 	my ($dbHDL, $dbSTH);

#open (LOG1, ">> C:/landfill/notes/__Bugzilla/test/log_$today");
open (LOG1, ">> /usr25/chin/buz-stuff/bugs_rolfk/log_$today");

#Comment out to work from home
$dbHDL = ConnectToDatabase();

# my @bug_fields = ("reporter", "product", "version", "rep_platform",
#                  "bug_severity", "priority", "op_sys", "assigned_to",
#                  "bug_status", "bug_file_loc", "short_desc", "component",
#                  "target_milestone");
#
# my @used_fields;
# foreach my $f (@bug_fields) {
#    if (exists $::FORM{$f}) {
#        push (@used_fields, $f);
#    }
# }
#
# my $query = "INSERT INTO bugs (\n" . join(",\n", @used_fields) . ",
# creation_ts, groupset)
# VALUES (
# ";



#open (fd1, "C:/landfill/notes/__Bugzilla/test/bug1.txt");
#open (fd1, "C:/landfill/notes/__Bugzilla/test/bug0102.txt");
#open (fd1, "C:/landfill/notes/__Bugzilla/test/rolf-bugs/buglist.61.txt");
#open (fd1, "C:/landfill/notes/__Bugzilla/test/rolf-bugs/new61Cbuglist.txt");
#open (fd1, "C:/landfill/notes/__Bugzilla/test/rolf-bugs/newVJ1released.txt");
#open (fd1, "C:/landfill/notes/__Bugzilla/test/rolf-bugs/032702-bug-update.txt");
#open (fd1, "C:/landfill/notes/__Bugzilla/test/rolf-bugs/040102-bug-update.txt");

#open (fd1, "C:/landfill/notes/__Bugzilla/test/bugs-rolfk/043002VJ.txt");
#open (fd1, "/usr25/chin/buz-stuff/bugs_rolfk/bugs_6.1_1-9-2006");

if ( $#ARGV == 1 ) { 
  open (fd1, $ARGV[1]);
} else {
  open (fd1, $ARGV[0]);
}

while (<fd1>) {
    chomp;
	
	if ($start_detailed_bugs == 0) {
		unless (/ DETAILED BUG LIST/) {
			next;	
		}
		else {
			$start_detailed_bugs = 1;
			next;
		}
		
	}

	if (/Keyword:/) {
        @splitline = split;
		my $num_ele = scalar(@splitline);
        	$keyword = $splitline[1];
		if ( $keyword_cnt == 0 ) {
				$keyword_cnt=1;
				#the sample Keyword: - do nothing
				#next;

		} elsif ( $num_ele == 4 ) {
           		$nmr_bug_id = $splitline[3];
           		#$query .= "$nmr_bug_id')\n";

		} elsif ( $num_ele == 5 ) {
           		$nmr_bug_id = $splitline[4];
           		#$query .= "$nmr_bug_id')\n";

		} elsif ( $num_ele == 6 ) {
           		$nmr_bug_id = $splitline[5];
           		#$query .= "$nmr_bug_id')\n";

           $keyword = $splitline[1] . $splitline[2];

		} elsif ( $num_ele == 7 ) {

           		$nmr_bug_id = $splitline[6];
           		#$query .= "$nmr_bug_id')\n";

           		$keyword = $splitline[1] . $splitline[2];
		} elsif ( $num_ele == 11 ) {
           		$nmr_bug_id = $splitline[10];
           		#$query .= "$nmr_bug_id')\n";
                }else {       
	   		#exit;
		}

	   #print "keyword= $keyword ---- \n";
	   #print "nmr_bug_id= $nmr_bug_id ---- \n\n";

	} elsif (/Short summary:/) {

		if ( $short_summary_cnt == 0 ) {
			$short_summary_cnt=1;
        } else {
        	@splitline = split(/:/);
			$short_summary= $splitline[1];        

			$short_summary =~ s/^\s+//;               # no leading white
			$short_summary =~ s/\s+$//;               # no trailing white
		}
		#print "split0= $splitline[0]  \n";        
		#print "short_summary= $splitline[1]  \n\n";        

	} elsif (/Full summary:/) {

		if ( $full_summary_cnt == 0 ) {
				$full_summary_cnt=1;
		} else {

			$full_summary = "$_";        

        	#@splitline = split(/:/);
			#$full_summary = "$splitline[1]";        

			$full_summary =~ s/^\s+//;               # no leading white
			$full_summary =~ s/\s+$//;               # no trailing white


			$fullsum_multi_lines_count=1;  #to read multiple lines token
		}

		#print "split0= $splitline[0]  \n";        
		#print "full_summary= $splitline[1]  \n\n";        

	} elsif (/Related:/) {

        	@splitline = split(/:/);
			$related = $splitline[1];        

		#print "split0= $splitline[0]  \n";        
		#print "related= $splitline[1]  \n\n";        

	} elsif (/Bad versions:/) {

		if ( $bad_version_cnt == 0 ) {  #the first Bad version: is example
			$bad_version_cnt=1;

		} else {

			$_ =~ s/^\s+//;               # no leading white
			$_ =~ s/\s+$//;               # no trailing white

			$full_summary .= "\n\n $_";  #Dan wants more information together with full summary

        	@splitline = split(/:/);

        	#everything else after "Bad version:"
			$orig_bad_version= $splitline[1];        

			$orig_bad_version =~ s/^\s+//;               # no leading white
			$orig_bad_version =~ s/\s+$//;               # no trailing white

        	my @aa = split(/ \/ /, $orig_bad_version);
        	my $num_ele = scalar(@aa);
			#print "num_ele= $num_ele\n";
			#print "aa= @aa \n";


        	if ( $aa[0] ) {  #NMR versions

        		#This takes care first token "VNMR n.nX"
        		if ($aa[0] =~ /VNMR/) {
           	     my (@ary) = split  (" ", $aa[0]);

					$nmr_ver = $ary[1];
					$nmr_ver =~ s/,//;               # no trailing ","

					#print "\nsplitline =@splitline+++++\n";
					#print "nmr_ver =$nmr_ver\n";
				}
			}


        	if ( $aa[1] ) {  #Operation system

        		#ignore "OS?" and all other
        		if ($aa[1] =~ /Solaris/) {

					$host_os = "Solaris";

        		} elsif ($aa[1] =~ /AIX/) {

					$host_os = "AIX";
		
        		} elsif ($aa[1] =~ /IRIX/) {

					$host_os = "IRIX";

				}

				#print "hosts_os=$host_os\n";
			} else {
					
					$host_os = "";
			
			} 


     	   if ( $aa[2] ) {  #console models

				my @bb;
				@bb = split(/ \/ /, $aa[2]);

        		#ignore "OS_Undefined" and all other
        		if ($bb[0] =~ /UNITY INOVA/) {

					$nmr_product = "INOVA";

        		} elsif ($bb[0] =~ /UNITYplus/) {

					$nmr_product = "Unity Plus";
		
        		} elsif ($bb[0] =~ /VXR-S/) {

					$nmr_product = "VXR-S";
		
        		} elsif ($bb[0] =~ /MERCURY-Vx/) {

					$nmr_product = "MERCURY VX/Plus";
		
        		} elsif ($bb[0] =~ /MERCURYplus/) {

					$nmr_product = "MERCURY VX/Plus";
		
        		} elsif ($bb[0] =~ /MERCURY/) {

					$nmr_product = "MERCURY";
		
        		} elsif ($bb[0] =~ /GEMINI 2000/) {

					$nmr_product = "GEMINI 2000";

				} else {
					$nmr_product = "??";
				}

				$nmr_product =~ s/,//;               # no trailing ","

				#print "nmr_product=$nmr_product\n";
			} else {

					$nmr_product = "?";
			}

			$fullsum_multi_lines_count=0;

		}

	} elsif (/Fixed version:/) {

		if ( $fixed_version_cnt == 0 ) {
			$fixed_version_cnt=1;

		} else {

			$_ =~ s/^\s+//;               # no leading white
			$_ =~ s/\s+$//;               # no trailing white

			$full_summary .= "\n $_";  #Dan wants more information together with full summary

        	@splitline = split(/:/);

			if (! $splitline[1]) {
				$splitline[1] = " ";
			}

			$fixed_version= $splitline[1];        
		}

		#print "split0= $splitline[0]  \n";        
		#print "fixed_version= $splitline[1]  \n\n";        

   	} elsif (/Reported by:/) {

		if ( $reported_by_cnt == 0 ) {
			$reported_by_cnt=1;

		} else {
        	@splitline = split(/:/);
			$reported_by= $splitline[1];        

			$reported_by =~ s/^\s+//;               # no leading white
			$reported_by =~ s/\s+$//;               # no trailing white
		}

		#print "split0= $splitline[0]  \n";        
		#print "reported_by= $splitline[1]  \n\n";        

   	} elsif (/Date:/) {

		if ( $date_cnt == 0 ) {
			$date_cnt=1;

		} else {

        	@splitline = split(/:/);
			$date= $splitline[1] . " 00:00:00";        

			$date =~ s/^\s+//;               # no leading white
			$date =~ s/\s+$//;               # no trailing white
		}

		#print "split0= $splitline[0]  \n";        
		#print "date= $date  \n\n";        

   	} elsif (/Confirmed by:/) {

			$_ =~ s/^\s+//;               # no leading white
			$_ =~ s/\s+$//;               # no trailing white

			$full_summary .= "\n $_";  #Dan wants more information together with full summary

		if ( $confirmed_by_cnt == 0 ) {
			$confirmed_by_cnt=1;

		} else {
        	@splitline = split(/:/);
			$confirmed_by= $splitline[1];        
		}

		#print "split0= $splitline[0]  \n";        
		#print "confirmed_by= $splitline[1]  \n\n";        

   	} elsif (/Severity:/) {

                        $_ =~ s/^\s+//;               # no leading white
                        $_ =~ s/\s+$//;               # no trailing white

                        $full_summary .= "\n $_";  #Dan wants more information together with full summary

                if ( $severity_cnt == 0 ) {
                        $severity_cnt=1;

                } else {
                @splitline = split(/:/);
                        $severity= $splitline[1];
                }

                #print "split0= $splitline[0]  \n";
                #print "confirmed_by= $splitline[1]  \n\n";

        } elsif (/Priority:/) {

                        $_ =~ s/^\s+//;               # no leading white
                        $_ =~ s/\s+$//;               # no trailing white

                        $full_summary .= "\n $_";  #Dan wants more information together with full summary

                if ( $priority_cnt == 0 ) {
                        $priority_cnt=1;

                } else {
                @splitline = split(/:/);
                        $priority= $splitline[1];
			my (@ary) = split  (" ", $splitline[1]);
                        $priority = $ary[0]; 
			#print "priority=$priority \n";
                }

                #print "split0= $splitline[0]  \n";
                #print "priority= $priority  \n\n";

        } elsif (/Workaround:/) {

			$_ =~ s/^\s+//;               # no leading white
			$_ =~ s/\s+$//;               # no trailing white

			$full_summary .= "\n $_";  #Dan wants more information together with full summary

		if ( $workaround_cnt == 0 ) {
			$workaround_cnt=1;

		} else {
        	@splitline = split(/:/);
			$workaround= $splitline[1];        
			$workaround =~ s/^\s+//;               # no leading white

			$workaround_multi_lines_count = 1;
		}

		#print "split0= $splitline[0]  \n";        
		#print "workaround= $splitline[1]  \n\n";        

   	} elsif (/  If you want to report/) {
		last;	
   	} elsif (/--------------------------------------------------------------------------/) {

		#if ($dash_line_count == 0 ) {   # this is the first -------- don't count
		#	$dash_line_count = 1;

   		#} else {      #This mark the end of one bug, 
					   #Continue constructing and sending query

			#print "\n\nkeyword= $keyword \n";
			#print "nmr_bug_id= $nmr_bug_id \n";
			#print "priority= $priority \n";
			#print "severity= $severity \n";
			#print "short_summary= $short_summary \n";
			#print "full_summary= \t $full_summary \n";
			#print "related= $related \n";
			#print "orig_bad_version= $orig_bad_version \n";
			#print "fixed_version= $fixed_version \n";
			#print "reported_by= $reported_by \n";
			#print "date= $date \n";
			#print "confirmed_by= $confirmed_by \n";
			#print "workaround= $workaround \n\n";
			#print "date= $date \n";
			#print "host_os= $host_os \n";
			#print "nmr_product= $nmr_product \n";
			#print "short_summary= $date \n\n";


			my $bug_reporter = 2;  #Dan's ID
			my $bug_status = "NEW";
			my $assigned_to = 2;     #search won't work correctly without this one

			if ( $#ARGV == 0 ) {  #for VJ bugs list only, be careful with the bug file name

				$nmr_ver = $ARGV[0];
				$nmr_product = "INOVA";

			}

			#---------------------------------------
			#is this bug already in?
			SendSQL ("SELECT varinc_id, bug_id  FROM bugs WHERE varinc_id='$nmr_bug_id'");
			my @ids = $dbSTH->fetchrow_array();

			if ( ! $ids[0] ) {  #New bug

				SendSQL("INSERT INTO bugs (varinc_id, reporter, varinc_reporter, bug_status, assigned_to,
					 creation_ts, version, op_sys, product, short_desc, varinc_badver,
					 bug_severity, priority, workaround) values" .  "("
												. SqlQuote($nmr_bug_id) . ","     #from Rolf, acqi.6102 ...
												. SqlQuote($bug_reporter) . ","   #bugzilla assigned person
												. SqlQuote($reported_by) . ","    #original reporter
												. SqlQuote($bug_status) . ","     #set to NEW
												. SqlQuote($assigned_to) . ","    #to Dan  (2)
												. SqlQuote($date) . ","
												. SqlQuote($nmr_ver) . ","     #version 6.1C VJ.Beta VJ1 ...
												. SqlQuote($host_os) . ","
												. SqlQuote($nmr_product) . "," #program: INOVA MERCURY VX/Plus ...
												. SqlQuote($short_summary) . ","
												. SqlQuote($orig_bad_version) . ","
												. SqlQuote($severity) . ", "
												. SqlQuote($priority) . ", "
												. SqlQuote($workaround) . ")");	


				#this value was an autoincremented id from the above INSERT, put this same
				#id to longdescs table
				SendSQL ("SELECT bug_id  FROM bugs WHERE varinc_id=" . SqlQuote($nmr_bug_id));
				my @auto_bug_id = $dbSTH->fetchrow_array ();


       			SendSQL("INSERT INTO longdescs (bug_id, who, varinc_id, bug_when,
					 varinc_reporter, thetext) values" . "("
							. SqlQuote($auto_bug_id[0]) . ","
							. SqlQuote($bug_reporter) . ","
							. SqlQuote($nmr_bug_id) . ","
							. SqlQuote($date) . ","
							. SqlQuote($reported_by) . ","
							. SqlQuote($full_summary) . ")");	

				print LOG1 "  $nmr_bug_id	\t\t ENTERED \t $auto_bug_id[0]\n";

			} else { #already exists

				SendSQL ("SELECT thetext  FROM longdescs WHERE varinc_id='$ids[0]'");
				my $long_text = $dbSTH->fetchrow_array();

				$long_text =~ s/^\s+//;               # no leading white
				$long_text =~ s/\s+$//;               # no trailing white


				if ($long_text eq $full_summary) {
					#do nothing
					print LOG1 "DUP: $nmr_bug_id \t$ids[1]\n";

				} else {   #append

					#duplicate, send to longdesc only
       				SendSQL("INSERT INTO longdescs (bug_id, who, varinc_id, bug_when,
						 varinc_reporter, thetext) values" . "("
								. SqlQuote($ids[1]) . ","
								. SqlQuote($bug_reporter) . ","
								. SqlQuote($nmr_bug_id) . ","
								. SqlQuote($date) . ","
								. SqlQuote($reported_by) . ","
								. SqlQuote($full_summary) . ")");	

				SendSQL("UPDATE bugs SET priority=" . SqlQuote($priority) . "WHERE varinc_id=". SqlQuote($nmr_bug_id)); 
					print LOG1 "DUP_APPENDED: $nmr_bug_id \t$ids[1]\n";
				}
			}

		#----------------------------------------------------------------------------------
		#end of one bug, reset all needed things

        $workaround_multi_lines_count=0;

		$keyword = "";
		$nmr_bug_id = "";
		$short_summary = "";
		$full_summary = "";
		$related = "";
		$orig_bad_version = "";
		$fixed_version = "";
		$reported_by = "";
		$date = "";
		$confirmed_by = "";
		$severity = "";
		$priority = "";
		$workaround = "";


   	} else {   # these are multiple lines comment
	     
		if ( $fullsum_multi_lines_count == 1 ) {

	   		$full_summary .= "\n $_" ;
		}

		if ( $workaround_multi_lines_count == 1 ) {

	   		$workaround .= "\n $_" ;
		}
   	}
} #end of while

print LOG1 "-------------------------------------------------\n";

close(fd1);




# This routine is largely copied from Mysql.pm.

sub SqlQuote {
    my ($str) = (@_);

#     if (!defined $str) {
#         confess("Undefined passed to SqlQuote");
#     }

    $str =~ s/([\\\'])/\\$1/g;
    $str =~ s/\0/\\0/g;
    # If it's been SqlQuote()ed, then it's safe, so we tell -T that.
    $str = detaint_string($str);
    return "'$str'";
}


# Use detaint_string() when you know that there is no way that the data
# in a scalar can be tainted, but taint mode still bails on it.
# WARNING!! Using this routine on data that really could be tainted
#           defeats the purpose of taint mode.  It should only be
#           used on variables that cannot be touched by users.

sub detaint_string {
    my ($str) = @_;
    $str =~ m/^(.*)$/s;
    $str = $1;
}
 
sub ConnectToDatabase {

     my $dbh = DBI->connect ("DBI:mysql:host=$db_host;database=$db_name", $db_user, $db_pass,
					{PrintError => 0, RaiseError => 1});
     return $dbh;				
}


sub SendSQL {

    my ($str, $dontshadow) = (@_);

	#print "++++ $str ++++\n";
    #my $iswrite =  ($str =~ /^(INSERT|REPLACE|UPDATE|DELETE)/i);

    $dbSTH = $dbHDL->prepare ($str);
    $dbSTH->execute ();

    #$::currentquery = $::db->prepare($str);
    #$::currentquery->execute
    #    || die "$str: " . $::db->errstr;
}


close(LOG1);

$dbSTH->finish ();

$dbHDL->disconnect ();
