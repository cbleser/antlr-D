module antlr.runtime.tests.lexer_t010;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.MismatchedRangeException;
import antlr.runtime.NoViableAltException;
import antlr.runtime.RecognitionException;
import tango.io.Stdout;

import antlr.runtime.tests.t010Lexer;

template main_test(char_t) {
  void main_test(){

	class t010Lexer_msg : t010Lexer!(char_t) {
  this(CharStream!(char_t) input) {
    super(input);
  }
  override void reportError(RecognitionExceptionT e) {
	//	auto E=e;
	auto E=cast(NoViableAltExceptionT)e;
    if (E !is null) {
      assert(cast(wchar)E.getUnexpectedType == '-');
      assert(E.charPositionInLine == 1);
      assert(E.line == 1);
    } else {
      Stdout(typeid(typeof(e))).newline;
      super.reportError(e);
    }
  }
}
  auto input=new ANTLRStringStream!(char_t)("foobar _Ab98 \n A12sdf");


  auto lexer=new t010Lexer_msg(input);
  //  while (true) {
  CommonToken!(char_t) token;

  token=cast(CommonToken!(char_t))lexer.nextToken;
  assert(token.Type==lexer.IDENTIFIER);
  assert(token.Text=="foobar");
  assert(token.StartIndex==0);
  assert(token.StopIndex==5);


  token=cast(CommonToken!(char_t))lexer.nextToken;
  assert(token.Type==lexer.WS);
  assert(token.Text==" ");
  assert(token.StartIndex==6);
  assert(token.StopIndex==6);

  token=cast(CommonToken!(char_t))lexer.nextToken;
  assert(token.Type==lexer.IDENTIFIER);
  assert(token.Text=="_Ab98");
  assert(token.StartIndex==7);
  assert(token.StopIndex==11);

  token=cast(CommonToken!(char_t))lexer.nextToken;
  assert(token.Type==lexer.WS);
  assert(token.Text==" \n ");
  assert(token.StartIndex==12);
  assert(token.StopIndex==14);

  token=cast(CommonToken!(char_t))lexer.nextToken;
  assert(token.Type==lexer.IDENTIFIER);
  assert(token.Text=="A12sdf");
  assert(token.StartIndex==15);
  assert(token.StopIndex==20);

  token=cast(CommonToken!(char_t))lexer.nextToken;
  assert(token.Type==lexer.EOF);

  // Mal formed input test
  input=new ANTLRStringStream!(char_t)("a-b");
  lexer=new t010Lexer_msg(input);

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