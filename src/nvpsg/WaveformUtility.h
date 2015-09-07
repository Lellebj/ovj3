/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

/* WaveformUtility.h */

#include <iostream>
#include <stdlib.h>
#include "Controller.h"
#include "RFController.h"

class WaveformUtility
{

  public:

     static cPatternEntry *readRFWaveform(char *name, RFController *rf1, unsigned int *array, int arraysize, double duration);
     static cPatternEntry *readDECWaveform(char *name, RFController *rf1, unsigned int *array);
     static cPatternEntry *makeOffsetPattern(unsigned int *inp, unsigned int *out, RFController *rf1, int nInc, double phss, double pacc, int flag, char mode, char *tag, char *emsg, int action);
     static cPatternEntry *weaveGatePattern(unsigned int *out, unsigned int *inp, int num_inp, unsigned int *gatePattern, int num_gatewords, long long totalticks);

  private:

     // private constructors
     WaveformUtility();
        
} ;

