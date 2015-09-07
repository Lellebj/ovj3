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
integer i_abs(x) integer *x;
#else
integer i_abs(integer *x)
#endif
{
if(*x >= 0)
	return(*x);
return(- *x);
}
