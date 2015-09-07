/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package  vnmr.bo;

import java.util.EventListener;

/**
 * Title: Patient Table Listener Interface
 * Description: Patient Table Event Listener Interface
 */

public interface PatientTableListener extends EventListener {

  public void tableMotionUpCmplt(PatientTableEvent e);
  public void tableMotionDownCmplt(PatientTableEvent e);
  public void tableMotionInCmplt(PatientTableEvent e);
  public void tableMotionOutCmplt(PatientTableEvent e);
  public void tableMotionQweryCmplt(PatientTableEvent e);
}
