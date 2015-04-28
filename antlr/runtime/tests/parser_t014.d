module antlr.runtime.tests.parser_t014;

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

import antlr.runtime.tests.t014Lexer;
import antlr.runtime.tests.t014Parser;

import antlr.runtime.BitSet;


template main_test(char_t) {
    void main_test(){
        t014Parser!(char_t).pair pairA;
        auto input=new ANTLRStringStream!(char_t)("var foobar; gnarz(); var blupp; flupp ( ) ;");
        auto lexer=new t014Lexer!(char_t)(input);
        auto stream=new CommonTokenStream!(char_t)(lexer);
        auto parser=new t014Parser!(char_t)(stream);
        parser.document();
        assert(parser.reportedErrors.size==0);
        // pairA=parser.events.removeHead;
        //pairB=t014Parser.pair("decl","foobar");
        assert(parser.events.removeHead==t014Parser!(char_t).pair("decl","foobar"));
        assert(parser.events.removeHead==t014Parser!(char_t).pair("call","gnarz"));
        assert(parser.events.removeHead==t014Parser!(char_t).pair("decl","blupp"));
        assert(parser.events.removeHead==t014Parser!(char_t).pair("call","flupp"));
        // Mal formed input 1
        input=new ANTLRStringStream!(char_t)("var; for();");
        lexer=new t014Lexer!(char_t)(input);
        stream=new CommonTokenStream!(char_t)(lexer);
        parser=new t014Parser!(char_t)(stream);
        parser.document();
        assert(parser.reportedErrors.size==1);
        assert(parser.events.size == 0);

        // Mal formed input 2
        input=new ANTLRStringStream!(char_t)("var foobar(); gnarz();");
        lexer=new t014Lexer!(char_t)(input);
        stream=new CommonTokenStream!(char_t)(lexer);
        parser=new t014Parser!(char_t)(stream);
        parser.document();
        assert(parser.reportedErrors.size==1);
        assert(parser.events.size > 0);
        assert(parser.events.removeHead==t014Parser!(char_t).pair("call","gnarz"));

        // Mal formed input 3
        input=new ANTLRStringStream!(char_t)("gnarz(; flupp();");
        lexer=new t014Lexer!(char_t)(input);
        stream=new CommonTokenStream!(char_t)(lexer);
        parser=new t014Parser!(char_t)(stream);
        parser.document();
        assert(parser.reportedErrors.size==1);
        assert(parser.events.size > 0);
        assert(parser.events.removeHead==t014Parser!(char_t).pair("call","gnarz"));
        assert(parser.events.removeHead==t014Parser!(char_t).pair("call","flupp"));


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
