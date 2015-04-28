module antlr.runtime.tests.lexer_t048rewrite;

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
import antlr.runtime.TokenRewriteStream;
import antlr.runtime.RuntimeException;
import tango.io.Stdout;

import antlr.runtime.tests.t048rewriteLexer;

template main_test(char_t) {
  void main_test(){

	t048rewriteLexer!(char_t) lexer;
	{ // Insert before index 0
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.insertBefore(0, "0");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="0abc");
	}  

	{ // Insert after last index 
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.insertAfter(2, "x");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="abcx");
	}  

	{ // 2 Insert after and before middle index 
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.insertBefore(1, "x");
	  stream.insertAfter(1, "x");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="axbxc");
	}  

	{ // replace index 0 
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(0, "x");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="xbc");
	}  

	{ // replace last index 0 
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(2, "x");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="abx");
	}  

	{ // replace middle index 
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(1, "x");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="axc");
	}  

	{ // 2 replace middle index 
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(1, "x");
	  stream.replace(1, "y");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="ayc");
	}  

	{ // 2 replace middle index 
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.remove(1);
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="ac");
	}  

	{ // Replace and the insert at same index 
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(0, "x");
	  stream.insertBefore(0, "0");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="0xbc");
	}  

	{ // Replace and the insert 2 at same index 
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(0, "x");
	  stream.insertBefore(0, "y");
	  stream.insertBefore(0, "z");

	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="zyxbc");
	}  

	{ // Insert replace at same index 
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.insertBefore(0, "0");
	  stream.replace(0, "x");

	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="0xbc");
	}  

	{ // Insert 2 middle index 
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(0, "x");
	  stream.insertBefore(1, "x");
	  stream.insertBefore(1, "y");

	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="xyxbc");
	}  

	{ // Insert 2 then replace at index 0 
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.insertBefore(0, "x");
	  stream.insertBefore(0, "y");
	  stream.replace(0, "z");
	  // Stdout(stream.toStringT).nl;

	  assert(stream.toStringT=="yxzbc");
	}  

	{ // Replace and then insert at the last index  
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.insertBefore(0, "x");
	  stream.insertBefore(0, "y");
	  stream.replace(0, "z");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="yxzbc");
	}  

	{ // Replace and then insert at the last index  
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.insertBefore(2, "x");
	  stream.insertBefore(2, "y");
	  // Stdout(stream.toStringT).nl;
	  // stream.dumpProgram();
	  assert(stream.toStringT=="abyxc");
	}  

	{ // Replace and then insert at the last index  
	  auto input=new ANTLRStringStream!(char_t)("abc");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.insertBefore(2, "y");
	  stream.replace(2, "x");
	  // Stdout(stream.toStringT).nl;

	  assert(stream.toStringT=="abyx");
	}  

	{ // Replace range and then insert at the middle index  
	  auto input=new ANTLRStringStream!(char_t)("abcccba");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(2, 4, "x");
	  // no effect can't insert in middle of replaced region
	  stream.insertBefore(3, "y");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="abxba");
	}  

	{ // Replace range and then insert at the left side   
	  auto input=new ANTLRStringStream!(char_t)("abcccba");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(2, 4, "x");
	  stream.insertBefore(2, "y");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="abyxba");
	}  

	{ // Replace range and then insert at before the right side   
	  auto input=new ANTLRStringStream!(char_t)("abcccba");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(2, 4, "x");
	  stream.insertBefore(4, "y");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="abxba");
	}  


	{ // Replace range and then insert at after the right side   
	  auto input=new ANTLRStringStream!(char_t)("abcccba");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(2, 4, "x");
	  stream.insertAfter(4, "y");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="abxyba");
	}  

	{ // Replace all
	  auto input=new ANTLRStringStream!(char_t)("abcccba");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(0, 6, "x");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="x");
	}  

	{ // Replace subset
	  auto input=new ANTLRStringStream!(char_t)("abcccba");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(2, 4, "xyz");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="abxyzba");
	}  

	{ // Replace super set
	  auto input=new ANTLRStringStream!(char_t)("abcccba");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(2, 4, "xyz");
	  stream.replace(2, 5, "foo"); // kills previous replace
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="abfooa");
	}  


	{ // Replace lower index super set
	  auto input=new ANTLRStringStream!(char_t)("abcccba");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(2, 4, "xyz");
	  // executes first since 1<2; then ignores replace@2 as it skips
	  // over 1..3
	  stream.replace(1, 3, "foo");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="afoocba");
	}  


	{ // Replace single middle index and then overlapping superset
	  auto input=new ANTLRStringStream!(char_t)("abcba");
	  lexer=new t048rewriteLexer!(char_t)(input);
	  auto stream=new TokenRewriteStream!(char_t)(lexer);
	  stream.LT(1);
	  stream.replace(2, 2, "xyz");
	  stream.replace(0, 3, "foo");
	  // Stdout(stream.toStringT).nl;
	  assert(stream.toStringT=="fooa");
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
