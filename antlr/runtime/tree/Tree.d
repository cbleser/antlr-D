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
module antlr.runtime.tree.Tree;

//import antlr.runtime.tree.CommonTree;
//import antlr.runtime.Token;
import antlr.runtime.Token;


/** What does a tree look like?  ANTLR has a number of support classes
 *  such as CommonTreeNodeStream that work on these kinds of trees.  You
 *  don't have to make your trees implement this interface, but if you do,
 *  you'll be able to use more support code.
 *
 *  NOTE: When constructing trees, ANTLR can build any kind of tree; it can
 *  even use Token objects as trees if you add a child list to your tokens.
 *
 *  This is a tree node without any payload; just navigation and factory stuff.
 */
interface Tree(char_t) : Token!(char_t) {
  alias Tree!(char_t) TreeT;
  //	const CommonTree INVALID_NODE = new CommonTree(Token.INVALID_TOKEN);
  TreeT INVALID_NODE();
  TreeT getChild(int i);


  int getChildCount();

  // Tree tracks parent and child index now > 3.0

  public TreeT getParent();

  public void setParent(TreeT t);

  /** This node is what child index? 0..n-1 */
  public int getChildIndex();

  public void setChildIndex(int index);

  /** Set the parent and child index values for all children */
  public void freshenParentAndChildIndexes();

  /** Add t as a child to this node.  If t is null, do nothing.  If t
   *  is nil, add all children of t to this' children.
   */
  void addChild(TreeT t);

  /** Set ith child (0..n-1) to t; t must be non-null and non-nil node */
  public void setChild(int i, TreeT t);

  public TreeT deleteChild(int i);

  /** Delete children from start to stop and replace with t even if t is
   *  a list (nil-root tree).  num of children can increase or decrease.
   *  For huge child lists, inserting children can force walking rest of
   *  children to set their childindex; could be slow.
   */
  public void replaceChildren(int startChildIndex, int stopChildIndex, TreeT t);

  /** Indicates the node is a nil node but may still have children, meaning
   *  the tree is a flat list.
   */
  bool isNil();

  /**
	This function telles if the tree continues down award or has children
   */
  bool continues();

  /**  What is the smallest token index (indexing from 0) for this node
   *   and its children?
   */
  int TokenStartIndex();

  int TokenStartIndex(int index);

  /**  What is the largest token index (indexing from 0) for this node
   *   and its children?
   */
  int TokenStopIndex();

  int TokenStopIndex(int index);

  TreeT dupNode();

  /** In case we don't have a token payload, what is the line for errors? */
  int Line();

  int CharPositionInLine();

  int opApply(int delegate(ref size_t i, ref TreeT tree));

  immutable(char_t)[] toStringTree() const;

  override immutable(char_t)[] toStringT() const;

}
