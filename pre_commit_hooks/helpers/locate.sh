################################################################################
#
# Locate the command from a list of options
#
################################################################################
# shellcheck shell=bash
# shellcheck disable=2034,2154

# Final location of the executable that we found by searching
exec_command=""

# PHP runtime arguments (like -d memory_limit=512M) that should be passed to php
# This is set by the php-args.sh helper
php_runtime_args="${php_runtime_args:-}"

# A phar file will need to be called by php
if [ -n "$php_runtime_args" ]; then
    prefixed_local_command="php $php_runtime_args $local_command"
else
    prefixed_local_command="php $local_command"
fi

if [ -f "$vendor_command" ]; then
    exec_command=$vendor_command
elif hash "$global_command" 2>/dev/null; then
    exec_command=$global_command
elif [ -f "$local_command" ]; then
    exec_command=$prefixed_local_command
else
    echo -e "${bldred}No valid ${title} found!${txtrst}"
    echo "Please have one available as one of the following:"
    echo " * $local_command"
    echo " * $vendor_command"
    echo " * $global_command"
    exit 1
fi
