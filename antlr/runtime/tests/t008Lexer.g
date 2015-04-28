lexer grammar t008Lexer;
options {
  language = D;
}

@lexer::header {
module antlr.rutime.tests.t008Lexer;
}

FOO: 'f' 'a'?;
