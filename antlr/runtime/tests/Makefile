
REPOROOT  ?=$(shell git root)

DC?=dmd-2.064.2

ARCH=-m64

TANGO_DIR:=$(REPOROOT)/../tango/
#TANGO_DIR:=$(HOME)/src/work/dversion/tango/
#GDC_LIB_DIR:=/usr/lib

ANTLR_DIR:=$(REPOROOT)/
#ANTLR_LIB_DIR:=../

ANTLRROOT:=../
OBJROOT:=$(ANTLRROOT)/obj/

LIBFILE:=libantlrd-$(DC).a

include $(REPOROOT)/scripts/basic.mk

## Auto parameters
EMPTY:=
SPACE:=$(EMPTY) $(EMPTY)

#DFLAGS+=-I$(TANGO_DIR)
DFLAGS+=-g -unittest
DOUT:=-of


INC:=-I$(TANGO_DIR)
INC+=-I$(ANTLR_DIR)

ifndef PROGS
PROGS:=lexer_t001
PROGS+=lexer_t002
PROGS+=lexer_t003
PROGS+=lexer_t004
PROGS+=lexer_t005
PROGS+=lexer_t006
PROGS+=lexer_t007
PROGS+=lexer_t008
PROGS+=lexer_t009
PROGS+=lexer_t010
PROGS+=lexer_t011
PROGS+=parser_t013
PROGS+=parser_t014
PROGS+=parser_t015calc
PROGS+=parser_t016actions
PROGS+=parser_t017
PROGS+=parser_t018llstar
PROGS+=lexer_t019
PROGS+=lexer_t020fuzzy
PROGS+=parser_t021hoist
PROGS+=parser_t022scopes
PROGS+=parser_t023scopes
PROGS+=parser_t024finally
PROGS+=lexer_t025RulePropertyRef
PROGS+=parser_t026actions
#PROGS+=lexer_t027eof
PROGS+=lexer_t029synpredgate
PROGS+=parser_t030specialStates
#PROGS+=parser_t031emptyAlt
PROGS+=parser_t032subrulePredict
#PROGS+=parser_t033backtracking
PROGS+=parser_t034tokenLabelPropertyRef
PROGS+=parser_t035ruleLabelPropertyRef
PROGS+=parser_t036multipleReturnValues
PROGS+=parser_t037rulePropertyRef
PROGS+=lexer_t038RuleLabel
PROGS+=parser_t039labels
PROGS+=lexer_t040bug80
PROGS+=parser_t041parameters
PROGS+=parser_t042ast
#PROGS+=parser_t042ast
PROGS+=parser_t043synpred
PROGS+=parser_t044trace
PROGS+=parser_t045dfabug
PROGS+=parser_t046rewrite
PROGS+=walker_t047treeparser
PROGS+=lexer_t048rewrite
#PROGS+=parser_t050decorate

endif

BIN=$(REPOROOT)/tools/bin/
#ANTLR:=antlr
#ANTLR:=$(REPOROOT)/scripts/antlrd
UTFMOD:=$(BIN)utfmod
DOLLAR:="$$"
#BUILD:=$(DSSS) build


LEXERFILES=$(whildcard %Lexer.d)
PARSERFILES=$(whildcard %Parser.d)

.SECONDARY: $(LEXERFILES) $(PARSERFILES)

#all: allobj $(PROGS)
all: $(PROGS)

run: all
	$(addprefix ./,$(addsuffix ;,$(PROGS)))

# Special flags
t044trace%.d: ANTLRFLAGS:=-trace
t047treeparserWalker.d: ANTLRFLAGS:=-trace


%Parser.o: %Parser.d
	@echo "# ------------------------------"
	@echo "# Compile $<"
	$(PRECMD)$(DC) $(INC) $(DFLAGS) -c $< $(DOUT)$@

%Lexer.o: %Lexer.d
	@echo "# ------------------------------"
	@echo "# Compile $<"
	$(PRECMD)$(DC) $(INC) $(DFLAGS) -c $< $(DOUT)$@

%Walker.o: %Walker.d
	@echo "# ------------------------------"
	@echo "# Compile $<"
	$(PRECMD)$(DC) $(INC) $(DFLAGS) -c $< $(DOUT)$@


lexer_%.o: lexer_%.d %Lexer.d
	@echo "################################"
	@echo "# Compile to $@"
	$(PRECMD)$(DC) $(INC) $(DFLAGS) -c $< $(DOUT)$@

parser_%.o: parser_%.d %Lexer.d %Parser.d
	@echo "################################"
	@echo "# Compile to $@"
	$(PRECMD)$(DC) $(INC) $(DFLAGS) -c $< $(DOUT)$@

walker_%.o: walker_%.d %Lexer.d %Parser.d %Walker.d
	@echo "################################"
	@echo "# Compile to $@"
	$(PRECMD)$(DC) $(INC) $(DFLAGS) -c $< $(DOUT)$@

%Parser.d %Lexer.d: %.g
	@echo "################################"
	@echo "# Grammer $<"
	$(PRECMD)$(ANTLR) $(ANTLRFLAGS) $<

%Lexer.d: %Lexer.g
	@echo "################################"
	@echo "# Lexer   $<"
	$(PRECMD)$(ANTLR) $(ANTLRFLAGS) $<

%Walker.d: %Walker.g
	@echo "################################"
	@echo "# Walker  $<"
	$(PRECMD)$(ANTLR) $(ANTLRFLAGS) $<

lexer_%: lexer_%.o %Lexer.o $(OFILES)
	@echo "################################"
	@echo "# Linking  $@"
	$(PRECMD)$(DC) $(INC) $(DFLAGS) $^ $(DOUT)$@ $(LIB)

parser_%: parser_%.o %Lexer.o %Parser.o $(OFILES)
	@echo "################################"
	@echo "# Linking  $@"
	$(PRECMD)$(DC) $(INC)  $(DFLAGS) $^ $(DOUT)$@ $(LIB)

walker_%: walker_%.o %Lexer.o %Parser.o %Walker.o $(OFILES)
	@echo "################################"
	@echo "# Linking  $@"
	$(PRECMD)$(DC) $(INC)  $(DFLAGS) $^ $(DOUT)$@ $(LIB)


# allobj: allobjdirs $(OFILES)

# allobjdirs: $(OBJDIRS)

# $(OBJDIRS):
# 	mkdir -p $@


pure:
	rm -f $(PROGS)

clean:
#	rm -fR $(OBJROOT)
#	rm -f *.o
	rm -f $(PROGS)
	rm -f $(addsuffix .o,$(PROGS))
	rm -f *Lexer.d
	rm -f *Parser.d
	rm -f *Walker.d
	rm -f *.tokens
