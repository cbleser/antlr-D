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
module antlr.runtime.ClassicToken;

import antlr.runtime.Token;
import antlr.runtime.CharStream;
import antlr.runtime.tango.Format;
import tango.text.Regex;

/** A Token object like we'd use in ANTLR 2.x; has an actual string created
 *  and associated with this object.  These objects are needed for imaginary
 *  tree nodes that have payload objects.  We need to create a Token object
 *  that has a string; the tree node will point at this token.  CommonToken
 *  has indexes into a char stream and hence cannot be used to introduce
 *  new strings.
 */
public class ClassicToken(char_t) : Token {
	protected char_t[] text;
	protected int type;
	protected int line;
	protected int charPositionInLine;
	protected int channel=DEFAULT_CHANNEL;

	/** What token number is this from 0..n-1 tokens */
	protected int index;

	public this(int type) {
		this.type = type;
	}

	public this(Token oldToken) {
		text = oldToken.Text;
		type = oldToken.Type;
		line = oldToken.Line;
		charPositionInLine = oldToken.CharPositionInLine();
		channel = oldToken.Channel;
	}

	public this(int type, char_t[] text) {
		this.type = type;
		this.text = text;
	}

	public this(int type, char_t[] text, int channel) {
		this.type = type;
		this.text = text;
		this.channel = channel;
	}

	public int Type() {
		return type;
	}

	public int Line(int line) {
	  return (this.line = line);
	}

	public char_t[] Text() {
		return text;
	}

	public void Text(char_t[] text) {
		this.text = text;
	}

	public int Line() {
		return line;
	}

	public int CharPositionInLine() {
		return charPositionInLine;
	}

	public void CharPositionInLine(int charPositionInLine) {
		this.charPositionInLine = charPositionInLine;
	}

	public int Channel() {
		return channel;
	}

	public int Channel(int channel) {
	  return (this.channel = channel);
	}

	public int Type(int type) {
	  return (this.type = type);
	}

	public int TokenIndex() {
	  return index;
	}

	public int TokenIndex(int index) {
	  return this.index = index;
	}

	public CharStream InputStream() {
	  return null;
	}

	public void InputStream(CharStream input) {
	}
	
	public char_t[] toStringT() {
	  alias RegExpT!(char_t) RegexT;
	  char_t[] channelStr = "";
	  if ( channel>0 ) {
		channelStr=Format16(",channel={}"w,channel);
	  }
	  char_t[] txt = Text();
	  if ( txt.length == 0 ) {
		Regex16("\n"w).replaceAll(txt, r"\\n"w, txt);
		Regex16("\r"w).replaceAll(txt, r"\\r"w, txt);
		Regex16("\t"w).replaceAll(txt, r"\\t"w, txt);
// 			txt = txt.replaceAll("\n","\\\\n");
// 			txt = txt.replaceAll("\r","\\\\r");
// 			txt = txt.replaceAll("\t","\\\\t");
		}
		else {
			txt = "<no text>"w;
		}
		return Format16("[@{},'{}',<{}>{},{}:{}]",TokenIndex,txt,type,channelStr,line,CharPositionInLine);
		//+getTokenIndex()+",'"+txt+"',<"+type+">"+channelStr+","+line+":"+CharPositionInLine()+"]";
	}
}
