tree grammar t047treeparserWalker;
options {
    language=D;
    tokenVocab=t047treeparser;
    ASTLabelType=CommonTree;
}

@header {
module antlr.runtime.antlr.t047treeparserWalker;
import antlr.runtime.RuntimeException;
import antlr.runtime.tree.TreeNodeStream;

        }

@members {
  LinkedList!(immutable(char)[]) traces;
  override void traceIn(immutable(char)[] ruleName, int ruleIndex) {
      traces.append(">"~ruleName);
  }

  override void traceOut(immutable(char)[] ruleName, int ruleIndex) {
      traces.append("<"~ruleName);
  }

  // void recover(TreeNodeStream!(char_t) input, RecognitionExceptionT re) {
  //     throw new RuntimeException("No error recovery yet, just crash!");
  // }

}

@treeparser::init {
   traces=new typeof(traces);
        }

program
    :   declaration+
    ;

declaration
    :  variable
    |   ^(FUNC_DECL functionHeader)
    |   ^(FUNC_DEF functionHeader block)
    ;

variable
    :   ^(VAR_DEF type declarator)
    ;

declarator
    :   ID
    ;

functionHeader
    :   ^(FUNC_HDR type ID formalParameter+)
    ;

formalParameter
    :   ^(ARG_DEF type declarator)
    ;

type
    :   'int'
    |   'char'
    |   'void'
    |   ID
    ;

block
    :   ^(BLOCK variable* stat*)
    ;

stat: forStat
    | expr
    | block
    ;

forStat
    :   ^('for' expr expr expr block)
    ;

expr:   ^(EQEQ expr expr)
    |   ^(LT expr expr)
    |   ^(PLUS expr expr)
    |   ^(EQ ID expr)
    |   atom
    ;

atom
    : ID
    | INT
    ;
