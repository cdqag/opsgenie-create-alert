#!/usr/bin/env bash

# Copyright (c) CDQ AG

set -e

SCRIPT_DIR="$(cd "$(dirname "$@")" >/dev/null 2>&1 && pwd)"

source "$SCRIPT_DIR/helpers/log_helpers.sh"
source "$SCRIPT_DIR/helpers/json_helpers.sh"

function validate_json() {
	if ! is_json "$2"; then
		log_error "Invalid JSON in field '$1'" "Provided JSON: '$2' is invalid. Please check documentation for correct format: https://docs.opsgenie.com/docs/alert-api#create-alert"
		exit 21
	fi
}

function validate_priority() {
	if [[ $1 =~ ^(P1|P2|P3|P4|P5)$ ]]; then
		return 0
	else
		log_error "Invalid priority" "Provided priority '$1' is invalid. Valid values are: P1, P2, P3, P4, P5"
		exit 22
	fi
}
