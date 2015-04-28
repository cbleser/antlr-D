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
module antlr.runtime.Debug.TraceDebugEventListener;

import antlr.runtime.Token;
import antlr.runtime.tree.TreeAdaptor;
import antlr.runtime.tree.Tree;
import tango.io.Stdout;

import antlr.runtime.Debug.BlankDebugEventListener;

/** Print out (most of) the events... Useful for debugging, testing... */
public abstract class TraceDebugEventListener(char_t) : BlankDebugEventListener!(char_t) {
  TreeAdaptor adaptor;

  public this(TreeAdaptor adaptor) {
	this.adaptor = adaptor;
  }

  public void enterRule(wchar[] ruleName) { Stdout("enterRule ")(ruleName).newline; }
  public void exitRule(wchar[] ruleName) { Stdout("exitRule ")(ruleName).newline; }
  public void enterSubRule(int decisionNumber) { Stdout("enterSubRule").newline; }
  public void exitSubRule(int decisionNumber) { Stdout("exitSubRule").newline; }
  public void location(int line, int pos) {Stdout("location ")(line)(":")(pos).newline;}

  // Tree parsing stuff

  public void consumeNode(Tree t) {
	int ID = adaptor.getUniqueID(t);
	wchar[] text = adaptor.Text(t);
	int type = adaptor.Type(t);
	Stdout("consumeNode ")(ID)(" ")(text)(" ")(type).newline;
  }

  public void LT(int i, Tree t) {
	int ID = adaptor.getUniqueID(t);
	wchar[] text = adaptor.Text(t);
	int type = adaptor.Type(t);
	Stdout("LT ")(i)(" ")(ID)(" ")(text)(" ")(type);
  }


  // AST stuff
  public void nilNode(Tree t) {Stdout("nilNode ")(adaptor.getUniqueID(t)).newline;}

  public void createNode(Tree t) {
	int ID = adaptor.getUniqueID(t);
	wchar[] text = adaptor.Text(t);
	int type = adaptor.Type(t);
	Stdout("create ")(ID)(": ")(text)(", ")(type).newline;
  }

  public void createNode(Tree node, Token token) {
	int ID = adaptor.getUniqueID(node);
	wchar[] text = adaptor.Text(node);
	int tokenIndex = token.TokenIndex();
	Stdout("create ")(ID)(": ")(tokenIndex).newline;
  }

  public void becomeRoot(Tree newRoot, Tree oldRoot) {
	Stdout("becomeRoot ")(adaptor.getUniqueID(newRoot))(", ")(
		adaptor.getUniqueID(oldRoot)).newline;
  }

  public void addChild(Tree root, Tree child) {
	Stdout("addChild ")(adaptor.getUniqueID(root))(", ")(
		adaptor.getUniqueID(child)).newline;
  }

  public void setTokenBoundaries(Tree t, int tokenStartIndex, int tokenStopIndex) {
	Stdout("setTokenBoundaries ")(adaptor.getUniqueID(t))(", ")(
		tokenStartIndex)(", ")(tokenStopIndex).newline;
  }
}

