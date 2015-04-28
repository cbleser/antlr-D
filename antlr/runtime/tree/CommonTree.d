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
module antlr.runtime.tree.CommonTree;

import antlr.runtime.tree.Tree;
import antlr.runtime.tree.BaseTree;
import antlr.runtime.Token;
import antlr.runtime.CharStream;
import antlr.runtime.RuntimeException;

/** A tree node that is wrapper for a Token object.  After 3.0 release
 *  while building tree rewrite stuff, it became clear that computing
 *  parent and child index is very difficult and cumbersome.  Better to
 *  spend the space in every tree node.  If you don't want these extra
 *  fields, it's easy to cut them out in your own BaseTree subclass.
 */
class CommonTree(char_t) : BaseTree!(char_t) {
    alias CommonTree!(char_t) CommonTreeT;
    /** What token indexes bracket all tokens associated with this node
     *  and below?
     */
    protected int startIndex=-1, stopIndex=-1;

    /** Who is the parent node of this node; if null, implies node is root */
    public CommonTreeT parent;

    /** What index is this node in the child list? Range: 0..n-1 */
    public int childIndex = -1;

    this() {
        /* Empty */
    }

    this(CommonTreeT node) {
        //super(node);
        this.token = node.token;
        this.startIndex = node.startIndex;
        this.stopIndex = node.stopIndex;
    }

    this(TokenT t) {
        this.token = t;
    }

    public TokenT getToken() {
        return token;
    }

    public TreeT dupNode() {
        return new CommonTreeT(this);
    }

    override bool isNil() const {
        return token is null;
    }

    override int Type() const {
        if ( token is null ) {
            return TokenT.INVALID_TOKEN_TYPE;
        }
        return token.Type;
    }

    override int Type(const int type) {
        return token.Type(type);
    }

    @property
    immutable(char_t)[] Text() const {
        if ( token is null ) {
            return "";
        }
        return token.Text();
    }

    override int Line() const {
        if ( token is null || token.Line == 0 ) {
            if ( getChildCount()>0 ) {
                return getChild(0).Line();
            }
            return 0;
        }
        return token.Line;
    }

    override int CharPositionInLine() const {
        if ( token is null || token.CharPositionInLine()==-1 ) {
            if ( getChildCount()>0 ) {
                return getChild(0).CharPositionInLine();
            }
            return 0;
        }
        return token.CharPositionInLine();
    }

    public int TokenStartIndex() {
        if ( startIndex==-1 && token !is null ) {
            return token.TokenIndex();
        }
        return startIndex;
    }

    public int TokenStartIndex(int index) {
        return startIndex = index;
    }

    public int TokenStopIndex() {
        if ( stopIndex==-1 && token !is  null ) {
            return token.TokenIndex();
        }
        return stopIndex;
    }

    public int TokenStopIndex(int index) {
        return stopIndex = index;
    }

    override int getChildIndex() {
        return childIndex;
    }

    override TreeT getParent() {
        return parent;
    }

    override void setParent(TreeT t) {
        this.parent = cast(CommonTreeT)t;
    }

    override void setChildIndex(int index) {
        this.childIndex = index;
    }

    override immutable(char_t)[] toStringT() const {
        if ( isNil() ) {
            return "nil";
        }
        if ( Type()==TokenT.INVALID_TOKEN_TYPE ) {
            return "<errornode>";
        }
        if ( token is null ) {
            return "";
        }
        return token.Text();
    }

}
