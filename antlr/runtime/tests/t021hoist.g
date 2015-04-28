grammar t021hoist;
options {
    language=D;
}

@parser::header {
module antlr.runtime.tests.t021hoistParser;
        }

@lexer::header {
module antlr.runtime.tests.t021hoistLexer;
        }

@parser::members {
   bool enableEnum;
   alias immutable(char_t)[] string_t;
        }

/* With this true, enum is seen as a keyword.  False, it's an identifier */
@parser::init {
  enableEnum = false;
}

stat returns [string_t enumIs]
    : identifier    {enumIs = "ID";}
    | enumAsKeyword {enumIs = "keyword";}
    ;

identifier
    : ID
    | enumAsID
    ;

enumAsKeyword : {enableEnum}? 'enum' ;

enumAsID : {!enableEnum}? 'enum' ;

ID  :   ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
    ;

INT :	('0'..'9')+
    ;

WS  :   (   ' '
        |   '\t'
        |   '\r'
        |   '\n'
        )+
        {$channel=HIDDEN;}
    ;
