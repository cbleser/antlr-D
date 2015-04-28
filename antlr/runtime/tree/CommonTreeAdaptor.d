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
module antlr.runtime.tree.CommonTreeAdaptor;

import antlr.runtime.CommonToken;
import antlr.runtime.Token;
import antlr.runtime.tree.BaseTreeAdaptor;
import antlr.runtime.tree.TreeAdaptor;
import antlr.runtime.tree.Tree;
import antlr.runtime.tree.CommonTree;

/** A TreeAdaptor that works with any Tree implementation.  It provides
 *  really just factory methods; all the work is done by BaseTreeAdaptor.
 *  If you would like to have different tokens created than ClassicToken
 *  objects, you need to override this and then set the parser tree adaptor to
 *  use your subclass.
 *
 *  To get your parser to build nodes of a different type, override
 *  create(Token).
 */
public class CommonTreeAdaptor(char_t, TreeC=CommonTree!(char_t)) : BaseTreeAdaptor!(char_t,TreeC) {
    static if (!is(TreeC : Tree!(char_t))) {
        pragma(msg, "TreeC must implement ",typeid(Tree!(char_t)));
    }
    static if (is(TreeC== Tree!(char_t))) {
        alias CommonTree!(char_t) CommonTreeT;
    } else {
        alias TreeC CommonTreeT;
    }
    alias CommonToken!(char_t) CommonTokenT;

    /** Duplicate a node.  This is part of the factory;
     *	override if you want another kind of node to be built.
     *
     *  I could use reflection to prevent having to override this
     *  but reflection is slow.
     */
    public TreeT dupNode(TreeT t) {
        if ( t is null ) {
            return null;
        }
        return t.dupNode();
    }

    override TreeT create(TokenT payload) {
        return new CommonTreeT(payload);
    }

    /** Tell me how to create a token for use with imaginary token nodes.
     *  For example, there is probably no input symbol associated with imaginary
     *  token DECL, but you need to create it as a payload or whatever for
     *  the DECL node as in ^(DECL type ID).
     *
     *  If you care what the token payload objects' type is, you should
     *  override this method and any other createToken variant.
     */
    override TokenT createToken(int tokenType, immutable(char_t)[] text) {
        return new CommonTokenT(tokenType, text);
    }

    /** Tell me how to create a token for use with imaginary token nodes.
     *  For example, there is probably no input symbol associated with imaginary
     *  token DECL, but you need to create it as a payload or whatever for
     *  the DECL node as in ^(DECL type ID).
     *
     *  This is a variant of createToken where the new token is derived from
     *  an actual real input token.  Typically this is for converting '{'
     *  tokens to BLOCK etc...  You'll see
     *
     *    r : lc='{' ID+ '}' -> ^(BLOCK[$lc] ID+) ;
     *
     *  If you care what the token payload objects' type is, you should
     *  override this method and any other createToken variant.
     */
    override TokenT createToken(TokenT fromToken) {
        return new CommonTokenT(fromToken);
    }

    /** Track start/stop token for subtree root created for a rule.
     *  Only works with Tree nodes.  For rules that match nothing,
     *  seems like this will yield start=i and stop=i-1 in a nil node.
     *  Might be useful info so I'll not force to be i..i.
     */
    public void setTokenBoundaries(TreeT t, TokenT startToken, TokenT stopToken) {
        if ( t is null ) {
            return;
        }
        int start = 0;
        int stop = 0;
        if ( startToken !is null ) {
            start = startToken.TokenIndex();
        }
        if ( stopToken !is null ) {
            stop = stopToken.TokenIndex();
        }
        t.TokenStartIndex(start);
        t.TokenStopIndex(stop);
    }

    public int TokenStartIndex(TokenT t) {
        auto tree=cast(TreeT)t;
        if ( tree is null ) {
            return -1;
        }
        return tree.TokenStartIndex();
    }

    public int TokenStopIndex(TokenT t) {
        auto tree=cast(TreeT)t;
        if ( tree is null ) {
            return -1;
        }
        return tree.TokenStopIndex();
    }

    override immutable(char_t)[] Text(TreeT t) {
        if ( t is null ) {
            return null;
        }
        return t.Text();
    }

    override int Type(TreeT t) {
        if ( t is null ) {
            return TokenT.INVALID_TOKEN_TYPE;
        }
        return t.Type();
    }

    /** What is the Token associated with this node?  If
     *  you are not using CommonTree, then you must
     *  override this in your own adaptor.
     */
    public TokenT getToken(TreeT t) {
        if ( auto result = cast(CommonTreeT)t ) {
            return result.getToken();
        }
        return null; // no idea what to do
    }

    override TreeT getChild(TreeT t, int i) {
        if ( t is null ) {
            return null;
        }
        return t.getChild(i);
    }

    override int getChildCount(TreeT t) {
        if ( t is null ) {
            return 0;
        }
        return t.getChildCount();
    }

    public bool continues(TreeT t) {
        if ( t is null ) {
            return false;
        }
        return t.continues();
    }

    public TreeT getParent(TreeT t) {
        return t.getParent();
    }

    public void setParent(TreeT t, TreeT parent) {
        t.setParent(parent);
    }

    public int getChildIndex(TreeT t) {
        return t.getChildIndex();
    }

    public void setChildIndex(TreeT t, int index) {
        t.setChildIndex(index);
    }

    public void replaceChildren(TreeT parent, int startChildIndex, int stopChildIndex, TreeT t) {
        if ( parent !is null ) {
            parent.replaceChildren(startChildIndex, stopChildIndex, t);
        }
    }

}
