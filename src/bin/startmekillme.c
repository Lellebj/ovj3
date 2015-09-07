/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* 
* Varian Assoc.,Inc. All Rights Reserved.
* This software contains proprietary and confidential
* information of Varian Assoc., Inc. and its contributors.
* Use, disclosure and reproduction is prohibited without
* prior consent.
*/

/* program to fork & execute a shell script, for the passwd file entry 'acqproc' */
#include <stdio.h>
main(argc,argv)
int argc;
char *argv[];
{
   /*fprintf(stderr,"execl('/bin/sh','-c','/vnmr/bin/execkillacqproc')\n"); */
   if (execl("/bin/sh","-c","/vnmr/bin/execkillacqproc",NULL) == -1)
   {
	perror("startmekillme: execl Error");
   }
   exit(0);
}
