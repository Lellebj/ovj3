// Copyright (C) 2015  Stanford University
// You may distribute under the terms of either the GNU General Public
// License or the Apache License, as specified in the README file.
// For more information, see the README file.

/*  s2pul - standard two-pulse sequence */

#include <standard.h>
#include <chempack.h>

pulsesequence()
{
   /* equilibrium period */
   status(A);

/*   lcsample(); */
   hsdelay(d1);

   /* --- tau delay --- */
   status(B);
   pulse(p1, zero);
   hsdelay(d2);

   /* --- observe period --- */
   status(C);
   pulse(pw,oph);
}
