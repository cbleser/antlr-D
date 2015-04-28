grammar t050decorate;
options {
  language = D;
}

@parser::header {
module antlr.runtime.tests.t050decorateParser;
import tango.util.container.more.Stack;
}

@lexer::header {
module antlr.runtime.tests.t050decorateLexer;
}

@parser::init {
}

@parser::members {
   Stack!(wchar[]) events;
   void decorated(ref int args, ref wchar[][] kwargs) {
     events.append("before");
       try {
         return func(args, kwargs);
       } finally {
           events.append("after");
       }
       // return decorated
   }
        }

document
@decorate {
    logme
}
    : IDENTIFIER
    ;

IDENTIFIER: ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
