module antlr.runtime.tests.parser_t031emptrAlt;

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

import antlr.runtime.tests.t031emptyAltLexer;
import antlr.runtime.tests.t031emptyAltParser;

 
int main() {
  wchar[] name;

  t031emptyAltLexer lexer;
  t031emptyAltParser parser;

  { // Valid test 1
	auto input=new ANTLRStringStream("foo");
	lexer=new t031emptyAltLexer(input);
	auto stream=new CommonTokenStream(lexer);
	parser=new t031emptyAltParser(stream);
	auto event=parser.r;
  }  

  Stdout
      .format("passed: {}, {}",typeid(typeof(parser)),typeid(typeof(lexer)))
      .newline;
  return 0;
}
