/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* 
 * Varian,Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian, Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */
/**********************************************************************
 gsadd  -  Add two bin files 

 Details - Two binary files are added 

 Usage - gsadd rootfilename
         Input - file.1 file.2 file.param
         Output - file.out

**********************************************************************/


#include	<stdio.h>
#include	<stdlib.h>
#include	<string.h>
#include	<math.h>
#include	"util.h"

#define		TWOPI		6.28318531
#define 	PI		3.1415926

/* I/O string */
char		s[80];

main(argc,argv)
int 	argc;
char	*argv[];
{
    FILE	*paramsfile,*phasefile1,*phasefile2,*fieldfile;
    char	fieldname[80];
    int		args;
    int		xfieldres,yfieldres,zfieldres;
    float	xfov,yfov,zfov;
    int		totalfieldsize;
    float	*p1,*p2,*field;
    float	freq;
    int		point;
    float delay;

    /* 
     * usage 
     */ 

    checkargs(argv[0],argc,"rootfilename");

    /*
     * process arguments
     */

    args = 1;

    /* open the field map phase files, frequency file, and parameter files */
    strcpy(fieldname,argv[args]);
    phasefile1 = efopen(argv[0],strcat(fieldname,".1"),"r");
    strcpy(fieldname,argv[args]);
    phasefile2 = efopen(argv[0],strcat(fieldname,".2"),"r");
    strcpy(fieldname,argv[args]);
    paramsfile = efopen(argv[0],strcat(fieldname,".param"),"r");

    strcpy(fieldname,argv[args]);
    fieldfile = efopen(argv[0],strcat(fieldname,".out"),"w");

    /* read the field map parameters */

    /* read field map size */
    efgets(s,80,paramsfile);
    sscanf(s,"%d %d %d",&xfieldres,&yfieldres,&zfieldres);
    efgets(s,80,paramsfile);
    sscanf(s,"%f %f %f",&xfov,&yfov,&zfov);
    /* read phase delay */
    efgets(s,80,paramsfile);
    sscanf(s,"%f",&delay);

    /* calculate array size  */   
    totalfieldsize = xfieldres*yfieldres*zfieldres;

    /* allocate data space  */
    p1 = (float *) calloc((unsigned)totalfieldsize,sizeof(float));
    p2 = (float *) calloc((unsigned)totalfieldsize,sizeof(float));
    field = (float *) calloc((unsigned)totalfieldsize,sizeof(float));

    /*
     * process
     */

    /* read in */
    fread(p1,sizeof(float),totalfieldsize,phasefile1);
    fread(p2,sizeof(float),totalfieldsize,phasefile2);

    /* phasesubtract, checking overange */
    for ( point=0 ; point<totalfieldsize ; point++ )
    {
      field[point] = (p2[point]+p1[point]);   /* add value */
    }
    /* write out the field map */
    fwrite(field,sizeof(float),totalfieldsize,fieldfile);  
}

/*************************************************************************
		Modification History
		
**************************************************************************/