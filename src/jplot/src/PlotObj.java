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

public interface PlotObj
{
	public void setColors(Color a, Color b, Color c);
	public void setHilitColor(Color c);
	public void setFgColor(Color c);
	public void setLineWidth(int c);
	public void setPreference();
	public void showPreference();
	public void setPrefWindow(PlotItemPref p);
}

