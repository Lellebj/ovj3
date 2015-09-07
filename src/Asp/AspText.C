/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

#include "AspText.h"
#include "AspUtil.h"

AspText::AspText(char words[MAXWORDNUM][MAXSTR], int nw) : AspPoint(words,nw) {
}

AspText::AspText(spAspCell_t cell, int x, int y) : AspPoint(cell,x,y) {
  created_type = ANNO_TEXT;
  disFlag = ANN_SHOW_LABEL;
  label="Text"; 
}
