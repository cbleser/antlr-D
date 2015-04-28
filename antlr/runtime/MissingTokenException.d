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
module antlr.runtime.MissingTokenException;

import antlr.runtime.IntStream;
import antlr.runtime.Token;
import antlr.runtime.MismatchedTokenException;

import antlr.runtime.misc.Format;

/** We were expecting a token but it's not found.  The current token
 *  is actually what we wanted next.  Used for tree node errors too.
 */
class MissingTokenException(char_t) : MismatchedTokenException!(char_t) {
    public TokenT inserted;
    /** Used for remote debugger deserialization */
    //this() {;}

    this(int expecting, IntStream input, TokenT inserted) {
        super(expecting, input);
        this.inserted = inserted;
    }

    public int getMissingType() {
        return expecting;
    }

    override immutable(char)[] toString() {
        if ( inserted !is null && token !is null ) {
            return iFormat8("MissingTokenException(inserted {} at {})",inserted,token.Text());
        }
        if ( token !is null ) {
            return iFormat8("MissingTokenException(at {})",token.Text());
        }
        return "MissingTokenException";
    }
}
