REPOROOT?=$(shell git root)

REVNO?=$(shell git revno)

# Source directory
TANGO_DIR:=$(REPOROOT)/../tango/
ANTLR_DIR:=$(REPOROOT)/
VERSION:=$(REPOROOT)/antlr/runtime/Version.d

# Update revsion tag file
REVNOFILE:=$(REPOROOT)/currentrevno.mk

MAKEWAY:=mkdir -p

.PHONY: revno

-include $(REVNOFILE)

ifneq ($(REVNO),$(CURRENTREVNO))
revno:
	@echo "REVNO='$(REVNO)'"
	@echo "CURRENTREVNO='$(CURRENTREVNO)'"
	@echo "bzr revno updated"
	@echo "CURRENTREVNO:=" $(shell git revno) > $(REVNOFILE)
	rm -f $(VERSION)
	@echo "module antlr.Version;" >$(VERSION)
	@echo "enum uint Major = 0;" >>$(VERSION)
	@echo "enum uint Minor =" $(shell git revno) ";" >>$(VERSION)

endif

## Default signs parameters
EMPTY:=
SPACE:=$(EMPTY) $(EMPTY)


# Lib and obj dirs
ifeq ($(ARCH),-m32)
LIBDIR=$(REPOROOT)/lib32
else
LIBDIR=$(REPOROOT)/lib64
endif
# OBJDIR
OBJDIR=$(LIBDIR)/obj/$(DC)

# Scripts settings
SCRIPTROOT:=$(REPOROOT)/scripts/
MODULENAME:=$(SCRIPTROOT)/modulename

INC:=-I$(TANGO_DIR)
#ifdef GRAMMARS
INC+=-I$(ANTLR_DIR)
#endif
INC+=-I$(VERSION_DIR)

#LIB+=-ldl -lgtango -lpthread
#LIB+=-L$(LIBDIR) -L$(GDC_LIB_DIR)


#ifeq ($(DC),dmd)
#LDFLAGS:=-L-L/usr/lib
#LDFLAGS+=$(REPOROOT)/../tango/libtango-$(DC).a
#DFLAGS+=$(REPOROOT)/lib/libantlrd-$(DC).a
LIB+=$(LIBDIR)/libantlrd-$(DC).a
LIB+=$(REPOROOT)/../tango/libtango-$(DC).a

#

STDDFLAGS+=-I$(TANGO_DIR)
# -L-L$(TANGO_DIR)
#STDDFLAGS+=-version=posix -version=tango
STDDFLAGS+=-version=posix -version=tango
#DFLAGS+=-defaultlib=tango -debuglib=tango
#STDDFLAGS+=-defaultlib=gtango -debuglib=gtango
STDDFLAGS+=-g -unittest
STDDFLAGS+=-c
DOUT:=-of
#else
#STDDFLAGS:=-fversion=Posix -fversion=Tango
#STDDFLAGS:=-fversion=EnableVararg
#STDDFLAGS+=-nophoboslib
#STDDFLAGS+= -c
#STDDFLAGS+=$(ARCH)
#ifdef DEBUG
#DEBUGDFLAGS+=-g$(DEBUG) #-O0
#endif

#ifdef UNITTEST
#DEBUGDFLAGS+=-funittest
#endif

#DOUT:=-o
#endif

PRECMD?=@
# Antlr settings
ANTLR:=java  -Xms2048m -Xmx2048m -cp $(REPOROOT)/antlrlib/antlrd/ org.antlr.Tool $*
# Compile from dsource $(1) file to object $(1)
# Append all object file to $(OBJ)
define COMPILEOBJ

$(2):$(1)
	$(DC) $(ARCH) $(DEBUGDFLAGS) $(INC)  $(STDDFLAGS) $(DFLAGS) $(1)  $(DOUT)$(2)

OBJ+=$(2)

endef

# Compile all dfiles in $(DFILES)
COMPILEDFILES=$(foreach file,$(DFILES), $(eval $(call COMPILEOBJ,$(file),$(OBJDIR)/$(shell $(MODULENAME) $(file)).o)))

DMODULES=$(foreach file, $(DFILES), $(shell $(MODULENAME) $(file)))

PROGRAMS=$(foreach file,$(PROGS), $(eval $(call LINK,$(file),$(OBJ))))

# Link macro
# $(1) is  executable
# $(2) object files
define LINK

$(1):$(2) $(1).d
	$(DC) $(ARCH) $(DEBUGDFLAGS) $(INC)  $(DFLAGS) $(2) $(LIB) $(DOUT)$(1) $(LDFLAGS)
RUNS+=$(1)
endef

# Library archive
# $(1) is the library archive
# $(2) is the list of object files
define LIBARCH_BUILD

$(1):$(2)
	$(AR) -rcs $(1) $(2)

endef

PARSERS=$(foreach file,$(GFILES),$(eval $(call PARSER_BUILD,$(file))))

TREEPARSERS=$(foreach file,$(TGFILES),$(eval $(call TREEPARSER_BUILD,$(file))))

define PARSER_BUILD

$(1:.g=Lexer.d) $(1:.g=Parser.d) : $(1)
	@echo "Parser $(1)"
	$(ANTLR) $(ANTLRFLAGS) $($(1)FLAGS) $(1)

endef

define TREEPARSER_BUILD

$(1:.g=.d): $(1)
	@echo "Tree builder $(1)"
	$(ANTLR) $(ANTLRFLAGS) $($(1)FLAGS) $(1)

endef

$(OBJDIR):
	$(MAKEWAY) $@
