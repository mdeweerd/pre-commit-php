#!/usr/bin/env bash

# Bash PHP Code Beautifier and Fixer Hook
# This script fails if the PHP Code Beautifier and Fixer output has the word "ERROR" in it.
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
#

# Plugin title
title="PHP Code Beautifier and Fixer"

# Possible command names of this tool
local_command="phpcbf.phar"
vendor_command="php-vendor/bin/phpcbf"
global_command="phpcbf"

# Print a welcome and locate the exec for this tool
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/helpers/colors.sh"
source "$DIR/helpers/formatters.sh"
source "$DIR/helpers/welcome.sh"
source "$DIR/helpers/locate.sh"

echo -e "${bldwht}Running command ${txtgrn}${exec_command} $(for i in "$@";do echo "'$i'";done)${txtrst}"

command_result="$($SHELL -c "(cd '$PWD' ; eval '\"${exec_command}\" \"\${@}\"' ) 2>&1 ; exit \$?" -- "$@")"
exitCode=$?

if [[ "$exitCode" -ge 1 ]]
then
    hr
    echo -en "${bldmag}Errors detected by PHP Code Beautifier and Fixer ... ${txtrst} \n"
    hr
    echo "$command_result"
fi

exit $exitCode
