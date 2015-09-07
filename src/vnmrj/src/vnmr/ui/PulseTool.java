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
 * pulse tool
 *
 * @author Mark Cao
 */
public class PulseTool extends JPanel {
    /**
     * constructor
     */
    public PulseTool() {
	setBackground(Color.darkGray);

	setLayout(new BorderLayout());

	add(new JTextField(), BorderLayout.NORTH);
	JLabel label = new JLabel("pulse tool");
	label.setForeground(Color.white);
	add(label, BorderLayout.CENTER);
	label = new JLabel("component");
	label.setForeground(Color.white);
	add(label, BorderLayout.SOUTH);
    } // PulseTool()

} // class PulseTool

