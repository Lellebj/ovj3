/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
 * Copyright 2005 MH-Software-Entwicklung. All rights reserved.
 * Use is subject to license terms.
 */
package vnmr.vplaf.jtattoo.hifi;

import vnmr.vplaf.jtattoo.*;
import java.awt.Color;
import java.awt.Graphics;
import javax.swing.JRootPane;

/**
 * @author  Michael Hagen
 */
public class HiFiTitlePane extends BaseTitlePane {

    public HiFiTitlePane(JRootPane root, BaseRootPaneUI ui) {
        super(root, ui);
    }

    public void paintText(Graphics g, int x, int y, String title) {
        g.setColor(Color.black);
        JTattooUtilities.drawString(rootPane, g, title, x + 1, y + 1);
        if (isActive()) {
            g.setColor(AbstractLookAndFeel.getWindowTitleForegroundColor());
        } else {
            g.setColor(AbstractLookAndFeel.getWindowInactiveTitleForegroundColor());
        }
        JTattooUtilities.drawString(rootPane, g, title, x, y);
    }

    protected void paintBorder(Graphics g) {
    }

}
