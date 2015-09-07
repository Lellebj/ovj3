/* 
 * Agilent Technologies All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Agilent Technologies and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

#include <standard.h>


pulsesequence()
{
   hsdelay(d1);
   rcvroff();
   if (dpwr==0.0) 
    rgpulse(p1, zero,50.0e-6,0.0);
   else
    decrgpulse(p1,zero,50.0e-6,0.0);
   delay(d2-rof1);
   if (dpwr==0.0)
    rgpulse(pw,two,rof1,rof2);
   else
    decrgpulse(pw,two,rof1,rof2);
}
