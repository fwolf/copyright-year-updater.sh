#!/usr/bin/env bash
#====================================================================
# copyright-year-updater.sh
#
# Copyright 2015-2017 Fwolf <fwolf.aide+bin.public@gmail.com>
# All rights reserved.
#
# Distributed under the MIT License.
# http://opensource.org/licenses/MIT
#
# For copyright year style, see:
# https://www.gnu.org/prep/maintain/html_node/Copyright-Notices.html
# For quick view, run 'bc' and see its copyright notice.
#====================================================================

VERSION=0.2.4

self="$0"
if [ -L "$self" ]; then
    self=$(readlink "$self")
    self=$(realpath "$self")
fi
P2R=${self%/*}/

source "${P2R}"lib/parse-options.sh
source "${P2R}"lib/update-file.sh


function PrintUsage {
    PROGNAME=$(basename "$self")
    cat <<-EOF
${PROGNAME} ${VERSION}

Usage: ${PROGNAME} [Options] [File]

Options:

    -y, --year              Copyright end year, default is current year

All options must set before [File].

EOF
}


if [ $# -lt 1 ]; then
    PrintUsage
    exit 1
fi


ParseOptions "$@" && shift $(($OPTIND - 1))

UpdateFile "$1"

exit 0
