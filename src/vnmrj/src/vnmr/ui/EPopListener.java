/*
 * Copyright (C) 2015  University of Oregon
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package  vnmr.ui;

import vnmr.ui.shuf.*;

/**
 * Listener of pop selections.
 */
public interface EPopListener {
    /**
     * notify of a popup selection string
     * @param popStr popup selection
     */
    public void popHappened(String popStr, StatementElement element);

} // interface EPopListener
