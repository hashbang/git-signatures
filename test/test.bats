#!/usr/bin/env bats

load test_helper

@test "can add signature to current HEAD" {
	run git signatures add HEAD
	[ "$status" -eq 0 ]
}

@test "can add signature to current HEAD with key as argument" {
	run git signatures add --key "approver1@company.com" HEAD
	[ "$status" -eq 0 ]
}

@test "can add signature and automatically push" {
	run git signatures add --push
	[ "$status" -eq 0 ]
}

@test "can not add signature to current HEAD with invalid key" {
	git config user.signingKey "INVALIDKEY"
	run git signatures add HEAD
	[ "$status" -eq 1 ]
}

@test "can not add signature to current HEAD with invalid key as argument" {
	run git signatures add --key "INVALIDKEY" HEAD
	[ "$status" -eq 1 ]
}

@test "can show signatures" {
	run git signatures show HEAD
	[ "$status" -eq 0 ]
}

@test "can show signatures in raw mode" {
	run git signatures show --raw HEAD
	[ "$status" -eq 0 ]
}
