/*
 * Copyright (C) 2015  University of Oregon
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/* gNhsqcHT.c    Hadamard version of the Fast N15 HSQC using 3919 watergate 

    Requires a frequency list of N-15 resonances, htfrq1 in the current 
    experiment. The list is generated by recording a gNhsqc spectrum, 
    and manual peak picking using the editht macro to initialize the 
    htfrq1 parameter in the current experiment  

    parameters:
    ==========
    htbw1 - excitation bandwidth. For pshape = 'gaus180' good numbers are 
          90, 45, 30 or 20 Hz.
    ni  - number of increments. Must be a power of 2. Other allowed values 
          are n*12, n*20 and n*28, where n is a power of 2.
    nimax - sets limit to ni to prevent unrealistic experiments.
    htofs1 - ni offset. Sets the number of increments to be omitted. Typical
            value is niofs = 1.
    pshape - shape used for Hadamard encoding, typically gaus180, square180,
             sinc180.
    bscor - Bloch-Siegert correction for Hadamard encoding, typically set 
            bscor = 'y'.
    repflg - set repflg = 'n' to suppress Pbox reports.
    ssF1 - stepsize for Hadamard encoding pulses. This parameter is adjusted
           by looking at the maximum phase increments in Hadamard enconing
           pulses, e.g. F1_2.RF. If unsure, set ssF1 = 0 to disable it.
    Hdseq - name of NH decoupling (.RF) pulse. Use inversion pulses of 1 - 1.5 ms and
           an appropriate supercycle. The total length must be the same as  
           that of the Hadamard encoding pulse (F1_1.RF). For example, 
           with 45 ms long pulse (htbw1=20 Hz) use a 40 step supercycle (e.g.             
           t5,m8) and a 1.125 ms long adiabatic pulse:
           >Pbox NHdec -w "wurst2i 25k/1.125m" -sucyc t5,m8 -s 5.0 -p ... -l ...   
           the _htbw1 macro creates the shape automatically
    Hdpwr - Power level for pwpat (NH decoupling).            
    Cdseq - name of CN decoupling (.RF) pulse. Only active if C13refoc = 'y'.
           Use inversion pulses of duration less than 1/5J(CN) (ca 5-10 ms) 
           and an appropriate supercycle. The total length must be the same   
           as that of the Hadamard encoding pulse (F1_1.RF). For example, 
           with 45 ms long pulse (bw1=20 Hz) use a 8 step supercycle (e.g.             
           t5,m8) and a 5.625 ms long adiabatic pulse:
           >Pbox CNdec -w "wurst2i 50k/5.625m" -sucyc m8 -s 3.0 -p ... -l ...   
           the _htbw1 macro creates the shape automatically
    Hdpwr - Power level for pwpat (NH decoupling).            
*/

#include <standard.h>

pulsesequence()
{
   char	    Hdseq[MAXSTR], Cdseq[MAXSTR],
            C13refoc[MAXSTR];		/* C13 sech/tanh pulse in middle of t1 */
   double   tau1, tauxh, rg1 = 2.0e-6,
            gzlvl1=getval("gzlvl1"),
            gzlvl4=getval("gzlvl4"),
            gzlvl3 = getval("gzlvl3"),
            gt1=getval("gt1"),
            gt4=getval("gt4"),
            gt3=getval("gt3"),
            JNH = getval("JNH"),
            pwN = getval("pwN"),
            pwNlvl = getval("pwNlvl"),      
            pwClvl = getval("pwClvl"), 	         /* coarse power for C13 pulse */
            pwC = getval("pwC"),       /* C13 90 degree pulse length at pwClvl */
            rf0,            	   /* maximum fine power when using pwC pulses */
            rfst,	                    /* fine power for the stCall pulse */
            pwCref = 0.0,
            compC = getval("compC"),   /* adjust for C13 amplifier compression */
            compN = getval("compN");   /* adjust for N15 amplifier compression */

   shape    hdx;                                   /* HADAMARD stuff */

   hdx = pboxHT_F1i("gaus180", pwN*compN, pwNlvl); /* HADAMARD stuff */

   setlimit("ni", getval("ni"), getval("nimax"));     /* limits max ni */

   getstr("C13refoc",C13refoc);
   if (C13refoc[A]=='y') 
     pwCref = hdx.pw;
   getstr("Hdseq", Hdseq);
   getstr("Cdseq", Cdseq);
   
/* PHASE CYCLING */

   mod2(ct, v1);  dbl(v1,oph);                  /* 0202 */     
   hlv(ct,v11); mod2(v11,v11); dbl(v11,v11);    /* 0022 */ 
   add(v11,oph,oph);                            /* 0220 */
   add(one,v11,v11);                            /* 1133 */
   
/* maximum fine power for pwC pulses (and initialize rfst) */
	rf0 = 4095.0;    rfst=0.0;

/* 180 degree adiabatic C13 pulse from 0 to 200 ppm */
     if (C13refoc[A]=='y')
       {rfst = (compC*4095.0*pwC*4000.0*sqrt((30.0*sfrq/600.0+7.0)/0.35));   
	rfst = (int) (rfst + 0.5);
	if ( 1.0/(4000.0*sqrt((30.0*sfrq/600.0+7.0)/0.35)) < pwC )
           { text_error( " Not enough C13 RF. pwC must be %f usec or less.\n", 
	    (1.0e6/(4000.0*sqrt((30.0*sfrq/600.0+7.0)/0.35))) );    psg_abort(1); }}

   initval(3.0,v2);
   initval(1.0,v3);
   initval(0.0,v4);

/* check validity of parameter range */

    if((dm[A] == 'y' || dm[B] == 'y' || dm[C] == 'y' ))
	{
	printf("incorrect Dec1 decoupler flags!  ");
	psg_abort(1);
    } 

    if((dm2[A] == 'y' || dm2[B] == 'y') )
	{
	printf("incorrect Dec2 decoupler flags!  ");
	psg_abort(1);
    } 


    if( dpwr > 0 )
    {
	printf("don't fry the probe, dpwr too large!  ");
	psg_abort(1);
    }

    if( dpwr2 > 48 )
    {
	printf("don't fry the probe, dpwr2 too large!  ");
	psg_abort(1);
    }


/* INITIALIZE VARIABLES */

  tauxh = ((JNH != 0.0) ? 1/(4*(JNH)) : 2.25e-3);

   tau1 = d2;
   tau1 = tau1/2.0 -rof1 -pw;
   if (tau1 < 0.0) tau1=0.0;

/* sequence starts!! */

   status(A);
   obspower(tpwr);
   dec2power(pwNlvl);
   decpower(pwClvl);
   decpwrf(rfst);
   delay(d1);
   status(B);

  rgpulse(pw, zero, rof1, rof1);

  zgradpulse(gzlvl1,gt1);
  txphase(zero);
  dec2phase(zero);
  delay(tauxh-gt1);               /* delay=1/4J(XH)   */
  
  sim3pulse(2*pw,0.0,2*pwN,zero,zero,zero,rof1,rof1);

  zgradpulse(gzlvl1,gt1);
  txphase(one);
  dec2phase(zero);
  delay(tauxh-gt1 );               /* delay=1/4J(XH)   */
 
  rgpulse(pw, v11, rof1, rof1);

  ifzero(v1); dec2rgpulse(2*pwN, zero, rof1, rof1);
  elsenz(v1); delay(2.0*pwN + 2*rof1);
  endif(v1);
  
  dec2power(hdx.pwr); obspower(getval("Hdpwr")); decpower(getval("Cdpwr")); 

   sim3shaped_pulse(Hdseq, Cdseq, hdx.name, hdx.pw, pwCref, hdx.pw, 
                   zero, zero, zero, rg1, rg1);
  
  zgradpulse(gzlvl4,gt4);
  obspower(tpwr); decpower(dpwr); dec2power(pwNlvl);
  delay(200.0e-6);

  rgpulse(pw, v4, rof1, rof1);

  dec2phase(zero);
  zgradpulse(gzlvl3,gt3);
  txphase(v2);
  delay(tauxh-gt3-pw*2.385-6.0*rof1 -d3*2.5);
 
  rgpulse(pw*0.231,v2,rof1,rof1);
  delay(d3);
  rgpulse(pw*0.692,v2,rof1,rof1);
  delay(d3);
  rgpulse(pw*1.462,v2,rof1,rof1);

   delay(d3/2-pwN);
   dec2rgpulse(2*pwN, zero, rof1, rof1);
   delay(d3/2-pwN);

  rgpulse(pw*1.462,v3,rof1,rof1);
  delay(d3);
  rgpulse(pw*0.692,v3,rof1,rof1);
  delay(d3);
  rgpulse(pw*0.231,v3,rof1,rof1);
  delay(tauxh-gt3-pw*2.385-6.0*rof1 -d3*2.5);
  dec2power(dpwr2);
  zgradpulse(gzlvl3,gt3);
  
status(C);
   

}


