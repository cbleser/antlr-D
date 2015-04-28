grammar t043synpred;
options {
  language = D;
}

@parser::header {
module antlr.runtime.tests.t043synpredParser;
        }

@lexer::header {
module antlr.runtime.tests.t043synpredLexer;
        }

a: ((s+ P)=> s+ b)? E;
b: P 'foo';

s: S;


S: ' ';
P: '+';
E: '>';
