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
module antlr.runtime.ANTLRStringStream;


import antlr.runtime.CharStreamState;
import antlr.runtime.CharStream;

import tango.util.container.LinkedList;
import tango.io.Stdout;

/** A pretty quick CharStream that pulls all data from an array
 *  directly.  Every method call counts in the lexer.  Java's
 *  strings aren't very good so I'm avoiding.
 */
class ANTLRStringStream(char_t, bool CaseSensitive=true) : CharStream!(char_t) {
    //  static int debug_line;
    /** The data being scanned */
    protected immutable(char_t)[] data;

    /** How many characters are actually in the buffer */
    protected int n;

    /** 0..n-1 index into string of next char */
    protected int p=0;

    /** line number 1..n within the input */
    protected int line = 1;

    /** The index of the character relative to the beginning of the line 0..n-1 */
    protected int charPositionInLine = 0;

    /** tracks how deep mark() calls are nested */
    protected int markDepth = 0;

    /** A list of CharStreamState objects that tracks the stream state
     *  values line, charPositionInLine, and p that can change as you
     *  move through the input stream.  Indexed from 1..markDepth.
     *  A null is kept @ index 0.  Create upon first call to mark().
     */
    protected LinkedList!(CharStreamState) markers;

    /** Track the last mark() call result value for use in rewind(). */
    protected int lastMarker;

    /** What is name or source of this char stream? */
    public immutable(char)[] name;

    this() {
    }
    /** Copy data in string to a local char array */
    /** This is the preferred constructor as no data is copied */
    this(immutable(char_t)[] input, int numberOfActualCharsInArray=-1) {
        this.data = input;
        if (numberOfActualCharsInArray>=0) {
            this.n = numberOfActualCharsInArray;
        } else {
            this.n=cast(int)input.length;
        }
    }

    static ANTLRStringStream!(char_t) opCall(char_t)(immutable(char_t)[] input, int numberOfActualCharsInArray=-1) {
        return new ANTLRStringStream!(char_t)(input, numberOfActualCharsInArray);
    }

    /** Reset the stream so that it's in the same state it was
     *  when the object was created *except* the data array is not
     *  touched.
     */
    public void reset() {
        p = 0;
        line = 1;
        charPositionInLine = 0;
        markDepth = 0;
    }

    public void consume() {
        //System.out.println("prev p="+p+", c="+(char)data[p]);
        if ( p < n ) {
            charPositionInLine++;
            if ( data[p]=='\n' ) {
                /*
                  System.out.println("newline char found on line: "+line+
                  "@ pos="+charPositionInLine);
                */
                line++;
                charPositionInLine=0;
            }
            p++;
            //System.out.println("p moves to "+p+" (c='"+(char)data[p]+"')");
        }
    }

    final public int rawLA(int i) {
        if ( i==0 ) {
            return 0; // undefined
        }
        if ( i<0 ) {
            i++; // e.g., translate LA(-1) to use offset i=0; then data[p+0-1]
            if ( (p+i-1) < 0 ) {
                return CharStream!(char_t).EOF; // invalid; no char before first char
            }
        }

        if ( (p+i-1) >= n ) {
            //System.out.println("char LA("+i+")=EOF; p="+p);
            return CharStream!(char_t).EOF;
        }
        return cast(int)data[p+i-1];
    }

    static if (CaseSensitive) {
        public int LA(int i) { return rawLA(i); }
    } else {
        bool ignorecase;
        public int LA(int i) {
            if (ignorecase) {
                int LAi=rawLA(i);
                if (LAi>='A' && LAi<='Z') {
                    return LAi+('a'-'A');
                }
            }
            return rawLA(i);
        }
    }

    public void IgnoreCase(bool flag) {
        assert(CaseSensitive, "IgnoreCase on supported for "~typeid(typeof(this)).toString~" you need to enable the CaseSensitive flag");
        static if (!CaseSensitive) {
            ignorecase=flag;
        }
    }

    public int LT(int i) {
        return LA(i);
    }

    /** Return the current input symbol index 0..n where n indicates the
     *  last symbol has been read.  The index is the index of char to
     *  be returned from LA(1).
     */
    public int index() {
        return p;
    }

    public int size() {
        return n;
    }

    public int mark() {
        if ( markers is null ) {
            markers = new typeof(markers);
            markers.append(cast(CharStreamState)null); // depth 0 means no backtracking, leave blank
        }
        markDepth++;
        CharStreamState state;
        if ( markDepth>=markers.size() ) {
            state = new CharStreamState();
            markers.append(state);
        }
        else {
            state = cast(CharStreamState)markers.get(markDepth);
        }
        state.p = p;
        state.line = line;
        state.charPositionInLine = charPositionInLine;
        lastMarker = markDepth;
        return markDepth;
    }

    public void rewind(int m) {
        CharStreamState state = cast(CharStreamState)markers.get(m);
        // restore stream state
        seek(state.p);
        line = state.line;
        charPositionInLine = state.charPositionInLine;
        release(m);
    }

    public void rewind() {
        rewind(lastMarker);
    }

    public void release(int marker) {
        // unwind any other markers made after m and release m
        markDepth = marker;
        // release this marker
        markDepth--;
    }

    /** consume() ahead until p==index; can't just set p=index as we must
     *  update line and charPositionInLine.
     */
    public void seek(int index) {
        if ( index<=p ) {
            p = index; // just jump; don't update stream state (line, ...)
            return;
        }
        // seek forward, consume until p hits index
        while ( p<index ) {
            consume();
        }
    }

    override immutable(char_t)[] substring(int start, int stop) const{
        //	Stdout.format("substring {} {} {}",data,start,stop+1).newline;
        return data[start..stop+1];
    }

    public int getLine() {
        return line;
    }

    public int CharPositionInLine() {
        return charPositionInLine;
    }

    public void setLine(int line) {
        this.line = line;
    }

    public void CharPositionInLine(int pos) {
        this.charPositionInLine = pos;
    }

    public immutable(char)[] getSourceName() {
        return name;
    }

    unittest {
        // Size test
        auto stream=new ANTLRStringStream("foo");
        assert(stream.size == 3);
    }

    unittest {
        // Index test

        auto stream=new ANTLRStringStream("foo\nbar");
        assert(stream.index == 0);

        // Consume test
        stream.consume(); // Consume f
        assert(stream.index == 1);
        assert(stream.charPositionInLine == 1);
        assert(stream.line == 1);

        stream.consume(); // Consume o
        assert(stream.index == 2);
        assert(stream.charPositionInLine == 2);
        assert(stream.line == 1);

        stream.consume(); // Consume o
        assert(stream.index == 3);
        assert(stream.charPositionInLine == 3);
        assert(stream.line == 1);

        stream.consume(); // Consume \n
        assert(stream.index == 4);
        assert(stream.charPositionInLine == 0);
        assert(stream.line == 2);

        stream.consume(); // Consume b
        assert(stream.index == 5);
        assert(stream.charPositionInLine == 1);
        assert(stream.line == 2);

        stream.consume(); // Consume a
        assert(stream.index == 6);
        assert(stream.charPositionInLine == 2);
        assert(stream.line == 2);

        stream.consume(); // Consume r
        assert(stream.index == 7);
        assert(stream.charPositionInLine == 3);
        assert(stream.line == 2);

        stream.consume(); // Consume EOF
        assert(stream.index == 7);
        assert(stream.charPositionInLine == 3);
        assert(stream.line == 2);

        stream.consume(); // Consume EOF
        assert(stream.index == 7);
        assert(stream.charPositionInLine == 3);
        assert(stream.line == 2);
    }

    unittest {
        // Reset test
        auto stream = new ANTLRStringStream("foo");
        stream.consume();
        stream.consume();

        stream.reset();
        assert(stream.index == 0);
        assert(stream.line == 1);
        assert(stream.charPositionInLine == 0);
        assert(stream.LT(1) == 'f');
    }

    unittest {
        // test LA
        auto stream = new ANTLRStringStream("foo");
        assert(stream.LT(1) == 'f');
        assert(stream.LT(2) == 'o');
        assert(stream.LT(3) == 'o');

        stream.consume();
        stream.consume();

        assert(stream.LT(1) == 'o');
        assert(stream.LT(2) == EOF);
        assert(stream.LT(3) == EOF);
    }

    unittest {
        // Test substring
        auto stream = new ANTLRStringStream("foobar");

        assert(stream.substring(0,0) == "f");
        assert(stream.substring(0,1) == "fo");
        assert(stream.substring(0,5) == "foobar");
        assert(stream.substring(3,5) == "bar");
    }

    unittest {
        // Test SeekForward
        auto stream = new ANTLRStringStream("foo\nbar");

        stream.seek(4);

        assert(stream.index == 4);
        assert(stream.line == 2);
        assert(stream.charPositionInLine == 0);
        assert(stream.LT(1) == 'b');
    }

    unittest {
        // Test Mark
        auto stream = new ANTLRStringStream("foo\nbar");

        stream.seek(4);
        auto marker = stream.mark();
        assert(marker == 1);
        assert(stream.markDepth == 1);

        stream.consume();
        marker = stream.mark();
        assert(marker == 2);
        assert(stream.markDepth == 2);
    }

    unittest {
        // Test ReleaseLast
        auto stream = new ANTLRStringStream("foo\nbar");

        stream.seek(4);
        auto marker1 = stream.mark();

        stream.consume();
        auto marker2 = stream.mark();

        assert(stream.markDepth == 2);

        stream.release(marker2);
        assert(stream.markDepth == 1);

        // release same marker again, nothing has changed
        stream.release(marker2);
        assert(stream.markDepth == 1);
    }

    unittest {
        // Test Release Nested
        auto stream = new ANTLRStringStream("foo\nbar");

        stream.seek(4);
        auto marker1 = stream.mark();

        stream.consume();
        auto marker2 = stream.mark();

        stream.consume();
        auto marker3 = stream.mark();

        stream.release(marker2);
        assert(stream.markDepth == 1);
    }

    unittest {
        // Test Rewind Last
        auto stream = new ANTLRStringStream("foo\nbar");

        stream.seek(4);

        auto marker = stream.mark();
        stream.consume();
        stream.consume();

        stream.rewind();
        assert(stream.markDepth == 0);
        assert(stream.index == 4);
        assert(stream.line == 2);
        assert(stream.charPositionInLine == 0);
        assert(stream.LT(1) == 'b');
    }

    unittest {
        // Test Rewind Nested
        auto stream = new ANTLRStringStream("foo\nbar");

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

    }
}
