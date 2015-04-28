module antlr.runtime.tests.parser_t017hoist;

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
import tango.io.Stdout;

import antlr.runtime.tests.t021hoistLexer;
import antlr.runtime.tests.t021hoistParser;

template main_test(char_t) {
  void main_test(){
	char_t[] name;
	// Valid test 01
	t021hoistLexer!(char_t) lexer;
	t021hoistParser!(char_t) parser;
	{
	  auto input=new ANTLRStringStream!(char_t)("enum");
	  lexer=new t021hoistLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t021hoistParser!(char_t)(stream);

	  parser.enableEnum=true;
	  auto enumIs=parser.stat();
	  assert(enumIs == "keyword");
	}

	// Valid test 02
	{
	  auto input=new ANTLRStringStream!(char_t)("enum");
	  lexer=new t021hoistLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t021hoistParser!(char_t)(stream);

	  parser.enableEnum=false;
	  auto enumIs=parser.stat();
	  assert(enumIs == "ID");
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
