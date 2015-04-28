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
module antlr.runtime.tree.ParseTree;

import antlr.runtime.Token;
import antlr.runtime.CommonToken;
import antlr.runtime.tree.BaseTree;
import antlr.runtime.tree.Tree;
import tango.core.Exception;

public class string(char_t) {
  public char_t[] text;
  this(char_t[] value) {
	text=value;
  }
  char[] toString() {
    return cast(char[])text;
  }
  char_t[] toStringT() {
    return text;
  }
}


/** A record of the rules used to match a token sequence.  The tokens
 *  end up as the leaves of this tree and rule nodes are the interior nodes.
 *  This really adds no functionality, it is just an alias for CommonTree
 *  that is more meaningful (specific) and holds a String to display for a node.
 */
public class ParseTree(char_t) : BaseTree {
  Object payload;

  public this(Token label) {
	this.payload = cast(Object)label;
  }

  public this(char_t[] label) {
	this.payload = new string(label);
  }

  public this(Exception label) {
	this.payload = label;
  }

  public Tree dupNode() {
	return null;
  }

  public int Type() {
	return 0;
  }

  public char_t[] Text() {
	return toString16();
  }

  public int TokenStartIndex() {
	return 0;
  }

  public int TokenStartIndex(int index) {
	return 0;
  }

  public int TokenStopIndex() {
	return 0;
  }

  public int TokenStopIndex(int index) {
	return 0;
  }

  public char_t[] toStringT() {
	if ( auto t=cast(Token)payload ) {
	  if ( t.Type() == Token.EOF ) {
		return "<EOF>";
	  }
	  return t.Text();
	}
	else if (auto str=cast(string)payload ) 
	{
	  return str.toStringT();
	}
	return cast(char_t[])payload.toString();
  }
}
