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

ftnlen f__typesize[] = { 0, 0, sizeof(shortint), sizeof(integer),
			sizeof(real), sizeof(doublereal),
			sizeof(complex), sizeof(doublecomplex),
			sizeof(logical), sizeof(char),
			0, sizeof(integer1),
			sizeof(logical1), sizeof(shortlogical),
#ifdef Allow_TYQUAD
			sizeof(longint),
#endif
			0};
