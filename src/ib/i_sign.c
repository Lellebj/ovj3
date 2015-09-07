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
integer i_sign(a,b) integer *a, *b;
#else
integer i_sign(integer *a, integer *b)
#endif
{
integer x;
x = (*a >= 0 ? *a : - *a);
return( *b >= 0 ? x : -x);
}
