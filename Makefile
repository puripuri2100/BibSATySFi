PREFIX=/usr/local
TARGET=bibsatysfi
BINDIR=$(PREFIX)/bin
BUILD=_build

.PHONY: build install uninstall test

build: src
	dune build src/main.exe
	cp ${BUILD}/default/src/main.exe ./${TARGET}

install: ${TARGET}
	mkdir -p $(BINDIR)
	install $(TARGET) $(BINDIR)

uninstall:
	rm -rf $(BINDIR)/$(TARGET)

test: src
	./${TARGET} -f test/test.bib
