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
module antlr.runtime.Debug.DebugTreeAdaptor;

import antlr.runtime.Token;
import antlr.runtime.TokenStream;
import antlr.runtime.RecognitionException;
import antlr.runtime.tree.Tree;
import antlr.runtime.tree.TreeAdaptor;


//import antlr.runtime.BaseToken;

import antlr.runtime.Debug.DebugEventListener;

/** A TreeAdaptor proxy that fires debugging events to a DebugEventListener
 *  delegate and uses the TreeAdaptor delegate to do the actual work.  All
 *  AST events are triggered by this adaptor; no code gen changes are needed
 *  in generated rules.  Debugging events are triggered *after* invoking
 *  tree adaptor routines.
 *
 *  Trees created with actions in rewrite actions like "-> ^(ADD {foo} {bar})"
 *  cannot be tracked as they might not use the adaptor to create foo, bar.
 *  The debug listener has to deal with tree node IDs for which it did
 *  not see a createNode event.  A single <unknown> node is sufficient even
 *  if it represents a whole tree.
 */
public abstract class DebugTreeAdaptor(char_t) : TreeAdaptor!(char_t) {
  protected DebugEventListener dbg;
  protected TreeAdaptor adaptor;

  public this(DebugEventListener dbg, TreeAdaptor adaptor) {
	this.dbg = dbg;
	this.adaptor = adaptor;
  }

  public Tree create(Token payload) {
	if ( payload.TokenIndex() < 0 ) {
	  // could be token conjured up during error recovery
	  return create(payload.Type(), payload.Text());
	}
	auto node = adaptor.create(payload);
	dbg.createNode(node, payload);
	return node;
  }

  public Tree errorNode(TokenStream input, Token start, Token stop,
	  RecognitionException e)
  {
	auto node = adaptor.errorNode(input, start, stop, e);
	if ( node !is null ) {
	  dbg.errorNode(node);
	}
	return node;
  }

  public Tree dupTree(Tree tree) {
	auto t = adaptor.dupTree(tree);
	// walk the tree and emit create and add child events
	// to simulate what dupTree has done. dupTree does not call this debug
	// adapter so I must simulate.
	simulateTreeConstruction(t);
	return t;
  }

  /** ^(A B C): emit create A, create B, add child, ...*/
  protected void simulateTreeConstruction(Tree t) {
	dbg.createNode(t);
	int n = adaptor.getChildCount(t);
	for (int i=0; i<n; i++) {
	  auto child = adaptor.getChild(t, i);
	  simulateTreeConstruction(child);
	  dbg.addChild(t, child);
	}
  }

  public Tree dupNode(Tree treeNode) {
	Tree d = adaptor.dupNode(treeNode);
	dbg.createNode(d);
	return d;
  }

  public Tree nil() {
	auto node = adaptor.nil();
	dbg.nilNode(node);
	return node;
  }

  public bool isNil(Tree tree) {
	return adaptor.isNil(tree);
  }

  public void addChild(Tree t, Tree child) {
	if ( t is null || child is null ) {
	  return;
	}
	adaptor.addChild(t,child);
	dbg.addChild(t, child);
  }

  public Tree becomeRoot(Tree newRoot, Tree oldRoot) {
	Tree n = adaptor.becomeRoot(newRoot, oldRoot);
	dbg.becomeRoot(newRoot, oldRoot);
	return n;
  }

  public Tree rulePostProcessing(Tree root) {
	return adaptor.rulePostProcessing(root);
  }

  public void addChild(Tree t, Token child) {
	auto n = this.create(child);
	this.addChild(t, n);
  }

  public Tree becomeRoot(Token newRoot, Tree oldRoot) {
	Tree n = cast(Tree)this.create(newRoot);
	adaptor.becomeRoot(n, oldRoot);
	dbg.becomeRoot(n, oldRoot);
	return n;
  }

  public Token create(int tokenType, Token fromToken) {
	auto node = adaptor.create(tokenType, fromToken);
	dbg.createNode(node);
	return node;
  }

  public Token create(int tokenType, Token fromToken, wchar[] text) {
	auto node = adaptor.create(tokenType, fromToken, text);
	dbg.createNode(node);
	return node;
  }

  public Tree create(int tokenType, wchar[] text) {
	auto node = adaptor.create(tokenType, text);
	dbg.createNode(node);
	return node;
  }

  public int Type(Tree t) {
	return adaptor.Type(t);
  }

  public int Type(Tree t, int type) {
	return adaptor.Type(t, type);
  }

  public wchar[] Text(Tree t) {
	return adaptor.Text(t);
  }

  public void Text(Tree t, wchar[] text) {
	adaptor.Text(t, text);
  }

  public Token getToken(Tree t) {
	return adaptor.getToken(t);
  }

  public void setTokenBoundaries(Tree t, Token startToken, Token stopToken) {
	adaptor.setTokenBoundaries(t, startToken, stopToken);
	if ( t !is null && startToken !is null && stopToken !is null ) {
	  dbg.setTokenBoundaries(
		  t, startToken.TokenIndex(),
		  stopToken.TokenIndex());
	}
  }

  public int TokenStartIndex(Token t) {
	return adaptor.TokenStartIndex(t);
  }

  public int getTokenStopIndex(Token t) {
	return adaptor.TokenStopIndex(t);
  }

  public Tree getChild(Tree t, int i) {
	return adaptor.getChild(t, i);
  }

  public void setChild(Tree t, int i, Tree child) {
	adaptor.setChild(t, i, child);
  }

  public Tree deleteChild(Tree t, int i) {
	return deleteChild(t, i);
  }

  public int getChildCount(Tree t) {
	return adaptor.getChildCount(t);
  }

  public int getUniqueID(Tree node) {
	return adaptor.getUniqueID(node);
  }

  public Tree getParent(Tree t) {
	return adaptor.getParent(t);
  }

  public int getChildIndex(Tree t) {
	return adaptor.getChildIndex(t);
  }

  public void setParent(Tree t, Tree parent) {
	adaptor.setParent(t, parent);
  }

  public void setChildIndex(Tree t, int index) {
	adaptor.setChildIndex(t, index);
  }

  public void replaceChildren(Tree parent, int startChildIndex, int stopChildIndex, Tree t) {
	adaptor.replaceChildren(parent, startChildIndex, stopChildIndex, t);
  }

  // support

  public DebugEventListener getDebugListener() {
	return dbg;
  }

  public void setDebugListener(DebugEventListener dbg) {
	this.dbg = dbg;
  }

  public TreeAdaptor getTreeAdaptor() {
	return adaptor;
  }
}
