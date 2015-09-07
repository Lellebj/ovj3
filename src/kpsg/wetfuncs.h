/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
 * Varian,Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian, Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */
#ifndef WETFUNCS_H
#define WETFUNCS_H

#include "acqparms2.h"

/* wet4 - Water Elimination */
extern void wet4(codeint phaseA, codeint phaseB);
extern int getflag(char *str);
extern void comp90pulse(double width, codeint phase, double rx1, double rx2);

#endif
