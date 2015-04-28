module antlr.runtime.tests.lexer_t025RulePropertyRef;

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

import antlr.runtime.tests.t025RulePropertyRefLexer;

template main_test(char_t) {
  void main_test(){

	auto input=new ANTLRStringStream!(char_t)("foobar _Ab98 \n A12sdf");
	auto lexer=new t025RulePropertyRefLexer!(char_t)(input);
	Token!(char_t) token;
	do {
	  token=lexer.nextToken;
	} while (token.Type != Token!(char_t).EOF);
	assert(lexer.properties.size==3);

	with (lexer.properties.get(0)) {
	  assert(text=="foobar");
	  assert(type==lexer.IDENTIFIER);
	  assert(line==1);
	  assert(pos==0);
	  assert(index==-1);
	  assert(channel==Token!(char_t).DEFAULT_CHANNEL);
	  assert(start==0);
	  assert(stop==5);
	}

	with (lexer.properties.get(1)) {
	  assert(text=="_Ab98");
	  assert(type==lexer.IDENTIFIER);
	  assert(line==1);
	  assert(pos==7);
	  assert(index==-1);
	  assert(channel==Token!(char_t).DEFAULT_CHANNEL);
	  assert(start==7);
	  assert(stop==11);
	}

	with (lexer.properties.get(2)) {
	  assert(text=="A12sdf");
	  assert(type==lexer.IDENTIFIER);
	  assert(line==2);
	  assert(pos==1);
	  assert(index==-1);
	  assert(channel==Token!(char_t).DEFAULT_CHANNEL);
	  assert(start==15);
	  assert(stop==20);
	}


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