/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*-*- Mode: C++ -*-*/
/* 
 * Varian Assoc.,Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian Assoc., Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "imagelist.h"

Create_ListClass(Imagelist);

ImagelistLink::~ImagelistLink() {}

ImagelistLink& ImagelistLink::Print() {
  printf("object[%d]\n", item);
  return *this;
}

Imagelist::Imagelist(char *newpath)
{
    filepath = strdup(newpath);
}

Imagelist::~Imagelist()
{
    if (filepath){
	free(filepath);
    }
}

char *
Imagelist::Filename()
{
    return filepath;
}
