/*
 * Copyright (C) 2015  University of Oregon
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
package vnmr.vplaf.jtattoo.mcwin;

import vnmr.vplaf.jtattoo.AbstractToolBarUI;
import java.awt.Graphics;
import javax.swing.JComponent;
import javax.swing.border.Border;
import javax.swing.plaf.ComponentUI;

/**
 * @author Michael Hagen
 */
public class McWinToolBarUI extends AbstractToolBarUI {

    public static ComponentUI createUI(JComponent c) {
        return new McWinToolBarUI();
    }

    public Border getRolloverBorder() {
        return McWinBorders.getRolloverToolButtonBorder();
    }

    public Border getNonRolloverBorder() {
        return McWinBorders.getToolButtonBorder();
    }

    public boolean isButtonOpaque() {
        return true;
    }

    public void paint(Graphics g, JComponent c) {
        McWinUtils.fillComponent(g, c);
    }
}
