module antlr.runtime.tests.lexer_t038RuleLabel;

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

import antlr.runtime.tests.t038RuleLabelLexer;

template main_test(char_t) {
  void main_test(){
	t038RuleLabelLexer!(char_t) lexer;
	{
	  auto input=new ANTLRStringStream!(char_t)("a  2");
	  lexer=new t038RuleLabelLexer!(char_t)(input);
	  Token!(char_t) token;
	  do {
		token=lexer.nextToken;
		if (token.Type == lexer.EOF) {
		  break;
		}
	  } while (true);
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