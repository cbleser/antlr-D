module antlr.runtime.tests.parser_t032subrulePredict;

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

import antlr.runtime.tests.t032subrulePredictLexer;
import antlr.runtime.tests.t032subrulePredictParser;

template main_test(char_t) {
  void main_test(){
  char_t[] name;

  t032subrulePredictLexer!(char_t) lexer;
  t032subrulePredictParser!(char_t) parser;
  { // Valid test 1
	auto input=new ANTLRStringStream!(char_t)("BEGIN  A END");
	lexer=new t032subrulePredictLexer!(char_t)(input);
	auto stream=new CommonTokenStream!(char_t)(lexer);
	parser=new t032subrulePredictParser!(char_t)(stream);
	parser.a;
  }  

  { // Valid test 1
	auto input=new ANTLRStringStream!(char_t)("BEGIN  A A END");
	lexer=new t032subrulePredictLexer!(char_t)(input);
	auto stream=new CommonTokenStream!(char_t)(lexer);
	parser=new t032subrulePredictParser!(char_t)(stream);
	parser.a;
  }  

  { // Valid test 2
	auto input=new ANTLRStringStream!(char_t)(" A A");
	lexer=new t032subrulePredictLexer!(char_t)(input);
	auto stream=new CommonTokenStream!(char_t)(lexer);
	parser=new t032subrulePredictParser!(char_t)(stream);
	parser.b;
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
