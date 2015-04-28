module antlr.runtime.tests.main_t003lexer;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;

import antlr.runtime.ANTLRStringStream;
import tango.io.Stdout;

import antlr.runtime.tests.t003Lexer;


template main_test(char_t) {
  void main_test(){
 
	auto input=new ANTLRStringStream!(char_t)("0fooze1");

	auto lexer=new t003Lexer!(char_t)(input);
	while (true) {
	  auto token=lexer.nextToken;
	  if (token.Type==CharStream!(char_t).EOF) break;
	  Stdout("type: ")(token.Type).newline;
	  Stdout("text: ")(token.Text).newline;
	  Stdout("len:  ")(token.Text.length).newline;
	  Stdout.newline;
	}
  }
}

int main() {
  main_test!(char);
  main_test!(wchar);
  main_test!(dchar);

  return 0;
}
