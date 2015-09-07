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
integer i_len(s, n) char *s; ftnlen n;
#else
integer i_len(char *s, ftnlen n)
#endif
{
return(n);
}
