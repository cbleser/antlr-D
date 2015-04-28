module antlr.runtime.tests.lexer_t029synpredgate;

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

import antlr.runtime.tests.t029synpredgateLexer;

template main_test(char_t) {
  void main_test(){

	t029synpredgateLexer!(char_t) lexer;
  {
    auto input=new ANTLRStringStream!(char_t)("ac");
    lexer=new t029synpredgateLexer!(char_t)(input);
    Token!(char_t) token;
    token=lexer.nextToken;
  }

  {
    auto input=new ANTLRStringStream!(char_t)("ab");
    lexer=new t029synpredgateLexer!(char_t)(input);
    Token!(char_t) token;
    token=lexer.nextToken;
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