lexer grammar t004Lexer;
options {
  language = D;
}

@lexer::header {
module antlr.runtime.tests.t004Lexer;
}


FOO: 'f' 'o'*;
