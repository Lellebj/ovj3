/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*-*- Mode: C++ -*-*/

#ifndef ASPBAR_H
#define ASPBAR_H

#include "AspLine.h"

class AspBar : public AspLine
{ 

public:

    AspBar(spAspCell_t cell, int x, int y);
    AspBar(char words[MAXWORDNUM][MAXSTR], int nw);

    void display(spAspCell_t cell, spAspDataInfo_t dataInfo);

    void getLabel(spAspDataInfo_t dataInfo, string &lbl, int &cwd, int &cht);

private:

};

#endif /* ASPBAR_H */
