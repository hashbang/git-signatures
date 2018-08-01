.PHONY: all test

SHELL=/bin/bash

test:
	bats test/test.bats

lint:
	shellcheck bin/git-signatures

install:
	mkdir -p $$HOME/.local/bin
	install bin/git-signatures $$HOME/.local/bin/

all: test
