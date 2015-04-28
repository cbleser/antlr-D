grammar t015calc;
options {
  language = D;
}

@lexer::header {
module antlr.rutime.tests.t015calcLexer;
}

@parser::header {
module antlr.rutime.tests.t015calcParser;
import tango.util.container.LinkedList;
import Math = tango.math.Math;
import Float = tango.text.convert.Float;
import Integer = tango.text.convert.Integer;
import antlr.runtime.ANTLRStringStream;
import antlr.runtime.CommonTokenStream;
import antlr.runtime.tests.t015calcLexer;
}


@parser::init {
  reportedErrors = new typeof(reportedErrors);
}


@parser::members {
  public LinkedList!(immutable(char)[]) reportedErrors;
  public real _evaluate(immutable(char_t)[] expr) {
      auto input=new ANTLRStringStream!(char_t)(expr);
      auto lexer=new t015calcLexer!(char_t)(input);
      auto stream=new CommonTokenStream!(char_t)(lexer);
      auto parser=new t015calcParser!(char_t)(stream);
      return parser.evaluate();
  }

  override void emitErrorMessage(immutable(char)[] msg) {
      reportedErrors.append(msg);
          }
}

evaluate returns [real result]: r=expression {$result = r; };

expression returns [real result]: r=mult (
    '+' r2=mult {r += r2;}
  | '-' r2=mult {r -= r2;}
  )* {$result = r;};

mult returns [real result]: r=log (
    '*' r2=log {r *= r2;}
  | '/' r2=log {r /= r2;}
//  | '%' r2=log {r %= r2}
  )* {$result = r; };

log returns [real result]: 'ln' r=exp {$result = Math.log(r);}
    | r=exp {$result = r; }
    ;

exp returns [real result]: r=atom ('^' r2=atom {r= Math.pow(r, r2);} )? {$result = r;}
    ;

atom returns [real result]:
    n=INTEGER {$result = Float.parse($n.text);}
  | n=DECIMAL {$result = Float.parse($n.text);}
  | '(' r=expression {$result = r; } ')'
  | 'PI' {$result = Math.PI;}
  | 'E' {$result = Math.E;}
  ;

INTEGER: DIGIT+;

DECIMAL: DIGIT+ '.' DIGIT+;

fragment
DIGIT: '0'..'9';

WS: (' ' | '\n' | '\t')+ {$channel = HIDDEN;};
