grammar t016actions;
options {
  language = D;
}

@lexer::header {
module antlr.rutime.tests.t016actionsLexer;
}

@parser::header {
module antlr.rutime.tests.t016actionsParser;

}

@parser::members {
alias immutable(char_t)[] string_t;
        }

declaration returns [string_t name]
    :   functionHeader ';'
        {$name = $functionHeader.name;}
    ;

functionHeader returns [string_t name]
    :   type ID
	{$name = $ID.text;}
    ;

type
    :   'int'
    |   'char'
    |   'void'
    ;

ID  :   ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
    ;

WS  :   (   ' '
        |   '\t'
        |   '\r'
        |   '\n'
        )+
        {$channel=HIDDEN;}
    ;
