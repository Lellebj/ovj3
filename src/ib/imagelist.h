/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*-*- Mode: C++ -*-*/
/* Copyright (c) Varian Assoc., Inc.  All Rights Reserved. */

/* 
 * Varian Assoc.,Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian Assoc., Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

#ifndef IMAGELIST_H
#define IMAGELIST_H

#include "macrolist_ib.h"

#ifndef TRUE
#define TRUE (0==0)
#define FALSE (!TRUE)
#endif

// This class holds lists of images
// For now, it's only the file name.
class Imagelist
{
  public:
    Imagelist(char *filepath);
    ~Imagelist();
    char *Filename();

  private:
    char *filepath;
};

Declare_ListClass(Imagelist);

class ImagelistIterator {
public:
  ImagelistIterator(ImagelistList* r) : rtl(r) {
    if (rtl)
      next = rtl->First();
    else
      next = 0;
  }
  
  ~ImagelistIterator() {};
  
  int NotEmpty() { return (next ? TRUE : FALSE) ; }
  int  IsEmpty() { return (next ? FALSE : TRUE) ; }
  
  ImagelistIterator& GotoLast()  {
    if (rtl)
      next = rtl->Last();
    return *this;
  }
  
  ImagelistIterator& GotoFirst() {
    if (rtl)
      next = rtl->First();
    return *this;
  }
  
  Imagelist *operator++() {
    ImagelistLink* curr;
    curr = next;
    if (next)
      next = next->Next();
    if (curr)
      return curr->Item();
    else
      return 0;
  }
  
  Imagelist *operator--() {
    ImagelistLink* curr;
    curr = next;
    if (next)
      next = next->Prev();
    if (curr)
      return curr->Item();
    else
      return 0;
  }
  
private:
  
  ImagelistLink* next;
  ImagelistList* rtl;
  
};

#endif /* IMAGELIST_H */

