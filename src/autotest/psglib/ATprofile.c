/* 
 * Agilent Technologies All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Agilent Technologies and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

/*  profile - gradient calibrtion sequence */

#include <standard.h>
pulsesequence()
{
   double gzlvl1;
   double td;
   char   gradaxis[MAXSTR];

   getstrnwarn("gradaxis",gradaxis);
   if (( gradaxis[0] != 'x') && ( gradaxis[0] != 'y') && ( gradaxis[0] != 'z') )
      strcpy(gradaxis,"z");
   gzlvl1 = getval("gzlvl1");
   at = getval("at");
   assign(zero,oph);
   status(A);
   delay(d1);

   status(B);
   td = (d2-at/2.0)/2.0;
   if (td < 0.0)
     td = 0.0;
   rgpulse(p1, zero,rof1,rof2);
   delay(td);
   rgradient(gradaxis[0],gzlvl1);
   delay(at/2.0);
   rgradient(gradaxis[0],0.0);
   delay(td);
   status(C);
   pulse(pw,zero);
   delay(d2-at/2.0);
   rgradient(gradaxis[0],gzlvl1);
   delay(0.0001); /* let gradient stabilize */
   acquire(np,1/sw);
   rgradient(gradaxis[0],0.0);
}
