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
double cos();
double d_cos(x) doublereal *x;
#else
#undef abs
#include "math.h"
double d_cos(doublereal *x)
#endif
{
return( cos(*x) );
}
