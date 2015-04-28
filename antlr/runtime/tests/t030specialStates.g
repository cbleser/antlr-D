grammar t030specialStates;
options {
  language = D;
}

@parser::header {
module antlr.runtime.tests.t030specialStatesParser;
        }

@lexer::header {
module antlr.runtime.tests.t030specialStatesLexer;
        }

@parser::members {
  bool cond;
        }

@parser::init {
  cond = true;
}

@lexer::members {
  override void recover(RecognitionExceptionT re) {
    // no error recovery yet, just crash!
    assert(0);
        }
}

r
    : ( {cond}? NAME
        | {!cond}? NAME WS+ NAME
        )
        ( WS+ NAME )?
        EOF
    ;

NAME: ('a'..'z') ('a'..'z' | '0'..'9')+;
NUMBER: ('0'..'9')+;
WS: ' '+;
