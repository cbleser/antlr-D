grammar t014;
options {
  language = D;
}

@lexer::header {
module antlr.rutime.tests.t014Lexer;
}

@parser::header {
module antlr.rutime.tests.t014Parser;
import tango.util.container.LinkedList;
}

@parser::init {
  events =  new typeof(events);
  reportedErrors = new typeof(reportedErrors);
}

@lexer::init {
  // -- Lexer Init functions
}

@parser::members {
  struct pair {
    immutable(char_t)[] label;
    immutable(char_t)[] token;
    int opEquals(pair p) {
        return((p.label==this.label)&&(p.token==this.token));
    }
    immutable(char_t)[] toString() {
        return (label~":"~token).idup;
    }
  };
  LinkedList!(pair) events;
  LinkedList!(immutable(char)[]) reportedErrors;


  override void emitErrorMessage(immutable(char)[] msg) {
      reportedErrors.append(msg);
          }
        }


document:
        ( declaration
        | call
        )*
        EOF
    ;

declaration:
        'var' t=IDENTIFIER ';'
        {events.append(pair("decl", $t.text));}
    ;

call:
        t=IDENTIFIER '(' ')' ';'
        {events.append(pair("call", $t.text));}
    ;

IDENTIFIER: ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
WS:  (' '|'\r'|'\t'|'\n') {$channel=HIDDEN;};
