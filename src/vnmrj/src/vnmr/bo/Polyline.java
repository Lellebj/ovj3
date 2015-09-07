/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package  vnmr.bo;

public class Polyline
{
    public int length;
    public int[] x;
    public int[] y;

    public Polyline(int length) {
	this.length = length;
	x = new int[length];
	y = new int[length];
    }
}
