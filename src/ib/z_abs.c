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
double f__cabs();
double z_abs(z) doublecomplex *z;
#else
double f__cabs(double, double);
double z_abs(doublecomplex *z)
#endif
{
return( f__cabs( z->r, z->i ) );
}
