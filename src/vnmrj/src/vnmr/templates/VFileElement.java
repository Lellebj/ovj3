/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package vnmr.templates;

import javax.swing.*;
import java.util.*;
import vnmr.ui.shuf.*;

public class VFileElement extends VTreeNodeElement
{
    public boolean getAllowsChildren () { 
	if(isLeaf()) return false; 
	else return true;
    }
}
