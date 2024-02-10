#!/usr/bin/env bash
#
# Script based on test_doc.sh from bash_unit
TEST_PATTERN='```test'
OUTPUT_PATTERN='```output'
LANG=C.UTF-8
TEST_DOC_BN=TEST.md

IGNORE_REGEX="(Sebastian Bergmann|tests.in.|[tT]ime|q{30}|-{20}|^[\r]?$)"

# Function to recursively search upwards for file
_find_file() {
    local dir="$1"
    local file="$2"
    while [ "${dir}" != "/" ]; do
        if [ -f "${dir}/${file}" ]; then
            echo "${dir}/${file}"
            return 0
        fi
        dir=$(dirname "${dir}")
    done
    return 1
}

TEST_DOC=$(_find_file "$(dirname "$(realpath "$0")")" ${TEST_DOC_BN})
# shellcheck disable=2181 # Use 'if ! mycmd;'
if [ $? != 0 ] ; then
    TEST_DOC=$(_find_file "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" ${TEST_DOC_BN})
fi

B_U=$(_find_file "$(dirname "$(realpath "$0")")" bash_unit)
# shellcheck disable=2089
BASH_UNIT="eval FORCE_COLOR=false \"$B_U\""

WORK_DIR=$(dirname "$(_find_file "$(dirname "$(realpath "$0")")" pre_commit_hooks/php_lint.sh)")

export STICK_TO_CWD=true

prepare_tests() {
    TMP_DIR=/tmp/$$
    mkdir ${TMP_DIR}
    local block=0
    local remaining=${TMP_DIR}/remaining
    local swap=${TMP_DIR}/swap
    local test_output=${TMP_DIR}/test_output
    local expected_output=${TMP_DIR}/expected_output
    cp "$TEST_DOC" "$remaining"

    while grep -E "^${TEST_PATTERN}$" "$remaining" >/dev/null
    do
        ((++block))
        cd "${WORK_DIR}" || exit 1
        #run_doc_test  "$remaining" "$swap"
        local bs="\\" # beautysh workaround
        run_doc_test  "$remaining" "$swap" \
            |& grep -avP "${IGNORE_REGEX}" \
            | sed -e 's/\r$//' -e "\$a$bs" \
            | work_around_github_action_problem > "$test_output$block"
        doc_to_output "$remaining" "$swap" > "$expected_output$block"
        eval 'function test_block_'"$(printf "%02d" "$block")"'() {
            assert "diff -u '"$expected_output$block"' '"$test_output$block"'"
        }'
    done
}

work_around_github_action_problem() {
    # I have no idea what is happening with these broken pipes on github actions
    grep -v '^/usr/bin/grep: write error: Broken pipe$'
}

function run_doc_test() {
    local remaining="$1"
    local swap="$2"
    # shellcheck disable=2090
    $BASH_UNIT <(< "$remaining" _next_code "$swap") \
        | clean_bash_unit_running_header \
        | clean_bash_pseudo_files_name \
        | clean_bash_unit_overall_result
    cat "$swap" > "$remaining"
}


function clean_bash_unit_running_header() {
    tail -n +2
}

function clean_bash_pseudo_files_name() {
    sed -e 's:/dev/fd/[0-9]*:doc:g'
}

function clean_bash_unit_overall_result() {
    sed '$d'
}

function doc_to_output() {
    local remaining="$1"
    local swap="$2"
    < "$remaining" _next_output "$swap"
    cat "$swap" > "$remaining"
}

function _next_code() {
    local remaining="$1"
    _next_quote_section "$TEST_PATTERN" "$remaining"
}

function _next_output() {
    local remaining="$1"
    _next_quote_section "$OUTPUT_PATTERN" "$remaining"
}

function _next_quote_section() {
    local quote_pattern=$1
    local remaining=$2
    sed -E '1 , /^'"$quote_pattern"'$/ d' |\
        sed -E '
  /^```$/ , $ w '"$remaining"'
  1,/^```$/ !d;//d
    '
}

prepare_tests
