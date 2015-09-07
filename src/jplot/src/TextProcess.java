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

public class TextProcess implements Runnable {
   private Process   chkit;
   private String   prog;

   public TextProcess(String cmd) {
	this.prog = cmd;
   }

	
   public void run() {
	try {
	      Runtime rt = Runtime.getRuntime();
              // exec and get back a Process class
              chkit = rt.exec(""+prog);
              // wait for process to exit
              int ret = chkit.waitFor();
      }
      catch (IOException e)
      {
            System.out.println(e);
      }
      catch (InterruptedException ex)
      {
            System.out.println(ex);
      }
   }
}

