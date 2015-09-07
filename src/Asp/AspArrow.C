/*
 * Copyright (C) 2015  University of Oregon
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

#include "AspArrow.h"
#include "AspUtil.h"

AspArrow::AspArrow(char words[MAXWORDNUM][MAXSTR], int nw) : AspLine(words,nw) {
}

AspArrow::AspArrow(spAspCell_t cell, int x, int y) : AspLine(cell,x,y) {
  created_type = ANNO_ARROW;
  disFlag = ANN_SHOW_ROI;
}
