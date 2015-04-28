lexer grammar t020fuzzyLexer;
options {
    language=D;
    filter=true;
}

@lexer::header {
module antlr.runtime.tests.t020fuzzyLexer;
import tango.text.Text;
alias Text!(char) Output;
}

@lexer::members {
public Output output;
        }
        
@lexer::init {
    output = new typeof(output);
}

IMPORT
	:	'import' WS name=QIDStar WS? ';'
	;
	
/** Avoids having "return foo;" match as a field */
RETURN
	:	'return' (options {greedy=false;}:.)* ';'
	;

CLASS
	:	'class' WS name=ID WS? ('extends' WS QID WS?)?
		('implements' WS QID WS? (',' WS? QID WS?)*)? '{'
        {output.format("found class {}\n", $name.text);}
	;
	
METHOD
    :   TYPE WS name=ID WS? '(' ( ARG WS? (',' WS? ARG WS?)* )? ')' WS? 
       ('throws' WS QID WS? (',' WS? QID WS?)*)? '{'
        {output.format("found method {}\n", $name.text);}
    ;

FIELD
    :   TYPE WS name=ID '[]'? WS? (';'|'=')
        {output.format("found var {}\n", $name.text);}
    ;

STAT:	('if'|'while'|'switch'|'for') WS? '(' ;
	
CALL
    :   name=QID WS? '('
        {output.format("found call {}\n", $name.text);}
    ;

COMMENT
    :   '/*' (options {greedy=false;} : . )* '*/'
        {output.format("found comment {}\n",Text());}
    ;

SL_COMMENT
    :   '//' (options {greedy=false;} : . )* '\n'
        {output.format("found // comment {}\n",Text());}
    ;
	
STRING
	:	'"' (options {greedy=false;}: ESC | .)* '"'
	;

CHAR
	:	'\'' (options {greedy=false;}: ESC | .)* '\''
	;

WS  :   (' '|'\t'|'\n')+
    ;

fragment
QID :	ID ('.' ID)*
	;
	
/** QID cannot see beyond end of token so using QID '.*'? somewhere won't
 *  ever match since k=1 lookahead in the QID loop of '.' will make it loop.
 *  I made this rule to compensate.
 */
fragment
QIDStar
	:	ID ('.' ID)* '.*'?
	;

fragment
TYPE:   QID '[]'?
    ;
    
fragment
ARG :   TYPE WS ID
    ;

fragment
ID  :   ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'_'|'0'..'9')*
    ;

fragment
ESC	:	'\\' ('"'|'\''|'\\')
	;
