/*
 * Copyright (C) 2015  Stanford University
 *
 * You may distribute under the terms of either the GNU General Public
 * License or the Apache License, as specified in the README file.
 *
 * For more information, see the README file.
 */
package vnmr.probeid;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import vnmr.vjclient.Messages;

public class ProbeIdZip {
	public static ZipInputStream getBufferedReader(InputStream reader) 
		throws IOException 
	{
		ZipInputStream zin = new ZipInputStream(reader);
		ZipEntry zentry = zin.getNextEntry();
		Messages.postDebug("Decompressing " + zentry.getName());
		return new ZipInputStream(reader);
	}
	
	public static ZipOutputStream getBufferedWriter(OutputStream writer) {
		ZipOutputStream zout = new ZipOutputStream(writer);
		return zout;
	}
}
