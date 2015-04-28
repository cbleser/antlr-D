REPOROOT?=$(shell git root)
ANTLRLIB:=$(REPOROOT)/antlrlib
ANTLRJAR:=antlr-3.3-complete.jar
ANTLRD:=antlrd
JAR:=jar
JAVAC:=javac
JAVAFLAGS:=-cp $(ANTLRLIB)/$(ANTLRD)
TARGET:=DTarget
TEMPLATEDIR:=$(ANTLRLIB)/$(ANTLRD)/org/antlr/codegen/templates

antlrd: $(ANTLRLIB)/$(ANTLRD) $(REPOROOT)/codegen/$(TARGET).class $(TEMPLATEDIR)/D
	cd $(ANTLRLIB)/$(ANTLRD)/org/antlr/codegen/; ln -s $(REPOROOT)/codegen/$(TARGET).class .


$(ANTLRLIB)/$(ANTLRD): $(ANTLRLIB)/$(ANTLRJAR)
	mkdir -p $(@)
	cd $(@); $(JAR) -xvf $(ANTLRLIB)/$(ANTLRJAR)

$(TEMPLATEDIR)/D:
	cd $(@D);rm -f D;ln -s $(REPOROOT)/templates/D .

%.class: %.java
	$(JAVAC) $(JAVAFLAGS) $<

info:
	echo $(ANTLRLIB)

clean:
	cd $(ANTLRLIB); rm -fR $(ANTLRD)
	cd codegen; rm -f *.class
