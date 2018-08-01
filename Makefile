.PHONY: all test

SHELL=/bin/bash
prefix=$$HOME/.local
bindir=$(prefix)/bin

test:
	bats test/test.bats

lint:
	shellcheck bin/git-signatures

install:
	mkdir -p $(bindir)
	install bin/git-signatures $(bindir)

all: test
