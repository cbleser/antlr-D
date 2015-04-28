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
module antlr.runtime.Debug.DebugTreeParser;

//import org.antlr.runtime.*;
import antlr.runtime.Debug.DebugEventListener;
import antlr.runtime.RecognizerSharedState;
import antlr.runtime.BitSet;
import antlr.runtime.RecognitionException;
import antlr.runtime.IntStream;
import antlr.runtime.Token;

import antlr.runtime.tree.TreeNodeStream;
import antlr.runtime.tree.TreeParser;
import antlr.runtime.tree.Tree;

import antlr.runtime.Debug.DebugTreeNodeStream;

import tango.core.Exception;
import tango.io.Stdout;

public class DebugTreeParser(char_t) : TreeParser!(char_t) {
  /** Who to notify when events in the parser occur. */
  protected DebugEventListener dbg = null;

  /** Used to differentiate between fixed lookahead and cyclic DFA decisions
   *  while profiling.
   */
  public bool isCyclicDecision = false;

  /** Create a normal parser except wrap the token stream in a debug
   *  proxy that fires consume events.
   */
  public this(TreeNodeStream input, DebugEventListener dbg, RecognizerSharedState state) {
	super(is(typeof(input) == DebugTreeNodeStream)?input:new DebugTreeNodeStream(input,dbg), state);
	setDebugListener(dbg);
  }

  public this(TreeNodeStream input, RecognizerSharedState state) {
	super(is(typeof(input) == DebugTreeNodeStream)?input:new DebugTreeNodeStream(input,null), state);
  }

  public this(TreeNodeStream input, DebugEventListener dbg) {
	this(is(typeof(input) == DebugTreeNodeStream)?input:new DebugTreeNodeStream(input,dbg), dbg, null);
  }

  /** Provide a new debug event listener for this parser.  Notify the
   *  input stream too that it should send events to this listener.
   */
  public void setDebugListener(DebugEventListener dbg) {
	if ( is(typeof(input) == DebugTreeNodeStream) ) {
	  (cast(DebugTreeNodeStream)input).setDebugListener(dbg);
	}
	this.dbg = dbg;
  }

  public DebugEventListener getDebugListener() {
	return dbg;
  }

  public void reportError(IOException e) {
	Stderr(e.msg).newline;
	//	System.err.println(e);
	//	e.printStackTrace(System.err);
  }

  public void reportError(RecognitionException e) {
	dbg.recognitionException(e);
  }

  protected Token getMissingSymbol(IntStream input,
	  RecognitionException e,
	  int expectedTokenType,
	  BitSet follow)
  {
	auto o = cast(Tree)super.getMissingSymbol(input, e, expectedTokenType, follow);
	assert(o !is null);
	dbg.consumeNode(o);
	return o;
  }

  public void beginResync() {
	dbg.beginResync();
  }

  public void endResync() {
	dbg.endResync();
  }

  public void beginBacktrack(int level) {
	dbg.beginBacktrack(level);
  }

  public void endBacktrack(int level, bool successful) {
	dbg.endBacktrack(level,successful);		
  }
}
