#!/usr/bin/env bash

# Copyright (c) CDQ AG

function set_env() {
	if [[ -z "$1" ]]; then
		echo "set_env: Variable name is required" >&2
		exit 1
	fi

	if [[ -n "$GITHUB_ACTIONS" ]]; then
		echo "$1=$2" >> "$GITHUB_ENV"
	fi
}

function set_output() {
	if [[ -z "$1" ]]; then
		echo "set_output: Output name is required" >&2
		exit 1
	fi

	if [[ -n "$GITHUB_ACTIONS" ]]; then
		echo "$1=$2" >> "$GITHUB_OUTPUT"
	fi
}
