################################################################################
#
# Text formatters and manipulators
#
################################################################################
# shellcheck shell=bash

# tput complains if TERM is not set
# Workaround: set TERM to dumb when not set.
TERM=${TERM:=dumb}
export TERM
hr() {
    local start=$'\e(0' end=$'\e(B' line='qqqqqqqqqqqqqqqq'
    local cols=${COLUMNS:-$(tput cols)}
    while ((${#line} < cols)); do line+="$line"; done
    printf '%s%s%s\n' "$start" "${line:0:cols}" "$end"
}
