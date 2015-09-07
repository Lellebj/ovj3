/* 
 * Agilent Technologies All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Agilent Technologies and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */
/*  cancel - standard two-pulse sequence */

#include <standard.h>

static int phasecycle[4] = {0, 2, 1, 3};

pulsesequence()
{
   status(A);
   hsdelay(d1);
   pulse(p1, zero);
   hsdelay(d2);
   settable(t1,4,phasecycle);
   pulse(pw,t1);
   setreceiver(t1);
}
