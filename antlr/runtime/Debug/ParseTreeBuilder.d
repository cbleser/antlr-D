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
module antlr.runtime.Debug.ParseTreeBuilder;

import antlr.runtime.RecognitionException;
import antlr.runtime.Token;
import antlr.runtime.tree.ParseTree;
import antlr.runtime.tree.Tree;

import antlr.runtime.Debug.BlankDebugEventListener;
import tango.util.container.more.Stack;


//import java.util.Stack;

/** This parser listener tracks rule entry/exit and token matches
 *  to build a simple parse tree using ParseTree nodes.
 */
public abstract class ParseTreeBuilder(char_t) : BlankDebugEventListener!(char_t) {
  //	Stack callStack = new Stack();
  Stack!(ParseTree) callStack;

  public this(wchar[] grammarName) {
	ParseTree root = create("<grammar "~grammarName~">");
	callStack.push(root);
  }

  public ParseTree getTree() {
	//	return (ParseTree)callStack.elementAt(0);
	return callStack.top;
  }

  /**  What kind of node to create.  You might want to override
   *   so I factored out creation here.
   */
  public ParseTree create(wchar[] payload) {
	return new ParseTree(payload);
  }

  public ParseTree create(Token payload) {
	return new ParseTree(payload);
  }

  public ParseTree create(Exception payload) {
	return new ParseTree(payload);
  }


  public void enterRule(char[] filename, wchar[] ruleName) {
	ParseTree parentRuleNode = callStack.top;
	ParseTree ruleNode = create(ruleName);
	parentRuleNode.addChild(ruleNode);
	callStack.push(ruleNode);
  }

  public void exitRule(char[] filename, char[] ruleName) {
	callStack.pop();
  }

  public void consumeToken(Token token) {
	ParseTree ruleNode = callStack.top();
	ParseTree elementNode = create(token);
	ruleNode.addChild(elementNode);
  }

  public void recognitionException(RecognitionException e) {
	ParseTree ruleNode = callStack.top();
	ParseTree errorNode = create(e);
	ruleNode.addChild(errorNode);
  }
}
