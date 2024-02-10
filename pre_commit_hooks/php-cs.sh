#!/usr/bin/env bash

# Bash PHP Codesniffer Hook
# This script fails if the PHP Codesniffer output has the word "ERROR" in it.
# Does not support failing on WARNING AND ERROR at the same time.
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - php
#
# Arguments
# - None

# Plugin title
title="PHP Codesniffer"

# Possible command names of this tool
local_command="phpcs.phar"
vendor_command="php-vendor/bin/phpcs"
global_command="phpcs"

# Print a welcome and locate the exec for this tool
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/helpers/colors.sh"
source "$DIR/helpers/formatters.sh"
source "$DIR/helpers/welcome.sh"
source "$DIR/helpers/locate.sh"

echo -e "${bldwht}Running command ${txtgrn}${exec_command} $(for i in "$@";do echo "'$i'";done)${txtrst}"

command_result="$($SHELL -c "(cd '$PWD' ; eval '\"${exec_command}\" \"\${@}\"' ) 2>&1 ; exit \$?" -- "$@")"
exitCode=$?

# exit codes: 0=ok, 1=warning, 2=error, others=?
if [[ "$exitCode" -ge 1 ]]
then
    hr
    echo -en "${bldmag}Errors detected by PHP CodeSniffer ... ${txtrst} \n"
    hr
else
    hr
    echo -en "${bldmag}No Errors detected by PHP CodeSniffer ... ${txtrst} (exit code:$exitCode)\n"
    hr
    exitCode=0
fi

echo "$command_result"
exit $exitCode
