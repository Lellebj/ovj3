/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
package vnmr.util;

public class FileChangeEvent {
    public static final int FILE_CHANGED = 1;
    public static final int FILE_CREATED = 2;
    public static final int FILE_DELETED = 3;
    public static final int FILE_TOUCHED = 4;
    public static final int FILE_INITIAL = 5;

    private int m_eventType;
    private String m_path;
    
    public FileChangeEvent(int type, String path) {
        m_eventType = type;
        m_path = path;
    }

    public int getEventType() {
        return m_eventType;
    }

    public void setEventType(int eventType) {
        this.m_eventType = eventType;
    }

    public String getPath() {
        return m_path;
    }

    public void setPath(String path) {
        this.m_path = path;
    }
}
