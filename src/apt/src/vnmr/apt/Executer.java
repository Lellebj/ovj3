/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
 * Copyright (c) 2004 Varian, Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian, Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 */

package vnmr.apt;

/**
 * Indicates that a class can execute command strings.
 * Implemented by ProbeTune and ProbeTuneGui and used by CommandListener
 * to specify where to send commands to get them executed.
 */
public interface Executer {

    public void exec(String cmd);
}
