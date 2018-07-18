#!/usr/bin/env bats

load test_helper

@test "can add signature to current HEAD" {
	git signatures add HEAD
}
