DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." >/dev/null 2>&1 && pwd)"
PATH="$DIR/../src:$PATH"

ORIGINAL_GITHUB_ACTIONS=$GITHUB_ACTIONS

function common_setup() {
	GITHUB_ACTIONS=""
}

function common_teardown() {
	GITHUB_ACTIONS=$ORIGINAL_GITHUB_ACTIONS
}
