/*
 * Copyright (C) 2015  University of Oregon
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
 * Copyright (c) 2004 Varian, Inc. All Rights Reserved.
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
