SHELL=/usr/bin/env bash
prefix=$$HOME/.local
bindir=$(prefix)/bin

all: test

test:
	bats test/test.bats

lint:
	shellcheck bin/git-signatures

install:
	mkdir -p $(bindir)
	install bin/git-signatures $(bindir)

.PHONY: all test lint install
