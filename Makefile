PREFIX=/usr/local
TARGET=bibsatysfi
BINDIR=$(PREFIX)/bin
BUILD=_build

.PHONY: build test

build: src
	dune build src/main.exe
	cp ${BUILD}/default/src/main.exe ./${TARGET}

test: src
	./${TARGET} -f test/test.bib