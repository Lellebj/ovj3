/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package  vnmr.ui;

/**
 * Listener of pop selections.
 *
 * @author Mark Cao
 */
public interface PopListener {
    /**
     * notify of a popup selection string
     * @param popStr popup selection
     */
    public void popHappened(String popStr);

} // interface PopListener
