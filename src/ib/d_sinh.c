/*
 * Copyright (C) 2015  University of Oregon
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
#include "f2c.h"

#ifdef KR_headers
double sinh();
double d_sinh(x) doublereal *x;
#else
#undef abs
#include "math.h"
double d_sinh(doublereal *x)
#endif
{
return( sinh(*x) );
}
