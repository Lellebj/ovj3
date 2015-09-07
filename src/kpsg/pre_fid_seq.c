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
/*-----------------------------------------------------------------------------
|  pre_fidsequence():
|  This routine is for users that want to preform functions between FIDs.
|  You can either modify this routine and execute 'psggen' or include
|  a pre_fidsequence() routine in your pulse sequence file and execute
|  'seqgen'. The loader use the one in the pulse sequence before this one
+----------------------------------------------------------------------------*/
pre_fidsequence()
{
  /*-----------------------------------------------------------------------
  |  You are responsible for any any fifo words generated to be outputed 
  |  failure to do so may result in unpredictable and possibly destructive
  |  settings of the hardware!!!!
  +----------------------------------------------------------------------*/
  return;
}

