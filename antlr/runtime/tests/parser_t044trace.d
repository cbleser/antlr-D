module antlr.runtime.tests.parser_t044trace;

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
import tango.io.Stdout;

import antlr.runtime.tests.t044traceLexer;
import antlr.runtime.tests.t044traceParser;


template main_test(char_t) {
  void main_test(){
	t044traceLexer!(char_t) lexer;
	t044traceParser!(char_t) parser;

  { // Valid test 1
    auto input=new ANTLRStringStream!(char_t)("< 1 + 2 + 3 >");
    lexer=new t044traceLexer!(char_t)(input);
    auto stream=new CommonTokenStream!(char_t)(lexer);
    parser=new t044traceParser!(char_t)(stream);
    parser.a;
    immutable(char)[][] expectedToken=
	[ ">T__6", "<T__6", ">WS", "<WS",
	    ">INT", "<INT", ">WS", "<WS",
	    ">T__8", "<T__8", ">WS", "<WS",
	    ">INT", "<INT", ">WS", "<WS",
	    ">T__8", "<T__8", ">WS", "<WS",
	    ">INT", "<INT", ">WS", "<WS",
	    ">T__7", "<T__7"];
    immutable(char)[][] expectedTags=
            [ ">a", ">synpred1_t044trace_fragment",
		"<synpred1_t044trace_fragment", ">b", ">c",
		"<c", ">c", "<c", ">c", "<c", "<b", "<a" ];
    assert(lexer.traces.toArray==expectedToken);
    assert(parser.traces.toArray==expectedTags);
  }

  { // Valid test 2 stack
    auto input=new ANTLRStringStream!(char_t)("< 1 + 2 + 3 >");
    lexer=new t044traceLexer!(char_t)(input);
    auto stream=new CommonTokenStream!(char_t)(lexer);
    parser=new t044traceParser!(char_t)(stream);
    parser.a;
    Stdout.nl;
    foreach(t;parser._stack) {
      Stdout(t)(" ").nl;
    }
    Stdout.nl;
	//  Stderr("Stack trace not implemented yet in the ANTLR D version").nl;
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
