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

trim_whitespace() {
    echo "$1" | xargs
}


apiUrl=$(trim_whitespace "${1}")
apiKey=$(trim_whitespace "${2}")
message=$(trim_whitespace "${3}")
alias=$(trim_whitespace "${4}")
description=$(trim_whitespace "${5}")
responders=$(trim_whitespace "${6}")
visibleTo=$(trim_whitespace "${7}")
actions=$(trim_whitespace "${8}")
tags=$(trim_whitespace "${9}")
details=$(trim_whitespace "${10}")
entity=$(trim_whitespace "${11}")
source=$(trim_whitespace "${12}")
priority=$(trim_whitespace "${13}")
user=$(trim_whitespace "${14}")
note=$(trim_whitespace "${15}")
verbose=$(trim_whitespace "${16}")


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


curl_command="curl --request POST \
    --url \"${apiUrl}/alerts\" \
    --header \"Authorization: GenieKey ${apiKey}\" \
    --header \"Content-Type: application/json\" \
    --data \"${payload}\" \
    --fail"

if [[ $verbose == "true" ]]; then
    curl_command+=" --verbose"
else
    curl_command+=" --silent"
fi

eval "$curl_command"
