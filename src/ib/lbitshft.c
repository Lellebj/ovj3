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

 integer
#ifdef KR_headers
lbit_shift(a, b) integer a; integer b;
#else
lbit_shift(integer a, integer b)
#endif
{
	return b >= 0 ? a << b : (integer)((uinteger)a >> -b);
	}
