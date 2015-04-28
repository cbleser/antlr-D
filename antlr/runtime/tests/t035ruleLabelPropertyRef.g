grammar t035ruleLabelPropertyRef;
options {
  language = D;
}

@parser::header {
module antlr.runtime.tests.t035ruleLabelPropertyRefParser;
        }

@lexer::header {
module antlr.runtime.tests.t035ruleLabelPropertyRefLexer;
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

a returns [LabelRef bla]: t=b
        {
            $bla=new LabelRef($t.start, $t.stop, $t.text);
        }
    ;

b: A+;

A: 'a'..'z';

WS: ' '+  { $channel = HIDDEN; };
