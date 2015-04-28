grammar t045dfabug;
options {
    language = D;
    output = AST;
}

@parser::header {
module antlr.runtime.tests.t045dfabugParser;
        }

@lexer::header {
module antlr.runtime.tests.t045dfabugLexer;
        }

// this rule used to generate an infinite loop in DFA.predict
r
options { backtrack=true; }
    : (modifier+ INT)=> modifier+ expression
    | modifier+ statement
    ;

expression
    : INT '+' INT
    ;

statement
    : 'fooze'
    | 'fooze2'
    ;

modifier
    : 'public'
    | 'private'
    ;

ID : 'a'..'z' + ;
INT : '0'..'9' +;
WS: (' ' | '\n' | '\t')+ {$channel = HIDDEN;};

