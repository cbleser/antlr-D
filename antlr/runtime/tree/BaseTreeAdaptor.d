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
module antlr.runtime.tree.BaseTreeAdaptor;

import antlr.runtime.Token;
import antlr.runtime.TokenStream;
import antlr.runtime.RecognitionException;
import antlr.runtime.tree.TreeAdaptor;
import antlr.runtime.tree.Tree;
import antlr.runtime.tree.CommonErrorNode;
import antlr.runtime.RuntimeException;
import antlr.runtime.NoSuchMethodError;

import antlr.runtime.tango.Format;

//import java.util.HashMap;
//import java.util.Map;

/** A TreeAdaptor that works with any Tree implementation. */
public abstract class BaseTreeAdaptor(char_t,TreeT) : TreeAdaptor!(char_t) {
    alias CommonErrorNode!(char_t) CommonErrorNodeT;
    /** System.identityHashCode() is not always unique; we have to
     *  track ourselves.  That's ok, it's only for debugging, though it's
     *  expensive: we have to create a hashtable with all tree nodes in it.
     */
    protected int[TreeT] treeToUniqueIDMap;
    protected int uniqueNodeID = 1;

    override abstract TreeT create(TokenT payload);

    public TreeT nil() {
        return create(null);
    }

    /** create tree node that holds the start and stop tokens associated
     *  with an error.
     *
     *  If you specify your own kind of tree nodes, you will likely have to
     *  override this method. CommonTree returns Token.INVALID_TOKEN_TYPE
     *  if no token payload but you might have to set token type for diff
     *  node type.
     */
    public TreeT errorNode(TokenStreamT input, TokenT start, TokenT stop,
        RecognitionExceptionT e)
    {
        auto t = new CommonErrorNodeT(input, start, stop, e);
        return t;
    }

    public bool isNil(TreeT tree) {
        return tree.isNil();
    }

    public TreeT dupTree(TreeT tree) {
        return dupTree(tree, null);
    }

    /** This is generic in the sense that it will work with any kind of
     *  tree (not just Tree interface).  It invokes the adaptor routines
     *  not the tree node routines to do the construction.
     */
    public TreeT dupTree(TreeT t, TreeT parent) {
        if ( t is null ) {
            return null;
        }
        auto newTree = dupNode(t);
        // ensure new subtree root has parent/child index set
        setChildIndex(newTree, getChildIndex(t)); // same index in new tree
        setParent(newTree, parent);
        int n = getChildCount(t);
        for (int i = 0; i < n; i++) {
            auto child = getChild(t, i);
            auto newSubTree = dupTree(child, t);
            addChild(newTree, newSubTree);
        }
        return newTree;
    }

    /** Add a child to the tree t.  If child is a flat tree (a list), make all
     *  in list children of t.  Warning: if t has no children, but child does
     *  and child isNil then you can decide it is ok to move children to t via
     *  t.children = child.children; i.e., without copying the array.  Just
     *  make sure that this is consistent with have the user will build
     *  ASTs.
     */
    public void addChild(TreeT t, TreeT child) {
        if ( t !is null && child !is null ) {
            t.addChild(child);
        }
    }

    /** If oldRoot is a nil root, just copy or move the children to newRoot.
     *  If not a nil root, make oldRoot a child of newRoot.
     *
     *    old=^(nil a b c), new=r yields ^(r a b c)
     *    old=^(a b c), new=r yields ^(r ^(a b c))
     *
     *  If newRoot is a nil-rooted single child tree, use the single
     *  child as the new root node.
     *
     *    old=^(nil a b c), new=^(nil r) yields ^(r a b c)
     *    old=^(a b c), new=^(nil r) yields ^(r ^(a b c))
     *
     *  If oldRoot was null, it's ok, just return newRoot (even if isNil).
     *
     *    old=null, new=r yields r
     *    old=null, new=^(nil r) yields ^(nil r)
     *
     *  Return newRoot.  Throw an exception if newRoot is not a
     *  simple node or nil root with a single child node--it must be a root
     *  node.  If newRoot is ^(nil x) return x as newRoot.
     *
     *  Be advised that it's ok for newRoot to point at oldRoot's
     *  children; i.e., you don't have to copy the list.  We are
     *  constructing these nodes so we should have this control for
     *  efficiency.
     */
    public TreeT becomeRoot(TreeT newRoot, TreeT oldRoot) {
        auto newRootTree = newRoot;
        auto oldRootTree = oldRoot;
        if ( oldRoot is null ) {
            return newRoot;
        }
        assert(newRootTree !is null);
        // handle ^(nil real-node)
        if ( newRootTree.isNil() ) {
            if ( newRootTree.getChildCount()>1 ) {
                // TODO: make tree run time exceptions hierarchy
                throw new RuntimeException("more than one node as root (TODO: make exception hierarchy)");
            }
            newRootTree = newRootTree.getChild(0);
            assert(newRootTree !is null);
        }
        // add oldRoot to newRoot; addChild takes care of case where oldRoot
        // is a flat list (i.e., nil-rooted tree).  All children of oldRoot
        // are added to newRoot.
        assert(newRootTree !is null);
        newRootTree.addChild(oldRootTree);
        return newRootTree;
    }

    /** Transform ^(nil x) to x and nil to null */
    public TreeT rulePostProcessing(TreeT root) {
        //System.out.println("rulePostProcessing: "+((Tree)root).toStringTree());
        auto r = root;
        if ( r !is null && r.isNil() ) {
            if ( r.getChildCount()==0 ) {
                r = null;
            }
            else if ( r.getChildCount()==1 ) {
                r = r.getChild(0);
                // whoever invokes rule will set parent and child index
                r.setParent(null);
                r.setChildIndex(-1);
            }
        }
        return r;
    }

    public TreeT becomeRoot(TokenT newRoot, TreeT oldRoot) {
        return becomeRoot(create(newRoot), oldRoot);
    }

    override TokenT create(int tokenType, TokenT fromToken) {
        fromToken = createToken(fromToken);
        //((ClassicToken)fromToken).setType(tokenType);
        fromToken.Type=tokenType;
        auto t = create(fromToken);
        return t;
    }

    override TreeT create(int tokenType, TokenT fromToken, immutable(char_t)[] text) {
        if (fromToken is null) {
            /* Create a substitute token if the fromToken is not defined yet */
            fromToken=createToken(tokenType, text);
        } else {
            fromToken = createToken(fromToken);
            fromToken.Type=tokenType;
            fromToken.Text(text);
        }
        auto t = create(fromToken);
        return t;
    }

    public TreeT create(int tokenType, immutable(char_t)[] text) {
        auto fromToken = createToken(tokenType, text);
        auto t = create(fromToken);
        return t;
    }

    public int Type(TreeT t) {
        //	t.Type();
        return 0;
    }

    public int Type(TreeT t, int type) {
        throw new NoSuchMethodError("don't know enough about Tree node");
        return -1;
    }

    override immutable(char_t)[] Text(TreeT t) {
        return t.Text();
    }

    public void Text(TreeT t, immutable(char_t)[] text) {
        throw new NoSuchMethodError("don't know enough about Tree node");
    }

    public TreeT getChild(TreeT t, int i) {
        return t.getChild(i);
    }

    public void setChild(TreeT t, int i, TreeT child) {
        t.setChild(i, child);
    }

    public TreeT deleteChild(TreeT t, int i) {
        return t.deleteChild(i);
    }

    public int getChildCount(TreeT t) {
        return t.getChildCount();
    }

    public int getUniqueID(TreeT node) {
        // 		if ( treeToUniqueIDMap==null ) {
        // 		  treeToUniqueIDMap = new typeof(treeToUniqueIDMap);
        // 		}
        if (node in treeToUniqueIDMap) {
            int prevID=treeToUniqueIDMap[node];
            return prevID;
        }
        int ID = uniqueNodeID;
        treeToUniqueIDMap[node]=uniqueNodeID;
        uniqueNodeID++;
        return ID;
        // GC makes these nonunique:
        // return System.identityHashCode(node);
    }

    /** Tell me how to create a token for use with imaginary token nodes.
     *  For example, there is probably no input symbol associated with imaginary
     *  token DECL, but you need to create it as a payload or whatever for
     *  the DECL node as in ^(DECL type ID).
     *
     *  If you care what the token payload objects' type is, you should
     *  override this method and any other createToken variant.
     */
    public abstract TokenT createToken(int tokenType, immutable(char_t)[] text);

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
    public abstract TokenT createToken(TokenT fromToken);
}

