
#GRAMMERS= DefaultTemplate.g Interface.g    


GRAMMARS= DefaultTemplate.g ActionEvaluator.g Group.g AngleBracketTemplate.g Interface.g    

#GRAMMARS= ActionEvaluator.g Group.g Action.g Interface.g    

GRAMMARDIR=language

GRAMMARDFILES:=ActionEvaluator.d 
GRAMMARDFILES+=GroupLexer.d GroupParser.d 
GRAMMARDFILES+=InterfaceLexer.d InterfaceParser.d 
GRAMMARDFILES+=ActionLexer.d ActionParser.d
GRAMMARDFILES+=DefaultTemplateLexer.d DefaultTemplateParser.d

GRAMMARDFILES:=${addprefix $(GRAMMARDIR)/,$(GRAMMARDFILES)}

PARSERDIR:=$(PWD)/$(GRAMMARDIR)

#ANTLR=antlr
ANTLR=antlrd
ANTLRFLAGS=-lib $(PARSERDIR)

ANTLROBJ:=${GRAMMARDFILES:.d=.o}
ANTLROBJ:=$(addprefix $(GRAMMARDIR)/, $(ANTLROBJ))

DFLAGS=-fversion=EnableVararg
DFILES:=$(GRAMMMARDFILES)
DFILES+=StringTemplateGroupInterface.d
#DFILES+=test/TestStringTemplate.d
DFILES+=StringTemplateWriter.d
DFILES+=StringTemplateErrorListener.d
DFILES+=NoIndentWriter.d
DFILES+=StringTemplateGroup.d
DFILES+=CommonGroupLoader.d
DFILES+=StringTemplate.d
#DFILES+=language/ArrayWrappedInList.d
#DFILES+=language/ArrayIterator.d
DFILES+=language/StringRef.d
#DFILES+=language/ActionEvaluator.d
DFILES+=language/NewlineRef.d
DFILES+=language/TemplateParserTokenTypes.d
#DFILES+=language/Cat.d
DFILES+=language/ASTExpr.d
DFILES+=language/ChunkToken.d
DFILES+=language/GroupParserTokenTypes.d
DFILES+=language/FormalArgument.d
#DFILES+=language/GroupParser.d
#DFILES+=language/ActionParser.d
DFILES+=language/StringTemplateToken.d
#DFILES+=language/GroupLexer.d
DFILES+=language/AngleBracketTemplateLexerTokenTypes.d
#DFILES+=language/InterfaceParser.d
DFILES+=language/ConditionalExpr.d
DFILES+=language/InterfaceParserTokenTypes.d
DFILES+=language/StringTemplateAST.d
DFILES+=language/ActionParserTokenTypes.d
DFILES+=language/ActionEvaluatorTokenTypes.d
DFILES+=PathGroupLoader.d
DFILES+=AttributeRenderer.d
#DFILES+=misc/DTreeStringTemplateModel.d
#DFILES+=misc/StringTemplateTreeView.d
#DFILES+=misc/DTreeStringTemplatePanel.d
DFILES+=AutoIndentWriter.d
DFILES+=StringTemplateGroupLoader.d

ifndef REPOROOT
REPOROOT  :=$(shell bzr root)
endif
include $(REPOROOT)/scripts/basic.mk

#TANGO_DIR:=$(REPOROOT)/tango/
GDC_LIB_DIR:=/usr/lib

INC+=-I$(REPOROOT)/antlr/


#all: $(OBJ)

# Setup compilation of dfiles
ifdef OBJPASS
$(COMPILEDFILES)
all: $(OBJ)
else
all: $(GRAMMARDFILES)
	$(MAKE) OBJPASS=1 all
endif

#info: $(OBJ) $(ANTLROBJ)
#	echo $(PARSERS)
#	echo $(LEXERS)

info:
	@echo $(OBJ)
	@echo $(GRAMMARDFILES)


ifndef OBJPASS
%Lexer.d %Parser.d %.d:%.g
	$(ANTLR) $(ANTLRFLAGS) $< 
endif

# %.o:%.d
# 	$(DC) $(INC) $(DFLAGS) -c $< -of$@



#/home/cbr/src/work/varwolf/obj/antlr.stringtemplate.StringTemplateGroupLoader.o

clean:
	rm -f $(GRAMMARDFILES) 
