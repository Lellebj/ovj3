/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package vnmr.sms;

public interface  SmsLayoutIF {
    public void setSampleList(SmsSample s[]);
    public void setStartSample(int s);
    public void setLastSample(int s);
    public int  zoomDir();
}
