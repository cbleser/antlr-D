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
module antlr.runtime.tree.CommonTreeNodeStream;

import antlr.runtime.Token;
import antlr.runtime.TokenStream;
import antlr.runtime.misc.IntArray;
import antlr.runtime.IntStream;
import antlr.runtime.RuntimeException;

import antlr.runtime.tree.TreeNodeStream;
import antlr.runtime.tree.TreeAdaptor;
import antlr.runtime.tree.Tree;
import antlr.runtime.tree.CommonTreeAdaptor;
import antlr.runtime.tree.CommonTree;

import antlr.runtime.tango.Format;

import tango.util.container.LinkedList;
import tango.text.Text;

import tango.io.Stdout;

/** A buffered stream of tree nodes.  Nodes can be from a tree of ANY kind.
 *
 *  This node stream sucks all nodes out of the tree specified in
 *  the constructor during construction and makes pointers into
 *  the tree using an array of Object pointers. The stream necessarily
 *  includes pointers to DOWN and UP and EOF nodes.
 *
 *  This stream knows how to mark/release for backtracking.
 *
 *  This stream is most suitable for tree interpreters that need to
 *  jump around a lot or for tree parsers requiring speed (at cost of memory).
 *  There is some duplicated functionality here with UnBufferedTreeNodeStream
 *  but just in bookkeeping, not tree walking etc...
 *
 *  @see UnBufferedTreeNodeStream
 */
public class CommonTreeNodeStream(char_t,CommonTreeT=CommonTree!(char_t)) : TreeNodeStream!(char_t) {
    public static final int DEFAULT_INITIAL_BUFFER_SIZE = 100;
    public static final int INITIAL_CALL_STACK_SIZE = 10;
    alias CommonTreeAdaptor!(char_t,CommonTreeT) CommonTreeAdaptorT;
    alias Token!(char_t) TokenT;
    // alias CommonTree!(char_t) CommonTreeT;

    protected class StreamIterator  {
        int i = 0;
        public bool hasNext() {
            return i<nodes.length;
        }

        public TreeT next() {
            int current = i;
            i++;
            if ( current < nodes.length ) {
                return nodes[current];
            }
            return eof;
        }

        public void remove() {
            throw new RuntimeException("cannot remove nodes from stream");
        }
    }

    // all these navigation nodes are shared and hence they
    // cannot contain any line/column info

    protected TreeT down;
    protected TreeT up;
    protected TreeT eof;

    /** The complete mapping from stream index to tree node.
     *  This buffer includes pointers to DOWN, UP, and EOF nodes.
     *  It is built upon ctor invocation.  The elements are type
     *  Object as we don't what the trees look like.
     *
     *  Load upon first need of the buffer so we can set token types
     *  of interest for reverseIndexing.  Slows us down a wee bit to
     *  do all of the if p==-1 testing everywhere though.
     */
    protected TreeT[] nodes;

    /** Pull nodes from which tree? */
    protected TreeT root;

    /** IF this tree (root) was created from a token stream, track it. */
    protected TokenStreamT tokens;

    /** What tree adaptor was used to build these trees */
    TreeAdaptorT adaptor;

    /** Reuse same DOWN, UP navigation nodes unless this is true */
    protected bool uniqueNavigationNodes = false;

    /** The index into the nodes list of the current node (next node
     *  to consume).  If -1, nodes array not filled yet.
     */
    protected int p = -1;

    /** Track the last mark() call result value for use in rewind(). */
    protected int lastMarker;

    /** Stack of indexes used for push/pop calls */
    protected IntArray calls;

    public this(TreeT tree) {
        this(new CommonTreeAdaptorT, tree);
    }

    // public this(TreeAdaptorT adaptor, TreeT tree) {
    // 	this(adaptor, tree, DEFAULT_INITIAL_BUFFER_SIZE);
    // }

    public this(TreeAdaptorT adaptor, TreeT tree) {
        this.root = tree;
        this.adaptor = adaptor;
        down = adaptor.create(TokenT.DOWN, "DOWN");
        up = adaptor.create(TokenT.UP, "UP");
        eof = adaptor.create(TokenT.EOF, "EOF");
    }

    /** Walk tree with depth-first-search and fill nodes buffer.
     *  Don't do DOWN, UP nodes if its a list (t is isNil).
     */
    protected void fillBuffer() {
        LinkedList!(TreeT) nodelist;

        /** As we flatten the tree, we use UP, DOWN nodes to represent
         *  the tree structure.  When debugging we need unique nodes
         *  so instantiate new ones when uniqueNavigationNodes is true.
         */
        void addNavigationNode(int ttype) {
            TreeT navNode;
            if ( ttype==TokenT.DOWN ) {
                if ( hasUniqueNavigationNodes() ) {
                    navNode = adaptor.create(TokenT.DOWN, "DOWN");
                }
                else {
                    navNode = down;
                }
            }
            else {
                if ( hasUniqueNavigationNodes() ) {
                    navNode = adaptor.create(TokenT.UP, "UP");
                }
                else {
                    navNode = up;
                }
            }
            nodelist.append(navNode);
        }
        void local_fillBuffer(TreeT t) {
            bool nil = adaptor.isNil(t);
            if ( !nil ) {
                nodelist.append(t); // add this node
            }
            // add DOWN node if t has children
            int n = adaptor.getChildCount(t);
            if ( !nil && n>0 ) {
                addNavigationNode(TokenT.DOWN);
            }
            // and now add all its children
            for (int c=0; c<n; c++) {
                auto child = adaptor.getChild(t,c);
                local_fillBuffer(child);
            }
            // add UP node if t has children
            if ( !nil && n>0 ) {
                addNavigationNode(TokenT.UP);
            }
        }

        nodelist=new LinkedList!(TreeT);
        local_fillBuffer(root);
        nodes=nodelist.toArray;
        p = 0; // buffer of nodes intialized now
    }


    /** What is the stream index for node? 0..n-1
     *  Return -1 if node not found.
     */
    protected int getNodeIndex(TreeT node) {
        if ( p==-1 ) {
            fillBuffer();
        }
        for (int i = 0; i < nodes.length; i++) {
            auto t = nodes[i];
            if ( t==node ) {
                return i;
            }
        }
        return -1;
    }

    public TreeT get(int i) {
        if ( p==-1 ) {
            fillBuffer();
        }
        return nodes[i];
    }

    public TreeT LT(int k) {
        if ( p==-1 ) {
            fillBuffer();
        }
        if ( k==0 ) {
            return null;
        }
        if ( k<0 ) {
            return LB(-k);
        }
        //System.out.print("LT(p="+p+","+k+")=");
        if ( (p+k-1) >= nodes.length ) {
            return eof;
        }
        return nodes[p+k-1];
    }

    public TreeT getCurrentSymbol() { return LT(1); }

    /*
      public Object getLastTreeNode() {
      int i = index();
      if ( i>=size() ) {
      i--; // if at EOF, have to start one back
      }
      System.out.println("start last node: "+i+" size=="+nodes.size());
      while ( i>=0 &&
      (adaptor.getType(get(i))==Token.EOF ||
      adaptor.getType(get(i))==Token.UP ||
      adaptor.getType(get(i))==Token.DOWN) )
      {
      i--;
      }
      System.out.println("stop at node: "+i+" "+nodes.get(i));
      return nodes.get(i);
      }
    */

    /** Look backwards k nodes */
    protected TreeT LB(int k) {
        if ( k==0 ) {
            return null;
        }
        if ( (p-k)<0 ) {
            return null;
        }
        return nodes[p-k];
    }

    public Object  getTreeSource() {
        return cast(Object)root;
    }

    override immutable(char)[] getSourceName() {
        return getTokenStream().getSourceName();
    }

    public TokenStreamT getTokenStream() {
        return tokens;
    }

    public void setTokenStream(TokenStreamT tokens) {
        this.tokens = tokens;
    }

    public TreeAdaptorT getTreeAdaptor() {
        return adaptor;
    }

    public void setTreeAdaptor(TreeAdaptorT adaptor) {
        this.adaptor = adaptor;
    }

    public bool hasUniqueNavigationNodes() {
        return uniqueNavigationNodes;
    }

    public void setUniqueNavigationNodes(bool uniqueNavigationNodes) {
        this.uniqueNavigationNodes = uniqueNavigationNodes;
    }

    public void consume() {
        if ( p==-1 ) {
            fillBuffer();
        }
        p++;
    }

    public int LA(int i) {
        return adaptor.Type(LT(i));
    }

    public int mark() {
        if ( p==-1 ) {
            fillBuffer();
        }
        lastMarker = index();
        return lastMarker;
    }

    public void release(int marker) {
        // no resources to release
    }

    public int index() {
        return p;
    }

    public void rewind(int marker) {
        seek(marker);
    }

    public void rewind() {
        seek(lastMarker);
    }

    public void seek(int index) {
        if ( p==-1 ) {
            fillBuffer();
        }
        p = index;
    }

    /** Make stream jump to a new location, saving old location.
     *  Switch back with pop().
     */
    public void push(int index) {
        if ( calls is null ) {
            calls = new IntArray();
        }
        calls.push(p); // save current index
        seek(index);
    }

    /** Seek back to previous index saved during last push() call.
     *  Return top of stack (return index).
     */
    public int pop() {
        int ret = calls.pop();
        seek(ret);
        return ret;
    }

    public void reset() {
        p = -1;
        lastMarker = 0;
        if (calls !is null) {
            calls.clear();
        }
    }

    public int size() {
        if ( p==-1 ) {
            fillBuffer();
        }
        return cast(int)nodes.length;
    }

    /* Implemeted as opApply in D
       public Iterator iterator() {
       if ( p==-1 ) {
       fillBuffer();
       }
       return new StreamIterator();
       }
    */

    // TREE REWRITE INTERFACE

    public void replaceChildren(TreeT parent, int startChildIndex, int stopChildIndex, TreeT t) {
        if ( parent !is null ) {
            adaptor.replaceChildren(parent, startChildIndex, stopChildIndex, t);
        }
    }

    /** Used for testing, just return the token type stream */
    public const(char_t)[] toStringT() {
        if ( p==-1 ) {
            fillBuffer();
        }
        auto buf = new Text!(char_t);
        for (int i = 0; i < nodes.length; i++) {
            auto t = nodes[i];
            buf.format(" {}", adaptor.Type(t));
        }
        return buf.selection;
    }

    /** Debugging */
    public const(char_t)[] toTokenString(int start, int stop) {
        if ( p==-1 ) {
            fillBuffer();
        }
        auto buf = new Text!(char_t);
        for (int i = start; i < nodes.length && i <= stop; i++) {
            auto t = nodes[i];
            buf.format(" {}", adaptor.getToken(t).Text);
        }
        return buf.selection;
    }

    override immutable(char_t)[] toStringT (TreeT start, TreeT stop) {
        if ( start is null || stop is null ) {
            return null;
        }
        if ( p==-1 ) {
            fillBuffer();
        }
        //System.out.println("stop: "+stop);
        if ( auto t = cast(CommonTreeT)start )
            Stdout.format("toString: {}, ",t.getToken.Text);
        else
            Stdout(start.toStringT);
        if ( auto t = cast(CommonTreeT)stop )
            Stdout(t.getToken.Text);
        else
            Stdout(stop.toStringT);
        // if we have the token stream, use that to dump text in order
        if ( tokens !is null ) {
            int beginTokenIndex = adaptor.TokenStartIndex(start);
            int endTokenIndex = adaptor.TokenStopIndex(stop);
            // if it's a tree, use start/stop index from start node
            // else use token range from start/stop nodes
            if ( adaptor.Type(stop)==TokenT.UP ) {
                endTokenIndex = adaptor.TokenStopIndex(start);
            }
            else if ( adaptor.Type(stop)==TokenT.EOF ) {
                endTokenIndex = size()-2; // don't use EOF
            }
            return tokens.toStringT(beginTokenIndex, endTokenIndex);
        }
        // walk nodes looking for start
        TreeT t;
        int i = 0;
        for (; i < nodes.length; i++) {
            t = nodes[i];
            if ( t==start ) {
                break;
            }
        }
        // now walk until we see stop, filling string buffer with text
        auto buf = new Text!(char_t);
        t = nodes[i];
        while ( t!=stop ) {
            auto text = adaptor.Text(t);
            if ( text.length == 0 ) {
                buf.format(" {}", adaptor.Type(t));
            } else {
                buf.append(text);
            }
            i++;
            t = nodes[i];
        }
        // include stop node too
        auto text = adaptor.Text(stop);
        if ( text.length == 0 ) {
            buf.format(" {}",adaptor.Type(stop));
        } else {
            buf.append(text);
        }
        return buf.selection.idup;
    }
}
