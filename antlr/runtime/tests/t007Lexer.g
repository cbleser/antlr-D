lexer grammar t007Lexer;
options {
  language = D;
}

@lexer::header {
module antlr.rutime.tests.t007Lexer;
}


FOO: 'f' ('o' | 'a' 'b'+)*;
