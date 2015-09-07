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
import java.awt.event.*;
import javax.swing.*;
import javax.swing.plaf.metal.*;

import vnmr.util.*;


public class VMetalLookAndFeel extends MetalLookAndFeel
{

    protected void initClassDefaults(UIDefaults table)
    {
         super.initClassDefaults(table);
         Object[] defaults = {
            "ComboBoxUI", "vnmr.ui.VComboMetalUI",
            "SliderUI", "vnmr.util.VSliderMetalUI"
         };

         table.putDefaults(defaults);
    }
}
