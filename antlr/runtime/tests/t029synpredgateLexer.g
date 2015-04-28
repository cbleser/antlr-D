lexer grammar t029synpredgateLexer;
options {
  language = D;
}

@lexer::header {
module antrl.runtime.tests.t029synpredgateLexer;
        }

FOO
    : ('ab')=> A
    | ('ac')=> B
    ;

fragment
A: 'a';

fragment
B: 'a';

