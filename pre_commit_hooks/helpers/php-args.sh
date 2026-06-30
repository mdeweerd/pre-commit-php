################################################################################
#
# Parse and apply PHP runtime arguments
#
# This helper script processes PHP runtime configuration arguments (like -d memory_limit=512M)
# and makes them available for use when executing PHP-based tools.
#
# Usage:
#   source "$DIR/helpers/php-args.sh"
#   parse_php_args "$@"
#   set -- ${php_filtered_args[@]}
#
# The script will:
#   - Parse arguments passed to the main script
#   - Extract PHP runtime arguments (those starting with -d, -e, -n, etc.)
#   - Store them in php_runtime_args variable
#   - Store the filtered arguments in php_filtered_args array
#
# After sourcing this, you can use:
#   php_runtime_args - contains the PHP runtime arguments
#   php_filtered_args - array of arguments without PHP runtime args
#
# Then call: set -- "${php_filtered_args[@]}"
#
################################################################################
# shellcheck shell=bash

# Initialize PHP runtime arguments
php_runtime_args=""
php_filtered_args=()

# Function to extract PHP runtime arguments
# PHP runtime args typically start with: -d, -e, -n, -i, -m, -v, -r, -B, -E, -H, -I, -S, -T, -w, -z
# We'll focus on the most common ones: -d (define ini entry), -n (no php.ini), etc.
parse_php_args() {
    local i=1
    php_filtered_args=()
    
    while [ $i -le $# ]; do
        local arg="${!i}"
        case "$arg" in
            -d)
                # -d flag, next argument is the value
                if [ $i -lt $# ]; then
                    i=$((i + 1))
                    local next_arg="${!i}"
                    php_runtime_args="$php_runtime_args -d $next_arg"
                    i=$((i + 1))
                    continue
                fi
                ;;
            -e)
                # -e flag, next argument is the value
                if [ $i -lt $# ]; then
                    i=$((i + 1))
                    local next_arg="${!i}"
                    php_runtime_args="$php_runtime_args -e $next_arg"
                    i=$((i + 1))
                    continue
                fi
                ;;
            -n|-i|-m|-v|-r|-B|-E|-H|-I|-S|-T|-w|-z*)
                # Single flag PHP runtime argument
                php_runtime_args="$php_runtime_args $arg"
                ;;
            -d=*|-e=*|-n=*|-i=*|-m=*|-v=*|-r=*|-B=*|-E=*|-H=*|-I=*|-S=*|-T=*|-w=*|-z=*)
                # PHP runtime argument with value attached
                php_runtime_args="$php_runtime_args $arg"
                ;;
            *)
                # Regular argument, keep it
                php_filtered_args+=("$arg")
                ;;
        esac
        i=$((i + 1))
    done
}
