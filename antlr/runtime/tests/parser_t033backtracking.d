module antlr.runtime.tests.parser_t033backtracking;

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

import antlr.runtime.tests.t033backtrackingLexer;
import antlr.runtime.tests.t033backtrackingParser;

 
int main() {
  wchar[] name;

  t033backtrackingLexer lexer;
  t033backtrackingParser parser;

  { // Valid test 1
	auto input=new ANTLRStringStream("int a;");
	lexer=new t033backtrackingLexer(input);
	auto stream=new CommonTokenStream(lexer);
	parser=new t033backtrackingParser(stream);
	parser.translation_unit();
  }  


  Stdout
      .format("passed: {}, {}",typeid(typeof(parser)),typeid(typeof(lexer)))
      .newline;
  return 0;
}
