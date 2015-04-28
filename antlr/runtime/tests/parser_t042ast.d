module antlr.runtime.tests.parser_t042ast;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.ANTLRFileStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.MismatchedRangeException;
import antlr.runtime.NoViableAltException;
import antlr.runtime.RecognitionException;
import antlr.runtime.CommonTokenStream;
import antlr.runtime.RuntimeException;
import antlr.runtime.tree.RewriteEmptyStreamException;
import antlr.runtime.tree.RewriteEarlyExitException;
import tango.io.Stdout;

import antlr.runtime.tests.t042astLexer;

import antlr.runtime.tests.t042astParser;

 
template main_test(char_t) {
  void main_test() {
    t042astLexer!(char_t) lexer;
    t042astParser!(char_t) parser;

    { // Valid test 1
      auto input=new ANTLRStringStream!(char_t)("1 + 2");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r1;
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(+ 1 2)");
    }  

    { // Valid test 2a
      auto input=new ANTLRStringStream!(char_t)("assert 2+3;");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r2;
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(assert (+ 2 3))");
    }  

    { // Valid test 2b
      auto input=new ANTLRStringStream!(char_t)("assert 2+3 : 5;");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r2;
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(assert (+ 2 3) 5)");
    }  

    { // Valid test 3a
      auto input=new ANTLRStringStream!(char_t)("if 1 fooze");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r3;
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(if 1 fooze)");
    }  

    { // Valid test 3b
      auto input=new ANTLRStringStream!(char_t)("if 1 fooze else fooze");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r3;
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(if 1 fooze fooze)");
    }  

    { // Valid test 4a
      auto input=new ANTLRStringStream!(char_t)("while 2 fooze");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r4;
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(while 2 fooze)");
    }  

    { // Valid test 5a
      auto input=new ANTLRStringStream!(char_t)("return;");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r5;
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="return");
    }  

    { // Valid test 5b
      auto input=new ANTLRStringStream!(char_t)("return 2+3;");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r5;
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(return (+ 2 3))");
    }  

    { // Valid test 6a
      auto input=new ANTLRStringStream!(char_t)("3");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r6;
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="3");
    }  

    { // Valid test 6b
      auto input=new ANTLRStringStream!(char_t)("3 a");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r6;
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="3 a");
    }  

    { // Valid test 7
      auto input=new ANTLRStringStream!(char_t)("3");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r7;
      //  // Stdout(r.tree.toStringTree).newline;
      assert(r.tree is null);
    }  

    { // Valid test 8
      auto input=new ANTLRStringStream!(char_t)("var foo:bool");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r8;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(var bool foo)");
    }  

    { // Valid test 9
      auto input=new ANTLRStringStream!(char_t)("int foo;");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r9;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(VARDEF int foo)");
    }  

    { // Valid test 10
      auto input=new ANTLRStringStream!(char_t)("10");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r10;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="10.0");
    }  

    { // Valid test 11a
      auto input=new ANTLRStringStream!(char_t)("1+2");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r11;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(EXPR (+ 1 2))");
    }  

    { // Valid test 11b
      auto input=new ANTLRStringStream!(char_t)("");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r11;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="EXPR");
    }  

    { // Valid test 12a
      auto input=new ANTLRStringStream!(char_t)("foo");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r12;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="foo");
    }  

    { // Valid test 12b
      auto input=new ANTLRStringStream!(char_t)("foo, bar, gnurz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r12;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="foo bar gnurz");
    }  

    { // Valid test 13a
      auto input=new ANTLRStringStream!(char_t)("int foo;");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r13;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(int foo)");
    }  

    { // Valid test 13b
      auto input=new ANTLRStringStream!(char_t)("bool foo, bar, gnurz;");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r13;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(bool foo bar gnurz)");
    }  

    { // Valid test 14a
      auto input=new ANTLRStringStream!(char_t)("1+2 int");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r14;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(EXPR (+ 1 2) int)");
    }  

    { // Valid test 14b
      auto input=new ANTLRStringStream!(char_t)("1+2 int bool");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r14;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(EXPR (+ 1 2) int bool)");
    }  

    { // Valid test 14c
      auto input=new ANTLRStringStream!(char_t)("int bool");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r14;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(EXPR int bool)");
    }  

    { // Valid test 14d
      auto input=new ANTLRStringStream!(char_t)("fooze fooze int bool");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r14;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(EXPR fooze fooze int bool)");
    }  

    { // Valid test 14e
      auto input=new ANTLRStringStream!(char_t)("7+9 fooze fooze int bool");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r14;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(EXPR (+ 7 9) fooze fooze int bool)");
    }  

    { // Valid test 15
      auto input=new ANTLRStringStream!(char_t)("7");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r15;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="7 7");
    }  

    { // Valid test 16a
      auto input=new ANTLRStringStream!(char_t)("int foo");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r16;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(int foo)");
    }  

    { // Valid test 16b
      auto input=new ANTLRStringStream!(char_t)("int foo, bar, gnurz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r16;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(int foo) (int bar) (int gnurz)");
    }  

    { // Valid test 17a
      auto input=new ANTLRStringStream!(char_t)("for ( fooze ; 1 + 2 ; fooze ) fooze");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r17;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(for fooze (+ 1 2) fooze fooze)");
    }  

    { // Valid test 18a
      auto input=new ANTLRStringStream!(char_t)("for");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r18;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="BLOCK");
    }  

    { // Valid test 19a
      auto input=new ANTLRStringStream!(char_t)("for");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r19;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="for");
    }  

    { // Valid test 20a
      auto input=new ANTLRStringStream!(char_t)("for");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r20;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="FOR");
    }  

    { // Valid test 21a
      auto input=new ANTLRStringStream!(char_t)("for");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r21;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="BLOCK");
    }  

    { // Valid test 22a
      auto input=new ANTLRStringStream!(char_t)("for");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r22;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="for");
    }  

    { // Valid test 23a
      auto input=new ANTLRStringStream!(char_t)("for");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r23;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="FOR");
    }  

    { // Valid test 24a
      auto input=new ANTLRStringStream!(char_t)("fooze 1 + 2");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r24;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(fooze (+ 1 2))");
    }  

    { // Valid test 24a
      auto input=new ANTLRStringStream!(char_t)("fooze 1 + 2");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r24;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(fooze (+ 1 2))");
    }  


    { // Valid test 25a
      auto input=new ANTLRStringStream!(char_t)("fooze, fooze2 1 + 2");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r25;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(fooze (+ 1 2))");
    }  


    { // Valid test 26a
      // Stdout("Test 26a").nl;
      auto input=new ANTLRStringStream!(char_t)("fooze, fooze2");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r26;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(BLOCK fooze fooze2)");
    }  


    { // Valid test 27a
      // Stdout("Test 27a").nl;
      auto input=new ANTLRStringStream!(char_t)("fooze 1 + 2");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r27;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(fooze (fooze (+ 1 2)))");
    }  

    { // Valid test 28
      // Stdout("Test 28").nl;
      auto input=new ANTLRStringStream!(char_t)("foo28a");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r28;
      assert(r.tree is null);
      // // Stdout(r.tree.toStringTree).newline;
      // assert(r.tree.toStringTree=="(fooze (fooze (+ 1 2)))");
    }  

    { // Valid test 28
      // Stdout("Test 28").nl;
      auto input=new ANTLRStringStream!(char_t)("foo28a");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r28;
      assert(r.tree is null);
      // // Stdout(r.tree.toStringTree).newline;
      // assert(r.tree.toStringTree=="(fooze (fooze (+ 1 2)))");
    }  

    { // Fail test 29
      // Stdout("Test 29").nl;
      auto input=new ANTLRStringStream!(char_t)("");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      try {
	auto r=parser.r29;
      } catch (RewriteEarlyExitException e) {
	/* fail test passed */
      } 
      //   assert(r.tree is null);
      // // Stdout(r.tree.toStringTree).newline;
      //      assert(r.tree.toStringTree=="(fooze (fooze (+ 1 2)))");
    }  

    { // Valid test 30
      // Stdout("Test 30").nl;
      auto input=new ANTLRStringStream!(char_t)("fooze fooze");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r30;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(BLOCK fooze)");
    }  

    { // Valid test 31a
      // Stdout("Test 31a").nl;
      auto input=new ANTLRStringStream!(char_t)("public int gnurz = 1 + 2;");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      parser.flag=0;
      auto r=parser.r31;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(VARDEF gnurz public int (+ 1 2))");
    }  

    { // Valid test 31b
      // Stdout("Test 31b").nl;
      auto input=new ANTLRStringStream!(char_t)("public int gnurz = 1 + 2;");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      parser.flag=1;
      auto r=parser.r31;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(VARIABLE gnurz public int (+ 1 2))");
    }  
  
    { // Valid test 31c
      // Stdout("Test 31c").nl;
      auto input=new ANTLRStringStream!(char_t)("public int gnurz = 1 + 2;");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      parser.flag=2;
      auto r=parser.r31;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(FIELD gnurz public int (+ 1 2))");
    }  

    { // Valid test 32a
      // Stdout("Test 32a").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz 32");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      parser.flag=0;
      auto r=parser.r32(1);
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="gnurz");
    }  

    { // Valid test 32b
      // Stdout("Test 32b").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz 32");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      parser.flag=2;
      auto r=parser.r32(2);
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="32");
    }  

    { // Valid test 32c
      // Stdout("Test 32c").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz 32");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      parser.flag=2;
      auto r=parser.r32(3);
      assert(r.tree is null);
    }  

    { // Valid test 33a
      // Stdout("Test 33a").nl;
      auto input=new ANTLRStringStream!(char_t)("public private fooze");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      parser.flag=0;
      auto r=parser.r33;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="fooze");
    }  

    { // Valid test 34a
      // Stdout("Test 34a").nl;
      auto input=new ANTLRStringStream!(char_t)("public class gnurz { fooze fooze2 }");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r34;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(class gnurz public fooze fooze2)");
    }  

    { // Valid test 34b
      // Stdout("Test 34b").nl;
      auto input=new ANTLRStringStream!(char_t)("public class gnurz extends bool implements int, bool { fooze fooze2 }");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r34;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(class gnurz public (extends bool) (implements int bool) fooze fooze2)");
    }  

    { // Fail test 35
      // Stdout("Test 35").nl;
      auto input=new ANTLRStringStream!(char_t)("{ extends }");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      try {
	auto r=parser.r35;
      } catch (RewriteEmptyStreamException e) {
	// Test Passed
      }
    }  


    { // Valid test 36a
      // Stdout("Test 36a").nl;
      auto input=new ANTLRStringStream!(char_t)("if ( 1 + 2 ) fooze");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r36;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(if (EXPR (+ 1 2)) fooze)");
    }  

    { // Valid test 36a
      // Stdout("Test 36a").nl;
      auto input=new ANTLRStringStream!(char_t)("if ( 1 + 2 ) fooze");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r36;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(if (EXPR (+ 1 2)) fooze)");
    }  

    { // Valid test 36a
      // Stdout("Test 36a").nl;
      auto input=new ANTLRStringStream!(char_t)("if ( 1 + 2 ) fooze else fooze2");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r36;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(if (EXPR (+ 1 2)) fooze fooze2)");
    }  

    { // Valid test 37a
      // Stdout("Test 37").nl;
      auto input=new ANTLRStringStream!(char_t)("1 + 2 + 3");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r37;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(+ (+ 1 2) 3)");
    }  

    { // Valid test 38
      // Stdout("Test 38").nl;
      auto input=new ANTLRStringStream!(char_t)("1 + 2 + 3");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r38;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(+ (+ 1 2) 3)");
    }  

    { // Valid test 39a
      // Stdout("Test 39a").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz[1]");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r39;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(INDEX gnurz 1)");
    }  

    { // Valid test 39b
      // Stdout("Test 39b").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz(2)");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r39;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(CALL gnurz 2)");
    }  

    { // Valid test 39c
      // Stdout("Test 39c").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz.gnarz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r39;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(FIELDACCESS gnurz gnarz)");
    }  

    { // Valid test 39d
      // Stdout("Test 39d").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz.gnarz.gnorz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r39;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(FIELDACCESS (FIELDACCESS gnurz gnarz) gnorz)");
    }  

    { // Valid test 40
      // Stdout("Test 40").nl;
      auto input=new ANTLRStringStream!(char_t)("1 + 2 + 3;");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r40;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(+ 1 2 3)");
    }  

    { // Valid test 41
      // Stdout("Test 41").nl;
      auto input=new ANTLRStringStream!(char_t)("1 + 2 + 3;");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r41;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(3 (2 1))");
    }  

    { // Valid test 42
      // Stdout("Test 42").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz, gnarz, gnorz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r42;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="gnurz gnarz gnorz");
    }  

    { // Valid test 43
      // Stdout("Test 43").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz, gnarz, gnorz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r43;
      assert(r.tree is null);
      foreach(id;r.res) {
	// Stdout(id).nl;
      }
      assert(r.res.get(0)=="gnurz");
      assert(r.res.get(1)=="gnarz");
      assert(r.res.get(2)=="gnorz");
    }  

    { // Valid test 44
      // Stdout("Test 44").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz, gnarz, gnorz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r42;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="gnurz gnarz gnorz");
    }  

    { // Valid test 45
      // Stdout("Test 45").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r45;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="gnurz");
    }  

    { // Valid test 46
      // Stdout("Test 46").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz, gnarz, gnorz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r46;
      foreach(id;r.res) {
	// Stdout(id).nl;
      }
      assert(r.res.get(0)=="gnurz");
      assert(r.res.get(1)=="gnarz");
      assert(r.res.get(2)=="gnorz");
    }  

    { // Valid test 47
      // Stdout("Test 47").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz, gnarz, gnorz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r47;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="gnurz gnarz gnorz");
    }  

    { // Valid test 48
      // Stdout("Test 48").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz, gnarz, gnorz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r48;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="gnurz gnarz gnorz");
    }  

    { // Valid test 49
      // Stdout("Test 49").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz gnorz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r49;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(gnurz gnorz)");
    }  

    { // Valid test 50
      // Stdout("Test 50").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r50;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(1.0 gnurz)");
    }  

    { // Valid test 51
      // Stdout("Test 51").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurza gnurzb gnurzc");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r51;
      assert(r.res !is null);
      // Stdout(r.res.toStringTree).newline;
      assert(r.res.toStringTree=="gnurzb");
    }  

    { // Valid test 52
      // Stdout("Test 52").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r52;
      assert(r.res !is null);
      // Stdout(r.res.toStringTree).newline;
      assert(r.res.toStringTree=="gnurz");
    }  

    { // Valid test 53
      // Stdout("Test 53").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurz");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r53;
      assert(r.res !is null);
      // Stdout(r.res.toStringTree).newline;
      assert(r.res.toStringTree=="gnurz");
    }  

    { // Valid test 54
      // Stdout("Test 54").nl;
      auto input=new ANTLRStringStream!(char_t)("gnurza 1 + 2 gnurzb");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r54;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(+ 1 2)");
    }  

    { // Valid test 55a
      // Stdout("Test 55a").nl;
      auto input=new ANTLRStringStream!(char_t)("public private 1 + 2");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r55;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="public private (+ 1 2)");
    }  

    { // Valid test 55b
      // Stdout("Test 55b").nl;
      auto input=new ANTLRStringStream!(char_t)("public fooze");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r55;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="public fooze");
    }  

    { // Valid test 56
      // Stdout("Test 56").nl;
      auto input=new ANTLRStringStream!(char_t)("a b c d");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r56;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="foo");
    }  

    { // Valid test 57
      // Stdout("Test 57").nl;
      auto input=new ANTLRStringStream!(char_t)("a b c d");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r57;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="foo");
    }  

    { // Valid test 59
      // Stdout("Test 59").nl;
      auto input=new ANTLRStringStream!(char_t)("a b c fooze");
      lexer=new t042astLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      parser=new t042astParser!(char_t)(stream);
      auto r=parser.r59;
      assert(r.tree !is null);
      // Stdout(r.tree.toStringTree).newline;
      assert(r.tree.toStringTree=="(a fooze) (b fooze) (c fooze)");
    }  


    Stdout
	.format("passed: {}, {}",typeid(typeof(parser)),typeid(typeof(lexer)))
	.newline;
  }

}

int main() {
  main_test!(char);
  main_test!(wchar);
  main_test!(dchar);

  return 0;
}
