module antlr.runtime.tests.parser_t041parameters;

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

import antlr.runtime.tests.t041parametersLexer;
import antlr.runtime.tests.t041parametersParser;

template main_test(char_t) {
  void main_test(){

	t041parametersLexer!(char_t) lexer;
	t041parametersParser!(char_t) parser;

  { // Valid test 1
    auto input=new ANTLRStringStream!(char_t)("a a a");
    lexer=new t041parametersLexer!(char_t)(input);
    auto stream=new CommonTokenStream!(char_t)(lexer);
    parser=new t041parametersParser!(char_t)(stream);
    auto r=parser.a("foo","bar");

	assert(r.arg1=="foo");
	assert(r.arg2=="bar");

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
