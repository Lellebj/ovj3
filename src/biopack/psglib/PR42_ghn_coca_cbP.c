/* PR42_ghn_coca_cbP.c
4D HNCOCACB PR-NMR (Non-TROSY) 2D version

Ref: (4,2)D Projection-Reconstruction Experiemnts for Protein Backbone
Assignment:  Application to Human Carbonic Anhydrase II and Calbindin
D28K.  Venters, R.A., Coggins, B.E., Kojetin, D., Cavanagh, J. and
Zhou, P. JACS 127(24), 8785-8795 (2005)

To obtain reconstruction software package, please visit
http://zhoulab.biochem.duke.edu/software/pr-calc


gzlvl1 and gzlvl2 are coherence selection gradients
and need to be optimized empirically

PR42_HNCOCACB_NONTROSY.c R. Venters, Duke University 02/02/05
added to BioPack, G.Gray Oct 2005
*/

#include <standard.h>
#include "bionmr.h"
#include "Pbox_bio.h"
  
static shape gly90;

static int 
             phx[1]={0},   phy[1]={1},

             phi3[2] = {0,2},
             phi5[4] = {0,0,2,2},
             phi6[8] = {1,1,1,1,3,3,3,3},
             phi7[1] = {1},
             phi9[8] = {0,0,0,0,2,2,2,2},
             rec[4] = {2,0,0,2};

pulsesequence()
{

/* DECLARE AND LOAD VARIABLES; parameters used in the last half of the */
/* sequence are declared and initialized as 0.0 in bionmr.h, and       */
/* reinitialized below  */

char            glyshp[MAXSTR],autocal[MAXSTR]; 
 
int         t1_counter,                        /* used for states tppi in t1 */
            ni = getval("ni");

double      d2_init=0.0,                       /* used for states tppi in t1 */
            tau1,                                                      /* Cb */
            tau2,                                                      /* Ca */
            tau3,                                                      /* N  */
            tauC = getval("tauC"),           /* delay for CO to Ca coupling  */
            tauCC= getval("tauCC"),          /* delay for Ca to Cb coupling  */
            timeTN = getval("timeTN"),    /* constant time for 15N evolution */

 glypwr,                            /* Power level for Cgly selective 90 */
 glypwrf,                            /* fine Power level for Cgly selective 90 */
 pwgly,                             /* Pulse width for Cgly selective 90 */
            
   bw,ppm,
   pwClvl = getval("pwClvl"),                  /* coarse power for C13 pulse */
   pwC = getval("pwC"),              /* C13 90 degree pulse length at pwClvl */

   compC = getval("compC"),         /* adjustment for amplifier compression */
   compH = getval("compH"),         /* adjustment for amplifier compression */
   pwHs = getval ("pwHs"),         /* H1 90 degree pulse at tpwrs */
   tpwrs,                          /* power for pwHs ("H2osinc") pulse */

   pwCa180,
   pwCO180,
   pwCab180,
   pwCab90,

   phshift,        /* phase shift induced on Ca by 180 on CO in middle of t1 */
   pwS2,                                              /* length of 180 on CO */
   pwS = getval("pwS"), /*used to change 180 on CO in t1 for 1D calibrations */
   pwZ,                                   /* the larger of pwS2 and 2.0*pwN */
   pwZ1,               /* the larger of pwS2 and 2.0*pwN for 1D experiments */

   pwNlvl = getval("pwNlvl"),                        /* power for N15 pulses */
   pwN = getval("pwN"),              /* N15 90 degree pulse length at pwNlvl */

   sw1 = getval("sw1"),
   swCb = getval("swCb"),
   swCa = getval("swCa"),
   swN  = getval("swN"),
   swTilt,                      /* This is the sweep width of the tilt vector */

   waltzB1 = getval("waltzB1"),         /* waltz16 field strength (in Hz)     */

   cos_N, cos_Ca, cos_Cb,
   angle_N = 0.0, angle_Ca, angle_Cb,  /* angle_N is calculated automatically */

   gt0 = getval("gt0"),     gzlvl0 = getval("gzlvl0"),
   gt1 = getval("gt1"),      gzlvl1 = getval("gzlvl1"),
                             gzlvl2 = getval("gzlvl2"),
   gt3 = getval("gt3"),      gzlvl3 = getval("gzlvl3"),
   gt4 = getval("gt4"),      gzlvl4 = getval("gzlvl4"),
   gt5 = getval("gt5"),      gzlvl5 = getval("gzlvl5"),
   gt6 = getval("gt6"),      gzlvl6 = getval("gzlvl6"),
   gt7 = getval("gt7"),      gzlvl7 = getval("gzlvl7"),
   gt8 = getval("gt8"),      gzlvl8 = getval("gzlvl8"),
   gt9 = getval("gt9"),      gzlvl9 = getval("gzlvl9"),
   gt10 = getval ("gt10"),   gzlvl10 = getval("gzlvl10"),
   gt11 = getval ("gt11"),   gzlvl11 = getval("gzlvl11"),
   gstab  = getval("gstab");

/* Load variables */
   glypwr = getval("glypwr");
   glypwrf = getval("glypwrf");
   getstr("autocal",autocal);
   getstr("glyshp",glyshp);
   pwgly = getval("pwgly");
   tau1 = 0;    tau2 = 0;     tau3 = 0;
   cos_N = 0;   cos_Ca = 0;   cos_Cb = 0;


/*   LOAD PHASE TABLE    */

   settable(t2,1,phy); 
   settable(t3,2,phi3); 
   settable(t5,4,phi5);  
   settable(t6,8,phi6);
   settable(t7,1,phi7);
   settable(t8,1,phx);  
   settable(t9,8,phi9); 
   settable(t10,1,phx);
   settable(t12,4,rec);

/*   INITIALIZE VARIABLES   */
   lambda = 2.4e-3;
   kappa = 5.4e-3;

   pwCab90  = c13pulsepw("cab", "co", "square", 90.0);
   pwCO180  = c13pulsepw("co", "ca", "sinc", 180.0);
   pwCab180 = c13pulsepw("cab", "co", "square", 180.0);
   pwCa180  = c13pulsepw("ca", "co", "square", 180.0);

   tpwrs = tpwr - 20.0*log10(pwHs/(compH*pw*1.69));   /*needs 1.69 times more*/
   tpwrs = (int) (tpwrs);                          /*power than a square pulse */
   widthHd = 2.681*waltzB1/sfrq;  /* bandwidth of H1 WALTZ16 decoupling */
   pwHd = h1dec90pw("WALTZ16", widthHd, 0.0);     /* H1 90 length for WALTZ16 */

   /* get calculated pulse lengths of shaped C13 pulses */
   pwS2 = c13pulsepw("co", "cab", "sinc", 180.0); 

   /* the 180 pulse on CO at the middle of t1 */
   if (pwS2 > 2.0*pwN) pwZ = pwS2; else pwZ = 2.0*pwN;
   if ((pwS==0.0) && (pwS2>2.0*pwN)) pwZ1=pwS2-2.0*pwN; else pwZ1=0.0;
   if ( ni > 1 )     pwS = 180.0;
   if ( pwS > 0 )   phshift = 140.0;
     else           phshift = 0.0;

/* CHECK VALIDITY OF PARAMETER RANGES */

   if ( tauC < (gt7+1.0e-4+0.5*10.933*pwC))  gt7=(tauC-1.0e-4-0.5*10.933*pwC);

   if ( dm[A] == 'y' || dm[B] == 'y' || dm[C] == 'y' )
      { printf("incorrect dec1 decoupler flags! Should be 'nnn' "); psg_abort(1);}

   if ( dm2[A] == 'y' || dm2[B] == 'y' )
      { printf ("incorrect dec2 decoupler flags! Should be 'nny' "); psg_abort(1);}

   if ( dm3[A] == 'y' || dm3[C] == 'y' )
      { printf ("incorrect dec3 decoupler flags! Should be 'nyn' or 'nnn' ");
                                                                    psg_abort(1);}     
   if ( dpwr2 > 46 ) { printf("dpwr2 too large! recheck value  ");  psg_abort(1);}
   if ( pw > 20.0e-6 ) { printf(" pw too long ! recheck value ");   psg_abort(1);} 
   if ( pwN > 100.0e-6 ) { printf(" pwN too long! recheck value "); psg_abort(1);} 

/* PHASES AND INCREMENTED TIMES */

   /* Set up angles and phases */

   angle_Cb=getval("angle_Cb");  cos_Cb=cos(PI*angle_Cb/180.0);
   angle_Ca=getval("angle_Ca");  cos_Ca=cos(PI*angle_Ca/180.0);
   
   if ( (angle_Cb < 0) || (angle_Cb > 90) )
   {  printf ("angle_Cb must be between 0 and 90 degree.\n"); psg_abort(1); }

   if ( (angle_Ca < 0) || (angle_Ca > 90) )
   {  printf ("angle_Ca must be between 0 and 90 degree.\n"); psg_abort(1); }

   if ( 1.0 < (cos_Cb*cos_Cb + cos_Ca*cos_Ca) )
   {
       printf ("Impossible angles.\n"); psg_abort(1);
   }
   else
   {
           cos_N=sqrt(1.0- (cos_Cb*cos_Cb + cos_Ca*cos_Ca));
           angle_N = 180.0*acos(cos_N)/PI;
   }

   swTilt=swCb*cos_Cb + swCa*cos_Ca + swN*cos_N;

   if (ix ==1)
   {

      if ( 0.5*ni*(cos_N/swTilt) > timeTN - WFG3_START_DELAY)
      { printf(" ni is too big. Make ni equal to %d or less.\n",
        ((int)((timeTN - WFG3_START_DELAY)*2.0*swTilt/cos_N)));     psg_abort(1);}

      if ( (0.5*ni*cos_Ca/swTilt) > (tauCC - pwCO180 - pwCab180/2 - WFG2_START_DELAY-
           2.0*PWRF_DELAY - 2.0*POWER_DELAY - WFG2_STOP_DELAY - 4.0e-6))
      { printf (" ni is too big. Make ni equal to %d or less. \n",
        (int) ((tauCC - pwCO180 - pwCab180/2 - WFG2_START_DELAY - 2.0*PWRF_DELAY
        -2.0*POWER_DELAY - WFG2_STOP_DELAY - 4.0e-6)/(0.5*cos_Ca/swTilt))); 
         psg_abort(1);}

      printf("\n\nn\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
      printf ("Maximum Sweep Width: \t\t %f Hz\n", swTilt);
      printf ("Angle_Cb:\t%6.2f\n", angle_Cb);
      printf ("Angle_Ca:\t%6.2f\n", angle_Ca);
      printf ("Angle_N :\t%6.2f\n", angle_N );
   }

/* Set up hyper complex */

   /* sw1 is used as symbolic index */
   if ( sw1 < 1000 ) { printf ("Please set sw1 to some value larger than 1000.\n"); psg_abort(1); }

   if (ix == 1) d2_init = d2;
   t1_counter = (int) ( (d2-d2_init)*sw1 + 0.5 );
   if (t1_counter % 2)  { tsadd(t8,2,4); tsadd(t12,2,4); }

   if (phase1 == 1)  { ;}                                                  /* CC */
   else if (phase1 == 2)  { tsadd(t3,3,4); tsadd(t2,3,4);}                 /* SC */
   else if (phase1 == 3)  { tsadd(t5,1,4); }                               /* CS */
   else if (phase1 == 4)  { tsadd(t3,3,4); tsadd(t2,3,4); tsadd(t5,1,4); } /* SS */
   else { printf ("phase1 can only be 1,2,3,4. \n"); psg_abort(1); }

   if (phase2 == 2)  { tsadd(t10,2,4); icosel = +1; }                      /* N */
            else                       icosel = -1;

   tau1 = 1.0*t1_counter*cos_Cb/swTilt;
   tau2 = 1.0*t1_counter*cos_Ca/swTilt;
   tau3 = 1.0*t1_counter*cos_N/swTilt;

   tau1 = tau1/2.0;  tau2 = tau2/2.0;  tau3 = tau3/2.0;


/* BEGIN PULSE SEQUENCE */

status(A);
      delay(d1);
      if (dm3[B] == 'y') lk_hold();
 
      rcvroff();
      obsoffset(tof);        obspower(tpwr);      obspwrf(4095.0);
      set_c13offset("co");   decpower(pwClvl);    decpwrf(4095.0);
      dec2power(pwNlvl);

      txphase(three);      delay(1.0e-5);

   dec2rgpulse(pwN, zero, 0.0, 0.0);  /*destroy N15 and C13 magnetization*/
   decrgpulse(pwC, zero, 0.0, 0.0);
   zgradpulse(gzlvl0, gt0);
   delay(2.0e-4);

   dec2rgpulse(pwN, one, 0.0, 0.0);
   decrgpulse(pwC, zero, 0.0, 0.0);
   zgradpulse(0.7*gzlvl0, gt0);
   delay(5.0e-4);

      shiftedpulse("sinc", pwHs, 90.0, 0.0, three, 2.0e-6, 0.0);

      txphase(zero);  decphase(zero); dec2phase(zero); 
      delay(2.0e-6);

/*   xxxxxxxxxxxxxxxxxxxxxx    1HN to 15N TRANSFER   xxxxxxxxxxxxxxxxxx    */

   rgpulse(pw, zero, 0.0, 0.0);                     /* 1H pulse excitation */
      dec2phase(zero);
      zgradpulse(gzlvl3, gt3);                                       /* G3 */ 
      delay(lambda - gt3);

   sim3pulse(2.0*pw, 0.0, 2.0*pwN, zero, zero, zero, 0.0, 0.0);
      txphase(one); 
      zgradpulse(gzlvl3, gt3);                                       /* G3 */
      delay(lambda - gt3);

   rgpulse(pw,one,2.0e-6,0.0);
      zgradpulse(gzlvl4, gt4);                                 /* Crush G4 */
      delay(2.0e-4);

   dec2rgpulse(pwN,zero,0.0,0.0);

      delay(kappa - POWER_DELAY - PWRF_DELAY - pwHd - 4.0e-6 - PRG_START_DELAY);
                            /* delays for h1waltzon subtracted */
      h1waltzon("WALTZ16", widthHd, 0.0);
      decphase(zero);
      dec2phase(zero);
      delay(timeTN - kappa - WFG3_START_DELAY);

                                     /* WFG3_START_DELAY */
   sim3_c13pulse("", "co", "ca", "sinc", "", 0.0, 180.0, 2.0*pwN,
                             zero, zero, zero, 2.0e-6, 2.0e-6);
      delay(timeTN);

     dec2rgpulse(pwN, zero, 0.0, 0.0);
     h1waltzoff("WALTZ16", widthHd, 0.0);

      delay(2.0e-6);
      zgradpulse(gzlvl5, gt5);                                 /* Crush G5 */
      delay(2.0e-4);

/*   xxxxxxxxxxxxxxxxxxxxxx    13CO to 13CA TRANSFER   xxxxxxxxxxxxxxxxxx    */

   c13pulse("co", "ca", "sinc", 90.0, zero, 2.0e-6, 0.0);

      zgradpulse(gzlvl6, gt6);                                         /* G6 */
      decphase(zero);
      delay(tauC - gt6 - 0.5*10.933*pwC);

   decrgpulse(pwC*158.0/90.0, zero, 0.0, 0.0);
   decrgpulse(pwC*171.2/90.0, two, 0.0, 0.0);
   decrgpulse(pwC*342.8/90.0, zero, 0.0, 0.0);          /* Shaka 6 composite */
   decrgpulse(pwC*145.5/90.0, two, 0.0, 0.0);
   decrgpulse(pwC*81.2/90.0, zero, 0.0, 0.0);
   decrgpulse(pwC*85.3/90.0, two, 0.0, 0.0);

      zgradpulse(gzlvl6, gt6);                                         /* G6 */
      decphase(one);
      delay(tauC - gt6 - 0.5*10.933*pwC - WFG_START_DELAY - 2.0e-6);
                                                          /* WFG_START_DELAY */
   c13pulse("co", "ca", "sinc", 90.0, one, 2.0e-6, 0.0);
/*   xxxxxxxxxxxxxxxxxxxx END of 13CO to 13CA TRANSFER   xxxxxxxxxxxxxxxx    */
      decphase(zero);

      set_c13offset("gly");                  /* dof at glycines (43ppm)      */
      setautocal();
      if (autocal[A] == 'y')
      {
        if(FIRST_FID)
        {
         ppm = getval("dfrq"); bw=9*ppm;
         gly90 = pbox_make("gly90","eburp1",bw,0.0,compC*pwC,pwClvl);
                               /* Gly selective 90 with null at 50ppm */
        }
        pwgly=gly90.pw; glypwr=gly90.pwr; glypwrf=gly90.pwrf;
        decpwrf(glypwrf);
        decpower(glypwr);                           
        decshaped_pulse("gly90",pwgly,zero,2.0e-6,0.0);
      }
      else
      {
       decpwrf(4095.0);
       decpower(glypwr);                           
       decshaped_pulse(glyshp,pwgly,zero,2.0e-6,0.0);
      }
      decphase(t3);

      zgradpulse(gzlvl7, gt7);                                   /* Crush G7 */
      set_c13offset("cab");
      delay(2.0e-4);

      if (dm3[B] == 'y')                 /*optional 2H decoupling on */
      {
        dec3unblank(); dec3rgpulse(1/dmf3, one, 0.0, 0.0); 
        dec3unblank(); setstatus(DEC3ch, TRUE, 'w', FALSE, dmf3); 
      } 

/*   xxxxxxxxxxxxx  13CA to 13CB TRANSFER  xxxxxxxxxxxxx  */
   c13pulse("cab", "co", "square", 90.0, t3, 2.0e-6, 0.0);      /*  pwCab180  */
        decphase(zero);
        delay(tauCC);
   c13pulse("cab", "co", "square", 180.0, zero, 2.0e-6, 0.0);
        decphase(t2);
        delay(tauCC - POWER_DELAY - PWRF_DELAY - PRG_START_DELAY);
      h1waltzon("WALTZ16", widthHd, 0.0);

/*   xxxxxxxxxxxxxxxxx     13CB EVOLUTION    xxxxxxxxxxxxxxxxxx    */

   c13pulse("cab", "co", "square", 90.0, t2, 2.0e-6, 0.0);      /*  pwCab180  */
        decphase(zero);

      if ((ni>1.0) && (tau1>0.0))          /* total 13C evolution equals d2 exactly */
      {           /* 2.0*pwCab90/PI compensates for evolution at 64% rate during 90 */
        if (tau1 - 2.0*pwCab90/PI - WFG_START_DELAY - pwN - 2.0e-6
                      - POWER_DELAY > 0.0)
        {
           delay (tau1 - 2.0*pwCab90/PI - pwN - 2.0e-6 );
           dec2rgpulse(2.0*pwN,zero, 2.0e-6,0.0);
           delay (tau1 - 2.0*pwCab90/PI  - pwN - 2.0e-6 - WFG_START_DELAY 
                  - PWRF_DELAY - POWER_DELAY);
        }
        else
        {
           tsadd(t12,2,4);
           delay(2.0*tau1);
           delay(10.0e-6);                                    /* WFG_START_DELAY */
        sim3_c13pulse("", "cab", "co", "square", "", 0.0, 180.0, 2.0*pwN, 
                      zero, zero, zero, 2.0e-6, 0.0);
           delay(10.0e-6);
        }
      }
      else            /* 13Cb evolution refocused for 1st increment, or when ni=0   */
      {
         tsadd(t12,2,4);
         delay(10.0e-6);
      sim3_c13pulse("", "cab", "co", "square", "", 0.0, 180.0, 2.0*pwN,
                    zero, zero, zero, 2.0e-6, 0.0);
         delay(10.0e-6);
      }
   
   decphase(t6);
   c13pulse("cab", "co", "square", 90.0, t6, 2.0e-6, 0.0);      /*  pwCab180  */
   
/* xxxxxxx  13CB to 13CA BACK TRANSFER - CA EVOLUTION  xxxxxxxx  */

      decphase(zero);
      delay(tau2);

   sim3_c13pulse("", "co", "cab", "sinc", "", 0.0, 180.0, 2.0*pwN,
                    zero, zero, zero, 2.0e-6, 0.0);
      decphase(zero);
      delay(tauCC- 2*pwN - pwCab180/2 - 2*PWRF_DELAY - 2*POWER_DELAY - 
             WFG2_START_DELAY - WFG2_STOP_DELAY - 4.0e-6 );

   c13pulse("cab", "co", "square", 180.0, zero, 2.0e-6, 0.0);
      delay(tauCC - tau2 - pwCO180 - pwCab180/2 - WFG2_START_DELAY - 2.0*PWRF_DELAY -
              2.0*POWER_DELAY - WFG2_STOP_DELAY - 4.0e-6 );

   c13pulse("co", "cab", "sinc", 180.0, zero, 2.0e-6, 0.0);
         decphase(t5);

   c13pulse("cab", "co", "square", 90.0, t5, 2.0e-6, 0.0);      /*  pwCab180  */
 
/* xxxxxxx END of 13CB to 13CA BACK TRANSFER - CA EVOLUTION  xxxxxxxx  */

      set_c13offset("co");
      if(dm3[B] == 'y')                        /*optional 2H decoupling off */
      { 
         dec3rgpulse(1/dmf3, three, 0.0, 0.0); dec3blank();
         setstatus(DEC3ch, FALSE, 'w', FALSE, dmf3); dec3blank();
      }

      decphase(t7);
      h1waltzoff("WALTZ16", widthHd, 0.0);
      zgradpulse(gzlvl8, gt8);                           /* Crush G8 */
      delay(2.0e-4);

/* xxxxxxxxxxxxx 13CA to 13CO BACK TRANSFER  xxxxxxxxxxxx */

   c13pulse("co", "ca", "sinc", 90.0, t7, 2.0e-6, 0.0);

      dec2rgpulse(2.0*pwN, zero, 0.0, 0.0);
 
      delay(tauC-pwCa180-2.0*pwN- pwCO180/2-WFG3_START_DELAY-2.0*PWRF_DELAY-
              2.0*POWER_DELAY - 3.0e-6 );
 
      c13pulse("ca", "co", "square", 180.0, zero, 2.0e-6, 0.0);
   c13pulse("co", "ca", "sinc", 180.0, zero, 2.0e-6, 0.0);
      delay(tauC - pwCO180/2 - pwCa180 - WFG3_START_DELAY - 2.0*PWRF_DELAY -
              2.0*POWER_DELAY - 3.0e-6 );

      c13pulse("ca", "co", "square", 180.0, zero, 2.0e-6, 0.0);
   c13pulse("co", "ca", "sinc", 90.0, zero, 2.0e-6, 0.0);
/* xxxxxxxxxxxxxEND of 13CA to 13CO BACK TRANSFER  xxxxxxxxxxxx */

      dec2phase(t8);
      zgradpulse(gzlvl9, gt9);                        /* Crush G9 */
      delay(2.0e-4);

/* xxxxxxxx  CO to 15N BACK TRANSFER - 15N EVOLUTION  xxxxxxxxxxx    */
   h1waltzon("WALTZ16", widthHd, 0.0);
   dec2rgpulse(pwN, t8, 0.0, 0.0);
      decphase(zero);
      dec2phase(t9);
      delay(timeTN - WFG3_START_DELAY - tau3);
                                                         /* WFG3_START_DELAY  */
   sim3_c13pulse ("", "co", "ca", "sinc", "", 0.0, 180.0, 2.0*pwN,
                                  zero, zero, t9, 2.0e-6, 2.0e-6);

      dec2phase(t10);

   if (tau3 > (kappa + PRG_STOP_DELAY + pwHd + 2.0e-6))
   {
       delay(timeTN - pwCa180 - WFG_START_DELAY - 2.0*POWER_DELAY
                                - 2.0*PWRF_DELAY - 2.0e-6);
    c13pulse("ca", "co", "square", 180.0, zero, 2.0e-6, 0.0); /*pwCO180*/
       delay(tau3 - kappa - PRG_STOP_DELAY - pwHd - 2.0e-6 - POWER_DELAY
                                         - PWRF_DELAY);
       h1waltzoff("WALTZ16", widthHd, 0.0);
       txphase(zero);

       delay(kappa - gt1 - 2.0*GRADIENT_DELAY - 1.0e-4);
       zgradpulse(gzlvl1, gt1);        /* 2.0*GRADIENT_DELAY */
       delay(1.0e-4);
   }
   else if (tau3 > (kappa - pwCa180 - WFG_START_DELAY - 2.0*POWER_DELAY
                                - 2.0*PWRF_DELAY - 2.0e-6))
   {
      delay(timeTN + tau3 - kappa - PRG_STOP_DELAY - pwHd - 2.0e-6
                                 - POWER_DELAY - PWRF_DELAY);
      h1waltzoff("WALTZ16", widthHd, 0.0);
      txphase(zero);
   c13pulse("ca", "co", "square", 180.0, zero, 2.0e-6, 0.0); /*pwCO180*/

      delay(kappa - pwCa180 - WFG_START_DELAY - 2.0*POWER_DELAY
            - 2.0*PWRF_DELAY - 2.0e-6 - gt1 - 2.0*GRADIENT_DELAY - 1.0e-4);
      zgradpulse(gzlvl1, gt1);        /* 2.0*GRADIENT_DELAY */
      delay(1.0e-4);
   }
   else if (tau3 > gt1 + 2.0*GRADIENT_DELAY + 1.0e-4)
   {
      delay(timeTN + tau3 - kappa - PRG_STOP_DELAY - pwHd - 2.0e-6
                                 - POWER_DELAY - PWRF_DELAY);
      h1waltzoff("WALTZ16", widthHd, 0.0);
      txphase(zero);
      delay(kappa - tau3 - pwCa180 - WFG_START_DELAY - 2.0*POWER_DELAY
                                   - 2.0*PWRF_DELAY - 2.0e-6);
   c13pulse("ca", "co", "square", 180.0, zero, 2.0e-6, 0.0); /*pwCO180*/
      delay(tau3 - gt1 - 2.0*GRADIENT_DELAY - 1.0e-4);
      zgradpulse(gzlvl1, gt1);        /* 2.0*GRADIENT_DELAY */
      delay(1.0e-4);
   }
   else
   {
      delay(timeTN + tau3 - kappa - PRG_STOP_DELAY - pwHd - 2.0e-6
                                 - POWER_DELAY - PWRF_DELAY);
      h1waltzoff("WALTZ16", widthHd, 0.0);
      txphase(zero);
      delay(kappa - tau3 - pwCa180 - WFG_START_DELAY - 2.0*POWER_DELAY
            - 2.0*PWRF_DELAY - 2.0e-6 - gt1 - 2.0*GRADIENT_DELAY - 1.0e-4);
      zgradpulse(gzlvl1, gt1);        /* 2.0*GRADIENT_DELAY */
      delay(1.0e-4);
   c13pulse("ca", "co", "square", 180.0, zero, 2.0e-6, 0.0); /*pwCO180*/
      delay(tau3);
   }

   sim3pulse(pw, 0.0, pwN, zero, zero, t10, 0.0, 0.0);
      txphase(zero);
      dec2phase(zero);
      zgradpulse(gzlvl10, gt10);                                 /* G10 */
      delay (lambda - 1.3*pwN - gt10);

   sim3pulse(2.0*pw, 0.0, 2.0*pwN, zero, zero, zero, 0.0, 0.0);
      zgradpulse(gzlvl10, gt10);                                 /* G10 */
      txphase(one);
      dec2phase(one);
      delay (lambda - 1.3*pwN - gt10);

   sim3pulse(pw, 0.0, pwN, one, zero, one, 0.0, 0.0);
      txphase(zero);
      dec2phase(zero);
      zgradpulse(gzlvl11, gt11);                                 /* G11 */
      delay (lambda - 1.3*pwN - gt11);

   sim3pulse(2.0*pw, 0.0, 2.0*pwN, zero, zero, zero, 0.0, 0.0);
      zgradpulse(gzlvl11, gt11);                                 /* G11 */
      delay (lambda - 0.65*(pw+pwN) - gt11);

   rgpulse(pw, zero, 0.0, 0.0);
   dec2power(dpwr2);   decpower(dpwr);
   delay((gt1/10.0) + 1.0e-4 +gstab - 0.3*pw + 2.0*GRADIENT_DELAY
                                   + POWER_DELAY);

   rgpulse(2.0*pw, zero, 0.0, 0.0);
      zgradpulse(icosel*gzlvl2, gt1/10.0);            /* 2.0*GRADIENT_DELAY */
      delay(gstab);

statusdelay(C, 1.0e-4);
   setreceiver(t12);
   if (dm3[B] == 'y') lk_sample();
}

