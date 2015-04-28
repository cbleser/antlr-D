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
module antlr.runtime.ANTLRFileStream;

import antlr.runtime.ANTLRStringStream;
import tango.io.device.File;
import tango.io.model.IConduit;

import tango.io.Stdout;

import tango.text.convert.UnicodeBom;
private import tango.io.UnicodeFile;
//import java.io.*;

/** This is a char buffer stream that is loaded from a file
 *  all at once when you construct the object.  This looks very
 *  much like an ANTLReader or ANTLRInputStream, but it's a special case
 *  since we know the exact size of the object to load.  We can avoid lots
 *  of data copying.
 */
class ANTLRFileStream(char_t, bool CaseSensitive=true) : ANTLRStringStream!(char_t,CaseSensitive) {
	protected immutable(char)[] fileName;
/**
 * Write the file.
 * Throws: IOException on failure
 */
    /++
         this(char[] fileName) {
        this(fileName, Encoding.Unknown);
	}
    ++/
/**
 * Write the file.
 * Throws: IOException on failure
 */
         this(immutable(char)[] fileName, Encoding encoding=Encoding.Unknown) {
             this.fileName = fileName;
             load(fileName, encoding);
         }

         this(InputStream stream) {
             this.data=cast(immutable(char_t)[])stream.load();
             n=cast(int)this.data.length;
         }
/**
 * Write the file.
 * Throws: IOException on failure
 */

         public void load(immutable(char)[] fileName, Encoding encoding)
         {
             if ( fileName is null ) {
                 return;
             }
             auto f = UnicodeFile!(char_t)(fileName, encoding);
             data=f.read().idup;
             Stdout.formatln("filename={} data.length={}",fileName,data.length);
             n=cast(int)data.length;
         }

         override immutable(char)[] getSourceName() {
             return fileName;
         }

         version(ANTLRfiles){
             unittest {
                 // Test No Encoding
                 char[] path;
                 path="teststream.input1";
                 auto stream=new ANTLRFileStream(path);

                 stream.seek(4);
                 auto marker1 = stream.mark();

                 stream.consume();
                 auto marker2 = stream.mark();

                 stream.consume();
                 auto marker3 = stream.mark();

                 stream.rewind(marker2);
                 assert(stream.markDepth == 1);
                 assert(stream.index == 5);
                 assert(stream.line == 2);
                 assert(stream.charPositionInLine == 1);
                 assert(stream.LT(1) == 'a');
                 assert(stream.LA(1) == cast(int)'a');

                 // Test Encoding
                 path="teststream.input2";
                 stream=new ANTLRFileStream(path, Encoding.UTF_8);

                 stream.seek(4);
                 marker1 = stream.mark();

                 stream.consume();
                 marker2 = stream.mark();

                 stream.consume();
                 marker3 = stream.mark();

                 stream.rewind(marker2);
                 assert(stream.markDepth == 1);
                 assert(stream.index == 5);
                 assert(stream.line == 2);
                 assert(stream.charPositionInLine == 1);
                 assert(stream.LT(1)==cast(int)'ä');
                 assert(stream.LA(1)==cast(int)'ä');

             }
         }
}
