/* ddec_s2pul */
#include <standard.h>
pulsesequence()
{
  char lkflg[MAXSTR];
  getstr("lkflg",lkflg);
  status(A);
   dec3blank();
  if (lkflg[A]=='y') lk_sample();
   hsdelay(d1);
  status(B);
   pulse(p1, zero);
   hsdelay(d2);
  status(C);
   pulse(pw,oph);
   if (lkflg[A]=='y') lk_hold();
   dec3unblank();
}
