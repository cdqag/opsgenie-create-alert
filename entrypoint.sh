#!/usr/bin/env bash

# Copyright (c) CDQ AG
# Licensed under the MIT License

set -e

apiUrl=${1}
apiKey=${2}
message=${3}
alias=${4}
description=${5}
responders=${6}
visibleTo=${7}
actions=${8}
tags=${9}
details=${10}
entity=${11}
source=${12}
priority=${13}
user=${14}
note=${15}


validate_json() {
    if ! jq -e . >/dev/null 2>&1 <<<"$2"; then
        echo "Invalid $1: $2"
        echo "Please check documentation for correct format: https://docs.opsgenie.com/docs/alert-api#create-alert"
        exit 1
    fi
}


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

curl --request POST \
    --silent \
    --url "${apiUrl}/alert" \
    --header "Authorization: GenieKey ${apiKey}" \
    --header "Content-Type: application/json" \
    --data "${payload}" \
    --fail
