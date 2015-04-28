lexer grammar t038RuleLabelLexer;
options {
  language = D;
}

@lexer::header {
module antlr.runtime.tests.t038RuleLabelLexer;
        }

A: 'a'..'z' WS '0'..'9'
        {
            Stdout(" class='")($WS)("'");
            Stdout(" type=")($WS.type);
            Stdout(" line=")($WS.line);
            Stdout(" pos=")($WS.pos);
            Stdout(" channel=")($WS.channel);
            Stdout(" index='")($WS.index)("'");
            Stdout(" text='")($WS.text)("'").newline;
        }
    ;

fragment WS  :
        (   ' '
        |   '\t'
        |  ( '\n'
            |	'\r\n'
            |	'\r'
            )
        )+

    ;    

