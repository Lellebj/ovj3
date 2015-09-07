/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package vnmr.ui;

import java.io.*;
import java.util.*;

/**
 * <p>Title: ComboBoxTitleIF </p>
 * <p>Description: Interface for the ComboBoxTitleUI. </p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p> </p>
 *  unascribed
 *
 */

public interface ComboBoxTitleIF
{

    public boolean getDefault();
    public String getDefaultLabel();
    public String getTitleLabel();
    public void enterPopup();
    public void exitPopup();
    public void listBoxMouseAdded();
}
