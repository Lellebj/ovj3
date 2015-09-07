/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package vnmr.admin.ui;

import vnmr.util.*;

import javax.swing.*;
import java.awt.*;
import java.beans.*;
import java.awt.event.*;





public class WSharedConsoleDialog {

    private static WSharedConsoleDialogSingle enablePanel=null;
    private static WSharedConsoleDialogSingle disablePanel=null;


    static public void openPanel() {
        String status;

        // Determine current status
        String output = WSharedConsoleCommands.status();
        if(output.contains("active"))
            status = "enabled";
        else
            status = "disabled";

        // Put the return status into the log file.  If there are any problems,
        // there could be useful information returned.
        Messages.postLog("WSharedConsoleDialog status output: " + status);
            
        
        // If enabled, open the disable panel
        if(status.equals("disabled")) {
            // Always make a new panel or the JPasswordField item
            // does not work correctly.
            enablePanel = new WSharedConsoleDialogSingle("");
            enablePanel.setVisible(true);
            enablePanel.statusLabel.setText("Status: Sharing Disabled");


        }
        // If disabled, open the enable panel
        else {
            if(disablePanel == null)
                disablePanel = new WSharedConsoleDialogSingle("");
            disablePanel.setVisible(true);
            disablePanel.statusLabel.setText("Status: Sharing Enabled");
            disablePanel.okButton.setEnabled(true);
        }
    }



}
