module antlr.runtime.tests.parser_t043synpred;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.ANTLRFileStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.MismatchedRangeException;
import antlr.runtime.NoViableAltException;
import antlr.runtime.RecognitionException;
import antlr.runtime.CommonTokenStream;
import antlr.runtime.RuntimeException;
import tango.io.Stdout;

import antlr.runtime.tests.t043synpredLexer;
import antlr.runtime.tests.t043synpredParser;


template main_test(char_t) {
  void main_test(){
	t043synpredLexer!(char_t) lexer;
	t043synpredParser!(char_t) parser;

  { // Valid test 1
    auto input=new ANTLRStringStream!(char_t)("   +foo>");
    lexer=new t043synpredLexer!(char_t)(input);
    auto stream=new CommonTokenStream!(char_t)(lexer);
    parser=new t043synpredParser!(char_t)(stream);
    parser.a;
  }  


  Stdout
      .format("passed: {}, {}",typeid(typeof(parser)),typeid(typeof(lexer)))
      .newline;
  }
}
 
int main() {
  main_test!(char);
  main_test!(wchar);
  main_test!(dchar);

  return 0;
}
