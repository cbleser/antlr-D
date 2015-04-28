module antlr.runtime.tests.parser_t018llstar;

import antlr.runtime.Lexer;
import antlr.runtime.CharStream;
import antlr.runtime.Token;
import antlr.runtime.CommonToken;

import antlr.runtime.ANTLRStringStream;
import antlr.runtime.ANTLRFileStream;
import antlr.runtime.MismatchedTokenException;
import antlr.runtime.MismatchedRangeException;
import antlr.runtime.NoViableAltException;
import antlr.runtime.RecognitionException;
import antlr.runtime.CommonTokenStream;
import tango.io.Stdout;

import antlr.runtime.tests.t018llstarLexer;
import antlr.runtime.tests.t018llstarParser;


template main_test(char_t) {
    void main_test(){
        immutable(char_t)[] name;
        // Valid test 01
        auto input=new ANTLRFileStream!(char_t)("t018llstar.input");
        auto lexer=new t018llstarLexer!(char_t)(input);
        auto stream=new CommonTokenStream!(char_t)(lexer);
        auto parser=new t018llstarParser!(char_t)(stream);
        parser.program();
        name=parser.output.removeHead;
        //  Stdout(name).newline;
        assert(name == (cast(char_t[])r"bar is a declaration"));
        name=parser.output.removeHead;
        //  Stdout(name).newline;
        assert(name == (cast(char_t[])r"foo is a definition"));
        //  Stdout.format("name={}",name).newline;
        // assert(parser.reportedErrors.size == 0);


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
