module antlr.runtime.tests.parser_t022scopes;

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

import antlr.runtime.tests.t022scopesLexer;
import antlr.runtime.tests.t022scopesParser;


template main_test(char_t) {
  void main_test(){

	char_t[] name;

	t022scopesLexer!(char_t) lexer;
	t022scopesParser!(char_t) parser;
	{ // testb1
	  auto input=new ANTLRStringStream!(char_t)("foobar");
	  lexer=new t022scopesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t022scopesParser!(char_t)(stream);
	  parser.a;

	}

	{ // testb1
	  auto input=new ANTLRStringStream!(char_t)("foobar");
	  lexer=new t022scopesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t022scopesParser!(char_t)(stream);
	  try {
		parser.b(false);
		Stdout("after parser.b(false);").newline;
		//  throw new RuntimeException("Should not fail here");
	  } catch (RuntimeException e) {
		// passed
	  }
	}

	{ // testb2
	  auto input=new ANTLRStringStream!(char_t)("foobar");
	  lexer=new t022scopesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t022scopesParser!(char_t)(stream);
	  parser.b(true);
	}

	{ // testc1
	  auto input=new ANTLRStringStream!(char_t)(
		  "{\n"
		  "   int i;\n"
		  "    int j;\n"
		  "    i = 0;\n"
		  "}\n"
									   );
	  lexer=new t022scopesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t022scopesParser!(char_t)(stream);
	  auto symbols=parser.c();
	  assert(symbols.contains("i"));
	  assert(symbols.contains("j"));
	}

	{ // testc2
	  auto input=new ANTLRStringStream!(char_t)(
		  "{\n"
		  "   int i;\n"
		  "    int j;\n"
		  "    i = 0;\n"
		  "    x = 4;\n"
		  "}\n"
									   );
	  lexer=new t022scopesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t022scopesParser!(char_t)(stream);
	  try {
		auto symbols=parser.c();
	  } catch (RuntimeException e) {
		assert(e.msg[0]=='x');
		// passed
	  }
	}

	{ // testd1
	  auto input=new ANTLRStringStream!(char_t)(
		  "{\n"
		  "   int i;\n"
		  "    int j;\n"
		  "    i = 0;\n"
		  "   {\n"
		  "     int i;"
		  "     int x;"
		  "     x = 5;\n"
		  "   }\n"
		  "}\n"
									   );
	  lexer=new t022scopesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t022scopesParser!(char_t)(stream);
	  auto symbols=parser.d();
	  assert(symbols.contains("i"));
	  assert(symbols.contains("j"));
	}

	{ // teste1
	  auto input=new ANTLRStringStream!(char_t)(
		  "{ { { { 12 } } } }\n"
									   );
	  lexer=new t022scopesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t022scopesParser!(char_t)(stream);
	  auto res=parser.e();
	  assert(res == 12);
	}

	{ // testf1
	  auto input=new ANTLRStringStream!(char_t)(
		  "{ { { { 12 } } } }\n"
									   );
	  lexer=new t022scopesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t022scopesParser!(char_t)(stream);
	  auto res=parser.f();
	  assert(res == 0);
	}

	{ // testf2
	  auto input=new ANTLRStringStream!(char_t)(
		  "{ { 12 } }\n"
									   );
	  lexer=new t022scopesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t022scopesParser!(char_t)(stream);
	  auto res=parser.f();
	  assert(res == 12);
	}

	{ // testf3
	  auto input=new ANTLRStringStream!(char_t)(
		  "{ { { 12 } } }\n"
									   );
	  lexer=new t022scopesLexer!(char_t)(input);
	  auto stream=new CommonTokenStream!(char_t)(lexer);
	  parser=new t022scopesParser!(char_t)(stream);
	  auto res=parser.f();
	  assert(res == 0);
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
