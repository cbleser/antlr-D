module antlr.runtime.tests.parser_t030specialStates;

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

import antlr.runtime.tests.t030specialStatesLexer;
import antlr.runtime.tests.t030specialStatesParser;

template main_test(char_t) {
  void main_test(){

	char_t[] name;

	t030specialStatesLexer!(char_t) lexer;
	t030specialStatesParser!(char_t) parser;

	{ // Valid test 1
	  auto input=new ANTLRStringStream!(char_t)("foo");
	  lexer=new t030specialStatesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t030specialStatesParser!(char_t)(stream);
	  parser.r;
	}  

	{ // Valid test 2
	  auto input=new ANTLRStringStream!(char_t)("foo name1");
	  lexer=new t030specialStatesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t030specialStatesParser!(char_t)(stream);
	  parser.r;
	}  

	{ // Valid test 3
	  auto input=new ANTLRStringStream!(char_t)("bar name1");
	  lexer=new t030specialStatesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t030specialStatesParser!(char_t)(stream);
	  parser.cond=false;
	  parser.r;
	}  

	{ // Valid test 4
	  auto input=new ANTLRStringStream!(char_t)("bar name1 name2");
	  lexer=new t030specialStatesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t030specialStatesParser!(char_t)(stream);
	  parser.cond=false;
	  parser.r;
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
