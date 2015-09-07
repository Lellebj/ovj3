/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
 * Varian,Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian, Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 *
 */
package vnmr.cryomon;

import java.util.StringTokenizer;


/**
 * This is the interface for communicating with the CryoBay.
 */
public interface CryoMonitor {
    /**
     * Return the name of this detector, typically the model number, as
     * a string.
     */
    public String getName();

    /**
     * Open communication with the cryobay.
     */
    public void connect(String host, int port);

    /**
     * Shut down communication with the cryobay.
     */
    public void disconnect();

    /**
     * Determine if cryobay communication is OK.
     */
    public boolean isConnected();

    /**
     * Send a command to the cryobay.
     * @param args The string to send.
     */
    public boolean sendToCryoBay(String command);

}
