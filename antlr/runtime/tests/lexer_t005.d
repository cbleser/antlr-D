module antlr.runtime.tests.lexer_t005;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.RecognitionException;
import tango.io.Stdout;

import antlr.runtime.tests.t005Lexer;

template main_test(char_t) {
  void main_test(){

	class t005Lexer_msg : t005Lexer!(char_t) {
	  this(CharStreamT input) {
		super(input);
	  }
	  override void reportError(RecognitionExceptionT e) {
		auto E=cast(MismatchedTokenExceptionT)e;
		if (E !is null) {
		  assert(E.expecting == cast(int)'f');
		  assert(cast(char_t)E.getUnexpectedType == '2');
		} else {
		  Stdout(typeid(typeof(e))).newline;
		  super.reportError(e);
		}
	  }
	}
	auto input=new ANTLRStringStream!(char_t)("fofoofooo");


	auto lexer=new t005Lexer_msg(input);
	//  while (true) {
	CommonToken!(char_t) token;

	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="fo");
	assert(token.StartIndex==0);
	assert(token.StopIndex==1);


	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="foo");
	assert(token.StartIndex==2);
	assert(token.StopIndex==4);


	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="fooo");
	assert(token.StartIndex==5);
	assert(token.StopIndex==8);


	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.EOF);

	input=new ANTLRStringStream!(char_t)("2");
	lexer=new t005Lexer_msg(input);

	token = cast(CommonToken!(char_t))lexer.nextToken();

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