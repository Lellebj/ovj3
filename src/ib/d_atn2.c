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

#ifdef KR_headers
double atan2();
double d_atn2(x,y) doublereal *x, *y;
#else
#undef abs
#include "math.h"
double d_atn2(doublereal *x, doublereal *y)
#endif
{
return( atan2(*x,*y) );
}
