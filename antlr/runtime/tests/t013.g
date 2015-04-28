grammar t013;
options {
  language = D;
}

@lexer::header {
module antlr.rutime.tests.t013Lexer;
}

@parser::header {
module antlr.rutime.tests.t013Parser;
import tango.util.container.LinkedList;
}

@parser::init {
  identifiers=new typeof(identifiers);
  reportedErrors= new typeof(reportedErrors);
}

@lexer::init {
  // -- Lexer Init functions
}


@parser::members {
            LinkedList!(char_t[]) identifiers;
            LinkedList!(char[]) reportedErrors;
            
            void foundIdentifier(char_t[] name) {
                identifiers.append(name);
            }
            
            override void emitErrorMessage(char[] msg) {
                reportedErrors.append(msg);
            }
        }


document:
        t=IDENTIFIER {foundIdentifier($t.text);}
        ;

IDENTIFIER: ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
