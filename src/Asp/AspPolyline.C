/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */


#include "AspPolyline.h"
#include "AspUtil.h"

AspPolyline::AspPolyline(char words[MAXWORDNUM][MAXSTR], int nw) : AspPolygon(words,nw) {
}

AspPolyline::AspPolyline(spAspCell_t cell, int x, int y) : AspPolygon(cell,x,y) {
  created_type = ANNO_POLYLINE;
  disFlag = ANN_SHOW_ROI;
}

