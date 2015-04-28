module antlr.runtime.tests.lexer_t007;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.RecognitionException;
import tango.io.Stdout;

import antlr.runtime.tests.t007Lexer;

template main_test(char_t) {
  void main_test(){
	class t007Lexer_msg : t007Lexer!(char_t) {
	  this(CharStreamT input) {
		super(input);
	  }
	  override void reportError(RecognitionExceptionT e) {
		auto E=e;
		//   auto E=cast(MismatchedTokenException)e;
		if (E !is null) {
		  assert(cast(wchar)E.getUnexpectedType == 'o');
		  assert(E.charPositionInLine == 6);
		  assert(E.line == 1);
		} else {
		  Stdout(typeid(typeof(e))).newline;
		  super.reportError(e);
		}
	  }
	}
 
	auto input=new ANTLRStringStream!(char_t)("fofababbooabb");


	auto lexer=new t007Lexer_msg(input);
	//  while (true) {
	CommonToken!(char_t) token;

	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="fo");
	assert(token.StartIndex==0);
	assert(token.StopIndex==1);


	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="fababbooabb");
	assert(token.StartIndex==2);
	assert(token.StopIndex==12);


	// Mal formed input test
	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.EOF);

	input=new ANTLRStringStream!(char_t)("foaboao");
	lexer=new t007Lexer_msg(input);

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