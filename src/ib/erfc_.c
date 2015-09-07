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
double erfc();
double erfc_(x) real *x;
#else
extern double erfc(double);
double erfc_(real *x)
#endif
{
return( erfc(*x) );
}
