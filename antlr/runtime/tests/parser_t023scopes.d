module antlr.runtime.tests.parser_t023scopes;

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

import antlr.runtime.tests.t023scopesLexer;
import antlr.runtime.tests.t023scopesParser;

template main_test(char_t) {
  void main_test(){
  char_t[] name;

  t023scopesLexer!(char_t) lexer;
  t023scopesParser!(char_t) parser;
  { // testb1
	auto input=new ANTLRStringStream!(char_t)("foobar");
	lexer=new t023scopesLexer!(char_t)(input);
	auto stream=new CommonTokenStream!(char_t)(lexer);
	parser=new t023scopesParser!(char_t)(stream);
	parser.prog;

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
