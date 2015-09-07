/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
 * 
 * Varian Assoc.,Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian Assoc., Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 *
 */

import java.awt.*;
import java.io.*;

public interface  EditItemIF {
    public void drawItem(Graphics g);
    public void drawItem();
    public void move(int dx, int dy, int step);
    public void move(Graphics g, int dx, int dy, int step);
    public void highlight (boolean hilit);
    public Rectangle getDim();
    public Rectangle getRegion();
    public Rectangle getVector();
    public int getType();
    public void setFgColor (Color fg);
    public void setColors (Color fg, Color bg, Color hg);
    public void setRatio (double r, int pw, int ph);
    public void setTextInfo(TextInput t);
    public void setPreference();
    public void showPreference();
    public void writeToFile(PrintWriter os);

} // EditItemIF

