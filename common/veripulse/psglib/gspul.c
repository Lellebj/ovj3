
/*  gspul */

#include <standard.h>

void pulsesequence()
{
   double gzlvl1, gstab;

   gzlvl1 = getval("gzlvl1");
   gstab = getval("gstab");

   /* equilibrium period */
   status(A);
   hsdelay(d1-gstab);
   rgradient('z',gzlvl1);
   delay(gstab);

   /* --- observe period --- */
   status(C);
   pulse(pw,oph);
   acquire(np,1.0/sw);
   rgradient('z',0.0);
}
