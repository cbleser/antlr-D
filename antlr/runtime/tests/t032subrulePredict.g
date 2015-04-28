grammar t032subrulePredict;
options {
  language = D;
}

@parser::header {
module antlr.runtime.tests.t032subrulePredictParser;
        }

@lexer::header {
module antlr.runtime.tests.t032subrulePredictLexer;
        }


a: 'BEGIN' b WS+ 'END';
b: ( WS+ 'A' )+;
WS: ' ';
