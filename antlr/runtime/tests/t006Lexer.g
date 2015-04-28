lexer grammar t006Lexer;
options {
  language = D;
}

@lexer::header {
module antlr.rutime.tests.t006Lexer;
}


FOO: 'f' ('o' | 'a')*;
