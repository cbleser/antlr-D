ARCH=-m64
#UNTTEST:=1
DEBUG:=1
#PROGS:= <programs>
#PROGS:=ANTLRTest
#PROGS+=TestRegexp
#DFLAGS+= -fdebug=DFA
#DFILES+= <dfiles>

UNITTESTPARSER:=Debug/UnittestLexer.d Debug/UnittestParser.d
PREBUILD+=$(UNITTESTPARSER)

DFILES+=DFA.d
DFILES+=Lexer.d
DFILES+=UnsupportedOperationException.d
DFILES+=MismatchedNotSetException.d
DFILES+=IllegalStateException.d
DFILES+=CharStream.d
DFILES+=UnwantedTokenException.d
DFILES+=EasyANTLR.d
DFILES+=Debug/UnittestLexer.d
DFILES+=Debug/ParseTreeBuilder.d
DFILES+=Debug/UnittestParser.d
DFILES+=Debug/Tracer.d
DFILES+=Debug/DebugLexer.d
DFILES+=Debug/DebugTreeParser.d
DFILES+=Debug/DebugParser.d
DFILES+=Debug/TraceDebugEventListener.d
DFILES+=Debug/DebugEventRepeater.d
DFILES+=Debug/BlankDebugEventListener.d
DFILES+=Debug/DebugEventHub.d
DFILES+=Debug/DebugTreeAdaptor.d
DFILES+=Debug/DebugTokenStream.d
DFILES+=Debug/DebugEventListener.d
DFILES+=Debug/DebugTreeNodeStream.d

DFILES+=ANTLRFileStream.d
DFILES+=NoViableAltException.d
DFILES+=TokenStream.d
DFILES+=ANTLRReaderStream.d
DFILES+=TokenSource.d
DFILES+=MismatchedSetException.d
DFILES+=FailedPredicateException.d
DFILES+=NoSuchMethodError.d
DFILES+=Base.d
#DFILES+=ANTLRTest.d
DFILES+=BitSet.d
DFILES+=MismatchedTreeNodeException.d
DFILES+=MismatchedTokenException.d
DFILES+=ANTLRStringStream.d
DFILES+=RuntimeException.d
DFILES+=EarlyExitException.d
DFILES+=MismatchedRangeException.d
DFILES+=RuleReturnScope.d
DFILES+=IntStream.d
DFILES+=CommonToken.d
DFILES+=BaseRecognizer.d
DFILES+=Token.d
DFILES+=ANTLRInputStream.d
DFILES+=CharStreamState.d
DFILES+=ParserRuleReturnScope.d
DFILES+=RecognizerSharedState.d
DFILES+=RecognitionException.d
DFILES+=CommonTokenStream.d
DFILES+=Parser.d
DFILES+=TokenRewriteStream.d

DFILES+=tango/Format.d
DFILES+=tango/Stack.d

DFILES+=ClassicToken.d
DFILES+=MissingTokenException.d
DFILES+=tree/TreeAdaptor.d
DFILES+=tree/RewriteEmptyStreamException.d
DFILES+=tree/TreeRuleReturnScope.d
DFILES+=tree/CommonTree.d
DFILES+=tree/RewriteRuleElementStream.d
DFILES+=tree/BaseTree.d
DFILES+=tree/TreeParser.d
DFILES+=tree/RewriteRuleSubtreeStream.d
DFILES+=tree/RewriteCardinalityException.d
DFILES+=tree/TreeWizard.d
DFILES+=tree/RewriteEarlyExitException.d
DFILES+=tree/CommonErrorNode.d
DFILES+=tree/TreeNodeStream.d
DFILES+=tree/TreePatternParser.d
DFILES+=tree/ParseTree.d
DFILES+=tree/TreePatternLexer.d
DFILES+=tree/RewriteRuleTokenStream.d
DFILES+=tree/CommonTreeNodeStream.d
DFILES+=tree/Tree.d
DFILES+=tree/CommonTreeAdaptor.d
DFILES+=tree/BaseTreeAdaptor.d
DFILES+=misc/Stats.d
DFILES+=misc/IntArray.d
DFILES+=misc/Format.d


#GRAMMARS:= <grammarname>.g

#Library
# LIRARCHIVE lib<name>.a
LIBFILE=libantlrd-$(DC).a
# Enable vampyra
#VAMPYRA:=1

# Initalize basic D make file
#ifndef REPOROOT
REPOROOT  ?=$(shell git root)
#endif

include $(REPOROOT)/scripts/master.mk


$(UNITTESTPARSER): Debug/Unittest.g
	$(ANTLR) $<

clean: master_clean
	rm -f $(UNITTESTPARSER)
