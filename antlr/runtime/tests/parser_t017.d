module antlr.runtime.tests.parser_t017;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.MismatchedRangeException;
import antlr.runtime.NoViableAltException;
import antlr.runtime.RecognitionException;
import antlr.runtime.CommonTokenStream;
import tango.io.Stdout;

import antlr.runtime.tests.t017Lexer;
import antlr.runtime.tests.t017Parser;

template main_test(char_t) {
    void main_test(){
        immutable(char_t)[] name;
        // Valid test 01
        auto input=new ANTLRStringStream!(char_t)("int foo;");
        auto lexer=new t017Lexer!(char_t)(input);
        auto stream=new CommonTokenStream!(char_t)(lexer);
        auto parser=new t017Parser!(char_t)(stream);
        parser.program();
        //  Stdout.format("name={}",name).newline;
        assert(parser.reportedErrors.size == 0);

        // Mal formed input test 1
        input=new ANTLRStringStream!(char_t)("int foo { 1+2 };");
        lexer=new t017Lexer!(char_t)(input);
        stream=new CommonTokenStream!(char_t)(lexer);
        parser=new t017Parser!(char_t)(stream);
        parser.program();
        //  Stdout.format("name={}",name).newline;
        assert(parser.reportedErrors.size == 1);


         // Mal formed input test 2
        input=new ANTLRStringStream!(char_t)("int foo() { 1+; 1+2 };");
        lexer=new t017Lexer!(char_t)(input);
        stream=new CommonTokenStream!(char_t)(lexer);
        parser=new t017Parser!(char_t)(stream);
        parser.program();

        //  Stdout.format("name={}",name).newline;
        assert(parser.reportedErrors.size == 2);

        Stdout
            .format("passed: {}, {}",typeid(typeof(parser)),typeid(typeof(lexer)))
            .newline;

    }
}

int main() {
    main_test!(char);
    main_test!(wchar);
    main_test!(dchar);
    return 0;
}
