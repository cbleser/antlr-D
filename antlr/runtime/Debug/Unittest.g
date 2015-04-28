grammar Unittest;
options {
  language = D;
}

@lexer::header {
module antlr.runtime.Debug.UnittestLexer;
}

@parser::header {
module antlr.runtime.Debug.UnittestParser;
}

run: (ID|DIGIT)+;

DIGIT: ('0' .. '9')+;

ID: ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;

WS: (' ' | '\n')+ {$channel = HIDDEN;};
