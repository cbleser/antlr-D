module antlr.runtime.tests.parser_t037rulePropertyRef;

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

import antlr.runtime.tests.t037rulePropertyRefLexer;
import antlr.runtime.tests.t037rulePropertyRefParser;

template main_test(char_t) {
  void main_test(){
	t037rulePropertyRefLexer!(char_t) lexer;
	t037rulePropertyRefParser!(char_t) parser;

  { // Valid test 1
    auto input=new ANTLRStringStream!(char_t)("   a a a a   ");
    lexer=new t037rulePropertyRefLexer!(char_t)(input);
    auto stream=new CommonTokenStream!(char_t)(lexer);
    parser=new t037rulePropertyRefParser!(char_t)(stream);
    auto bla=parser.a().bla;
	// first token of rule b is the 2nd token (counting hidden tokens)
	assert(bla.start.TokenIndex == 1);
        
	// first token of rule b is the 7th token (counting hidden tokens)
	assert(bla.stop.TokenIndex == 7);

	assert(bla.text == "a a a a");


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
