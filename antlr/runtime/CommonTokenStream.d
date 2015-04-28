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
  B
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
module antlr.runtime.CommonTokenStream;

import antlr.runtime.TokenStream;
import antlr.runtime.TokenSource;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.CharStream;


//import tango.util.container.LinkedList;
//import antlr.runtime.tango.Stack;
import tango.util.container.HashSet;
import tango.util.container.LinkedList;
import antlr.runtime.BitSet;
import tango.io.Stdout;

/** The most common stream of tokens is one where every token is buffered up
 *  and tokens are prefiltered for a certain channel (the parser will only
 *  see these tokens and cannot change the filter channel number during the
 *  parse).
 *
 *  TODO: how to access the full token stream?  How to track all tokens matched per rule?
 */
public class CommonTokenStream(char_t) : TokenStream!(char_t) {
    alias Token!(char_t) TokenT;
    alias TokenSource!(char_t) TokenSourceT;
    alias CharStream!(char_t) CharStreamT;
    alias CommonToken!(char_t) CommonTokenT;
    protected TokenSourceT tokenSource;

    /** Record every single token pulled from the source so we can reproduce
     *  chunks of it later.
     */
    protected TokenT[] tokens;

    /** Map<tokentype, channel> to override some Tokens' channel numbers */
    protected int[int] channelOverrideMap;

    /** Set<tokentype>; discard any tokens with this type */
    protected HashSet!(int) discardSet;

    /** Skip tokens on any channel but this one; this is how we skip whitespace... */
    protected int channel = TokenT.DEFAULT_CHANNEL;

    /** By default, track all incoming tokens */
    public bool discardOffChannelTokens = false;

    /** Track the last mark() call result value for use in rewind(). */
    protected int lastMarker;

    /** The index into the tokens list of the current token (next token
     *  to consume).  p==-1 indicates that the tokens list is empty
     */
    protected int p = -1;

    public this() {
        // tokens = new LinkedList!(Token);
        //	tokens.capacity=500;
    }

    public this(TokenSourceT tokenSource) {
        this();
        this.tokenSource = tokenSource;
    }

    public this(TokenSourceT tokenSource, int channel) {
        this(tokenSource);
        this.channel = channel;
    }

    /** Reset this token stream by setting its token source. */
    public void setTokenSource(TokenSourceT tokenSource) {
        this.tokenSource = tokenSource;
        tokens.length=0;
        p = -1;
        channel = TokenT.DEFAULT_CHANNEL;
    }

    /** Load all tokens from the token source and put in tokens.
     *  This is done upon first LT request because you might want to
     *  set some token type / channel overrides before filling buffer.
     */
    protected void fillBuffer() {
        int index = 0;
        auto t = tokenSource.nextToken();
        while ( t !is null && t.Type()!=CharStreamT.EOF ) {
            bool discard = false;
            // is there a channel override for token type?
            if ( channelOverrideMap.length ) {
                if (t.Type in channelOverrideMap) {
                    t.Channel(channelOverrideMap[t.Type()]);
                }
            }
            if ( discardSet !is null &&
                discardSet.contains(t.Type()) )
            {
                discard = true;
            }
            else if ( discardOffChannelTokens && t.Channel()!=this.channel ) {
                discard = true;
            }
            if ( !discard )	{
                t.TokenIndex(index);
                tokens~=t;
                index++;
            }
            t = tokenSource.nextToken();
        }
        // leave p pointing at first token on channel
        p = 0;
        p = skipOffTokenChannels(p);
    }

    /** Move the input pointer to the next incoming token.  The stream
     *  must become active with LT(1) available.  consume() simply
     *  moves the input pointer so that LT(1) points at the next
     *  input symbol. Consume at least one token.
     *
     *  Walk past any token not on the channel the parser is listening to.
     */
    public void consume() {
        if ( p<tokens.length ) {
            p++;
            p = skipOffTokenChannels(p); // leave p on valid token
        }
    }

    /** Given a starting index, return the index of the first on-channel
     *  token.
     */
    protected int skipOffTokenChannels(int i) {
        int n = cast(int)tokens.length;
        while ( i<n && (tokens[i].Channel()!=channel )) {
            i++;
        }
        return i;
    }

    protected int skipOffTokenChannelsReverse(int i) {
        while ( i>=0 && (tokens[i].Channel()!=channel )) {
            i--;
        }
        return i;
    }

    /** A simple filter mechanism whereby you can tell this token stream
     *  to force all tokens of type ttype to be on channel.  For example,
     *  when interpreting, we cannot exec actions so we need to tell
     *  the stream to force all WS and NEWLINE to be a different, ignored
     *  channel.
     */
    public void setTokenTypeChannel(int ttype, int channel) {
        /*
          if ( channelOverrideMap==null ) {
          channelOverrideMap = new HashMap();
          }
        */
        channelOverrideMap[ttype]=channel;
    }

    public void discardTokenType(int ttype) {
        if ( discardSet is null ) {
            discardSet = new HashSet!(int);
        }
        discardSet.add(ttype);
    }

    /*
      public void discardOffChannelTokens(bool discardOffChannelTokens_) {
      this.discardOffChannelTokens = discardOffChannelTokens_;
      }
    */
    public TokenT[] getTokens() {
        if ( p == -1 ) {
            fillBuffer();
        }
        return tokens;
    }

    public TokenT[] getTokens(int start, int stop) {
        BitSet bitset; bitset.length=0;
        return getTokens(start, stop, bitset);
    }

    /** Given a start and stop index, return a List of all tokens in
     *  the token type BitSet.  Return null if no tokens were found.  This
     *  method looks at both on and off channel tokens.
     */
    public TokenT[] getTokens(int start, int stop, BitSet types) {
        if ( p == -1 ) {
            fillBuffer();
        }
        if ( stop>=tokens.length ) {
            stop=cast(int)tokens.length-1;
        }
        if ( start<0 ) {
            start=0;
        }
        if ( start>stop ) {
            return null;
        }

        // list = tokens[start:stop]:{Token t, t.getType() in types}
        TokenT[] filteredTokens;
        for (int i=start; i<=stop; i++) {
            TokenT t = tokens[i];
            if ( types.length==0 || types[t.Type()] ) {
                filteredTokens~=t;
            }
        }
        /*
          if ( filteredTokens.size()==0 ) {
          filteredTokens = null;
          }
        */
        return filteredTokens;
    }

    public TokenT[] getTokens(int start, int stop, int[] types) {
        BitSet temp;
        foreach(t; types) {
            temp[t]=true;
        }
        return getTokens(start,stop,temp);
    }

    public TokenT[] getTokens(int start, int stop, int ttype) {
        BitSet temp;
        temp[ttype]=true;
        return getTokens(start,stop,temp);
    }

    /** Get the ith token from the current position 1..n where k=1 is the
     *  first symbol of lookahead.
     */
    public TokenT LT(int k) {
        if ( p == -1 ) {
            fillBuffer();
        }
        if ( k==0 ) {
            return null;
        }
        if ( k<0 ) {
            return LB(-k);
        }
        //System.out.print("LT(p="+p+","+k+")=");
        if ( (p+k-1) >= tokens.length ) {
            return CommonTokenT.EOF_TOKEN;
        }
        //System.out.println(tokens.get(p+k-1));
        int i = p;
        int n = 1;
        // find k good tokens
        while ( n<k ) {
            // skip off-channel tokens
            i = skipOffTokenChannels(i+1); // leave p on valid token
            n++;
        }
        if ( i>=tokens.length ) {
            return CommonTokenT.EOF_TOKEN;
        }
        return tokens[i];
    }

    /** Look backwards k tokens on-channel tokens */
    protected TokenT LB(int k) {
        //System.out.print("LB(p="+p+","+k+") ");
        if ( p == -1 ) {
            fillBuffer();
        }
        if ( k==0 ) {
            return null;
        }
        if ( (p-k)<0 ) {
            return null;
        }

        int i = p;
        int n = 1;
        // find k good tokens looking backwards
        while ( n<=k ) {
            // skip off-channel tokens
            i = skipOffTokenChannelsReverse(i-1); // leave p on valid token
            n++;
        }
        if ( i<0 ) {
            return null;
        }
        return tokens[i];
    }

    /** Return absolute token i; ignore which channel the tokens are on;
     *  that is, count all tokens not just on-channel tokens.
     */
    public TokenT get(int i) {
        return tokens[i];
    }

    public int LA(int i) {
        return LT(i).Type();
    }

    public int mark() {
        if ( p == -1 ) {
            fillBuffer();
        }
        lastMarker = index();
        return lastMarker;
    }

    public void release(int marker) {
        // no resources to release
    }

    public int size() {
        return cast(int)tokens.length;
    }

    public int index() {
        return p;
    }

    public void rewind(int marker) {
        seek(marker);
    }

    public void rewind() {
        seek(lastMarker);
    }

    public void reset() {
        p = -1;
        lastMarker = 0;
    }

    public void seek(int index) {
        p = index;
    }

    public TokenSourceT getTokenSource() {
        return tokenSource;
    }

    override immutable(char)[] getSourceName() {
        return getTokenSource().getSourceName();
    }

    public immutable(char_t)[] toStringT() {
        if ( p == -1 ) {
            fillBuffer();
        }
        return toStringT(0, cast(int)tokens.length-1);
    }

    public override immutable(char_t)[] toStringT(int start, int stop) {
        if ( start<0 || stop<0 ) {
            return null;
        }
        if ( p == -1 ) {
            fillBuffer();
        }
        if ( stop>=tokens.length ) {
            stop = cast(int)tokens.length-1;
        }
        //StringBuffer buf = new StringBuffer();
        immutable(char_t)[] buf;
        for (int i = start; i <= stop; i++) {
            auto t = tokens[i];
            //buf.append(t.getText());
            buf~=t.Text;
        }
        return buf;
    }

    public override immutable(char_t)[] toStringT(TokenT start, TokenT stop) {
        if ( start !is null && stop !is null ) {
            return toStringT(start.TokenIndex(), stop.TokenIndex());
        }
        return null;
    }


    unittest {
        /*
          The constructor of CommonTokenStream needs a token source. This
          is a simple mock class providing just the nextToken() method.
        */

        class MockSource : TokenSource!(char) {
            LinkedList!(Token!(char)) tokens;
            this() {
                //		 Stdout("new LinkedList!(Token);").newline;
                tokens=new LinkedList!(Token!(char));
            }
            Token!(char) nextToken() {
                // Stdout("tokens.size",tokens.size).newline;
                if (tokens.size > 0) {
                    return tokens.removeHead;
                } else {
                    return null;
                }
            }

            immutable(char)[] getSourceName() {
                return "Test_mock_source";
            }

            void append(Token!(char) token) {
                tokens.append(token);
            }
        }



        MockSource source;
        CommonTokenStream!(char) stream;
        Token!(char) lt1;
        int marker;

        // MockSource Test
        source = new MockSource;
        source.append(new CommonToken!(char)(1));
        source.append(new CommonToken!(char)(2));
        source.append(new CommonToken!(char)(3));

        assert(source.nextToken.Type==1);
        assert(source.nextToken.Type==2);
        assert(source.nextToken.Type==3);

        // Test Init
        source = new MockSource();
        stream = new CommonTokenStream!(char)(source);


        assert(stream.index == -1);

        // Test Set Token source
        source = new MockSource();

        stream = new CommonTokenStream!(char)();
        stream.setTokenSource(source);
        assert(stream.index == -1);
        assert(stream.channel == Token!(char).DEFAULT_CHANNEL);

        // Test LT empty source
        source = new MockSource();
        stream = new CommonTokenStream!(char)(source);

        lt1 = stream.LT(1);
        assert(lt1.Type == CharStream!(char).EOF);

        // Test LT1
        source = new MockSource();
        source.tokens.append(new CommonToken!(char)(12));

        stream = new CommonTokenStream!(char)(source);

        lt1 = stream.LT(1);
        assert(lt1.Type == 12);

        // Test LT1 with hidden
        source = new MockSource();
        source.tokens.append(new CommonToken!(char)(12,  Token!(char).HIDDEN_CHANNEL));
        source.tokens.append(new CommonToken!(char)(13));

        stream = new CommonTokenStream!(char)(source);

        lt1 = stream.LT(1);
        assert(lt1.Type == 13);

        // Type LT2 beyond end
        source = new MockSource();
        source.tokens.append(new CommonToken!(char)(12));
        source.tokens.append(new CommonToken!(char)(13, Token!(char).HIDDEN_CHANNEL));

        stream = new CommonTokenStream!(char)(source);

        lt1 = stream.LT(2);
        assert(lt1.Type == CharStream!(char).EOF);

        // Test LT negative
        source = new MockSource();
        source.tokens.append(new CommonToken!(char)(12));
        source.tokens.append(new CommonToken!(char)(13, Token!(char).HIDDEN_CHANNEL));

        stream = new CommonTokenStream!(char)(source);
        stream.fillBuffer();
        stream.consume();

        lt1 = stream.LT(-1);
        assert(lt1.Type == 12);

        // Test B1
        source = new MockSource();
        source.tokens.append(new CommonToken!(char)(12));
        source.tokens.append(new CommonToken!(char)(13));

        stream = new CommonTokenStream!(char)(source);
        stream.fillBuffer();
        stream.consume();

        assert(stream.LT(1).Type == 13);
        assert(stream.LT(-1).Type == 12);
        assert(stream.LT(2).Type == CharStream!(char).EOF);
        assert(stream.LB(1).Type == 12);


        // Test LT Zero
        source = new MockSource();
        source.tokens.append(new CommonToken!(char)(12));
        source.tokens.append(new CommonToken!(char)(13, Token!(char).HIDDEN_CHANNEL));

        stream = new CommonTokenStream!(char)(source);
        lt1 = stream.LT(0);
        assert(lt1 is null);

        // Test LB beyond begin
        source = new MockSource();
        source.tokens.append(new CommonToken!(char)(12));
        source.tokens.append(new CommonToken!(char)(12, Token!(char).HIDDEN_CHANNEL));
        source.tokens.append(new CommonToken!(char)(12, Token!(char).HIDDEN_CHANNEL));
        source.tokens.append(new CommonToken!(char)(13));

        stream = new CommonTokenStream!(char)(source);
        assert(stream.LB(1) is null);

        stream.consume();
        stream.consume();
        assert(stream.LB(3) is null);

        // Test FillBuffer
        source = new MockSource();
        source.tokens.append(new CommonToken!(char)(12));
        source.tokens.append(new CommonToken!(char)(13));
        source.tokens.append(new CommonToken!(char)(14));
        source.tokens.append(new CommonToken!(char)(CharStream!(char).EOF));

        stream = new CommonTokenStream!(char)(source);
        stream.fillBuffer();

        assert(stream.tokens.length == 3);
        assert(stream.tokens[0].Type == 12);
        assert(stream.tokens[1].Type == 13);
        assert(stream.tokens[2].Type == 14);


        // Test Consume
        source = new MockSource();
        source.tokens.append(new CommonToken!(char)(12));
        source.tokens.append(new CommonToken!(char)(13));
        //     source.tokens.append(new CommonToken(14));
        source.tokens.append(new CommonToken!(char)(CharStream!(char).EOF));

        stream = new CommonTokenStream!(char)(source);
        assert(stream.LA(1) == 12);

        stream.consume();
        assert(stream.LA(1) == 13);

        stream.consume();
        assert(stream.LA(1) == CharStream!(char).EOF);

        stream.consume();
        assert(stream.LA(1) == CharStream!(char).EOF);

        // Test Seek
        source = new MockSource();
        source.tokens.append(new CommonToken!(char)(12));
        source.tokens.append(new CommonToken!(char)(13));
        source.tokens.append(new CommonToken!(char)(CharStream!(char).EOF));

        stream = new CommonTokenStream!(char)(source);
        assert(stream.LA(1) == 12);

        stream.seek(2);
        assert(stream.LA(1) == CharStream!(char).EOF);

        stream.seek(0);
        assert(stream.LA(1) == 12);

        // Test Mark rewind
        source = new MockSource();
        source.tokens.append(new CommonToken!(char)(12));
        source.tokens.append(new CommonToken!(char)(13));
        source.tokens.append(new CommonToken!(char)(CharStream!(char).EOF));

        stream = new CommonTokenStream!(char)(source);
        stream.fillBuffer();

        stream.consume();
        marker = stream.mark();

        stream.consume();
        stream.rewind(marker);

        assert(stream.LA(1) == 13);

        // Test toString
        source = new MockSource();
        source.tokens.append(new CommonToken!(char)(12, "foo"));
        source.tokens.append(new CommonToken!(char)(13, "bar"));
        source.tokens.append(new CommonToken!(char)(14, "gnurz"));
        source.tokens.append(new CommonToken!(char)(14, "blarz"));

        stream = new CommonTokenStream!(char)(source);
        assert(stream.toStringT == "foobargnurzblarz");
        assert(stream.toStringT(1, 2) == "bargnurz");
        assert(stream.toStringT(stream.tokens[1], stream.tokens[2]) == "bargnurz");
    }

}
