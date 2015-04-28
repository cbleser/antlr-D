grammar t039labels;
options {
  language = D;
}

@parser::header {
module antlr.runtime.tests.t039labelsParser;
import tango.util.container.LinkedList;
        }

@lexer::header {
module antlr.runtime.tests.t039labelsLexer;
        }

@parser::members {
class Label {
    LinkedList!(TokenT) ids;
    TokenT w;
    this (LinkedList!(TokenT) ids, TokenT w) {
        this.ids=ids;
        this.w=w;
    }
}
        }

a returns [Label l]
    : ids+=A ( ',' ids+=(A|B) )* C D w=. ids+=. F EOF
        { l = new Label($ids, $w); }
    ;

A: 'a'..'z';
B: '0'..'9';
C: a='A' { Stdout.format("'{}' ", $a).nl; };
D: a='FOOBAR' { Stdout.format("'{}' ",$a.text).nl; };
E: 'GNU' a=. { Stdout($a).nl; };
F: 'BLARZ' a=EOF { Stdout($a).nl; };

WS: ' '+  { $channel = HIDDEN; };
