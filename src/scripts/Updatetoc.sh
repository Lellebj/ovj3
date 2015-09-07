#!/bin/csh -f
# '@(#)Updatetoc.sh 22.1 03/24/08 1994-1996 '
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
set argn = ${#argv}
if ( $argn == 3 ) then
   set bname = $argv[1]
   set fname = $argv[2]
   set oname = $argv[3]
else
   echo -n "Enter TOC file name (e.g. common.toc): "
   set bname = $<
   echo -n "Enter Tar Size file: (e.g. com.sizes): "
   set fname = $<
   echo -n "Enter Output file: (e.g. common.toc.xxx): "
   set oname = $<
endif

# 1st read in given file of tar or ar sizes
# 2nd read in toc file and create file size field
# 3rd write out new toc file with size info included.
#E.G. file or sizes
# com.size:    NOTE: sizes in KiloBytes(BSD)  (SystemV gives 512 bytes)
# 456     com.tar
# 472     fidlib.tar
# 832     manual.tar
# 640     maclib.tar
# 2616    par.tar
# 64      bin.ar
# 78       psg.ar
# 160     psglib.ar
# 91      shapelib.ar
# 83      help.ar
# 58      menulib.ar
# 1       tablib.ar
# 232     PFG.tar
#
nawk -f - pinf=$fname bmf=$bname $fname > $oname << THEEND
BEGIN { flag = 0;
}
{
  while( getline < pinf ) # read in file of tar or ar sizes
  {
    kilosiz = \$1;
    archive = \$2;
    tarsize[archive] = kilosiz / 1000;  # size in MB
    # printf("arch: %s, size: %d \n",archive,kilosiz);
  }

     # for ( rd in tarsize)
     # {
     #    printf("archive:  %s, \t size: %f \n",rd,tarsize[rd]);
     # }
   # printf("\n")

  flag = 0
 
  while( getline < bmf )
  {
    if ( index(\$1,"#") != 0 ) 
    {
      printf("%s\n",\$0);
      continue;
    }  
    refarch = \$1
    sub(/.Z/,"",refarch);	# strip .Z out of name to find match

   if (refarch in tarsize)	# find the match and add the size
   { 
     printf("%-10s \t %s \t %5.2f \t",\$1,\$2,tarsize[refarch]);
     for (j = 3; j <= NF; j++)
       printf("%s ",\$j);
     printf("\n");
   } 
  }  
  exit
}
THEEND
