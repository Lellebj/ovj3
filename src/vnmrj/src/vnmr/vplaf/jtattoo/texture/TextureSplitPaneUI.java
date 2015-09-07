/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
 * Copyright 2012 MH-Software-Entwicklung. All rights reserved.
 * Use is subject to license terms.
 */
package vnmr.vplaf.jtattoo.texture;

import vnmr.vplaf.jtattoo.BaseSplitPaneUI;
import javax.swing.JComponent;
import javax.swing.plaf.ComponentUI;
import javax.swing.plaf.basic.BasicSplitPaneDivider;

/**
 * @author Michael Hagen
 */
public class TextureSplitPaneUI extends BaseSplitPaneUI {

    public static ComponentUI createUI(JComponent c) {
        return new TextureSplitPaneUI();
    }

    public BasicSplitPaneDivider createDefaultDivider() {
        return new TextureSplitPaneDivider(this);
    }
}
