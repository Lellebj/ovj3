/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* Copyright (c) Varian Assoc., Inc.  All Rights Reserved. */
#include "f2c.h"

/*
 * subroutine getarg(k, c)
 * returns the kth unix command argument in fortran character
 * variable argument c
*/

#ifdef KR_headers
VOID getarg_(n, s, ls) ftnint *n; register char *s; ftnlen ls;
#else
void getarg_(ftnint *n, register char *s, ftnlen ls)
#endif
{
extern int xargc;
extern char **xargv;
register char *t;
register int i;

if(*n>=0 && *n<xargc)
	t = xargv[*n];
else
	t = "";
for(i = 0; i<ls && *t!='\0' ; ++i)
	*s++ = *t++;
for( ; i<ls ; ++i)
	*s++ = ' ';
}
