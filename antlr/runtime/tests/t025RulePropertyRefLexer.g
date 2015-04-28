lexer grammar t025RulePropertyRefLexer;
options {
  language = D;
}

@lexer::header {
module antlr.runtime.tests.t025RulePropertyRefLexer;
import tango.util.container.LinkedList;
        }

@lexer::members {
struct lexerProperty {
    immutable(char_t)[] text;
    int type;
    int line;
    int pos;
    int index;
    int channel;
    int start;
    int stop;
    void OpCall(
        immutable(char_t)[] text,
        int type,
        int line,
        int pos,
        int index,
        int channel,
        int start,
        int stop)
    {
        this.text=text;
        this.type=type;
        this.line=line;
        this.pos=pos;
        this.index=index;
        this.channel=channel;
        this.start=start;
        this.stop=stop;

    }
};

LinkedList!(lexerProperty) properties;
}

@lexer::init {
  properties = new typeof(properties);
}

IDENTIFIER:
        ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
        {
            properties.append(
                lexerProperty
($text, $type, $line, $pos, $index, $channel, $start, $stop)
                              );
        }
;


WS: (' ' | '\n')+
  ;
