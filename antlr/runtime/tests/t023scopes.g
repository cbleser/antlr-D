grammar t023scopes;

options {
    language=D;
}

@parser::header {
module antlr.runtime.t023scopesParser;
        }

@lexer::header {
module antlr.runtime.t023scopesLexer;
        }

prog
scope {
  immutable(char_t)[] name;
}
    :   ID {$prog::name=$ID.text;}
    ;

ID  :   ('a'..'z')+
    ;

WS  :   (' '|'\n'|'\r')+ {$channel=HIDDEN;}
    ;
