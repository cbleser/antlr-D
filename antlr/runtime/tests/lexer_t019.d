module antlr.runtime.tests.lexer_t019;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRFileStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.MismatchedRangeException;
import antlr.runtime.NoViableAltException;
import antlr.runtime.RecognitionException;
import tango.io.Stdout;

import antlr.runtime.tests.t019Lexer;

template main_test(char_t) {
  void main_test(){
 
	auto input=new ANTLRFileStream!(char_t)("t019lexer.input");
	auto lexer=new t019Lexer!(char_t)(input);
	Token!(char_t) token;
	do {
	  token=lexer.nextToken;
	} while (token.Type != Token!(char_t).EOF);
	Stdout
		.format("passed: {}",typeid(typeof(lexer)))
		.newline;
  }
}
 
int main() {
  main_test!(char);
  main_test!(wchar);
  main_test!(dchar);

  return 0;
}