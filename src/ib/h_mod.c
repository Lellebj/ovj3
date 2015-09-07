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
shortint h_mod(a,b) short *a, *b;
#else
shortint h_mod(short *a, short *b)
#endif
{
return( *a % *b);
}
