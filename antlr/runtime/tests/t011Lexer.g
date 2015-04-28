lexer grammar t011Lexer;
options {
  language = D;
}

@lexer::header {
module antlr.rutime.tests.t011Lexer;
}



IDENTIFIER: 
        ('a'..'z'|'A'..'Z'|'_') 
        ('a'..'z'
        |'A'..'Z'
        |'0'..'9'
        |'_'
            { 
              Stdout("Underscore") 
              ("foo");
            }
        )*
    ;

WS: (' ' | '\n')+;
