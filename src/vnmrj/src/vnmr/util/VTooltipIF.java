/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package vnmr.util;

import java.awt.event.*;

public interface VTooltipIF {
    public void setTooltip(String str);
    public String getTooltip(MouseEvent e);
}
 
