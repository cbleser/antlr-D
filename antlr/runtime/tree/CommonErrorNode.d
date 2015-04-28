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
module antlr.runtime.tree.CommonErrorNode;

import antlr.runtime.Token;
import antlr.runtime.IntStream;
import antlr.runtime.RecognitionException;
import antlr.runtime.TokenStream;
import antlr.runtime.MissingTokenException;
import antlr.runtime.UnwantedTokenException;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.NoViableAltException;

import antlr.runtime.tree.CommonTree;
import antlr.runtime.tree.TreeNodeStream;
import antlr.runtime.tree.Tree;

//import antlr.runtime.tango.Format16;

import antlr.runtime.misc.Format;

/** A node representing erroneous token range in token stream */
public class CommonErrorNode(char_t) : CommonTree!(char_t) {
    alias RecognitionException!(char_t) RecognitionExceptionT;
    alias TokenStream!(char_t) TokenStreamT;
    alias TreeNodeStream!(char_t) TreeNodeStreamT;
    alias MissingTokenException!(char_t) MissingTokenExceptionT;
    alias MismatchedTokenException!(char_t) MismatchedTokenExceptionT;
    alias NoViableAltException!(char_t) NoViableAltExceptionT;
    alias UnwantedTokenException!(char_t) UnwantedTokenExceptionT;
    public IntStream input;
    public TokenT start;
    public TokenT stop;
    public RecognitionExceptionT trappedException;

    mixin iFormatT!(char_t);

    public this(TokenStreamT input, TokenT start, TokenT stop,
        RecognitionExceptionT e)
    {
        //System.out.println("start: "+start+", stop: "+stop);
        if ( stop is null ||
            (stop.TokenIndex() < start.TokenIndex() &&
                stop.Type()!=TokenT.EOF) )
        {
            // sometimes resync does not consume a token (when LT(1) is
            // in follow set.  So, stop will be 1 to left to start. adjust.
            // Also handle case where start is the first token and no token
            // is consumed during recovery; LT(-1) will return null.
            stop = start;
        }
        this.input = input;
        this.start = start;
        this.stop = stop;
        this.trappedException = e;
    }

    override bool isNil() const {
        return false;
    }

    override int Type() const {
        return TokenT.INVALID_TOKEN_TYPE;
    }

    override immutable(char_t)[] Text() const {
        immutable(char_t)[] badText;
        if ( is (start == TokenT) ) {
            int i = start.TokenIndex();
            int j = stop.TokenIndex();
            if ( stop.Type == TokenT.EOF ) {
                j = (cast(TokenStreamT)input).size();
            }
            badText = (cast(TokenStreamT)input).toStringT(i, j);
        }
        else if ( auto treeStart = cast(TreeT)start ) {
            badText = (cast(TreeNodeStreamT)input).toStringT(treeStart, cast(TreeT)stop);
        }
        else {
            // people should subclass if they alter the tree type so this
            // next one is for sure correct.
            badText = "<unknown>";
        }
        return badText;
    }

    override immutable(char)[] toString() {
        if ( auto e = cast(MissingTokenExceptionT)trappedException ) {
            return iFormat8("<missing type: {} >", e.getMissingType());
        }
        else if ( auto e = cast(UnwantedTokenExceptionT)trappedException ) {
            return iFormat8("<extraneous: {}, resync={}>",
                e.getUnexpectedToken(),Text());
        }
        else if ( auto e=cast(MismatchedTokenExceptionT)trappedException  ) {
            return iFormat8( "<mismatched token: {}, resync={}>",e.token,Text());
        }
        else if ( auto e=cast(NoViableAltExceptionT)trappedException ) {
            return iFormat8("<unexpected: {}, resync={}>",e.token,Text());
        }
        return iFormat8("<error: {}>",Text());
    }
}
