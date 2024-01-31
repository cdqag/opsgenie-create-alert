#!/usr/bin/env bash

# Copyright (c) CDQ AG
# Licensed under the MIT License

set -e

validate_json() {
    if ! jq -e . >/dev/null 2>&1 <<<"$2"; then
        echo "Invalid $1: $2"
        echo "Please check documentation for correct format: https://docs.opsgenie.com/docs/alert-api#create-alert"
        exit 1
    fi
}

trim() {
    echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}


apiUrl=$(trim "${1}")
apiKey=$(trim "${2}")
message=$(trim "${3}")
alias=$(trim "${4}")
description=$(trim "${5}")
responders=$(trim "${6}")
visibleTo=$(trim "${7}")
actions=$(trim "${8}")
tags=$(trim "${9}")
details=$(trim "${10}")
entity=$(trim "${11}")
source=$(trim "${12}")
priority=$(trim "${13}")
user=$(trim "${14}")
note=$(trim "${15}")
verbose=$(trim "${16}")


# Init payload
payload='{'

# Support alias
if [[ -n $alias ]]; then
    payload+="\"alias\":\"$alias\","
fi

# Support description
if [[ -n $description ]]; then
    payload+="\"description\":\"$description\","
fi

# Support responders
if [[ -n $responders ]]; then
    validate_json "responders" "$responders"
    payload+="\"responders\":$responders,"
fi

# Support visibleTo
if [[ -n $visibleTo ]]; then
    validate_json "visibleTo" "$visibleTo"
    payload+="\"visibleTo\":$visibleTo,"
fi

# Support actions
if [[ -n $actions ]]; then
    validate_json "actions" "$actions"
    payload+="\"actions\":$actions,"
fi

# Support tags
if [[ -n $tags ]]; then
    validate_json "tags" "$tags"
    payload+="\"tags\":$tags,"
fi

# Support details
if [[ -n $details ]]; then
    validate_json "details" "$details"
    payload+="\"details\":$details,"
fi

# Support entity
if [[ -n $entity ]]; then
    payload+="\"entity\":\"$entity\","
fi

# Support source
if [[ -n $source ]]; then
    payload+="\"source\":\"$source\","
fi

# Support priority
if [[ -n $priority ]]; then
    if [[ $priority =~ ^(P1|P2|P3|P4|P5)$ ]]; then
        payload+="\"priority\":\"$priority\","
    else
        echo "Invalid priority: $priority"
        exit 1
    fi
fi

# Support user
if [[ -n $user ]]; then
    payload+="\"user\":\"$user\","
fi

# Support note
if [[ -n $note ]]; then
    payload+="\"note\":\"$note\","
fi

# Add required message
payload+="\"message\":\"$message\""

# Close payload
payload+='}'


req_type="POST"
req_url="${apiUrl}/alerts"
req_header_auth="Authorization: GenieKey ${apiKey}"
req_header_content="Content-Type: application/json"

# Note: Simplyfing it using string concatenation and eval breaks the JSON payload

if [[ $verbose == "true" ]]; then
    curl --request "${req_type}" \
        --url "${req_url}" \
        --header "${req_header_auth}" \
        --header "${req_header_content}" \
        --data "${payload}" \
        --fail \
        --verbose
else
    curl --request "${req_type}" \
        --url "${req_url}" \
        --header "${req_header_auth}" \
        --header "${req_header_content}" \
        --data "${payload}" \
        --fail \
        --silent
fi
