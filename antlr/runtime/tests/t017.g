grammar t017;

options {
    language = D;
}

@lexer::header {
module antlr.rutime.tests.t017Lexer;
}

@parser::header {
module antlr.rutime.tests.t017Parser;
import tango.util.container.LinkedList;
}

@parser::init {
  reportedErrors = new typeof(reportedErrors);
}

@parser::members {
  public LinkedList!(immutable(char)[]) reportedErrors;
  override void emitErrorMessage(immutable(char)[] msg) {
      Stdout.formatln("Error {}",msg);
      reportedErrors.append(msg);
          }
}

program
    :   declaration+
    ;

declaration
    :   variable
    |   functionHeader ';'
    |   functionHeader block
    ;

variable
    :   type declarator ';'
    ;

declarator
    :   ID
    ;

functionHeader
    :   type ID '(' ( formalParameter ( ',' formalParameter )* )? ')'
    ;

formalParameter
    :   type declarator
    ;

type
    :   'int'
    |   'char'
    |   'void'
    |   ID
    ;

block
    :   '{'
            variable*
            stat*
        '}'
    ;

stat: forStat
    | expr ';'
    | block
    | assignStat ';'
    | ';'
    ;

forStat
    :   'for' '(' assignStat ';' expr ';' assignStat ')' block
    ;

assignStat
    :   ID '=' expr
    ;

expr:   condExpr
    ;

condExpr
    :   aexpr ( ('==' | '<') aexpr )?
    ;

aexpr
    :   atom ( '+' atom )*
    ;

atom
    : ID
    | INT
    | '(' expr ')'
    ;

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