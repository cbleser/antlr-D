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
module antlr.runtime.NoViableAltException;

import antlr.runtime.RecognitionException;
import antlr.runtime.IntStream;
import antlr.runtime.CharStream;

import antlr.runtime.misc.Format;
debug import tango.io.Stdout;

public class NoViableAltException(char_t) : RecognitionException!(char_t) {
    public immutable(char_t)[] grammarDecisionDescription;
    public int decisionNumber;
    public int stateNumber;

    /** Used for remote debugger deserialization */
    //this() {;}

    this(immutable(char_t)[] grammarDecisionDescription,
        int decisionNumber,
        int stateNumber,
        IntStream input)
    {
        super(input);
        this.grammarDecisionDescription = grammarDecisionDescription;
        this.decisionNumber = decisionNumber;
        this.stateNumber = stateNumber;
    }

    override immutable(char)[] toString() {
        debug Stdout("input=")(input).newline;
        if ( cast(CharStreamT)input ) {
            return iFormat8("NoViableAltException('{}'@[{}])",cast(char)getUnexpectedType(),grammarDecisionDescription);
        }
        else {
            return iFormat8("NoViableAltException({}@[{}])",getUnexpectedType(),grammarDecisionDescription);
        }
    }
}
