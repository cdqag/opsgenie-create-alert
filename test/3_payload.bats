load "test_helper/bats-support/load"
load "test_helper/bats-assert/load"
load "test_helper/common"

load "$DIR/src/payload.sh"

setup() {
	common_setup
}

teardown() {
	common_teardown
}

@test "get_payload should create a valid payload without optional fields" {
	local alias="test-alias"
	local description="test-description"
	local responders=""
	local visibleTo=""
	local actions=""
	local tags=""
	local details=""
	local entity=""
	local source=""
	local priority="P1"
	local user=""
	local note=""
	local message="foobar"

	local GITHUB_WORKFLOW="foo1"
	local GITHUB_RUN_ID="foo2"
	local GITHUB_RUN_NUMBER="foo3"
	local GITHUB_ACTION="foo4"
	local GITHUB_ACTOR="foo5"
	local GITHUB_EVENT_NAME="foo6"
	local GITHUB_REPOSITORY="foo7"
	local GITHUB_REF="foo8"
	local GITHUB_SHA="foo9"

	run get_payload "$alias" "$description" "$responders" "$visibleTo" "$actions" "$tags" "$details" "$entity" "$source" "$priority" "$user" "$note" "$message"

	assert_success
	assert_output '{"alias":"test-alias","description":"test-description","details":{"workflow":"foo1","runId":"foo2","runNumber":"foo3","action":"foo4","actor":"foo5","eventName":"foo6","repository":"foo7","ref":"foo8","sha":"foo9"},"source":"GitHub Action - foo4","priority":"P1","user":"foo5","message":"foobar"}'
}

@test "get_payload should fail if responders is not valid JSON" {
	local alias="test-alias"
	local description="test-description"
	local responders="foobar"
	local visibleTo=""
	local actions=""
	local tags=""
	local details=""
	local entity=""
	local source=""
	local priority="P1"
	local user=""
	local note=""
	local message="test-message"

	run get_payload "$alias" "$description" "$responders" "$visibleTo" "$actions" "$tags" "$details" "$entity" "$source" "$priority" "$user" "$note"

	assert_failure
	assert_output "[ERROR] Invalid JSON in field 'responders': Provided JSON: 'foobar' is invalid. Please check documentation for correct format: https://docs.opsgenie.com/docs/alert-api#create-alert"
}

@test "get_payload should fail if visibleTo is not valid JSON" {
	local alias="test-alias"
	local description="test-description"
	local responders=""
	local visibleTo="foobar"
	local actions=""
	local tags=""
	local details=""
	local entity=""
	local source=""
	local priority="P1"
	local user=""
	local note=""
	local message="test-message"

	run get_payload "$alias" "$description" "$responders" "$visibleTo" "$actions" "$tags" "$details" "$entity" "$source" "$priority" "$user" "$note"

	assert_failure
	assert_output "[ERROR] Invalid JSON in field 'visibleTo': Provided JSON: 'foobar' is invalid. Please check documentation for correct format: https://docs.opsgenie.com/docs/alert-api#create-alert"
}

@test "get_payload should fail if actions is not valid JSON" {
	local alias="test-alias"
	local description="test-description"
	local responders=""
	local visibleTo=""
	local actions="foobar"
	local tags=""
	local details=""
	local entity=""
	local source=""
	local priority="P1"
	local user=""
	local note=""
	local message="test-message"

	run get_payload "$alias" "$description" "$responders" "$visibleTo" "$actions" "$tags" "$details" "$entity" "$source" "$priority" "$user" "$note"

	assert_failure
	assert_output "[ERROR] Invalid JSON in field 'actions': Provided JSON: 'foobar' is invalid. Please check documentation for correct format: https://docs.opsgenie.com/docs/alert-api#create-alert"
}

@test "get_payload should fail if tags is not valid JSON" {
	local alias="test-alias"
	local description="test-description"
	local responders=""
	local visibleTo=""
	local actions=""
	local tags="foobar"
	local details=""
	local entity=""
	local source=""
	local priority="P1"
	local user=""
	local note=""
	local message="test-message"

	run get_payload "$alias" "$description" "$responders" "$visibleTo" "$actions" "$tags" "$details" "$entity" "$source" "$priority" "$user" "$note"

	assert_failure
	assert_output "[ERROR] Invalid JSON in field 'tags': Provided JSON: 'foobar' is invalid. Please check documentation for correct format: https://docs.opsgenie.com/docs/alert-api#create-alert"
}

@test "get_payload should fail if details is not valid JSON" {
	local alias="test-alias"
	local description="test-description"
	local responders=""
	local visibleTo=""
	local actions=""
	local tags=""
	local details="foobar"
	local entity=""
	local source=""
	local priority="P1"
	local user=""
	local note=""
	local message="test-message"

	run get_payload "$alias" "$description" "$responders" "$visibleTo" "$actions" "$tags" "$details" "$entity" "$source" "$priority" "$user" "$note"

	assert_failure
	assert_output "[ERROR] Invalid JSON in field 'details': Provided JSON: 'foobar' is invalid. Please check documentation for correct format: https://docs.opsgenie.com/docs/alert-api#create-alert"
}

@test "get_payload should create a valid payload" {
	local alias="test-alias"
	local description="test-description"
	local responders='[{"id":"test-responder-id","type":"team"}]'
	local visibleTo='[{"id":"test-visibleTo-id","type":"team"}]'
	local actions='[{"name":"test-action-name","type":"test-action-type","integrationId":"test-action-integrationId"}]'
	local tags='["test-tag1","test-tag2"]'
	local details='{"test-detail-key":"test-detail-value"}'
	local entity="test-entity"
	local source="test-source"
	local priority="P1"
	local user="test-user"
	local note="test-note"
	local message="test-message"

	run get_payload "$alias" "$description" "$responders" "$visibleTo" "$actions" "$tags" "$details" "$entity" "$source" "$priority" "$user" "$note"

	assert_success
	assert_output '{"alias":"test-alias","description":"test-description","responders":[{"id":"test-responder-id","type":"team"}],"visibleTo":[{"id":"test-visibleTo-id","type":"team"}],"actions":[{"name":"test-action-name","type":"test-action-type","integrationId":"test-action-integrationId"}],"tags":["test-tag1","test-tag2"],"details":{"test-detail-key":"test-detail-value"},"entity":"test-entity","source":"test-source","priority":"P1","user":"test-user","note":"test-note","message":"test-message"}'
}
