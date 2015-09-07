/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
package vnmr.wizard.event;

public interface WizardListener extends java.util.EventListener
{
    public void wizardCancelled(WizardEvent we);
    public void wizardComplete(WizardEvent we);
    public void wizardScreenChanging(WizardEvent we);
    public void wizardScreenChanged(WizardEvent we);
}
