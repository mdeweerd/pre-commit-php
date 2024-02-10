#!/usr/bin/env -S bash

# Bash PHP Unit Task Runner
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
title="PHP Unit Task Runner"

# Possible command names of this tool
local_command="phpunit.phar"
vendor_command="php-vendor/bin/phpunit"
global_command="phpunit"

# Print a welcome and locate the exec for this tool
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/helpers/colors.sh"
source "$DIR/helpers/formatters.sh"
source "$DIR/helpers/welcome.sh"
source "$DIR/helpers/locate.sh"

echo -e "${bldwht}Running command ${txtgrn}${exec_command}${txtrst}"

if [ 0 == ${#@} ] ; then
    command_result="$($SHELL -c "(cd '$PWD' ; eval '${exec_command}' \"\${@}\" ) 2>&1 ; exit \$?" -- . "$@")"
    exitCode=$?
else
    command_result="$($SHELL -c "(eval '\"${exec_command}\" \"\${@}\"' ) 2>&1 ; exit \$?" -- "$@")"
    exitCode=$?
fi


if [[ "$exitCode" != 0 ]]
then
    hr
    echo "Failures detected in unit tests..."
    hr
    echo "$command_result"
    exit $exitCode
fi
exit 0
