module antlr.runtime.tests.parser_t050decorate;

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

import antlr.runtime.tests.t050decorateLexer;
import antlr.runtime.tests.t050decorateParser;

 
int main() {
  t050decorateLexer lexer;
  t050decorateParser parser;

  { // Valid test 1
    auto input=new ANTLRStringStream("forbar");
    lexer=new t050decorateLexer(input);
    auto stream=new CommonTokenStream(lexer);
    parser=new t050decorateParser(stream);
    parser.document;

  }  

  Stdout
      .format("passed: {}, {}",typeid(typeof(parser)),typeid(typeof(lexer)))
      .newline;
  return 0;
}
