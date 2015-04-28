grammar t037rulePropertyRef;
options {
  language = D;
}

@parser::header {
module antlr.runtime.tests.t037rulePropertyRefParser;
        }

@lexer::header {
module antlr.runtime.tests.t037rulePropertyRefLexer;
}


@parser::members{
            class LabelRef {
                TokenT start;
                TokenT stop;
                immutable(char_t)[] text;
                this(TokenT start, TokenT stop, immutable(char_t)[] text) {
                    this.start=start;
                    this.stop=stop;
                    this.text=text;
                }
            }
        }

a returns [LabelRef bla]
@after {
    $bla = new LabelRef($start, $stop, $text);
}
    : A+
    ;

A: 'a'..'z';

WS: ' '+  { $channel = HIDDEN; };
