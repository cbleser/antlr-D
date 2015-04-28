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
module antlr.runtime.tree.BaseTree;

import antlr.runtime.tree.Tree;
import antlr.runtime.tree.CommonTree;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;
import antlr.runtime.IllegalStateException;
import antlr.runtime.CharStream;

import tango.util.container.LinkedList;
import antlr.runtime.misc.Format;

import tango.core.Exception;

import tango.io.Stdout;
//import java.util.ArrayList;
//import java.util.List;

/** A generic tree implementation with no payload.  You must subclass to
 *  actually have any user data.  ANTLR v3 uses a list of children approach
 *  instead of the child-sibling approach in v2.  A flat tree (a list) is
 *  an empty node whose children represent the list.  An empty, but
 *  non-null node is called "nil".
 */
abstract class BaseTree(char_t) : Tree!(char_t) {
    alias Tree!(char_t) TreeT;
    alias BaseTree!(char_t) BaseTreeT;
    alias CommonTree!(char_t) CommonTreeT;
    alias CommonToken!(char_t) CommonTokenT;
    /** A single token is the payload */
    public TokenT token;
    protected TreeT[] children;
    private static TreeT invalid_node;
    /*
      static this() {
      invalid_node=new CommonTree(Token.INVALID_TOKEN);
      }
    */
    public TreeT INVALID_NODE() {
        if (invalid_node is null) invalid_node=cast(TreeT)new CommonTreeT(CommonTokenT.INVALID_TOKEN);
        return invalid_node;
    }

    /** Create a new node from an existing node does nothing for BaseTree
     *  as there are no fields other than the children list, which cannot
     *  be copied as the children are not considered part of this node.
     */

    public const TreeT getChild(int i) const {
        if ( children.length==0 || i>=children.length ) {
            return null;
        }
        return cast(TreeT)children[i];
    }


    public TreeT getChild(int i) {
        if ( children.length==0 || i>=children.length ) {
            return null;
        }
        return children[i];
    }

    /** Get the children internal List; note that if you directly mess with
     *  the list, do so at your own risk.
     */
    public const(TreeT)[] getChildren() {
        return children;
    }

    public TreeT getFirstChildWithType(int type) {
        foreach(t ; children) {
        // for (int i = 0; i < children.length; i++) {
        //     auto t = children[i];
            if ( t.Type==type ) {
                return t;
            }
        }
        return null;
    }

    public int getChildCount() const {
        return cast(int)children.length;
    }

    /** Add t as child of this node.
     *
     *  Warning: if t has no children, but child does
     *  and child isNil then this routine moves children to t via
     *  t.children = child.children; i.e., without copying the array.
     */
    public void addChild(TreeT t) {
        //System.out.println("add child "+t.toStringTree()+" "+this.toStringTree());
        //System.out.println("existing children: "+children);
        if ( t is null ) {
            return; // do nothing upon addChild(null)
        }
        auto childTree = cast(BaseTreeT)t;
        assert(childTree !is null);
        if ( childTree.isNil() ) { // t is an empty node possibly with children
            if ( this.children !is null && this.children is childTree.children ) {
                throw new IllegalElementException("attempt to add child list to itself");
            }
            // just add all of childTree's children to this
            if ( childTree.children.length >0 ) {
                if ( children.length > 0 ) { // must copy, this has children already
                    int n = cast(int)childTree.children.length;
                    for (int i = 0; i < n; i++) {
                        auto c = childTree.children[i];
                        children~=c;
                        // handle double-link stuff for each child of nil root
                        c.setParent(this);
                        c.setChildIndex(cast(int)children.length-1);
                    }
                }
                else {
                    // no children for this but t has children; just set pointer
                    // call general freshener routine
                    this.children = childTree.children;
                    this.freshenParentAndChildIndexes();
                }
            }
        }
        else { // child is not nil (don't care about children)
            /*
              if ( children.length >0 ) {
              children = createChildrenList(); // create children list on demand
              }
            */

            children~=t;
            childTree.setParent(this);
            childTree.setChildIndex(cast(int)children.length-1);
        }
        // System.out.println("now children are: "+children);
        //	Stdout.format("now children are: {}", children).nl;
    }

    /** Add all elements of kids list as children of this node */
    public void addChildren(LinkedList!(TreeT) kids) {
        foreach(t;kids) {
            addChild(t);
        }
    }

    public void setChild(int i, TreeT t) {
        if ( t is null ) {
            return;
        }
        if ( t.isNil() ) {
            throw new IllegalArgumentException("Can't set single child to a list");
        }
        /*
          if ( children.length > 0) {
          children = createChildrenList();
          }
        */
        children[i]= t;
        t.setParent(this);
        t.setChildIndex(i);
    }

    public TreeT deleteChild(int i) {
        if ( children.length > 0) {
            return null;
        }
        auto killed = children[i];
        children=children[0..i-1]~children[i..children.length];
        //        children.removeAt(i);
        // walk rest and decrement their child indexes
        this.freshenParentAndChildIndexes(i);
        return killed;
    }

    /** Delete children from start to stop and replace with t even if t is
     *  a list (nil-root tree).  num of children can increase or decrease.
     *  For huge child lists, inserting children can force walking rest of
     *  children to set their childindex; could be slow.
     */
    public void replaceChildren(int startChildIndex, int stopChildIndex, TreeT t) {
        /*
          System.out.println("replaceChildren "+startChildIndex+", "+stopChildIndex+
          " with "+((BaseTree)t).toStringTree());
          System.out.println("in="+toStringTree());
        */
        if ( children is null ) {
            throw new IllegalArgumentException("indexes invalid; no children in list");
        }
        int replacingHowMany = stopChildIndex - startChildIndex + 1;
        int replacingWithHowMany;
        auto newTree = cast(BaseTreeT)t;
        TreeT[] newChildren;
        // normalize to a list of children to add: newChildren
        if ( newTree.isNil() ) {
            newChildren = newTree.children;
        }
        else {
            //	newChildren = new LinkedList!(Tree);
            newChildren~=newTree;
        }
        replacingWithHowMany = cast(int)newChildren.length;
        auto numNewChildren = cast(int)newChildren.length;
        auto delta = replacingHowMany - replacingWithHowMany;
        // if same number of nodes, do direct replace
        if ( delta == 0 ) {
            int j = 0; // index into new children
            for (int i=startChildIndex; i<=stopChildIndex; i++) {
                auto child = newChildren[j];
                children[i]=child;
                child.setParent(this);
                child.setChildIndex(i);
                j++;
            }
        }
        else if ( delta > 0 ) { // fewer new nodes than there were
            // set children and then delete extra
            for (int j=0; j<numNewChildren; j++) {
                children[startChildIndex+j]=newChildren[j];
            }
            int indexToDelete = cast(int)startChildIndex+numNewChildren;
            for (int c=indexToDelete; c<=stopChildIndex; c++) {
                // delete same index, shifting everybody down each time
                auto killed = children[indexToDelete];
                children=children[0..indexToDelete-1]~children[indexToDelete..children.length];
                //  children.removeAt(indexToDelete);
            }
            freshenParentAndChildIndexes(startChildIndex);
        }
        else { // more new nodes than were there before
            // fill in as many children as we can (replacingHowMany) w/o moving data
            for (int j=0; j<replacingHowMany; j++) {
                children[startChildIndex+j]=newChildren[j];
            }
            int numToInsert = replacingWithHowMany-replacingHowMany;
            for (int j=replacingHowMany; j<replacingWithHowMany; j++) {
                children[startChildIndex+j]=newChildren[j];
            }
            freshenParentAndChildIndexes(startChildIndex);
        }
        //System.out.println("out="+toStringTree());
    }

    /** Override in a subclass to change the impl of children list */
    /*
      protected LinkedList!(Tree) createChildrenList() {
      return new LinkedList!(Tree);
      }
    */

    public bool isNil() const{
        return false;
    }

    public bool continues() {
        return (token.Type==TokenT.DOWN)||(getChildCount>0);
    }

    /** Set the parent and child index values for all child of t */
    public void freshenParentAndChildIndexes() {
        freshenParentAndChildIndexes(0);
    }

    public void freshenParentAndChildIndexes(int offset) {
        int n = getChildCount();
        for (int c = offset; c < n; c++) {
            auto child = cast(TreeT)getChild(c);
            child.setChildIndex(c);
            child.setParent(this);
        }
    }

    public void sanityCheckParentAndChildIndexes() {
        sanityCheckParentAndChildIndexes(null, -1);
    }

    public void sanityCheckParentAndChildIndexes(TreeT parent, int i) {
        if ( parent!=this.getParent() ) {
            throw new IllegalStateException(iFormat8("parents don't match; expected {} found {}]",parent,getParent));
        }
        if ( i!=this.getChildIndex() ) {
            throw new IllegalStateException(iFormat8("child indexes don't match; expected {} found {}",i,getChildIndex));
        }
        int n = this.getChildCount();
        for (int c = 0; c < n; c++) {
            BaseTree child = cast(BaseTree)getChild(c);
            child.sanityCheckParentAndChildIndexes(this, c);
        }
    }

    /** BaseTree doesn't track child indexes. */
    public int getChildIndex() {
        return 0;
    }
    public void setChildIndex(int index) {
    }

    /** BaseTree doesn't track parent pointers. */
    public TreeT getParent() {
        return null;
    }
    public void setParent(TreeT t) {
    }

    /** Print out a whole tree not just a node */
    override immutable(char_t)[] toStringTree() const {
        if ( children.length==0 ) {
            return this.toStringT;
        }
        //StringBuffer buf = new StringBuffer();
        immutable(char_t)[] buf;
        if ( !isNil() ) {
            buf="("~toStringT~" ";
            /*
              buf.append("(");
              buf.append(this.toString());
              buf.append(' ');
            */
        }
        for (int i = 0; i < children.length; i++) {
            auto t = cast(BaseTreeT) children[i];
            if ( i>0 ) {
                buf~=' ';
            }
            buf~=t.toStringTree();
        }
        if ( !isNil() ) {
            buf~=")";
        }
        return buf;
    }

    public int Line() {
        return 0;
    }

    public int CharPositionInLine() const {
        return 0;
    }

    /** Override to say how a node (not a tree) should look as text */
    public abstract immutable(char_t)[] toStringT() const;

    // Added functions for compatibilty with Token interface
    public void Text(immutable(char_t)[] text) {
        token.Text(text);
    }

    public int Type() const {
        return token.Type;
    }

    public int Type(const int ttype) {
        return token.Type(ttype);
    }

    public int Line(const int line) {
        return token.Line(line);
    }

    public void CharPositionInLine(const int pos) {
        token.CharPositionInLine(pos);
    }

    public int Channel() const {
        return token.Channel;
    }

    public int Channel(const int channel) {
        return token.Channel(channel);
    }

    public int TokenIndex() const {
        return token.TokenIndex;
    }

    public int TokenIndex(const int index) {
        return token.TokenIndex(index);
    }

    public CharStreamT InputStream() {
        return token.InputStream;
    }

    public void InputStream(CharStreamT input) {
        token.InputStream(input);
    }

    public int opApply(int delegate(ref size_t i, ref Tree!(char_t) tree) dg) {
        int result;
        foreach(i,tree;children) {
            if ( (result = dg(i,tree)) != 0 ) {
                break;
            }
        }
        return result;
    }

    public int opApply(int delegate(ref Tree!(char_t) tree) dg) {
        int result;
        foreach(tree;children) {
            if ( (result = dg(tree) ) != 0 ) {
                break;
            }
        }
        return result;
    }

}
