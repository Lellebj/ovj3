/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
#ifndef AIPIMGOVERLAY_H
#define AIPIMGOVERLAY_H

#include <list>

#include "aipGframe.h"

class ImgOverlay {

public:
    static int rebinOverlayData(spGframe_t gf, spDataInfo_t overlayData, int nfast, int nmedium, double scalex, double scaley, float *buf, bool drawIntersect);
    static bool isCoPlane(spDataInfo_t di1, spDataInfo_t di2);
    static bool isParallel(spDataInfo_t di1, spDataInfo_t di2);
    static list<string> getOverlayImages(spGframe_t gf, RQgroup *group);
    static string getCoPlane(spGframe_t gf, spDataInfo_t overlayData);
    static string extractPlane(spGframe_t gf, spDataInfo_t overlayData);
};


#endif /* AIPIMGOVERLAY_H */
