grammar t026actions;
options {
  language = D;
}

@lexer::header {
module antlr.runtime.tests.t026actionsLexer;

import tango.util.container.LinkedList;
        }

@parser::header {
module antlr.runtime.tests.t026actionsParser;
import tango.util.container.LinkedList;
        }


@parser::members {
  public char_t[] _output;
  private LinkedList!(immutable(char)[]) _error;
  private void capture(immutable(char_t)[] t) {
      _output ~= t;
  }

  override void emitErrorMessage(immutable(char)[] msg) {
      _error.append(msg);
  }
        }

@lexer::members {
  private immutable(char_t)[] foobar;
  public  immutable(char_t)[] _output;
  private LinkedList!(immutable(char)[]) _error;
  private void capture(immutable(char_t)[] t) {
      _output ~= t;
  }

  override void emitErrorMessage(immutable(char)[] msg) {
      _error.append(msg);
  }
        }

@lexer::init {
    foobar = "attribute;";
    _error = new typeof(_error);
}

@parser::init {
    _error = new typeof(_error);
}

prog
@init {
    capture("init;");
}
@after {
    capture("after;");
}
    :   IDENTIFIER EOF
    ;
    catch [ RecognitionExceptionT exc ] {
        capture("catch;");
        //throw exc;
    }
    finally {
        capture("finally;");
    }


IDENTIFIER
    : ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
        {
            // a comment
            capture("action;");
            capture(FormatT("'{}' {} {} {} {} {} {} {};", $text, $type, $line, $pos, $index, $channel, $start, $stop).idup);
            capture(foobar);
        }
    ;

WS: (' ' | '\n')+;
