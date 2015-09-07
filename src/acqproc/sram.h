/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
 * Varian Assoc.,Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian Assoc., Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

#ifndef SRAMDEF
#define SRAMDEF
#define  MAXCHANNELS		6
#define  DF_SIZE		1
#define  LF_SIZE		2

/*  The offset is spelled out in units of 16-bit words.
    Most values require 1 such word; thus the default.
    The lock frequency requires 2 16-bit words		*/

#define  PTS_OFFSET		0
#define  LF_OFFSET		(PTS_OFFSET+MAXCHANNELS)
#define  H1F_OFFSET		(LF_OFFSET+LF_SIZE)
#define  SYS_OFFSET             (H1F_OFFSET+DF_SIZE)
#define  IF_OFFSET		(SYS_OFFSET+DF_SIZE)
#define  SF_OFFSET		(IF_OFFSET+DF_SIZE)

#define  CS_OFFSET		(SF_OFFSET+DF_SIZE)
#define  SRAM_SIZE		(CS_OFFSET+DF_SIZE)
#endif
