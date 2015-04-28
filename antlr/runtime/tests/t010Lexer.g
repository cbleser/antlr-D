lexer grammar t010Lexer;
options {
  language = D;
}

@lexer::header {
module antlr.rutime.tests.t010Lexer;
}


IDENTIFIER: ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
WS: (' ' | '\n')+;
