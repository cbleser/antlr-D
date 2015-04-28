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
module antlr.runtime.Token;

import antlr.runtime.CharStream;
import antlr.runtime.CommonToken;

interface TokenElement {
    // This interface is used as a common for all Tokens

}

interface Token(char_t) : TokenElement {
    alias CharStream!(char_t) CharStreamT;
    alias Token!(char_t) TokenT;
  public:
    // this(int type, int channel=TokenT.DEFAULT_CHANNEL);
    // this(CharStreamT input, int type, int channel, int start, int stop);
    // this(TokenT oldToken);

    enum int EOR_TOKEN_TYPE = 1;

    /** imaginary tree navigation type; traverse "get child" link */
    enum int DOWN = 2;
    /** imaginary tree navigation type; finish with a child list */
    enum int UP = 3;

    enum int MIN_TOKEN_TYPE = UP+1;

    enum int EOF = CharStreamT.EOF;

    // D translation note
    // Token interface members EOF_TOKEN, INVALID_TOKEN and SKIP_TOKEN
    // is move to CommemToken class, because D interface can not hold
    // member contain memory data

    //  const CommonToken EOF_TOKEN = new CommonToken(EOF);
    //static Token EOF_TOKEN();
    enum int INVALID_TOKEN_TYPE = 0;
    // const CommonToken INVALID_TOKEN = new CommonToken(INVALID_TOKEN_TYPE);
    //static Token INVALID_TOKEN();
    /** In an action, a lexer rule can set token to this SKIP_TOKEN and ANTLR
     *  will avoid creating a token for this symbol and try to fetch another.
     */
    //	const CommonToken SKIP_TOKEN = new CommonToken(INVALID_TOKEN_TYPE);
    //static Token SKIP_TOKEN();
    /** All tokens go to the parser (unless skip() is called in that rule)
     *  on a particular "channel".  The parser tunes to a particular channel
     *  so that whitespace etc... can go to the parser on a "hidden" channel.
     */
    enum int DEFAULT_CHANNEL = 0;

    /** Anything on different channel than DEFAULT_CHANNEL is not parsed
     *  by parser.
     */
    enum int HIDDEN_CHANNEL = 99;

    /** Get the text of the token */
    /* This function is moved to BaseToken */
    @property
        public immutable(char_t)[] Text() const;

    @property
        public void Text(immutable(char_t)[] text);

    // public int getType();
    public int Type() const;
    // public void setType(int ttype);
    public int Type(const int ttype);
    /**  The line number on which this token was matched; line=1..n */
    // public int getLine();
    // public void setLine(int line);
    public int Line() const;
    public int Line(const int line);
    /** The index of the first character relative to the beginning of the line 0..n-1 */
    public int CharPositionInLine() const;
    public void CharPositionInLine(const int pos);

    public int Channel() const;
    public int Channel(const int channel);

    /** An index from 0..n-1 of the token object in the input stream.
     *  This must be valid in order to use the ANTLRWorks debugger.
     */
    public int TokenIndex() const;
    public int TokenIndex(const int index);

    /** From what character stream was this token created?  You don't have to
     *  implement but it's nice to know where a Token comes from if you have
     *  include files etc... on the input.
     */
    public CharStreamT InputStream();
    public void InputStream(CharStreamT input);
    //  public char opCast();
    public immutable(char_t)[] toStringT() ;

}
