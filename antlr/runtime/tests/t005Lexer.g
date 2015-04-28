lexer grammar t005Lexer;
options {
  language = D;
}

@lexer::header {
module antlr.rutime.tests.t005Lexer;
}


FOO: 'f' 'o'+;
