# Executables
#PROGS:= <programs>

# D source files
#DFILES+= <dfiles>

# Antlr grammar files
#GRAMMARS:= <grammarname>.g

#Library
# LIRARCHIVE lib<name>.a

# Enable vampyra
#VAMPYRA:=1

# Initalize basic D make file
REPOROOT  ?=$(shell git root)

DC?=dmd-2.064.2
include $(REPOROOT)/scripts/basic.mk


.PHONY: all

ifndef PASS
all: $(PREBUILD) $(OBJDIR) $(GDFILES)
	$(MAKE) PASS=1 $@

allobj: $(OBJDIR)
	$(MAKE) PASS=1 $@

library: $(OBJDIR)
	$(MAKE) PASS=1 $@

#Parsers
$(PARSERS)


# Tree Parsers
$(TREEPARSERS)

else


# Set up compilation of D source
$(COMPILEDFILES)

# Link programs
$(PROGRAMS)

# Library
ifdef LIBFILE
$(eval $(call LIBARCH_BUILD,$(LIBDIR)/$(LIBFILE),$(OBJ)))
endif

#$(BUILDARCHIVE)

all: allobj library progs
#	echo $(OBJ)

progs: allobj $(PROGS)

library: $(LIBDIR)/$(LIBFILE)


allobj: $(OBJ)

endif


# Clean all .o and driven files
master_clean:
ifndef PASS
	$(MAKE) PASS=1 $@
else
	cd $(OBJDIR); rm -f *
	rm -f $(GDFILES)
ifdef LIBFILE
	rm -f $(LIBDIR)/$(LIBFILE)
endif
	rm -f $(PROGS)
endif

parser: $(GDFILES)
	@echo "parser"
	@echo $(DFILES)
	@echo $(GDFILES)

info:
	@echo DFILES=$(DFILES)
	@echo GDFILES=$(GDFILES)
	@echo GRAMMARS=$(GRAMMARS)
	@echo OBJ=$(OBJ)
	@echo LIBFILE=$(LIBFILE)
#	@echo X=$(LIBARCH_BUILD)
