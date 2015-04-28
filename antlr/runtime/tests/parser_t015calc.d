module antlr.runtime.tests.parser_t015;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.MismatchedRangeException;
import antlr.runtime.NoViableAltException;
import antlr.runtime.RecognitionException;
import antlr.runtime.CommonTokenStream;
import tango.io.Stdout;

import antlr.runtime.tests.t015calcLexer;
import antlr.runtime.tests.t015calcParser;

template main_test(char_t) {
  void main_test(){
	real x;
	// Valid test 01
	auto input=new ANTLRStringStream!(char_t)("1 + 2");
	auto lexer=new t015calcLexer!(char_t)(input);
	auto stream=new CommonTokenStream!(char_t)(lexer);
	auto parser=new t015calcParser!(char_t)(stream);
	x=parser.evaluate();
	assert(x == 3.0);

	// Valid test 02
	input=new ANTLRStringStream!(char_t)("1 + 2 * 3");
	lexer=new t015calcLexer!(char_t)(input);
	stream=new CommonTokenStream!(char_t)(lexer);
	parser=new t015calcParser!(char_t)(stream);
	x=parser.evaluate();
	assert(x == 7.0);

	// Valid test 03
	input=new ANTLRStringStream!(char_t)("10 / 5");
	lexer=new t015calcLexer!(char_t)(input);
	stream=new CommonTokenStream!(char_t)(lexer);
	parser=new t015calcParser!(char_t)(stream);
	x=parser.evaluate();
	assert(x == 2.0);

	// Valid test 04
	input=new ANTLRStringStream!(char_t)("6 + 2*(3+1) - 4");
	lexer=new t015calcLexer!(char_t)(input);
	stream=new CommonTokenStream!(char_t)(lexer);
	parser=new t015calcParser!(char_t)(stream);
	x=parser.evaluate();
	assert(x == 10.0);

	// Mal formed input 01
	input=new ANTLRStringStream!(char_t)("6 - (3*1");
	lexer=new t015calcLexer!(char_t)(input);
	stream=new CommonTokenStream!(char_t)(lexer);
	parser=new t015calcParser!(char_t)(stream);
	x=parser.evaluate();
	//  assert(x == 10.0);
	Stdout.format("errors={}",parser.reportedErrors.size).newline;
	char[] error=cast(char[])parser.reportedErrors.head;
	Stdout.format("ERR:{}",error).newline;

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
