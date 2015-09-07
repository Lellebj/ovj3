/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package vnmr.lc;

import java.awt.Dimension;

import vnmr.bo.VPlot;
import vnmr.ui.SessionShare;
import vnmr.util.ButtonIF;


/**
 * Plots an LC method.
 */
public class VLcMethodPlot extends VPlot {

    public VLcMethodPlot(SessionShare sshare, ButtonIF vif, String typ) {
        super(sshare, vif, typ);
        /*System.out.println("VLcMethodPlot()");/*CMP*/

        m_plot = new VPlot.CursedPlot();
        m_plot.setOpaque(false);
        m_plot.setPreferredSize(new Dimension(500, 300));
        add(m_plot);
        //offsetDragEnabled = true;
    }

}
