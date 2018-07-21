.PHONY: all test

EXECUTABLES = bats shellcheck git base64 xargs gpg
K := $(foreach exec,$(EXECUTABLES),\
        $(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH)))

SHELL=/bin/bash

test: lint
	bats test/test.bats

lint:
	shellcheck bin/git-signatures

install:
	mkdir -p $$HOME/.local/bin
	cp bin/git-signatures $$HOME/.local/bin/

all: test
