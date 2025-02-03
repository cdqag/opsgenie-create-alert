#!/usr/bin/env bash

# Copyright (c) CDQ AG

set -e

SCRIPT_DIR="$(cd "$(dirname "$@")" >/dev/null 2>&1 && pwd)"

source "$SCRIPT_DIR/helpers/log_helpers.sh"
source "$SCRIPT_DIR/helpers/json_helpers.sh"
source "$SCRIPT_DIR/validate.sh"


function get_payload() {
	local alias="$1"
	local description="$2"
	local responders="$3"
	local visibleTo="$4"
	local actions="$5"
	local tags="$6"
	local details="$7"
	local entity="$8"
	local source="$9"
	local priority="${10}"
	local user="${11}"
	local note="${12}"
	local message="${13}"

	log_debug "Creating payload..."

	# Init payload
	local payload='{'

	# Support alias
	if [[ -n $alias ]]; then
		log_debug "Adding alias: $alias"
		payload+="\"alias\":\"$alias\","
	fi

	# Support description
	if [[ -n $description ]]; then
		description=$(escape_json "$description")

		log_debug "Adding description: $description"
		payload+="\"description\":\"$description\","
	fi

	# Support responders
	if [[ -n $responders ]]; then
		validate_json "responders" "$responders"

		log_debug "Adding responders: $responders"
		payload+="\"responders\":$responders,"
	fi

	# Support visibleTo
	if [[ -n $visibleTo ]]; then
		validate_json "visibleTo" "$visibleTo"

		log_debug "Adding visibleTo: $visibleTo"
		payload+="\"visibleTo\":$visibleTo,"
	fi

	# Support actions
	if [[ -n $actions ]]; then
		validate_json "actions" "$actions"

		log_debug "Adding actions: $actions"
		payload+="\"actions\":$actions,"
	fi

	# Support tags
	if [[ -n $tags ]]; then
		validate_json "tags" "$tags"

		log_debug "Adding tags: $tags"
		payload+="\"tags\":$tags,"
	fi

	# Support details
	if [[ -z $details ]]; then
		details='{'
		details+="\"workflow\":\"$GITHUB_WORKFLOW\","
		details+="\"runId\":\"$GITHUB_RUN_ID\","
		details+="\"runNumber\":\"$GITHUB_RUN_NUMBER\","
		details+="\"action\":\"$GITHUB_ACTION\","
		details+="\"actor\":\"$GITHUB_ACTOR\","
		details+="\"eventName\":\"$GITHUB_EVENT_NAME\","
		details+="\"repository\":\"$GITHUB_REPOSITORY\","
		details+="\"ref\":\"$GITHUB_REF\","
		details+="\"sha\":\"$GITHUB_SHA\""
		details+='}'
	fi
	validate_json "details" "$details"

	log_debug "Adding details: $details"
	payload+="\"details\":$details,"

	# Support entity
	if [[ -n $entity ]]; then
		log_debug "Adding entity: $entity"
		payload+="\"entity\":\"$entity\","
	fi

	# Support source
	if [[ -z $source ]]; then
		source="GitHub Action - $GITHUB_ACTION"
	fi

	log_debug "Adding source: $source"
	payload+="\"source\":\"$source\","

	# Support priority
	if [[ -n $priority ]]; then
		validate_priority "$priority"
		
		log_debug "Adding priority: $priority"
		payload+="\"priority\":\"$priority\","
	fi

	# Support user
	if [[ -z $user ]]; then
		user="$GITHUB_ACTOR"
	fi

	log_debug "Adding user: $user"
	payload+="\"user\":\"$user\","

	# Support note
	if [[ -n $note ]]; then
		note=$(escape_json "$note")

		log_debug "Adding note: $note"
		payload+="\"note\":\"$note\","
	fi

	# Add required message
	message=$(escape_json "$message")

	log_debug "Adding message: $message"
	payload+="\"message\":\"$message\""

	# Close payload
	payload+='}'

	echo "$payload"
}
