load "test_helper/bats-support/load"
load "test_helper/bats-assert/load"
load "test_helper/common"

load "$DIR/src/validate.sh"

setup() {
	common_setup
}

teardown() {
	common_teardown
}


@test "validate_json should fail if input is not a valid JSON" {
	run validate_json "test" "invalid"

	assert_failure 21
	assert_output "[ERROR] Invalid JSON in field 'test': Provided JSON: 'invalid' is invalid. Please check documentation for correct format: https://docs.opsgenie.com/docs/alert-api#create-alert"
}

@test "validate_json should pass if input is a valid JSON" {
	run validate_json "test" "{}"

	assert_success
}

@test "validate_priority should fail if input is not a valid priority" {
	run validate_priority "P0"

	assert_failure 22
	assert_output "[ERROR] Invalid priority: Provided priority 'P0' is invalid. Valid values are: P1, P2, P3, P4, P5"
}

@test "validate_priority should pass if input is a valid priority" {
	run validate_priority "P1"
	assert_success

	run validate_priority "P2"
	assert_success

	run validate_priority "P3"
	assert_success

	run validate_priority "P4"
	assert_success

	run validate_priority "P5"
	assert_success
}
