grammar t024finally;

options {
    language=D;
}

@parser::header {
module antlr.runtime.tests.t024finallyParser;
import tango.util.container.LinkedList;
import antlr.runtime.RuntimeException;
alias LinkedList!(immutable(wchar)[]) List;
        }

@lexer::header {
module antlr.runtime.tests.t024finallyLexer;
        }


prog returns [List events]
@init {events=new List;}
@after {events.append("after");}
    :   ID {throw new RuntimeException(cast(immutable(char)[])$ID.text);}
    ;
    catch [RuntimeException e] {events.append("catch");}
    finally {events.append("finally");}

ID  :   ('a'..'z')+
    ;

WS  :   (' '|'\n'|'\r')+ {$channel=HIDDEN;}
    ;
