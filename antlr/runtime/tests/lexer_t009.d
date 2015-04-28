module antlr.runtime.tests.lexer_t009;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.MismatchedRangeException;
import antlr.runtime.RecognitionException;
import tango.io.Stdout;

import antlr.runtime.tests.t009Lexer;

template main_test(char_t) {
  void main_test(){
	class t009Lexer_msg : t009Lexer!(char_t) {
	  this(CharStreamT input) {
		super(input);
	  }
	  override void reportError(RecognitionExceptionT e) {
		//	auto E=e;
		auto E=cast(MismatchedRangeExceptionT)e;
		if (E !is null) {
		  assert(cast(wchar)E.getUnexpectedType == 'a');
		  assert(E.charPositionInLine == 1);
		  assert(E.line == 1);
		  assert(E.a == '0');
		  assert(E.b == '9');
		} else {
		  Stdout(typeid(typeof(e))).newline;
		  super.reportError(e);
		}
	  }
	}
 
	auto input=new ANTLRStringStream!(char_t)("085");

	auto lexer=new t009Lexer_msg(input);
	//  while (true) {
	CommonToken!(char_t) token;

	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.DIGIT);
	assert(token.Text=="0");
	assert(token.StartIndex==0);
	assert(token.StopIndex==0);


	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.DIGIT);
	assert(token.Text=="8");
	assert(token.StartIndex==1);
	assert(token.StopIndex==1);

	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.DIGIT);
	assert(token.Text=="5");
	assert(token.StartIndex==2);
	assert(token.StopIndex==2);


	// Mal formed input test
	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.EOF);

	input=new ANTLRStringStream!(char_t)("2a");
	lexer=new t009Lexer_msg(input);

	// Next token must fail
	token = cast(CommonToken!(char_t))lexer.nextToken();
	token = cast(CommonToken!(char_t))lexer.nextToken();
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