/*
  [The "BSD licence"]
  Copyright (c) 2005-2008 Terence Parr
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:
  1. Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
  3. The name of the author may not be used to endorse or promote products
  derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
module antlr.runtime.ANTLRReaderStream;


import antlr.runtime.ANTLRStringStream;

import tango.io.model.IConduit;

/++ D Translation note 
++ InputStream is used instead of Reader in java
++/

/** Vacuum all input from a Reader and then treat it like a StringStream.
 *  Manage the buffer manually to avoid unnecessary data copying.
 *
 *  If you need encoding, use ANTLRInputStream.
 */
public class ANTLRReaderStream(char_t) : ANTLRStringStream {
  const int READ_BUFFER_SIZE = 1024;
  const INITIAL_BUFFER_SIZE = 1024;

  this(InputStream r) {
	this(r, INITIAL_BUFFER_SIZE, READ_BUFFER_SIZE);
  }

  this(InputStream r, int size) {
	this(r, size, READ_BUFFER_SIZE);
  }

  this(InputStream r, int size, int readChunkSize) {
	load(r, size, readChunkSize);
  }

  public void load(InputStream r, int size, int readChunkSize)
  {
	if ( r is null ) {
	  return;
	}
	if ( size<=0 ) {
	  size = INITIAL_BUFFER_SIZE;
	}
	if ( readChunkSize<=0 ) {
	  readChunkSize = READ_BUFFER_SIZE;
	}
	void[] buffer=new void[readChunkSize];
	// System.out.println("load "+size+" in chunks of "+readChunkSize);
	try {
	  // alloc initial buffer size.
	  char_t[] data;
	  // read all the data in chunks of readChunkSize
	  for (int numRead=r.read(buffer); numRead !=r.Eof; numRead=r.read(buffer)) {
	    data~=cast(char_t[])buffer;
	  }
	  super.n = data.length+1;
	  //System.out.println("n="+n);
	}
	finally {
	  r.close();
	}
  }

}
