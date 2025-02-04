#!/usr/bin/env bash

# Copyright (c) CDQ AG

function echo_err() {
	echo "$1" >&2
}

function _log_x() {
	local prefix=""
	local lines=""
	
	if [[ -n "$GITHUB_ACTIONS" ]]; then
		prefix="::${1}"
		
		if [[ -n "$3" ]]; then
			prefix="$prefix title=${2}::"
			lines="$3"
		else
			prefix="$prefix::"
			lines="$2"
		fi
	else
		prefix="[${1^^}]"

		if [[ -n "$3" ]]; then
			prefix="$prefix ${2}: "
			lines="$3"
		else
			prefix="$prefix "
			lines="$2"
		fi
	fi

	lines=$(echo -e "$lines")
	while IFS= read -r line; do
		echo_err "${prefix}${line}"
	done <<< "$lines"
}

function log_error() {
	_log_x error "$1" "$2"
}

function log_warning() {
	_log_x warning "$1" "$2"
}

function log_notice() {
	_log_x notice "$1" "$2"
}

function log_info() {
	if [[ -n "$GITHUB_ACTIONS" ]]; then
		echo "$1"
	else
		echo_err "[INFO] $1"
	fi
}

function log_debug() {
	if [[ -n "$RUNNER_DEBUG" ]]; then
		_log_x debug "$1"
	fi
}

function group_start() {
	if [[ -z "$1" ]]; then
		echo "group_start: Group name cannot be empty" >&2
		exit 1
	fi

	if [[ -n "$GITHUB_ACTIONS" ]]; then
		echo "::group::$1"
	fi
}

function group_end() {
	if [[ -n "$GITHUB_ACTIONS" ]]; then
		echo "::endgroup::"
	fi
}

function mask() {
	if [[ -z "$1" ]]; then
		echo "mask: Value to mask cannot be empty" >&2
		exit 1
	fi

	if [[ -n "$GITHUB_ACTIONS" ]]; then
		echo "::add-mask::$1"
	fi
}
