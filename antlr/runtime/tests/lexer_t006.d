module antlr.runtime.tests.lexer_t006;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.RecognitionException;
import tango.io.Stdout;

import antlr.runtime.tests.t006Lexer;

template main_test(char_t) {
  void main_test(){

	class t006Lexer_msg : t006Lexer!(char_t) {
	  this(CharStreamT input) {
		super(input);
	  }
	  override void reportError(RecognitionExceptionT e) {
		auto E=cast(MismatchedTokenExceptionT)e;
		if (E !is null) {
		  assert(E.expecting == cast(int)'f');
		  assert(cast(wchar)E.getUnexpectedType == '2');
		  assert(E.charPositionInLine == 10);
		  assert(E.line == 1);
		} else {
		  Stdout(typeid(typeof(e))).newline;
		  super.reportError(e);
		}
	  }
	}
 
	auto input=new ANTLRStringStream!(char_t)("fofaaooa");


	auto lexer=new t006Lexer_msg(input);
	//  while (true) {
	CommonToken!(char_t) token;

	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="fo");
	assert(token.StartIndex==0);
	assert(token.StopIndex==1);


	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="faaooa");
	assert(token.StartIndex==2);
	assert(token.StopIndex==7);


	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.EOF);

	input=new ANTLRStringStream!(char_t)("fofoaooaoa2");
	lexer=new t006Lexer_msg(input);

	token = cast(CommonToken!(char_t))lexer.nextToken();
	token = cast(CommonToken!(char_t))lexer.nextToken();
	// Next token must fail
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