#!/usr/bin/env bash
#====================================================================
# copyright-year-updater.sh
#
# Copyright 2015 Fwolf <fwolf.aide+bin.public@gmail.com>
# All rights reserved.
#
# Distributed under the MIT License.
# http://opensource.org/licenses/MIT
#
# For copyright year style, see:
# https://www.gnu.org/prep/maintain/html_node/Copyright-Notices.html
# For quick view, run 'bc' and see its copyright notice.
#====================================================================

VERSION=0.1.2

P2R=${0%/*}/
source ${P2R}lib/update-file.sh


function PrintUsage {
    PROGNAME=$(basename $0)
    cat <<-EOF
$PROGNAME $VERSION

Usage: $PROGNAME [FILE]

EOF
}


if [ $# -lt 1 ]; then
    PrintUsage
    exit 1
fi


CURRENT_YEAR=$(date +"%Y")

UpdateFile "$@"

exit 0
