grammar t022scopes;

options {
    language=D;
}

/* global scopes */

scope aScope {
char_t[][] names;
}

@parser::header {
module antlr.runtime.t022scopesParser;
import Integer = tango.text.convert.Integer;
import tango.util.container.HashSet;
import antlr.runtime.RuntimeException;

        }

@lexer::header {
module antlr.runtime.t022scopesLexer;

        }

@parser::members {
  alias HashSet!(immutable(char_t)[]) Set;
  override void emitErrorMessage(immutable(char)[] msg) {
    return;
  }
  override void reportError(RecognitionException!(char_t) e) {
    throw new RuntimeException(e.toString);
  }
}


a
scope aScope;
    :   {$aScope::names.length = 0;} ID*
    ;


/* rule scopes, from the book, final beta, p.147 */

b[bool v]
scope {bool x;}
    : {$b::x = v; } b2
    ;

b2
    : b3
    ;

b3
    : {$b::x}?=> ID // only visible, if b was called with True
    | NUM
    ;


/* rule scopes, from the book, final beta, p.148 */

c returns [Set res]
scope {
    Set symbols;
}
@init {
    $c::symbols=new Set;
}
    : '{' c1* c2+ '}'
        { $res = $c::symbols; }
    ;

c1
    : 'int' ID {$c::symbols.add($ID.text);} ';'
    ;

c2
    : ID '=' NUM ';'
        {
             if (!$c::symbols.contains($ID.text))
                throw new RuntimeException(cast(immutable(char)[])$ID.text);
        }
    ;

/* recursive rule scopes, from the book, final beta, p.150 */

d returns [Set res]
scope {
    Set symbols;
}
@init {
    $d::symbols=new Set;
}
    : '{' d1* d2* '}'
        { $res = $d::symbols; }
    ;


d1    : 'int' ID {$d::symbols.add($ID.text);} ';'
    ;

d2
    : ID '=' NUM ';'
        {
            foreach (s; $d)
                {
                    if (s.symbols.contains($ID.text))
                        break;
                    else
                        throw new RuntimeException(cast(immutable(char)[])$ID.text);
                }
        }
    | d
    ;

/* recursive rule scopes, access bottom-most scope */

e returns [int res]
scope {
    int a;
}
@after {
    $res = $e::a;
}
    : NUM { $e[0]::a =cast(int) Integer.parse($NUM.text); }
    | '{' e '}'
    ;


/* recursive rule scopes, access with negative index */

f returns [int res]
scope {
    int a;
}
@after {
    $res = $f::a;
}
    : NUM { $f[-2]::a = cast(int)Integer.parse($NUM.text); }
    | '{' f '}'
    ;



/* tokens */

ID  :   ('a'..'z')+
    ;

NUM :   ('0'..'9')+
    ;

WS  :   (' '|'\n'|'\r')+ {$channel=HIDDEN;}
    ;
