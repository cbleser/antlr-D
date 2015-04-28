module antlr.runtime.tests.parser_t013;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.MismatchedRangeException;
import antlr.runtime.NoViableAltException;
import antlr.runtime.RecognitionException;
import antlr.runtime.CommonTokenStream;
import tango.io.Stdout;

import antlr.runtime.tests.t013Lexer;
import antlr.runtime.tests.t013Parser;
import antlr.runtime.CommonToken;
import antlr.runtime.EasyANTLR;

import tango.core.Traits;

int main() {
  //auto input=new ANTLRStringStream!(char)("foobar");
    version(none) {
  auto input=ANTLRStringStreamT("foobar");
  t013Lexer!(char, CommonToken!(char)) lexer=t013LexerT(input);
  auto stream=CommonTokenStreamT(lexer);
  auto parser=t013ParserT(stream);
  parser.document();
  assert(parser.identifiers.head=="foobar");
  // Mal function test
  input=ANTLRStringStreamT("");
  lexer=t013LexerT(input);
  stream=CommonTokenStreamT(lexer);
  parser=t013ParserT(stream);
  parser.document();

  assert(parser.reportedErrors.size==1);
  Stdout
      .format("passed: {}, {}",typeid(typeof(parser)),typeid(typeof(lexer)))
      .newline;
    }
  return 0;
}
