#!/usr/bin/env bash

# Copyright (c) CDQ AG

set -e

export SCRIPT_DIR="$(cd "$(dirname "$0")" >/dev/null 2>&1 && pwd)"

source "$SCRIPT_DIR/helpers/log_helpers.sh"
source "$SCRIPT_DIR/payload.sh"

function trim() {
	local x=$(echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
	echo $x
}

log_debug "Normalizing inputs..."
input_apiUrl=$(trim "$input_apiUrl")
input_apiKey=$(trim "$input_apiKey")

input_alias=$(trim "$input_alias")
input_description=$(trim "$input_description")
input_responders=$(trim "$input_responders")
input_visibleTo=$(trim "$input_visibleTo")
input_actions=$(trim "$input_actions")
input_tags=$(trim "$input_tags")
input_details=$(trim "$input_details")
input_entity=$(trim "$input_entity")
input_source=$(trim "$input_source")
input_priority=$(trim "$input_priority")
input_user=$(trim "$input_user")
input_note=$(trim "$input_note")
input_message=$(trim "$input_message")

log_debug "Preparing request..."
req_type="POST"
req_url="${input_apiUrl}/alerts"
req_header_auth="Authorization: GenieKey ${input_apiKey}"
req_header_content="Content-Type: application/json"

payload=$(get_payload \
	"$input_alias" \
	"$input_description" \
	"$input_responders" \
	"$input_visibleTo" \
	"$input_actions" \
	"$input_tags" \
	"$input_details" \
	"$input_entity" \
	"$input_source" \
	"$input_priority" \
	"$input_user" \
	"$input_note" \
	"$input_message" \
)

log_debug "Sending request..."
if [[ -n $RUNNER_DEBUG ]]; then
	curl --request "${req_type}" \
		--url "${req_url}" \
		--header "${req_header_auth}" \
		--header "${req_header_content}" \
		--data "${payload}" \
		--fail \
		-vvv
else
	curl --request "${req_type}" \
		--url "${req_url}" \
		--header "${req_header_auth}" \
		--header "${req_header_content}" \
		--data "${payload}" \
		--fail \
		--silent
fi
