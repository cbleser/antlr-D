module antlr.runtime.tests.parser_t024finally;

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

import antlr.runtime.tests.t024finallyLexer;
import antlr.runtime.tests.t024finallyParser;

template main_test(char_t) {
  void main_test(){

  char_t[] name;

  t024finallyLexer!(char_t) lexer;
  t024finallyParser!(char_t) parser;
  { // testb1
	auto input=new ANTLRStringStream!(char_t)("foobar");
	lexer=new t024finallyLexer!(char_t)(input);
	auto stream=new CommonTokenStream!(char_t)(lexer);
	parser=new t024finallyParser!(char_t)(stream);
	auto events=parser.prog;
	
	assert(events.get(0) == "catch");
	assert(events.get(1) == "finally");

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
