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
 
/*  Below are various symbols required by routines in magiclib.a or
    unmrlib.a which are needed by the ``vconfig'' program.  They are
    defined here to prevent the ``ld'' program from bringing in the
    VNMR module which defines them.					*/
 
int     Dflag = 0;
int     Eflag = 0;
 
/*  The next two actually do something.  */
 
/* char *skymalloc(memsize)
int memsize;
{
        return( (char *) malloc(memsize) );
}
 
skyfree(memptr)
unsigned *memptr;
{
        return( free(memptr) );
} */
 
/* called from varaibles1.c in tossvar() */
/**
void unsetMagicVar(addr)
int addr;
{
}
**/

/*  Under normal operation the window routines below should not
    be called.  At this time each routine just announces itself.  */
     
WerrprintfWithPos()
{
/*        printf( "WerrprintfWithPos called\n" ); */
}
 
Wscrprintf()
{
/*        printf( "Wscrprintf called\n" ); */
}

Wprintfpos()
{
/*        printf( "Wprintfpos called\n" ); */
}
 
Werrprintf()
{
/*        printf( "Werrprintf called\n" ); */
}

Winfoprintf()
{
/*        printf( "Winfoprintf called\n" ); */
}

Wgetgraphicsdisplay()
{
}

Wclearerr()
{
}

Wgettextdisplay()
{
}

Wissun()
{
}
