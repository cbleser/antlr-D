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
  1
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
module antlr.runtime.Lexer;

import antlr.runtime.RecognitionException;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;
import antlr.runtime.RecognizerSharedState;
import antlr.runtime.CharStream;
import antlr.runtime.TokenSource;
import antlr.runtime.BaseRecognizer;
import antlr.runtime.UnwantedTokenException;
import antlr.runtime.NoViableAltException;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.MismatchedRangeException;
import antlr.runtime.EarlyExitException;
import antlr.runtime.MismatchedNotSetException;
import antlr.runtime.MismatchedSetException;

import antlr.runtime.Base;

import antlr.runtime.misc.Format;


//import tango.io.Stdout;

//import tango.stdc.stdio : printf;
//import antlr.runtime.TokenSource;
/** A lexer is recognizer that draws input symbols from a character stream.
 *  lexer grammars result in a subclass of this object. A Lexer object
 *  uses simplified match() and error recovery mechanisms in the interest
 *  of speed.
 */
abstract class Lexer(char_t,TokenC=CommonToken!(char_t)) : BaseRecognizer!(char_t), TokenSource!(char_t) {
    static if (!is(TokenC : Token!(char_t))) {
        pragma(msg, "TokenC must implement ",typeid(Token!(char_t)));
    }
    alias CharStream!(char_t) CharStreamT;
    alias CommonToken!(char_t) CommonTokenT;


    /** Where is the lexer drawing characters from? */
    protected CharStreamT input;

  public:
    mixin iFormatT!(char_t);

    this() {
        super();
    }

    this(CharStreamT input, RecognizerSharedStateT state=null) {
        super(state);
        assert(input !is null);
        this.input = input;
    }

    override void reset() {
        super.reset(); // reset all recognizer state variables
        // wack Lexer state variables
        if ( input !is null ) {
            input.seek(0); // rewind the input
        }
        if ( state is null ) {
            return; // no shared state work to do
        }
        state.token = null;
        state.type = TokenT.INVALID_TOKEN_TYPE;
        state.channel = TokenT.DEFAULT_CHANNEL;
        state.tokenStartCharIndex = -1;
        state.tokenStartCharPositionInLine = -1;
        state.tokenStartLine = -1;
        state.use_text=false;
        //printf("set to empty state.text.init=%p\n",&state.text.init);
        // state.text = empty_text;
    }

    /** Return a token from this source; i.e., match a token on the char
     *  stream.
     */
    public TokenT nextToken() {
        while (true) {
            state.token = null;
            state.channel = TokenT.DEFAULT_CHANNEL;
            state.tokenStartCharIndex = input.index();
            state.tokenStartCharPositionInLine = input.CharPositionInLine();
            state.tokenStartLine = input.getLine();
            state.text = null;
            state.use_text =false;
            if ( input.LA(1)==CharStreamT.EOF ) {
                return CommonTokenT.EOF_TOKEN;
            }
            try {
                mTokens();
                if ( state.token is null ) {
                    emit();
                }
                else if ( state.token==CommonTokenT.SKIP_TOKEN ) {
                    continue;
                }
                return state.token;
            }
            catch (NoViableAltExceptionT nva) {
                reportError(nva);
                recover(nva); // throw out current char and try again
            }
            catch (RecognitionExceptionT re) {
                reportError(re);
                // match() routine has already called recover()
            }
        }
    }

    /** Instruct the lexer to skip creating a token for current lexer rule
     *  and look for another token.  nextToken() knows to keep looking when
     *  a lexer rule finishes with token set to SKIP_TOKEN.  Recall that
     *  if token==null at end of any token rule, it creates one for you
     *  and emits it.
     */
    public void skip() {
        state.token = CommonTokenT.SKIP_TOKEN;
    }

    /** This is the lexer entry point that sets instance var 'token' */
    public abstract void mTokens();

    /** Set the char stream and reset the lexer */
    public void setCharStream(CharStreamT input) {
        this.input = null;
        reset();
        this.input = input;
    }

    public CharStreamT getCharStream() {
        return this.input;
    }

    override immutable(char)[] getSourceName() {
        return input.getSourceName();
    }

    /** Currently does not support multiple emits per nextToken invocation
     *  for efficiency reasons.  Subclass and override this method and
     *  nextToken (to push tokens into a list and pull from that list rather
     *  than a single variable as this implementation does).
     */
    public void emit(TokenT token) {
        state.token = token;
    }

    /** The standard method called to automatically emit a token at the
     *  outermost lexical rule.  The token object should point into the
     *  char buffer start..stop.  If there is a text override in 'text',
     *  use that to set the token's text.  Override this method to emit
     *  custom Token objects.
     *
     *  If you are building trees, then you should also override
     *  Parser or TreeParser.getMissingSymbol().
     */
    public TokenT emit() {
        auto t = new TokenC(input, state.type, state.channel, state.tokenStartCharIndex, getCharIndex()-1);
        t.Line(state.tokenStartLine);
        t.Text=Text;
        t.CharPositionInLine(state.tokenStartCharPositionInLine);
        emit(t);
        return t;
    }

    public void match(immutable(char_t)[] s) {
        int i = 0;
        while ( i<s.length ) {
            if ( input.LA(1)!=s[i] ) {
                if ( state.backtracking>0 ) {
                    state.failed = true;
                    return;
                }
                auto mte =
                    new MismatchedTokenExceptionT(s[i], input);
                recover(mte);
                throw mte;
            }
            i++;
            input.consume();
            state.failed = false;
        }
    }

    public void matchAny() {
        input.consume();
    }

    public void match(int c) {
        if ( input.LA(1)!=c ) {
            if ( state.backtracking>0 ) {
                state.failed = true;
                return;
            }
            auto mte =
                new MismatchedTokenExceptionT(c, input);
            recover(mte);  // don't really recover; just consume in lexer
            throw mte;
        }
        input.consume();
        state.failed = false;
    }

    public void matchRange(int a, int b)
    {
        if ( input.LA(1)<a || input.LA(1)>b ) {
            if ( state.backtracking>0 ) {
                state.failed = true;
                return;
            }
            auto mre =
                new MismatchedRangeExceptionT(a,b,input);
            recover(mre);
            throw mre;
        }
        input.consume();
        state.failed = false;
    }

    public int getLine() {
        return input.getLine();
    }

    public int CharPositionInLine() {
        return input.CharPositionInLine();
    }

    /** What is the index of the current character of lookahead? */
    public int getCharIndex() {
        return input.index();
    }

    /** Return the text matched so far for the current token or any
     *  text override.
     */
    public immutable(char_t)[] Text()
    {
        if ( state.use_text ) {
            return state.text;
        }
        return input.substring(state.tokenStartCharIndex,getCharIndex()-1);
    }

    /** Set the complete text of this token; it wipes any previous
     *  changes to the text.
     */
    public immutable(char_t)[] Text(immutable(char_t)[] text) {
        state.use_text=true;
        state.text = text;
        return state.text;
    }

    public immutable(char_t)[] Text(int chr) {
        auto str=new immutable(char_t)[1];
        str~=cast(char_t)chr;
        assert(str.length == 1);
        return Text(str);
    }

    public void setLength(size_t len) {
        state.text.length=len;
    }

    public void setToken(TokenT token) {
        state.token=token;
    }

    override void reportError(RecognitionExceptionT e) {
        /** TODO: not thought about recovery in lexer yet.
         *
         // if we've already reported an error and have not matched a token
         // yet successfully, don't report any errors.
         if ( errorRecovery ) {
         //System.err.print("[SPURIOUS] ");
         return;
         }
         errorRecovery = true;
        */

        displayRecognitionError(this.getTokenNames(), e);
    }

    override immutable(char)[] getErrorMessage(RecognitionExceptionT e, immutable(char_t)[][] tokenNames) {
        immutable(char)[] msg;
        if ( auto mte = cast(MismatchedTokenExceptionT)e ) {
            // Stdout("MismatchedTokenException").newline;
            msg = iFormat8("mismatched character {} expecting {}",
                getCharErrorDisplay(e.c),getCharErrorDisplay(mte.expecting));
        }
        else if ( auto nvae= cast(NoViableAltExceptionT)e ) {
            // Stdout("NoViableAltException").newline;
            msg = iFormat8("no viable alternative at character {}",getCharErrorDisplay(e.c));
        }
        else if ( auto eee=cast(EarlyExitExceptionT)e ) {
            // Stdout("EarlyExitException").newline;
            msg = iFormat8("required (...)+ loop did not match anything at character ",getCharErrorDisplay(e.c));
        }
        else if ( auto mse= cast(MismatchedNotSetExceptionT)e )  {
            // Stdout("MismatchedNotSetException").newline;
            msg = iFormat8("mismatched character {} expecting set {}",getCharErrorDisplay(e.c),mse.toString);
        }
        else if ( auto mse=cast(MismatchedSetExceptionT)e ) {
            // Stdout("").newline;
            msg = iFormat8("mismatched character {}  expecting set {}",getCharErrorDisplay(e.c),mse.toString);
        }
        else if ( auto mre=cast(MismatchedRangeExceptionT)e ) {
            // Stdout("MismatchedRangeException").newline;
            msg = iFormat8("mismatched character {} expecting set {}..{}",getCharErrorDisplay(e.c),
                getCharErrorDisplay(mre.a),getCharErrorDisplay(mre.b));
        } else {
            //	  Stdout("NoLexerException").newline;
            msg = super.getErrorMessage(e, tokenNames);
        }
        return msg;
    }

    immutable(char)[] getCharErrorDisplay(int c) {
        //	char[] s = String.valueOf(cast(char)c);
        immutable(char)[] s;
        switch ( c ) {
        case TokenT.EOF :
            s = "<EOF>";
            break;
        case '\n' :
            s = "\\n";
            break;
        case '\t' :
            s = "\\t";
            break;
        case '\r' :
            s = "\\r";
            break;
        default:
            s~=c;
        }
        return "'"~s~"'";
    }

    /** Lexers can normally match any char in it's vocabulary after matching
     *  a token, so do the easy thing and just kill a character and hope
     *  it all works out.  You can instead use the rule invocation stack
     *  to do sophisticated error recovery if you are in a fragment rule.
     */
    public void recover(RecognitionExceptionT re) {
        //System.out.println("consuming char "+(char)input.LA(1)+" during recovery");
        //re.printStackTrace();
        input.consume();
    }

    public void traceIn(immutable(char)[] ruleName, int ruleIndex)  {
        auto inputSymbol = new TokenC(0, iFormat("{} line {}:{} ",input.LT(1),getLine(),CharPositionInLine()).idup);
        super.traceIn(ruleName, ruleIndex, inputSymbol);
    }

    public void traceOut(immutable(char)[] ruleName, int ruleIndex)  {
        immutable(char_t)[] inputSymbol = iFormat("{} line {}:{} ",cast(char_t)input.LT(1),getLine(),CharPositionInLine());
        super.traceOut(ruleName, ruleIndex, new TokenC(0,inputSymbol));
    }
}
