/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
/*
 * 
 * Varian Assoc.,Inc. All Rights Reserved.
 * This software contains proprietary and confidential
 * information of Varian Assoc., Inc. and its contributors.
 * Use, disclosure and reproduction is prohibited without
 * prior consent.
 *
 */

import java.io.*;
import java.net.*;

public class ToVnmrSocket {
   private Socket vnmrSocket;
   private int  socketPort;
   private String  host;

   public ToVnmrSocket(String host,  int port) {
	this.host = host;
	this.socketPort = port;
   }

   public void send(String str) {
	try
        {
	   vnmrSocket = new Socket (host, socketPort);
	   if (vnmrSocket == null)
		return;
	   vnmrSocket.setTcpNoDelay(true);
	   PrintWriter out2Vnmr = new PrintWriter (
                        vnmrSocket.getOutputStream(), true);
	   out2Vnmr.println(str);
           out2Vnmr.close();
	   vnmrSocket.close();
        }
        catch (Exception e)
        {  System.out.println(e);
        }
   }
}

