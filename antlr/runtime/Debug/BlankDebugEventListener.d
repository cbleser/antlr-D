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
module antlr.runtime.Debug.BlankDebugEventListener;

import antlr.runtime.RecognitionException;
import antlr.runtime.Token;
import antlr.runtime.tree.Tree;

import antlr.runtime.Debug.DebugEventListener;


/** A blank listener that does nothing; useful for real classes so
 *  they don't have to have lots of blank methods and are less
 *  sensitive to updates to debug interface.
 */

public abstract class BlankDebugEventListener(char_t) : DebugEventListener!(char_t) {
	public void enterRule(char[] grammarFileName, char_t[] ruleName) {}
	public void exitRule(char[] grammarFileName, char_t[] ruleName) {}
	public void enterAlt(int alt) {}
	public void enterSubRule(int decisionNumber) {}
	public void exitSubRule(int decisionNumber) {}
	public void enterDecision(int decisionNumber) {}
	public void exitDecision(int decisionNumber) {}
	public void location(int line, int pos) {}
	public void consumeToken(TokenT token) {;}
	public void consumeHiddenToken(TokenT token) {}
	public void LT(int i, TokenT t) {}
	public void mark(int i) {}
	public void rewind(int i) {}
	public void rewind() {}
	public void beginBacktrack(int level) {}
	public void endBacktrack(int level, bool successful) {}
	public void recognitionException(RecognitionException e) {}
	public void beginResync() {}
	public void endResync() {}
	public void semanticPredicate(bool result, char_t[] predicate) {;}
	public void commence() {}
	public void terminate() {}

	// Tree parsing stuff

	public void consumeNode(TreeT t) {}

	public void LT(int i, TreeT t) {}

	// AST Stuff

	public void nilNode(TreeT t) {}
	public void errorNode(TreeT t) {}
	public void createNode(TreeT t) {;}
	public void createNode(TreeT node, TokenT token) {;}
	public void becomeRoot(TreeT newRoot, TreeT oldRoot) {}
	public void addChild(TreeT root, TreeT child) {}
	public void setTokenBoundaries(TreeT t, int tokenStartIndex, int tokenStopIndex) {}
}


