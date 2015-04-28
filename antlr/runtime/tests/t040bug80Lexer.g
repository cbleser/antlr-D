lexer grammar t040bug80Lexer; 
options {
  language = D;
}

@lexer::header {
module antlr.runtime.tests.t040bug80Lexer;
    }

ID_LIKE
    : 'defined' 
    | {false}? Identifier 
    | Identifier 
    ; 
 
fragment 
Identifier: 'a'..'z'+ ; // with just 'a', output compiles 
