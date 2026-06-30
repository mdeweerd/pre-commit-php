################################################################################
#
# Parse and apply PHP runtime arguments
#
# This helper script processes PHP runtime configuration arguments and makes them
# available for use when executing PHP-based tools.
#
# Supported arguments:
#   --memory_limit=<value>  : Set PHP memory limit (e.g., --memory_limit=512M)
#
# Usage:
#   source "$DIR/helpers/php-args.sh"
#   parse_php_args "$@"
#   set -- "${php_filtered_args[@]}"
#
# The script will:
#   - Parse arguments passed to the main script
#   - Extract and validate --memory_limit argument
#   - Store PHP runtime args in php_runtime_args variable
#   - Store the filtered arguments in php_filtered_args array
#
# After sourcing this, you can use:
#   php_runtime_args - contains the PHP runtime arguments (e.g., "-d memory_limit=512M")
#   php_filtered_args - array of arguments without PHP runtime args
#
# Then call: set -- "${php_filtered_args[@]}"
#
################################################################################
# shellcheck shell=bash

# Initialize PHP runtime arguments
php_runtime_args=""
php_filtered_args=()

# Function to validate memory limit value
# Allows: digits followed by optional K, M, G (case insensitive)
validate_memory_limit() {
    local value="$1"
    # Remove leading --memory_limit=
    value="${value#--memory_limit=}"

    # Check if value matches pattern: digits followed by optional K/M/G (case insensitive)
    if [[ "$value" =~ ^[0-9]+[KMGkmg]?$ ]]; then
        return 0
    fi

    return 1
}

# Function to extract PHP runtime arguments
parse_php_args() {
    local i=1
    php_filtered_args=()

    while [ $i -le $# ]; do
        local arg="${!i}"
        case "$arg" in
            --memory_limit=*)
                # Validate memory limit value
                if validate_memory_limit "$arg"; then
                    local value="${arg#--memory_limit=}"
                    php_runtime_args="$php_runtime_args -d memory_limit=${value}"
                else
                    echo "Error: Invalid memory_limit value: ${arg#--memory_limit=}" >&2
                    echo "Valid formats: --memory_limit=512M, --memory_limit=1G, --memory_limit=1024K" >&2
                    exit 1
                fi
                ;;
            *)
                # Regular argument, keep it
                php_filtered_args+=("$arg")
                ;;
        esac
        i=$((i + 1))
    done
}
