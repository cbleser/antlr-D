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
module antlr.runtime.TokenRewriteStream;

import antlr.runtime.CommonTokenStream;
import antlr.runtime.TokenSource;
import antlr.runtime.Token;
//import antlr.runtime.tango.Format;

import tango.util.container.SortedMap;

import tango.core.Array;

import tango.core.Exception;
import tango.core.RuntimeTraits;
import tango.io.Stdout;

import antlr.runtime.misc.Format;
import antlr.runtime.misc.MinMax;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.Debug.UnittestLexer;
import antlr.runtime.Debug.UnittestParser;

//import java.util.*;

/** Useful for dumping out the input stream after doing some
 *  augmentation or other manipulations.
 *
 *  You can insert stuff, replace, and delete chunks.  Note that the
 *  operations are done lazily--only if you convert the buffer to a
 *  String.  This is very efficient because you are not moving data around
 *  all the time.  As the buffer of tokens is converted to strings, the
 *  toString() method(s) check to see if there is an operation at the
 *  current index.  If so, the operation is done and then normal String
 *  rendering continues on the buffer.  This is like having multiple Turing
 *  machine instruction streams (programs) operating on a single input tape. :)
 *
 *  Since the operations are done lazily at toString-time, operations do not
 *  screw up the token index values.  That is, an insert operation at token
 *  index i does not change the index values for tokens i+1..n-1.
 *
 *  Because operations never actually alter the buffer, you may always get
 *  the original token stream back without undoing anything.  Since
 *  the instructions are queued up, you can easily simulate transactions and
 *  roll back any changes if there is an error just by removing instructions.
 *  For example,
 *
 *   CharStream input = new ANTLRFileStream("input");
 *   TLexer lex = new TLexer(input);
 *   TokenRewriteStream tokens = new TokenRewriteStream(lex);
 *   T parser = new T(tokens);
 *   parser.startRule();
 *
 * 	 Then in the rules, you can execute
 *      Token t,u;
 *      ...
 *      input.insertAfter(t, "text to put after t");}
 * 		input.insertAfter(u, "text after u");}
 * 		Stdout(tokens.toString16).nl;
 *
 *  Actually, you have to cast the 'input' to a TokenRewriteStream. :(
 *
 *  You can also have multiple "instruction streams" and get multiple
 *  rewrites from a single pass over the input.  Just name the instruction
 *  streams and use that name again when printing the buffer.  This could be
 *  useful for generating a C file and also its header file--all from the
 *  same buffer:
 *
 *      tokens.insertAfter("pass1", t, "text to put after t");}
 * 		tokens.insertAfter("pass2", u, "text after u");}
 * 		Stdout(tokens.toString16("pass1")).nl;
 * 		Stdout(tokens.toString16("pass2")).nl;
 *
 *  If you don't use named rewrite streams, a "default" stream is used as
 *  the first example shows.
 */

/* Changes from java
   1) delete function is renamed to remove because delete is a reserved
   word in D
*/


class TokenRewriteStream(char_t) : CommonTokenStream!(char_t) {
    public immutable char_t[] DEFAULT_PROGRAM_NAME = "default";
    public const int PROGRAM_INIT_SIZE = 100;
    public const int MIN_TOKEN_INDEX = 0;

    mixin iFormatT!(char_t);

    alias SortedMap!(Index,RewriteOperation) RewriteProgram;
    // Define the rewrite operation hierarchy

    struct Index {
        int index; // Repesents the token index in the stream
        int order;
        // Repesents the order in which the oprations is executed.
        // If order is negative the operation is executed before the token
        // index.
        // And if the order is positive the operation is executed after
        // the token with index
        static Index opCall(int index, int order) {
            Index result;
            result.index=index;
            result.order=order;
            return result;
        }
        bool opEquals(Index a) {
            return (index==a.index) && (order==a.order);
        }
        int opCmp(const Index a) {
            if ( index<a.index ) return -1;
            if ( index>a.index ) return 1;
            if ( order<a.order ) return -1;
            if ( order>a.order ) return 1;
            return 0;
        }
        const(char)[] toString() {
            return tango.text.convert.Format.Format("{}:{}",index,order);
        }
        static int compare(ref Index a, ref Index b) {
            return a.opCmp(b);
        }
    }

    static class RewriteOperation {
        protected Index pos;
        public int index() { return pos.index; }
        protected int index(int i) { return pos.index=i; }
        public int order() { return pos.order; }
        protected int order(int o) { return pos.order=o; }

        protected immutable(char_t)[] text;
        protected this(int index, immutable(char_t)[] text) {
            this.index = index;
            this.text = text;
            this.order=0;
        }
        /** Execute the rewrite operation by possibly adding to the buffer.
         *  Return the index of the next token to operate on.
         */
        public int execute(ref char_t[] buf) {
            return index;
        }
        public void join(RewriteProgram rewrite) {
            return; // Do nothing
        }
        public immutable(char_t)[] toStringT() {
            auto opName = asClass(realType(typeid(typeof(this)))).name;
            //  Stdout("Token.toString16").newline;
            //int _index = opName.indexOf('$');
            //opName = opName.substring(_index+1, opName.length());
            return iFormat("{}@{} \"{}\" ",opName,opName.length,text);
        }
    }

    static class InsertBeforeOp : RewriteOperation {
        public this(int index, immutable(char_t)[] text) {
            super(index,text);
        }
        override int execute(ref char_t[] buf) {
            buf~=text;
            return index;
        }
        override void join(RewriteProgram rewrite) {
            // Find op after absolute minimum order at index
            try {
                auto before=rewrite.nearbyKey(Index(index, order.min), true);
                // Decrease the order place this operation on leftmost side of
                // at this index
                if (before.index==index) {
                    order=(before.order<=0)?before.order-1:-1;
                    rewrite[pos]=this;
                } else {
                    order=-1;
                    rewrite[pos]=this;
                }
            } catch (NoSuchElementException e) {
                order=-1;
                rewrite[pos]=this;
            }
        }
    }


    static class InsertAfterOp : RewriteOperation {
        public this(int index, immutable(char_t)[] text) {
            super(index,text);
        }
        override int execute(ref char_t[] buf) {
            buf~=text;
            return index;
        }
        override void join(RewriteProgram rewrite) {
            try {
                // Find op after absolute maximum order at index
                auto after=rewrite.nearbyKey(Index(index, order.max), false);
                // Increase the order place this operation on leftmost side of
                // at this index
                if (after.index==index) {
                    order=(after.order>=0)?after.order+1:1;
                    rewrite[pos]=this;
                } else {
                    order=1;
                    rewrite[pos]=this;
                }
            } catch (NoSuchElementException e) {
                order=1;
                rewrite[pos]=this;
            }
        }
    }


    /** I'm going to try replacing range from x..y with (y-x)+1 ReplaceOp
     *  instructions.
     */
    static class ReplaceOp : RewriteOperation {
        protected int lastIndex;
        public this(int from, int to, immutable(char_t)[] text) {
            super(from,text);
            lastIndex = to;
        }
        override int execute(ref char_t[] buf) {
            //if ( text!=null ) {
            buf~=text;
            //}
            return lastIndex;
        }
        override void join(RewriteProgram rewrite) {
            RewriteOperation op;
            if (rewrite.get(pos,op)) {
                rewrite.replacePair(pos, op, this);
            } else {
                rewrite[pos]=this;
            }
        }
        override immutable(char_t)[] toStringT() {
            if (index==lastIndex) {
                return super.toStringT();
            } else {
                return iFormat("{} range {} to {}",
                    super.toStringT,index,lastIndex);
            }
        }
    }

    static class DeleteOp : ReplaceOp {
        public this(int from, int to) {
            super(from, to, null);
        }
    }

    // Unittest for Rewrite Operations
    // Added by cbr
    unittest {
        char_t[] buf;
        int index;
        auto op1=new InsertBeforeOp(10, "Test 1");
        auto op2=new InsertBeforeOp(15, "Test 2");
        auto i1=op1.execute(buf);
        auto i2=op2.execute(buf);

        assert(i1==10);
        assert(i2==15);
        assert(op1.index==i1);
        assert(op2.index==i2);
        assert(buf==op1.text~op2.text);

        auto op3=new ReplaceOp(22, 25, "Test 3");
        auto i3=op3.execute(buf);
        assert(i3==25);
        assert(i3==op3.lastIndex);
        assert(buf==op1.text~op2.text~op3.text);
        auto op4=new DeleteOp(30, 33);
        auto i4=op4.execute(buf);
        assert(i4==33);
        assert(i4==op4.lastIndex);
        assert(buf==op1.text~op2.text~op3.text);
    }

    /** You may have multiple, named streams of rewrite operations.
     *  I'm calling these things "programs."
     *  Maps String (name) -> rewrite (List)
     */
    protected RewriteProgram[char_t[]] programs;
    /** Map String (program name) -> Integer index */
    protected int lastRewriteTokenIndexes[char_t[]];

    public this() {
        init();
    }

    protected void init() {
        initializeProgram(DEFAULT_PROGRAM_NAME);
    }

    public this(TokenSourceT tokenSource) {
        super(tokenSource);
        init();
    }

    public this(TokenSourceT tokenSource, int channel) {
        super(tokenSource, channel);
        init();
    }

    public void rollback(int instructionIndex) {
        rollback(DEFAULT_PROGRAM_NAME, instructionIndex);
    }

    /** Rollback the instruction stream for a program so that
     *  the indicated instruction (via instructionIndex) is no
     *  longer in the stream.
     */
    public void rollback(immutable(char_t)[] programName, int instructionIndex) {
        if (programName in programs) {
            // Delete from instructionIndex and forward
            auto I=programs[programName].iterator(Index(instructionIndex,-1), true);
            foreach(index,op;I) {
                I.remove;
            }
        }
    }

    public void deleteProgram() {
        deleteProgram(DEFAULT_PROGRAM_NAME);
    }

    /** Reset the program so that no instructions exist */
    public void deleteProgram(immutable(char_t)[] programName) {
        rollback(programName, MIN_TOKEN_INDEX);
    }

    /** If op.index > lastRewriteTokenIndexes, just add to the end.
     *  Otherwise, do linear */
    protected void addToSortedRewriteList(RewriteOperation op) {
        addToSortedRewriteList(DEFAULT_PROGRAM_NAME, op);
    }


    /** Add an instruction to the rewrite instruction list ordered by
     *  the instruction number (use a binary search for efficiency).
     *  The list is ordered so that toString() can be done efficiently.
     *
     *  When there are multiple instructions at the same index, the instructions
     *  must be ordered to ensure proper behavior.  For example, a delete at
     *  index i must kill any replace operation at i.  Insert-before operations
     *  must come before any replace / delete instructions.  If there are
     *  multiple insert instructions for a single index, they are done in
     *  reverse insertion order so that "insert foo" then "insert bar" yields
     *  "foobar" in front rather than "barfoo".  This is convenient because
     *  I can insert new InsertOp instructions at the index returned by
     *  the binary search.  A ReplaceOp kills any previous replace op.  Since
     *  remove is the same as replace with null text, i can check for
     *  ReplaceOp and cover RemoveOp at same time. :)
     */

    protected void addToSortedRewriteList(immutable(char_t)[] programName, RewriteOperation op) {
        auto rewrites = getProgram(programName);
        //Stdout.format("### add {}; rewrites={}",op,rewrites).nl;
        /* Old java code
           Comparator comparator = new Comparator() {
           public int compare(Object o, Object o1) {
           RewriteOperation a = (RewriteOperation)o;
           RewriteOperation b = (RewriteOperation)o1;
           if ( a.index<b.index ) return -1;
           if ( a.index>b.index ) return 1;
           return 0;
           }
           };
        */
        // int pos = Collections.binarySearch(rewrites, op, comparator);
        //System.out.println("bin search returns: pos="+pos);

        // Find op in rewrites before or equal to op.index
        assert(rewrites !is null);
        op.join(rewrites);

    }

    public void insertAfter(TokenT t, immutable(char_t)[] text) {
        insertAfter(DEFAULT_PROGRAM_NAME, t, text);
    }

    public void insertAfter(int index, immutable(char_t)[] text) {
        insertAfter(DEFAULT_PROGRAM_NAME, index, text);
    }

    public void insertAfter(immutable(char_t)[] programName, TokenT t, immutable(char_t)[] text) {
        insertAfter(programName,t.TokenIndex(), text);
    }

    public void insertAfter(immutable(char_t)[] programName, int index, immutable(char_t)[] text) {
        addToSortedRewriteList(programName, new InsertAfterOp(index,text));
    }

    public void insertBefore(TokenT t, immutable(char_t)[] text) {
        insertBefore(DEFAULT_PROGRAM_NAME, t, text);
    }

    public void insertBefore(int index, immutable(char_t)[] text) {
        insertBefore(DEFAULT_PROGRAM_NAME, index, text);
    }

    public void insertBefore(immutable(char_t)[] programName, TokenT t, immutable(char_t)[] text) {
        insertBefore(programName,t.TokenIndex(), text);
    }

    public void insertBefore(immutable(char_t)[] programName, int index, immutable(char_t)[] text) {
        addToSortedRewriteList(programName, new InsertBeforeOp(index,text));
    }



    public void replace(int index, immutable(char_t)[] text) {
        replace(DEFAULT_PROGRAM_NAME, index, index, text);
    }

    public void replace(int from, int to, immutable(char_t)[] text) {
        replace(DEFAULT_PROGRAM_NAME, from, to, text);
    }

    public void replace(TokenT indexT, immutable(char_t)[] text) {
        replace(DEFAULT_PROGRAM_NAME, indexT, indexT, text);
    }

    public void replace(TokenT from, TokenT to, immutable(char_t)[] text) {
        replace(DEFAULT_PROGRAM_NAME, from, to, text);
    }

    public void replace(immutable(char_t)[] programName, int from, int to, immutable(char_t)[] text) {
        //	Stdout.format("replace {} [{}:{}] '{}'", programName, from, to, text).nl;
        if ( from > to || from<0 || to<0 ) {
            return;
        }
        addToSortedRewriteList(programName, new ReplaceOp(from, to, text));
        /*
        // replace from..to by deleting from..to-1 and then do a replace
        // on last index
        for (int i=from; i<to; i++) {
        addToSortedRewriteList(new DeleteOp(i,i));
        }
        addToSortedRewriteList(new ReplaceOp(to, to, text));
        */
    }

    public void replace(immutable(char_t)[] programName, const TokenT from, const TokenT to, immutable(char_t)[] text) {
        replace(programName,
            from.TokenIndex(),
            to.TokenIndex(),
            text);
    }

    public void remove(int index) {
        remove(DEFAULT_PROGRAM_NAME, index, index);
    }

    public void remove(int from, int to) {
        remove(DEFAULT_PROGRAM_NAME, from, to);
    }

    public void remove(const TokenT indexT) {
        remove(DEFAULT_PROGRAM_NAME, indexT, indexT);
    }

    public void remove(const TokenT from, const TokenT to) {
        remove(DEFAULT_PROGRAM_NAME, from, to);
    }

    public void remove(immutable(char_t)[] programName, int from, int to) {
        replace(programName,from,to,null);
    }

    public void remove(immutable(char_t)[] programName, const TokenT from, const TokenT to) {
        replace(programName,from,to,null);
    }

    public int getLastRewriteTokenIndex() {
        return getLastRewriteTokenIndex(DEFAULT_PROGRAM_NAME);
    }

    protected int getLastRewriteTokenIndex(immutable(char_t)[] programName) {
        if (programName in lastRewriteTokenIndexes) {
            return lastRewriteTokenIndexes[programName];
        } else {
            return -1;
        }
    }

    protected void setLastRewriteTokenIndex(immutable(char_t)[] programName, int i) {
        lastRewriteTokenIndexes[programName]=i;
    }

    protected RewriteProgram getProgram(immutable(char_t)[] name) {
        if (!(name in programs )) {
            return initializeProgram(name);
        }
        return programs[name];
    }

    private RewriteProgram initializeProgram(immutable(char_t)[] name) {
        return programs[name]=new RewriteProgram(&Index.compare);
    }

    public const(char_t)[] toOriginalString() {
        return toOriginalString(MIN_TOKEN_INDEX, size()-1);
    }

    public immutable(char_t)[] toOriginalString(int start, int end) {
        immutable(char_t)[] result;
        //	  Stdout.format("toOrigianlString start={} end={} tokens={}",start,end,tokens.length).newline;
        for (int i=start; i>=MIN_TOKEN_INDEX && i<=end && i<tokens.length; i++) {
            result~="<"~get(i).Text()~">";
        }
        return result;
    }

    public override immutable(char_t)[] toStringT() {
        return toStringT(MIN_TOKEN_INDEX, size()-1);
    }

    public immutable(char_t)[] toStringT(immutable(char_t)[] programName) {
        return toStringT(programName, MIN_TOKEN_INDEX, size()-1);
    }

    public override immutable(char_t)[] toStringT(int start, int end) {
        return toStringT(DEFAULT_PROGRAM_NAME, start, end);
    }

    public immutable(char_t)[] toStringT(immutable(char_t)[] programName, int start, int end) {
        // Stdout("TokenRewriteStream.toString16").newline;
        // Stdout.format("programName={} start={} end={} length={}",
        //     programName, start, end, tokens.length).newline;
        // 	//		if ( rewrites is null || rewrites.size()==0 ) {
        // Stdout.format("MIN_TOKEN_INDEX={}",MIN_TOKEN_INDEX).newline;
        if ( ! (programName in programs) ) {
            Stdout("No instruction to execute").newline;
            return toOriginalString(start,end); // no instructions to execute
        }
        auto rewrites=programs[programName];
        char_t[] buf;
        // Index of first rewrite
        auto rewriteIterator = rewrites.iterator(true);
        Index pos;
        RewriteOperation op;
        rewriteIterator.next(pos, op);

        for ( int tokenCursor=max(start,MIN_TOKEN_INDEX);
              tokenCursor<=end && tokenCursor<size();
              tokenCursor++
            )
        {
            //      Stdout.format("tokenCursor={}",tokenCursor).nl;
            // execute instructions associated with this token index
            // Stdout.format("tokenCursor={}",tokenCursor).newline;
            // skip all ops at lower index
            while (op !is null && op.index < tokenCursor) {
                if ( !rewriteIterator.next(pos, op) ) break;
            }
            // while we have ops for this token index, exec them
            while ( op !is null && tokenCursor==op.index && op.order < 0 ) {
                //System.out.println("execute "+op+" at instruction "+rewriteOpIndex);
                //	Stdout.format("execute {} at instruction {}:{}",op,op.index,op.order).newline;
                tokenCursor = op.execute(buf);
                //System.out.println("after execute tokenCursor =
                //"+tokenCursor);
                //	Stdout.format("after execute tokenCursor = {}",tokenCursor).newline;
                if ( !rewriteIterator.next(pos, op) ) break;
            }
            // dump the token at this index
            if ( op !is null && op.index == tokenCursor && op.order == 0 ) {
                tokenCursor = op.execute(buf);
                rewriteIterator.next(pos, op);
            } else if ( tokenCursor<=end ) {
                buf~=get(tokenCursor).Text();
            }
            // Skip all ops until after the tokenCursor
            while (op !is null && op.pos <= Index(tokenCursor,0)) {
                if ( !rewriteIterator.next(pos, op) ) break;
            }
            // Execute all ops after the token
            while ( op !is null && tokenCursor==op.index && op.order > 0) {
                //System.out.println("execute "+op+" at instruction "+rewriteOpIndex);
                //	Stdout.format("after execute {} at instruction {}:{}",op,op.index,op.order).newline;
                tokenCursor = op.execute(buf);
                //System.out.println("after execute tokenCursor =
                //"+tokenCursor);
                //	Stdout.format("after execute tokenCursor = {}",tokenCursor).newline;
                if ( !rewriteIterator.next(pos, op) ) break;
            }

        }
        // now see if there are operations (append) beyond last token
        // index
        while ( rewriteIterator.next(pos,op) ) {
            if ( op.index>=size() ) {
                op.execute(buf); // must be insertions if after last token
            }
        }
        return buf.idup;
    }

    public char_t[] toDebugString() {
        return toDebugString(MIN_TOKEN_INDEX, size()-1);
    }

    public char_t[] toDebugString(int start, int end) {
        char_t[] result;
        for (int i=start; i>=MIN_TOKEN_INDEX && i<=end && i<tokens.length; i++) {
            result~=get(i).Text();
        }
        return result;
    }

    public void dumpProgram() {
        dumpProgram(DEFAULT_PROGRAM_NAME);
    }

    public void dumpProgram(immutable(char_t)[] programName) {
        auto rewrites = getProgram(programName);
        if (rewrites !is null) {
            foreach(op;rewrites) {
                Stdout.format("{}:{} {}\n",op.index,op.order,op.toStringT);
            }
        }
    }

    unittest{
        auto input=new ANTLRStringStream!(char_t)("int foo 9 hugo");
        auto lexer=new UnittestLexer!(char_t)(input);
        auto stream=new TokenRewriteStream!(char_t)(lexer);
        auto parser=new UnittestParser!(char_t)(stream);
        immutable(char_t)[] program;
        parser.run;
        // Stdout("TokenRewriteStream test").nl;
        // Stdout(stream.toString16).nl;

        { 	// Replace test 1
            program="replace1";
            // Stdout(program).nl;
            stream.replace(program,2,2,"test");
            //stream.dumpProgram(program);
            //  Stdout(cast(char[])stream.toStringT(program)).nl;
            assert(stream.toStringT(program)=="int test 9 hugo");

        }
        { 	// Replace test 2
            // Double replace
            program="replace2";
            // Stdout(program).nl;
            stream.replace(program,2,2,"test");
            stream.replace(program,2,2,"test2");
            // stream.dumpProgram(program);
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="int test2 9 hugo");

        }
        { 	// Replace test 3
            // Triple replace
            program="replace2";
            stream.replace(program,2,2,"test");
            stream.replace(program,2,2,"test2");
            stream.replace(program,2,2,"test3");
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="int test3 9 hugo");
        }
        { 	// Replace test 3
            // Range replace
            // Stdout(program).nl;
            stream.replace(program,2,4,"testrange");
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="int testrange hugo");
        }
        { 	// Replace test 4
            // Range from first token index
            program="replace4";
            // Stdout(program).nl;
            stream.replace(program,0,2,"testrange");
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="testrange 9 hugo");
        }
        { 	// Replace test 5
            // Range from token index and beond the last token index
            program="replace5";
            // Stdout(program).nl;
            stream.replace(program,4,stream.index,"testrange");
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="int foo testrange");
        }
        { 	// Replace test 6
            // More than one replace
            program="replace6";
            // Stdout(program).nl;
            stream.replace(program,1,1,"<1>");
            stream.replace(program,5,5,"<2>");
            stream.replace(program,3,3,"<3>");
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="int<1>foo<3>9<2>hugo");
        }
        { 	// remove test 7
            program="remove7";
            // Stdout(program).nl;
            stream.remove(program,1,1);
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="intfoo 9 hugo");
        }
        { // remove test 8
            // remove range
            program="remove8";
            // Stdout(program).nl;
            stream.remove(program,1,3);
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="int9 hugo");
        }
        { // insert before test 9
            program="before9";
            // Stdout(program).nl;
            stream.insertBefore(program,1,"before");
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="intbefore foo 9 hugo");
        }
        { // insert before test 10
            program="before10";
            // Stdout(program).nl;
            stream.insertBefore(program,1,"before1");
            stream.insertBefore(program,3,"before2");
            stream.insertBefore(program,0,"before3");
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="before3intbefore1 foobefore2 9 hugo");
        }
        { // insert before test 11
            // Multiple insert at the same token index
            program="before11";
            // Stdout(program).nl;
            stream.insertBefore(program,2,"before1");
            stream.insertBefore(program,2,"before2");
            stream.insertBefore(program,2,"before3");
            stream.insertBefore(program,0,"before4");
            stream.insertBefore(program,0,"before5");
            stream.insertBefore(program,0,"before6");
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="before6before5before4int before3before2before1foo 9 hugo");
        }

        { // insert after test 12
            program="after12";
            // Stdout(program).nl;
            stream.insertAfter(program,2,"after");
            // stream.dumpProgram(program);
            //Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="int fooafter 9 hugo");
        }
        { // insert after test 13
            program="after13";
            // Stdout(program).nl;
            stream.insertAfter(program,1,"after1");
            stream.insertAfter(program,3,"after2");
            stream.insertAfter(program,0,"after3");
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="intafter3 after1foo after29 hugo");
        }
        { // insert after test 14
            // Multiple insert at the same token index
            program="after14";
            // Stdout(program).nl;
            stream.insertAfter(program,2,"after1");
            stream.insertAfter(program,2,"after2");
            stream.insertAfter(program,2,"after3");
            stream.insertAfter(program,0,"after4");
            stream.insertAfter(program,0,"after5");
            stream.insertAfter(program,0,"after6");
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="intafter4after5after6 fooafter1after2after3 9 hugo");
        }

        { // insert be-after test 15
            program="beftet15";
            // Stdout(program).nl;
            stream.insertAfter(program,2,"after1");
            stream.insertBefore(program,2,"before1");
            // Stdout(stream.toStringT(program)).nl;
            assert(stream.toStringT(program)=="int before1fooafter1 9 hugo");
        }

        { // all test 16
            program="all16";
            // Stdout(program).nl;
            stream.insertAfter(program,2,">a");
            stream.insertBefore(program,2,"b<");
            stream.insertBefore(program,2,"b(");
            stream.insertAfter(program,2,")a");
            stream.insertBefore(program,2,"b{");
            stream.insertAfter(program,2,"}a");
            // stream.dumpProgram(program);
            // Stdout(stream.toStringT(program)).nl;
            assert(stream.toStringT(program)=="int b{b(b<foo>a)a}a 9 hugo");
        }
        { // all test 17
            program="all17";
            // Stdout(program).nl;
            stream.insertAfter(program,2,">a");
            stream.insertBefore(program,2,"b<");
            stream.replace(program,2,2,"replace");
            stream.insertBefore(program,2,"b(");
            stream.insertAfter(program,2,")a");
            stream.insertBefore(program,2,"b{");
            stream.insertAfter(program,2,"}a");
            // stream.dumpProgram(program);
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="int b{b(b<replace>a)a}a 9 hugo");
        }
        { // all test 18
            program="all18";
            // Stdout(program).nl;
            stream.insertAfter(program,4,">a");
            stream.insertBefore(program,2,"b<");
            stream.replace(program,2,4,"replace");
            stream.insertBefore(program,2,"b(");
            stream.insertAfter(program,4,")a");
            stream.insertBefore(program,2,"b{");
            stream.insertAfter(program,4,"}a");
            // Following ops must be ignored
            stream.insertAfter(program,2,"]a");
            stream.insertAfter(program,3,"]a");
            stream.insertBefore(program,3,"b[");
            stream.insertBefore(program,4,"b[");
            stream.replace(program,3,3,"fail1");
            stream.replace(program,4,4,"fail2");
            // stream.dumpProgram(program);
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="int b{b(b<replace>a)a}a hugo");
        }
        { // rollback test 19
            program="rollback19";
            // Stdout(program).nl;
            stream.replace(program,0,0,"t0");
            stream.replace(program,2,2,"t2");
            stream.replace(program,4,4,"t4");
            stream.replace(program,6,6,"t6");
            // stream.dumpProgram(program);
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="t0 t2 t4 t6");
            stream.rollback(program, 4);
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="t0 t2 9 hugo");
            stream.rollback(program, 0);
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="int foo 9 hugo");
        }
        { // rollback test 20
            program="rollback20";
            // Stdout(program).nl;
            stream.insertBefore(program,0,"0{");
            stream.insertAfter(program,0,"}0");
            stream.insertBefore(program,2,"2{");
            stream.insertAfter(program,2,"}2");
            stream.insertBefore(program,4,"4{");
            stream.insertAfter(program,4,"}4");
            stream.insertBefore(program,6,"6{");
            stream.insertAfter(program,6,"}6");
            // stream.dumpProgram(program);
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="0{int}0 2{foo}2 4{9}4 6{hugo}6");
            stream.rollback(program, 4);
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="0{int}0 2{foo}2 9 hugo");
            stream.rollback(program, 0);
            // Stdout(stream.toString16(program)).nl;
            assert(stream.toStringT(program)=="int foo 9 hugo");
        }
    }
}
