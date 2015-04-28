module antlr.runtime.tests.parser_t039labels;

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

import antlr.runtime.tests.t039labelsLexer;
import antlr.runtime.tests.t039labelsParser;

template main_test(char_t) {
  void main_test(){

	t039labelsLexer!(char_t) lexer;
	t039labelsParser!(char_t) parser;

  { // Valid test 1
    auto input=new ANTLRStringStream!(char_t)("a, b, c, 1, 2 A FOOBAR GNU1 A BLARZ");
    lexer=new t039labelsLexer!(char_t)(input);
    auto stream=new CommonTokenStream!(char_t)(lexer);
    parser=new t039labelsParser!(char_t)(stream);
    auto label=parser.a();

	with (label) {
	  assert(ids.size==6);
	  assert(ids.get(0).Text=="a");
	  assert(ids.get(1).Text=="b");
	  assert(ids.get(2).Text=="c");
	  assert(ids.get(3).Text=="1");
	  assert(ids.get(4).Text=="2");
	  assert(ids.get(5).Text=="A");
	}
	
	assert(label.w.Text == "GNU1");
	
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
