module antlr.runtime.tests.parser_t045dfabug;

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

import antlr.runtime.tests.t045dfabugLexer;
import antlr.runtime.tests.t045dfabugParser;

template main_test(char_t) {
  void main_test(){
	t045dfabugLexer!(char_t) lexer;
	t045dfabugParser!(char_t) parser;

  { // Valid test 1
    auto input=new ANTLRStringStream!(char_t)("public fooze");
    lexer=new t045dfabugLexer!(char_t)(input);
    auto stream=new CommonTokenStream!(char_t)(lexer);
    parser=new t045dfabugParser!(char_t)(stream);
    auto r=parser.r;

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
