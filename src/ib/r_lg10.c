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

#define log10e 0.43429448190325182765

#ifdef KR_headers
double log();
double r_lg10(x) real *x;
#else
#undef abs
#include "math.h"
double r_lg10(real *x)
#endif
{
return( log10e * log(*x) );
}
