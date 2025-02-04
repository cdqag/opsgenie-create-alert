#!/usr/bin/env bash

# Copyright (c) CDQ AG

function is_json() {
	echo "$1" | jq . >/dev/null 2>&1
}

function escape_json() {
	local x=$(echo "$1" | sed -e 's/"/\\"/g')
	echo $x
}
