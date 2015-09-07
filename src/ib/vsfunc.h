/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/************************************************************************
*
*  Copyright (c) Varian Assoc., Inc.  All Rights Reserved.
*
*************************************************************************/

#ifndef vsfunc_h
#define vsfunc_h

#include <sys/types.h>

class VsTable
{
  public:
    VsTable(int size);
    ~VsTable();

    int ref_count;
    int size;
    u_char *table;
};

class VsFunc
{
  public:
    VsFunc(int size);
    VsFunc(VsFunc *);
    ~VsFunc();
    int isequal(VsFunc *);

    int negative;
    float min_data;
    float max_data;
    u_char uflow_cmi;
    u_char oflow_cmi;
    VsTable *lookup;
    char *command;
};

#endif /* vsfunc_h */
