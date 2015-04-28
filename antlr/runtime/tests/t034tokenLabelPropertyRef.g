grammar t034tokenLabelPropertyRef;
options {
  language = D;
}

@parser::header {
module antlr.runtime.tests.t034tokenLabelPropertyRefParser;
        }

@lexer::header {
module antlr.runtime.tests.t034tokenLabelPropertyRefLexer;
        }


a: t=A
        {
            /+
            Stdout( $t.text ).newline;
            Stdout( $t.type ).newline;
            Stdout( $t.line ).newline;
            Stdout( $t.pos ).newline;
            Stdout( $t.channel ).newline;
            Stdout( $t.index ).newline;
            +/
            assert($t.text=="a");
            assert($t.type==4);
            assert($t.line==1);
            assert($t.pos==3);
            assert($t.channel==0);
            assert($t.index==1);

            // print $t.tree
        }
    ;

A: 'a'..'z';

WS  :
        (   ' '
        |   '\t'
        |  ( '\n'
            |	'\r\n'
            |	'\r'
            )
        )+
        { $channel = HIDDEN; }
    ;    

