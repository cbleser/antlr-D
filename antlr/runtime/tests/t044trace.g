grammar t044trace;
options {
  language = D;
}

@parser::header {
module antlr.runtime.tests.t044traceParser;
import tango.util.container.LinkedList;
        }

@lexer::header {
module antlr.runtime.tests.t044traceLexer;
import tango.util.container.LinkedList;
import antlr.runtime.RuntimeException;


        }

@parser::members {
  LinkedList!(const(char)[]) _stack;
  LinkedList!(immutable(char)[]) traces;
  override void traceIn(immutable(char)[] ruleName, int ruleIndex) {
      traces.append(">"~ruleName);
  }

  override void traceOut(immutable(char)[] ruleName, int ruleIndex) {
      traces.append("<"~ruleName);
  }
        }

@lexer::members {
  LinkedList!(immutable(char)[]) traces;
  override void traceIn(immutable(char)[] ruleName, int ruleIndex) {
      traces.append(">"~ruleName);
  }

  override void traceOut(immutable(char)[] ruleName, int ruleIndex) {
      traces.append("<"~ruleName);
  }

  override void recover(RecognitionExceptionT re) {
      throw new RuntimeException("No error recovery yet, just crash!");
  }
        }

@lexer::init {
   traces=new typeof(traces);
        }

@parser::init {
   _stack = null;
   traces=new typeof(traces);
}

a: '<' ((INT '+')=>b|c) '>';
b: c ('+' c)*;
c: INT
    {
        if (_stack is null) {
            _stack = getRuleInvocationStack();
        }
    }
    ;

INT: ('0'..'9')+;
WS: (' ' | '\n' | '\t')+ {$channel = HIDDEN;};
