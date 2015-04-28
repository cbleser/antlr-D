module antlr.runtime.tests.lexer_t020fuzzy;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRFileStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.MismatchedRangeException;
import antlr.runtime.NoViableAltException;
import antlr.runtime.RecognitionException;
import tango.io.Stdout;

import antlr.runtime.tests.t020fuzzyLexer;
import tango.io.device.File;
 
int main() {
 
  // open check file
  auto file = new File ("t020fuzzy.output");

  // create an array to house the entire file
  auto content = new char [file.length];

  auto bytes = file.read (content);
  file.close;

  auto input=new ANTLRFileStream!(char)("t020fuzzy.input");
  auto lexer=new t020fuzzyLexer!(char)(input);
  Token!(char) token;
  do {
    token=lexer.nextToken;
  } while (token.Type != Token!(char).EOF);

  assert(lexer.output.slice == content);
  Stdout
      .format("passed: {}",typeid(typeof(lexer)))
      .newline;
  return 0;
}