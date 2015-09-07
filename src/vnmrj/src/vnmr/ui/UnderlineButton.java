/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package  vnmr.ui;

import java.awt.*;
import javax.swing.*;

/**
 * underlined the text in a button
 *
 */
public class UnderlineButton extends JButton {
    /**
     * constructor
     */
    public UnderlineButton() {
	super();
    } // UnderlineButton()

    /**
     * constructor
     * @param text
     */
    public UnderlineButton(String text) {
	super(text);
    } // UnderlineButton()

    /**
     * paint
     */
    public void paint(Graphics g) {
	super.paint(g);
	
	Dimension size = getSize();
	int height0 = size.height - 1;
	g.drawLine(0, height0, size.width - 1, height0);
    } // paint()
} // class UnderlineButton
