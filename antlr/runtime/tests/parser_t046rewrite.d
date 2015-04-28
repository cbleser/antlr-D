module antlr.runtime.tests.parser_t046rewrite;

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
import antlr.runtime.TokenRewriteStream;
import antlr.runtime.RuntimeException;
import tango.io.Stdout;

import antlr.runtime.tests.t046rewriteLexer;
import antlr.runtime.tests.t046rewriteParser;


template main_test(char_t) {
    void main_test(){

        t046rewriteLexer!(char_t) lexer;
        t046rewriteParser!(char_t) parser;
        immutable(char_t)[] stream_out=
            "\n"
            "public class Wrapper {\n"
            "public void foo() {\n"
            "int i;\n"
            "int k;\n"
            " i = 3;\n"
            " k = i;\n"
            " i = k*4;\n"
            "}\n"
            "\n"
            "public void bar() {\n"
            "int j;\n"
            " j = i*2;\n"
            "}\n"
            "}\n"
            "\n";
        immutable(char_t)[] stream_in =
            "\n"
            "method foo() {\n"
            " i = 3;\n"
            " k = i;\n"
            " i = k*4;\n"
            "}\n"
            "\n"
            "method bar() {\n"
            " j = i*2;\n"
            "}\n";

        { // Valid test 1
            auto input=new ANTLRStringStream!(char_t)(
                stream_in
                );
            lexer=new t046rewriteLexer!(char_t)(input);
            auto stream=new TokenRewriteStream!(char_t)(lexer);
            parser=new t046rewriteParser!(char_t)(stream);
            parser.program;
            assert(stream.toStringT==stream_out);
        }


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
