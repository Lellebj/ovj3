/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package vnmr.lc;

import java.util.*;

public interface LcStatusListener extends EventListener {

    public void detectorFileStatusChanged(int status, String message);
    public void pumpFileStatusChanged(int status, String message);
    // TODO: Generalize this by defining an LcStatusThread interface
    public void pumpStateChanged(Map<String, Object> state);
}
