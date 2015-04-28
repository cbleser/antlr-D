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
module antlr.runtime.tree.TreeParser;

//import org.antlr.runtime.*;
import antlr.runtime.BaseRecognizer;
import antlr.runtime.RecognizerSharedState;
import antlr.runtime.RecognitionException;
import antlr.runtime.Token;
import antlr.runtime.IntStream;
import antlr.runtime.BitSet;
import antlr.runtime.CommonToken;

import antlr.runtime.MismatchedTreeNodeException;

import antlr.runtime.tree.TreeNodeStream;
import antlr.runtime.tree.CommonTree;
import antlr.runtime.tree.Tree;
import antlr.runtime.tree.TreeAdaptor;
import antlr.runtime.tree.TreeRuleReturnScope;

import antlr.runtime.misc.Format;

/** A parser for a stream of tree nodes.  "tree grammars" result in a subclass
 *  of this.  All the error reporting and recovery is shared with Parser via
 *  the BaseRecognizer superclass.
 */
public class TreeParser(char_t) : BaseRecognizer!(char_t) {
    public static final int DOWN = TokenT.DOWN;
    public static final int UP = TokenT.UP;
    public static const BitSet EmptyBitSet;
    alias TreeNodeStream!(char_t) TreeNodeStreamT;
    alias TreeRuleReturnScope!(char_t) TreeRuleReturnScopeT;
    alias CommonToken!(char_t) CommonTokenT;
    alias CommonTree!(char_t) CommonTreeT;

    mixin iFormatT!(char_t);

    protected TreeNodeStreamT input;

    // private static this() {
    //     EmptyBitSet=[];
    // }

    public this(TreeNodeStreamT input) {
        super(); // highlight that we go to super to set state object
        setTreeNodeStream(input);
    }

    public this(TreeNodeStreamT input, RecognizerSharedStateT state) {
        super(state); // share the state object with another parser
        setTreeNodeStream(input);
    }

    override void reset() {
        super.reset(); // reset all recognizer state variables
        if ( input !is null ) {
            input.seek(0); // rewind the input
        }
    }
    //deprecated void setTokenStream(TokenStreamT input);

    /** Set the input stream */
    public void setTreeNodeStream(TreeNodeStreamT input) {
        this.input = input;
    }

    public TreeNodeStreamT getTreeNodeStream() {
        return input;
    }

    override immutable(char)[] getSourceName() {
        return input.getSourceName();
    }

    protected override TokenT getCurrentInputSymbol(IntStream input) {
        //	return cast(Token)((cast(TreeNodeStream)input).LT(1));
        return ((cast(TreeNodeStreamT)input).LT(1));
    }

    override TokenT getMissingSymbol(IntStream input,
        RecognitionExceptionT e,
        int expectedTokenType,
        const BitSet follow)
    {
        auto tokenText = iFormat("<missing {}>",getTokenNames()[expectedTokenType]);
        return new CommonTreeT(new CommonTokenT(expectedTokenType, tokenText));
    }

    /** Match '.' in tree parser has special meaning.  Skip node or
     *  entire tree if node has children.  If children, scan until
     *  corresponding UP node.
     */
    override void matchAny(IntStream ignore) { // ignore stream, copy of input
        state.errorRecovery = false;
        state.failed = false;
        auto look = input.LT(1);
        if ( input.getTreeAdaptor().getChildCount(look)==0 ) {
            input.consume(); // not subtree, consume 1 node and return
            return;
        }
        // current node is a subtree, skip to corresponding UP.
        // must count nesting level to get right UP
        int level=0;
        int tokenType = input.getTreeAdaptor().Type(look);
        while ( tokenType!=TokenT.EOF && !(tokenType==UP && level==0) ) {
            input.consume();
            look = input.LT(1);
            tokenType = input.getTreeAdaptor().Type(look);
            if ( tokenType == DOWN ) {
                level++;
            }
            else if ( tokenType == UP ) {
                level--;
            }
        }
        input.consume(); // consume UP
    }

    /** We have DOWN/UP nodes in the stream that have no line info; override.
     *  plus we want to alter the exception type.  Don't try to recover
     *  from tree parser errors inline...
     */
    protected override void mismatch(IntStream input, int ttype, BitSet follow)
        //		throws RecognitionException
    {
        throw new MismatchedTreeNodeExceptionT(ttype, cast(TreeNodeStreamT)input);
    }

    /** Prefix error message with the grammar name because message is
     *  always intended for the programmer because the parser built
     *  the input tree not the user.
     */
    override immutable(char)[] getErrorHeader(RecognitionExceptionT e) {
        return iFormat8(
            "{}: node from {} line {}:{}",
            getGrammarFileName(),
            (e.approximateLineInfo?"after ":""),
            e.line, e.charPositionInLine
            );
        // 		return getGrammarFileName()~": node from "~
        // 			   (e.approximateLineInfo?"after ":"")~"line "~e.line~":"~e.charPositionInLine;
    }

    /** Tree parsers parse nodes they usually have a token object as
     *  payload. Set the exception token and do the default behavior.
     */
    override immutable(char)[] getErrorMessage(RecognitionExceptionT e, immutable(char_t)[][] tokenNames) {
        if ( is(typeof(this) == TreeParser) ) {
            auto adaptor = (cast(TreeNodeStreamT)e.input).getTreeAdaptor();
            e.token = adaptor.getToken(e.node);
            if ( e.token is null ) { // could be an UP/DOWN node
                e.token = new CommonTokenT(adaptor.Type(e.node),
                    adaptor.Text(e.node));
            }
        }
        return super.getErrorMessage(e, tokenNames);
    }

    public void traceIn(immutable(char)[] ruleName, int ruleIndex)  {
        super.traceIn(ruleName, ruleIndex, input.LT(1));
    }

    public void traceOut(immutable(char)[] ruleName, int ruleIndex)  {
        super.traceOut(ruleName, ruleIndex, input.LT(1));
    }

}
