/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
package vnmr.vjclient;

import java.io.File;
import java.io.FilenameFilter;
import java.util.regex.Pattern;

public class RegexFileFilter implements FilenameFilter {
    private Pattern m_pattern;

    public RegexFileFilter(String regex) {
        m_pattern = Pattern.compile(regex);
    }

    public boolean accept(File dir, String name) {
        return m_pattern.matcher(name).matches();
    }
}
