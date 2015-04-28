grammar t031emptyAlt;
options {
  language = D;
}

@parser::header {
module antlr.runtime.tests.t031emptyAltParser;
        }

@parser::members {
  bool cond;
        }

@parser::init {
  cond=false;
        }

@lexer::header {
module antlr.runtime.tests.t031emptyAltLexer;
        }


r
    : NAME 
        ( {cond}?=> WS+ NAME
        | 
        )
        EOF
    ;

NAME: ('a'..'z') ('a'..'z' | '0'..'9')+;
NUMBER: ('0'..'9')+;
WS: ' '+;
