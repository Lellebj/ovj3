/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*-*- Mode: C++ -*-*/
// @(#)ddlfile.h 18.1 03/21/08 (c)1992 SISCO

extern int ValidMagicNumber(char* filename, char *magic_string_list[]);
Imginfo *ddldata_load(char *filename, char *errmsg);

extern char *magic_string_list[];
