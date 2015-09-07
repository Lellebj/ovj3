/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package  vnmr.bo;

/**
 * experiment identifier
 *
 */
public class PanelNComp extends ID {
    /**
     * constructor
     */

    public PanelNComp(String id) {
	super(id);
    } // PanelNComp()


    public String getName() {
	return id;
    }

    /**
     * indicates whether the given object is equal to this one
     * @return boolean
     */
    public boolean equals(Object obj) {
	if (this == obj)
	    return true;
	if (id != null && obj instanceof PanelNComp)
	    return id.equals(((PanelNComp)obj).id);
	return false;
    } // equals()

} // class PanelNComp
