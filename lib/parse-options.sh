#!/usr/bin/env bash
#====================================================================
# Copyright 2015 Fwolf <fwolf.aide+bin.public@gmail.com>
# All rights reserved.
#
# Distributed under the MIT License.
# http://opensource.org/licenses/MIT
#====================================================================

# Parse command options
# see https://stackoverflow.com/a/7680682/1759745
function ParseOptions {
    # Default options
    DESTINATION_YEAR=$(date +"%Y")

    optspec=":y:-:"
    while getopts "$optspec" option; do
        case "${option}" in
            -)
                case "${OPTARG}" in
                    year)
                        DESTINATION_YEAR="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                        ;;
                    *)
                        if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                            echo "Unknown option --${OPTARG}" >&2
                        fi
                        ;;
                esac;;
            y)
                DESTINATION_YEAR="${OPTARG}" >&2
                ;;
            *)
                if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                    echo "Non-option argument: '-${OPTARG}'" >&2
                fi
                ;;
        esac
    done
}
