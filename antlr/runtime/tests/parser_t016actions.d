module antlr.runtime.tests.parser_t016actions;

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

import antlr.runtime.tests.t016actionsLexer;
import antlr.runtime.tests.t016actionsParser;


template main_test(char_t) {
    void main_test(){
        immutable(char_t)[] name;
        // Valid test 01
        auto input=new ANTLRStringStream!(char_t)("int foo;");
        auto lexer=new t016actionsLexer!(char_t)(input);
        auto stream=new CommonTokenStream!(char_t)(lexer);
        auto parser=new t016actionsParser!(char_t)(stream);
        name=parser.declaration();
        //  Stdout.format("name={}",name).newline;
        assert(name == "foo");


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
