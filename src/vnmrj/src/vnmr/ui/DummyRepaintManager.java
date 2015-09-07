/*
 * Copyright (C) 2015  University of Oregon
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package vnmr.ui;

import java.awt.*;
import javax.swing.*;

public  class DummyRepaintManager extends RepaintManager {

   public synchronized void addInvalidComponent(JComponent invalidComponent) { }

   public synchronized void addDirtyRegion(JComponent c, int x, int y, int w, int h)     { }

}

