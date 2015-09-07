// Copyright (C) 2015  Stanford University
// You may distribute under the terms of either the GNU General Public
// License or the Apache License, as specified in the README file.
// For more information, see the README file.
#ifndef LINT
#endif
/* 
 */

#include <standard.h>

pulsesequence()
{

   dpwr = getval("dpwr");
   if (dpwr > 46)               /* Do not fry the probe */
   { abort_message("Decoupling power too large (max is 46) - acquisition aborted.");
   }

   /* equilibrium period */
   status(A);
   decpwrf(4095.0);
   hsdelay(d1);

   /* --- tau delay --- */
   status(B);
   pulse(p1, zero);
   hsdelay(d2);

   /* --- observe period --- */
   status(C);
   pulse(pw,oph);
}
