/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
 * Varian, Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian, Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */
/*-----------------------------------------------------------------------
|	The Revision Numbers of GO, PSG and Acquisition 
|	   to allow revisiion clash checking between them.
|
|				Author Greg Brissey  7/05/90
|
|      Changed		Author	Description
|      -------		------	-----------
|      5/2/91		Greg B. changed both due to change in lc.h elemid 
|				moved and changed to a long from a int.
+--------------------------------------------------------------------*/

#define GO_PSG_REV 5
#define PSG_ACQ_REV 12
#define IMG_REV_BIT 0x80
#define IMG_PSG_ACQ_REV  (PSG_ACQ_REV | IMG_REV_BIT)

/* INOVA DEFINES */
#define INOVA_SYSTEM_REV 1
#define INOVA_INTERP_REV 5

#define MERCURY_SYSTEM_REV 1
#define MERCURY_INTERP_REV 1

