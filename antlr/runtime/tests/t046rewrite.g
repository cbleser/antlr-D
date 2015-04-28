
grammar t046rewrite;
options {
    language=D;
}

@parser::header {
module antlr.runtime.tests.t046rewriteParser;
import tango.util.container.HashSet;
import antlr.runtime.TokenRewriteStream;

        }

@lexer::header {
module antlr.runtime.tests.t046rewriteLexer;
        }

@parser::members{
alias TokenRewriteStream!(char_t) TokenRewriteStreamT;
TokenT start;
alias HashSet!(immutable(char_t)[]) Set;
        }

program
@init {
    start = input.LT(1);
}
    :   method+
        {
            (cast(TokenRewriteStreamT)input).insertBefore(start,"public class Wrapper {\n");
            (cast(TokenRewriteStreamT)input).insertAfter($method.stop, "\n}\n");
        }
    ;

method
    :   m='method' ID '(' ')' dbody {
            (cast(TokenRewriteStreamT)input).replace($m, "public void");
        }
    ;

dbody
scope {
    Set decls;
}
@init {
    $dbody::decls = new typeof($dbody::decls);
}
    :   lcurly='{' stat* '}' {
          foreach(it;$dbody::decls.toArray.sort) {
            (cast(TokenRewriteStreamT)input).insertAfter($lcurly, "\nint "~it~";");
          }
        }
    ;

stat:   ID '=' expr ';' {$dbody::decls.add($ID.text);}
    ;

expr:   mul ('+' mul)*
    ;

mul :   atom ('*' atom)*
    ;

atom:   ID
    |   INT
    ;

ID  :   ('a'..'z'|'A'..'Z')+ ;

INT :   ('0'..'9')+ ;

WS  :   (' '|'\t'|'\n')+ {$channel=HIDDEN;}
    ;
