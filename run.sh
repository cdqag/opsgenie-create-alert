#!/usr/bin/env bash

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
    payload+="\"responders\":$responders,"
fi

# Support visibleTo
if [[ -n $visibleTo ]]; then
    payload+="\"visibleTo\":$visibleTo,"
fi

# Support actions
if [[ -n $actions ]]; then
    payload+="\"actions\":$actions,"
fi

# Support tags
if [[ -n $tags ]]; then
    payload+="\"tags\":$tags,"
fi

# Support details
if [[ -n $details ]]; then
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
    --url "${apiUrl}/alert" \
    --header "Authorization: GenieKey ${apiKey}" \
    --header "Content-Type: application/json" \
    --data "${payload}" \
    --fail
