module antlr.runtime.tests.parser_t047treeparser;

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
import antlr.runtime.RuntimeException;
import antlr.runtime.tree.CommonTreeNodeStream;
import tango.io.Stdout;

import antlr.runtime.tests.t047treeparserLexer;
import antlr.runtime.tests.t047treeparserParser;
import antlr.runtime.tests.t047treeparserWalker;

template main_test(char_t) {
    void main_test(){
        t047treeparserLexer!(char_t) lexer;
        t047treeparserParser!(char_t) parser;
        immutable(char_t)[] stream_in=
            "char c;\n"
            "int x;\n"
            "\n"
            "void bar(int x);\n"
            "\n"
            "int foo(int y, char d) {\n"
            "  int i;\n"
            "  for (i=0; i<3; i=i+1) {\n"
            "    x=3;\n"
            "    y=5;\n"
            "  }\n"
            "}\n";
        { // Valid test 1
            auto input=new ANTLRStringStream!(char_t)(stream_in);
            lexer=new t047treeparserLexer!(char_t)(input);
            auto tokens=new CommonTokenStream!(char_t)(lexer);
            parser=new t047treeparserParser!(char_t)(tokens);
            auto r=parser.program;
            //   Stdout(stream.toString16).nl;
            // assert(stream.toString16==stream_out);
            // Stdout(r.tree.toStringTree).nl;
            auto t=r.getTree;
            // Stdout(t.toStringTree).nl;
            assert(t.toStringTree == "(VAR_DEF char c) (VAR_DEF int x) (FUNC_DECL (FUNC_HDR void bar (ARG_DEF int x))) (FUNC_DEF (FUNC_HDR int foo (ARG_DEF int y) (ARG_DEF char d)) (BLOCK (VAR_DEF int i) (for (= i 0) (< i 3) (= i (+ i 1)) (BLOCK (= x 3) (= y 5)))))");

            auto nodes = new CommonTreeNodeStream!(char_t)(t);

            nodes.setTokenStream(tokens);
            // Stdout.formatln("nodes={}",nodes.toStringT);
            auto walker = new t047treeparserWalker!(char_t)(nodes);

            walker.program();

            // foreach(i,trace;walker.traces.toArray) {
            // 	Stdout.formatln("{}] {} ", i,trace).nl;
            // }
            assert(walker.traces.toArray ==
                [ ">program", ">declaration", ">variable", ">type", "<type",
                    ">declarator", "<declarator", "<variable", "<declaration",
                    ">declaration", ">variable", ">type", "<type", ">declarator",
                    "<declarator", "<variable", "<declaration", ">declaration",
                    ">functionHeader", ">type", "<type", ">formalParameter",
                    ">type", "<type", ">declarator", "<declarator",
                    "<formalParameter", "<functionHeader", "<declaration",
                    ">declaration", ">functionHeader", ">type", "<type",
                    ">formalParameter", ">type", "<type", ">declarator",
                    "<declarator", "<formalParameter", ">formalParameter", ">type",
                    "<type", ">declarator", "<declarator", "<formalParameter",
                    "<functionHeader", ">block", ">variable", ">type", "<type",
                    ">declarator", "<declarator", "<variable", ">stat", ">forStat",
                    ">expr", ">expr", ">atom", "<atom", "<expr", "<expr", ">expr",
                    ">expr", ">atom", "<atom", "<expr", ">expr", ">atom", "<atom",
                    "<expr", "<expr", ">expr", ">expr", ">expr", ">atom", "<atom",
                    "<expr", ">expr", ">atom", "<atom", "<expr", "<expr", "<expr",
                    ">block", ">stat", ">expr", ">expr", ">atom", "<atom", "<expr",
                    "<expr", "<stat", ">stat", ">expr", ">expr", ">atom", "<atom",
                    "<expr", "<expr", "<stat", "<block", "<forStat", "<stat",
                    "<block", "<declaration", "<program"
                    ]
                );
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
