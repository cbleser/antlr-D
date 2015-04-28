module antlr.runtime.tests.lexer_t027eof;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.MismatchedRangeException;
import antlr.runtime.NoViableAltException;
import antlr.runtime.RecognitionException;
import antlr.runtime.Token;
import tango.io.Stdout;

import antlr.runtime.tests.t027eofLexer;


template main_test(char_t) {
  void main_test(){

	auto input=new ANTLRStringStream!(char_t)(" ");
	auto lexer=new t027eofLexer!(char_t)(input);
	Token!(char_t) token;
	token=lexer.nextToken;
	//  Stdout.format("Type={} SPACE={}",token.Type,lexer.SPACE).newline;
	assert(token.Type==lexer.SPACE);
	token=lexer.nextToken;
	//  Stdout.format("Type={} END={}",token.Type,lexer.END).newline;
	assert(token.Type==lexer.END);
	token=lexer.nextToken;
	//  Stdout.format("Type={} END={}",token.Type,lexer.END).newline;


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