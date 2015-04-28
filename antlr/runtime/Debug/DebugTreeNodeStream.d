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
module antlr.runtime.Debug.DebugTreeNodeStream;

import antlr.runtime.tree.TreeAdaptor;
import antlr.runtime.tree.TreeNodeStream;
import antlr.runtime.tree.Tree;
import antlr.runtime.TokenStream;
import antlr.runtime.IntStream;
import antlr.runtime.Debug.DebugEventListener;

/** Debug any tree node stream.  The constructor accepts the stream
 *  and a debug listener.  As node stream calls come in, debug events
 *  are triggered.
 */
public class DebugTreeNodeStream(char_t) : TreeNodeStream!(char_t) {
  protected DebugEventListener dbg;
  protected TreeAdaptor adaptor;
  protected TreeNodeStream input;
  protected bool initialStreamState = true;

  /** Track the last mark() call result value for use in rewind(). */
  protected int lastMarker;

  public this(TreeNodeStream input,
	  DebugEventListener dbg)
  {
	this.input = input;
	this.adaptor = input.getTreeAdaptor();
	this.input.setUniqueNavigationNodes(true);
	setDebugListener(dbg);
  }

  public void setDebugListener(DebugEventListener dbg) {
	this.dbg = dbg;
  }

  public TreeAdaptor getTreeAdaptor() {
	return adaptor;
  }

  public void consume() {
	auto node = input.LT(1);
	input.consume();
	dbg.consumeNode(node);
  }

  public Tree get(int i) {
	return input.get(i);
  }

  public Tree LT(int i) {
	auto node = input.LT(i);
	int ID = adaptor.getUniqueID(node);
	char_t[] text = adaptor.Text(node);
	int type = adaptor.Type(node);
	dbg.LT(i, node);
	return node;
  }

  public int LA(int i) {
	auto node = input.LT(i);
	int ID = adaptor.getUniqueID(node);
	char_t[] text = adaptor.Text(node);
	int type = adaptor.Type(node);
	dbg.LT(i, node);
	return type;
  }

  public int mark() {
	lastMarker = input.mark();
	dbg.mark(lastMarker);
	return lastMarker;
  }

  public int index() {
	return input.index();
  }

  public void rewind(int marker) {
	dbg.rewind(marker);
	input.rewind(marker);
  }

  public void rewind() {
	dbg.rewind();
	input.rewind(lastMarker);
  }

  public void release(int marker) {
  }

  public void seek(int index) {
	// TODO: implement seek in dbg interface
	// db.seek(index);
	input.seek(index);
  }

  public int size() {
	return input.size();
  }

	
  public Object getTreeSource() {
	return cast(Object)input;
  }

  public char[] getSourceName() {
	return getTokenStream().getSourceName();
  }

  public TokenStream getTokenStream() {
	return input.getTokenStream();
  }

  /** It is normally this object that instructs the node stream to
   *  create unique nav nodes, but to satisfy interface, we have to
   *  define it.  It might be better to ignore the parameter but
   *  there might be a use for it later, so I'll leave.
   */
  public void setUniqueNavigationNodes(bool uniqueNavigationNodes) {
	input.setUniqueNavigationNodes(uniqueNavigationNodes);
  }

  public void replaceChildren(Tree parent, int startChildIndex, int stopChildIndex, Tree t) {
	input.replaceChildren(parent, startChildIndex, stopChildIndex, t);
  }

  public char_t[] toStringT(Tree start, Tree stop) {
	return input.toStringT(start,stop);
  }
}
