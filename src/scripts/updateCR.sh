#!/bin/csh -f
# '@(#)updateCR.sh 22.1 03/24/08 1991-1996 '
#
# Another Great csh & awk script from Greg Brissey  6/12/92
# Given the filtervms script output and pin positiion file this script
# calculate the ZONE and inserts the zone into the file
# modified to handle new SC output format
#

set argn = ${#argv}
if ( $argn > 1 ) then
  echo "Usage:  updateCR year,  e.g.  updateCR 1996"
  exit
else

endif

set yr = $argv[1]


set filelist = `ls *`

#set yr = "1996"
#set filelist = "/common/sysvwacq/tmp.srt"


foreach file ($filelist)

# echo $file


nawk -f - yrarg=$yr pinf=$file $file > $file.cr << THEEND
BEGIN { flag = 0;
}
{   
  while( getline < pinf )
  {
    if ( \$0 ~ /Copyright/ )
    {
       if ( sub("-19[1-9][0-9]","-1997") < 1)
       {
         if ( sub("-[1-9][0-9]","-1997") < 1)
         {
           if ( sub(",19[1-9][0-9]","-1997") < 1)
           {
             if ( sub(",[1-9][0-9]","-1997") < 1)
             {
               if ( sub("19[1-9][0-9] Varian","1994-1997 Varian") < 1)
               {
                  if ( sub("19[1-9][0-9] SISCO","1994-1997 Varian") < 1)
                  {
		     print "WARNING No Copyright subsitution performed: " \$0 | "cat 1>&2"
                  }
               }
             }
           }
         }
       }
    }
    print \$0
  }
}
THEEND

diff -b $file $file.cr > $file.dif
set difcnt = `cat $file.dif | wc -l`
if ($difcnt == 0) then
           continue;
endif
if ( ($difcnt == 4) || ($difcnt == 8) ) then
          set answer = "y"
else
          echo "  Dif : $difcnt"
	  cat $file.dif
          echo -n "OK (y/n) "
          set answer = $<
endif
if ("x$answer" == "xy") then
   mv $file $file.bkup
   mv $file.cr $file
endif
end
