grammar t036multipleReturnValues;
options {
  language = D;
}

@parser::header {
module antr.runtime.tests.t036multipleReturnValuesParser;

        }

@parser::members {
   alias immutable(char_t)[] string_t;
        }

@lexer::header {
module antr.runtime.tests.t036multipleReturnValuesLexer;
        }

@lexer::members {
   alias immutable(char_t)[] string_t;
        }

a returns [string_t foo, string_t bar]: A
        {
            $foo = "foo";
            $bar = "bar";
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

