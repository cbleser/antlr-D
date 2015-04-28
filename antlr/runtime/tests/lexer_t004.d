module antlr.runtime.tests.main_t004Lexer;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import tango.io.Stdout;

import antlr.runtime.tests.t004Lexer;

template main_test(char_t) {
  void main_test(){
	Stdout.formatln("Test {} ",typeid(char_t));
	auto input=new ANTLRStringStream!(char_t)("ffofoofooo");


	auto lexer=new t004Lexer!(char_t)(input,null);
	//  while (true) {
	CommonToken!(char_t) token;

	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="f");
	assert(token.StopIndex==0);
	assert(token.StartIndex==0);

	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="fo");
	assert(token.StartIndex==1);
	assert(token.StopIndex==2);


	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="foo");
	assert(token.StartIndex==3);
	assert(token.StopIndex==5);


	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.FOO);
	assert(token.Text=="fooo");
	assert(token.StartIndex==6);
	assert(token.StopIndex==9);


	token=cast(CommonToken!(char_t))lexer.nextToken;
	assert(token.Type==lexer.EOF);

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