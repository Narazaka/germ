LIB = lib
BIN = bin
SRC = src
BIN_SOURCES = $(SRC)/$(BIN)/germ.coffee
LIB_SOURCES = $(SRC)/$(LIB)/germ.coffee
TARGETS = $(LIB)/germ.js $(BIN)/germ.js

all: $(TARGETS)

clean :
	rm  $(TARGETS)

$(LIB)/germ.js: $(LIB_SOURCES)
	coffee -cmbj $@ $^

$(BIN)/germ.js: $(BIN_SOURCES)
	coffee -cmbj $@ $^
	node -e "fs=require('fs');c='#!/usr/bin/env node\n'+fs.readFileSync('$@');fs.writeFileSync('$@', c)"

test:
	mocha test

doc: doc/index.html
doc/index.html:  $(LIB_SOURCES) $(BIN_SOURCES)
	codo --name "Germ" --title "Germ Documentation" src

.PHONY: test doc
