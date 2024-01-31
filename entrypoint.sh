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

normalize() {
    x=$(echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    echo $x
}

escape_json() {
    x=$(echo "$1" | sed -e 's/"/\\"/g')
    echo $x
}


apiUrl=$(normalize "${1}")
apiKey=$(normalize "${2}")
message=$(normalize "${3}")
alias=$(normalize "${4}")
description=$(normalize "${5}")
responders=$(normalize "${6}")
visibleTo=$(normalize "${7}")
actions=$(normalize "${8}")
tags=$(normalize "${9}")
details=$(normalize "${10}")
entity=$(normalize "${11}")
source=$(normalize "${12}")
priority=$(normalize "${13}")
user=$(normalize "${14}")
note=$(normalize "${15}")
verbose=$(normalize "${16}")


# Init payload
payload='{'

# Support alias
if [[ -n $alias ]]; then
    payload+="\"alias\":\"$alias\","
fi

# Support description
if [[ -n $description ]]; then
    description=$(escape_json "$description")
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
payload+="\"details\":$details,"

# Support entity
if [[ -n $entity ]]; then
    payload+="\"entity\":\"$entity\","
fi

# Support source
if [[ -z $source ]]; then
    soure="GitHub Action - $GITHUB_ACTION"
fi
payload+="\"source\":\"$source\","

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
if [[ -z $user ]]; then
    user="$GITHUB_ACTOR"
fi
payload+="\"user\":\"$user\","

# Support note
if [[ -n $note ]]; then
    note=$(escape_json "$note")
    payload+="\"note\":\"$note\","
fi

# Add required message
message=$(escape_json "$message")
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
