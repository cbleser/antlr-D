module antlr.runtime.tests.lexer_t008;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.RecognitionException;
import tango.io.Stdout;

import antlr.runtime.tests.t008Lexer;

template main_test(char_t) {
  void main_test(){
	class t008Lexer_msg : t008Lexer!(char_t) {
	  this(CharStreamT input) {
		super(input);
	  }
	  override void reportError(RecognitionExceptionT e) {
		auto E=e;
		//   auto E=cast(MismatchedTokenException)e;
		if (E !is null) {
		  assert(cast(wchar)E.getUnexpectedType == 'b');
		  assert(E.charPositionInLine == 3);
		  assert(E.line == 1);
		} else {
		  Stdout(typeid(typeof(e))).newline;
		  super.reportError(e);
		}
	  }
	}
	
	auto input=new ANTLRStringStream!(char_t)("ffaf");
	
	
	auto lexer=new t008Lexer_msg(input);
	//  while (true) {
	CommonToken!(char_t) token;
	
	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="f");
	assert(token.StartIndex==0);
	assert(token.StopIndex==0);
	
	
	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="fa");
	assert(token.StartIndex==1);
	assert(token.StopIndex==2);
	
	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="f");
	assert(token.StartIndex==3);
	assert(token.StopIndex==3);
	

	// Mal formed input test
	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.EOF);

	input=new ANTLRStringStream!(char_t)("fafb");
	lexer=new t008Lexer_msg(input);

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