module antlr.runtime.tests.parser_t026actions;

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

import antlr.runtime.tests.t026actionsLexer;
import antlr.runtime.tests.t026actionsParser;

template main_test(char_t) {
  void main_test(){
  char_t[] name;

  t026actionsLexer!(char_t) lexer;
  t026actionsParser!(char_t) parser;
  { // testb1
	auto input=new ANTLRStringStream!(char_t)("foobar _Ab98 \n A12sdf");
	lexer=new t026actionsLexer!(char_t)(input);
	auto stream=new CommonTokenStream!(char_t)(lexer);
	parser=new t026actionsParser!(char_t)(stream);
	parser.prog;
	assert(parser._output=="init;after;finally;");
	Stdout.format("lexer._output.length={}",lexer._output.length).newline;
	assert(lexer._output=="action;'foobar' 4 1 0 -1 0 0 5;attribute;action;'_Ab98' 4 1 7 -1 0 7 11;attribute;action;'A12sdf' 4 2 1 -1 0 15 20;attribute;");

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