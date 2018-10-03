SHELL=/usr/bin/env bash
prefix=$$HOME/.local
bindir=$(prefix)/bin

all: test

test:
	make -C test

lint:
	shellcheck bin/git-signatures

install:
	mkdir -p $(bindir)
	install bin/git-signatures $(bindir)

clean:
	make -C test clean

.PHONY: all test lint install clean
