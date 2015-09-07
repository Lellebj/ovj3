/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */

package vnmr.print;


public class VjPrintEvent  {

      private int  status;
      private Object  source;

      public VjPrintEvent(Object source, int e) {
          this.source = source;
          this.status = e;
      }

      public Object getSource() {
          return source;
      }

      public void setSource(Object obj) {
          source = obj;
      }

      public int getStatus() {
          return status;
      }

      public void setStatus(int n) {
          status = n;
      }
}

