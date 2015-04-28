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
module antlr.runtime.CommonToken;

import antlr.runtime.Token;
import antlr.runtime.CharStream;
import antlr.runtime.IllegalStateException;
import antlr.runtime.CommonToken;

import antlr.runtime.tree.Tree;
import antlr.runtime.tree.CommonTree;

import antlr.runtime.misc.Format;
import tango.text.Regex;

// import tango.io.Stdout;



public class CommonToken(char_t) : Token!(char_t) {
    alias RegExpT!(char_t) RegexT;
    static if (is(char_t == char) )
        alias iFormat8 iFormatT;
    else static if ( is(char_t == wchar) )
        alias iFormat16 iFormatT;
    else static if ( is(char_t == dchar) )
        alias iFormat32 iFormatT;
    else
        static assert(0, "Type char_t must be one of (char,wchar,dchar) not "~char_t.stringof);

        //alias iFormat!(char_t) iFormatT;
    package int type;
    package int line;
    package int charPositionInLine = -1; // set to invalid position
    package int channel=DEFAULT_CHANNEL;
    protected CharStreamT input;

    /** We need to be able to change the text once in a while.  If
     *  this is non-null, then Text should return this.  Note that
     *  start/stop are not affected by changing this.
     */
    protected immutable(char_t)[] text;
    protected bool use_text;
    /** What token number is this from 0..n-1 tokens; < 0 implies invalid index */
    protected int index = -1;

    /** The char position into the input buffer where this token starts */
    protected int start;

    /** The char position into the input buffer where this token stops */
    protected int stop;

    private static TokenT eof_token;
    private static TokenT invalid_token;
    private static TokenT skip_token;

    static this() {
        eof_token=new CommonToken(EOF);
        invalid_token=new CommonToken(INVALID_TOKEN_TYPE);
        skip_token=new CommonToken(INVALID_TOKEN_TYPE);
        // Set up format for char_t
    }


  public:

    static TokenT EOF_TOKEN() {
        return eof_token;
    }

    static TokenT INVALID_TOKEN() {
        return invalid_token;
    }

    static TokenT SKIP_TOKEN() {
        return skip_token;
    }

    this(const int type, const int channel=TokenT.DEFAULT_CHANNEL) {
        this.type = type;
        this.channel=channel;
    }

    this(CharStreamT input, const int type, const int channel, const int start, const int stop) {
        this.input = input;
        this.type = type;
        this.channel = channel;
        this.start = start;
        this.stop = stop;
    }

    this(const int type, immutable(char_t)[] text) {
        this.type = type;
        this.channel = DEFAULT_CHANNEL;
        this.text = text;
        this.use_text=true;
    }

    this(TokenT oldToken) {
        Text = oldToken.Text;
        type = oldToken.Type;
        line = oldToken.Line;
        index = oldToken.TokenIndex();
        charPositionInLine = oldToken.CharPositionInLine();
        channel = oldToken.Channel();
        if ( auto token=cast(CommonToken)(oldToken)) {
            start = token.start;
            stop = token.stop;
        }
    }

    public int Type() const {
        return type;
    }

    public int Line(const int line) {
        return (this.line = line);
    }

    @property
    public immutable(char_t)[] Text() const {
        if ( use_text ) {
            return text;
        }
        if ( input is null ) {
            return "";
        }
        return input.substring(start,stop);
    }

    /** Override the text for this token.  Text() will return this text
     *  rather than pulling from the buffer.  Note that this does not mean
     *  that start/stop indexes are not valid.  It means that that input
     *  was converted to a new string in the token object.
     */
    @property
    public void Text(immutable(char_t)[] text) {
        this.use_text=true;
        this.text = text;
    }

    public int Line() const {
        return line;
    }

    public int CharPositionInLine() const {
        return charPositionInLine;
    }

    public void CharPositionInLine(const int charPositionInLine) {
        this.charPositionInLine = charPositionInLine;
    }

    public int Channel() const {
        return channel;
    }

    public int Channel(const int channel) {
        return (this.channel = channel);
    }

    public int Type(const int type) {
        return (this.type = type);
    }

    public int StartIndex() {
        return start;
    }

    public void StartIndex(const int start) {
        this.start = start;
    }

    public int StopIndex() {
        return stop;
    }

    public void StopIndex(int stop) {
        this.stop = stop;
    }

    public int TokenIndex() const {
        return index;
    }

    public int TokenIndex(const int index) {
        return this.index = index;
    }

    public CharStreamT InputStream() {
        return input;
    }

    public void InputStream(CharStreamT input) {
        this.input = input;
    }

    public immutable(char_t)[] toStringT()  {
        immutable(char_t)[] channelStr;
        if ( channel>0 ) {
            channelStr=iFormatT(",channel={}",channel);
        }
        immutable(char_t)[] txt = Text();
        if ( txt.length>0 ) {
            txt = RegexT("\n").replaceAll(txt,"\\\\n").idup;
            txt = RegexT("\r").replaceAll(txt,"\\\\r").idup;
            txt = RegexT("\t").replaceAll(txt,"\\\\t").idup;
        }
        else {
            txt = "<no text>";
        }
        //	return
        //	"[@"+getTokenIndex()+","+start+":"+stop+"='"+txt+"',<"+type+">"+channelStr+","+line+":"+CharPositionInLine()+"]";
        return iFormatT("[@{},{}:{}='{}',<{}>{},{}:{}]",
            TokenIndex,start,stop,txt,type,channelStr,line,CharPositionInLine);
    }

}
