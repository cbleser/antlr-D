grammar t041parameters;
options {
  language = D;
}

@parser::header {
module antlr.runtime.tests.t041parametersParser;

class Pair(string_t) {
    string_t arg1;
    string_t arg2;
    this (string_t arg1, string_t arg2) {
        this.arg1=arg1; this.arg2=arg2;
    }
}
        }

@parser::members {
alias immutable(char_t)[] string_t;
alias Pair!(string_t) PairT;
        }

@lexer::header {
module antlr.runtime.tests.t041parametersLexer;
        }


a[string_t arg1, string_t arg2] returns [PairT l]
    : A+ EOF
        {
            l = new PairT($arg1, $arg2);
            $arg1 = "gnarz";
        }
    ;

A: 'a'..'z';

WS: ' '+  { $channel = HIDDEN; };
