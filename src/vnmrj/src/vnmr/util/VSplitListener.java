/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package  vnmr.util;

import java.awt.*;
import javax.swing.*;

public interface VSplitListener {
    public void setSplitSize(VSeparator comp, int size);
    public void setSplitPos(VSeparator comp, int  pos);
}
