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
module antlr.runtime.Parser;

import antlr.runtime.BaseRecognizer;
import antlr.runtime.TokenStream;
import antlr.runtime.RecognizerSharedState;
import antlr.runtime.IntStream;
import antlr.runtime.RecognitionException;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;
import antlr.runtime.BitSet;
import antlr.runtime.ParserRuleReturnScope;
import antlr.runtime.tree.TreeAdaptor;
import antlr.runtime.tree.Tree;
import antlr.runtime.tree.CommonTree;
import antlr.runtime.tree.CommonTreeAdaptor;
import antlr.runtime.RuleReturnScope;
import antlr.runtime.tree.RewriteRuleTokenStream;
import antlr.runtime.tree.RewriteRuleSubtreeStream;
import antlr.runtime.TokenRewriteStream;

import tango.io.Stdout;
/** A parser for TokenStreams.  "parser grammars" result in a subclass
 *  of this.
 */
class Parser(char_t) : BaseRecognizer!(char_t) {
    alias TokenStream!(char_t) TokenStreamT;
    alias Token!(char_t) TokenT;
    alias Tree!(char_t) TreeT;
    alias CommonToken!(char_t) CommonTokenT;
    alias CommonTree!(char_t) CommonTreeT;
    alias TreeAdaptor!(char_t) TreeAdaptorT;
    alias ParserRuleReturnScope!(char_t) ParserRuleReturnScopeT;
    alias CommonTreeAdaptor!(char_t) CommonTreeAdaptorT;
    alias RuleReturnScope!(char_t) RuleReturnScopeT;
    alias RewriteRuleTokenStream!(char_t,TokenT) RewriteRuleTokenStreamT;
    alias RewriteRuleSubtreeStream!(char_t,TreeT) RewriteRuleSubtreeStreamT;
    alias TokenRewriteStream!(char_t) TokenRewriteStreamT;

    public TokenStreamT input;

    this(TokenStreamT input) {
        super(); // highlight that we go to super to set state object
        setTokenStream(input);
    }

    this(TokenStreamT input, RecognizerSharedStateT state) {
        super(state); // share the state object with another parser
        setTokenStream(input);
    }

    override void reset() {
        super.reset(); // reset all recognizer state variables
        if ( input !is null ) {
            input.seek(0); // rewind the input
        }
    }

    override TokenT getCurrentInputSymbol(IntStream input)
    {
        static if (is(typeof(input):TokenStreamT)) {
            pragma(msg,"input must be of type TokenStream!(char_t)");
        }
        return (cast(TokenStreamT)input).LT(1);
	}


    protected override TokenT getMissingSymbol(IntStream input,
        RecognitionExceptionT e,
        int expectedTokenType,
        const BitSet follow)
    {
        immutable(char_t)[] tokenText =
            cast(immutable(char_t)[])("<missing "~getTokenNames()[(expectedTokenType>0)?expectedTokenType:0]~">");
        auto t = new CommonTokenT(expectedTokenType, tokenText);
        auto current = (cast(TokenStreamT)input).LT(1);
        if ( current.Type == TokenT.EOF ) {
            auto temp = (cast(TokenStreamT)input).LT(-1);
            if (temp !is null) current=temp;
            //current = (cast(TokenStream)input).LT(-1);
        }
        t.line = current.Line();
        t.charPositionInLine = current.CharPositionInLine();
        t.channel = DEFAULT_TOKEN_CHANNEL;
        return t;
    }

    /** Set the token stream and reset the parser */
    public void setTokenStream(TokenStreamT input)
        in {
        assert(input !is null);
	}
    body {
        this.input = null;
        reset();
        this.input = input;
	}

    public TokenStreamT getTokenStream() {
        return input;
    }

    override immutable(char)[] getSourceName() {
        return input.getSourceName();
    }

    public void traceIn(immutable(char)[] ruleName, int ruleIndex)  {
        immutable(char_t)[] msg;
        auto t=input.LT(1).Type;
        if (t is TokenT.CharStreamT.EOF) {
            msg~="[EOF]";
        } else {
            msg~=t;
        }
        auto inputSymbol=new CommonTokenT(0, msg);
        super.traceIn(ruleName, ruleIndex, inputSymbol);
    }

    public void traceOut(immutable(char)[] ruleName, int ruleIndex)  {
        immutable(char_t)[] msg;
        auto t=input.LT(1).Type;
        if (t is TokenT.CharStreamT.EOF) {
            msg~="[EOF]";
        } else {
            msg~=t;
        }
        super.traceOut(ruleName, ruleIndex, new CommonTokenT(0,msg));
    }
}
