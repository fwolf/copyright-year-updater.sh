#!/usr/bin/env bash
#====================================================================
# Copyright 2015 Fwolf <fwolf.aide+bin.public@gmail.com>
# All rights reserved.
#
# Distributed under the MIT License.
# http://opensource.org/licenses/MIT
#====================================================================

function UpdateFile {
    # Search file for matched lines, then save to array
    # https://stackoverflow.com/a/13825568/1759745
    GREP_COPY_SIGN="(\(c\)|©|&copy;)"
    GREP_YEAR="[0-9]{4}"
    GREP_SPACE="[ \t]+"
    declare -a matchedLines
    mapfile -t matchedLines < <(
        grep -in -E "${GREP_SPACE}Copyright${GREP_SPACE}(${GREP_COPY_SIGN}${GREP_SPACE}|)${GREP_YEAR}" "$1"
    )

    sedString=""

    # Double quote in 'in' is required
    for matchedLine in "${matchedLines[@]}"; do
        # Full matched line for replace later
        #echo "$matchedLine"

        lineNumber=${matchedLine%%:*}
        #echo $lineNumber

        originalLine=${matchedLine#*:}
        #echo "$originalLine"

        changedLine=$(UpdateLine "$originalLine")
        #echo Changed: "$changedLine"

        if [ "x$originalLine" != "x$changedLine" ]; then
            # Delete line, then insert new line
            # '\\' Before inserted line is prevent sed to ignore leading space
            # http://www.linuxquestions.org/questions/programming-9/sed-insert-line-with-leading-spaces-866217/
            # http://stackoverflow.com/questions/18439528
            sedString=$(
                echo "$sedString"
                echo "${lineNumber}i \\${changedLine}"
                echo "${lineNumber}d"
            )
        fi
    done

    if [ ${#sedString} -gt 0 ]; then
        sed -i "$sedString" "$1"
    fi
}


function UpdateLine {
    # Neither basic nor extended Posix/GNU regex recognizes the non-greedy
    # quantifier, so we cut line to 3 sections.
    # http://stackoverflow.com/questions/1103149
    SED_COPY_SIGN="\((c)\|©\|&copy;\)"
    SED_YEAR="[0-9]\{4\}"
    SED_YEARS="[0-9 ,\t-]*"
    SED_SPACE="[ \t]\+"

    # Before part include tailing space
    SED_BEFORE="\(.*Copyright${SED_SPACE}\(${SED_COPY_SIGN}${SED_SPACE}\|\)\)"
    before=$(echo "$1" | sed "s/${SED_BEFORE}\(${SED_YEAR}${SED_YEARS}.*\)/\1/i")

    # After part include leading space
    SED_AFTER="\($SED_SPACE[^0-9].*\)"
    after=$(echo "$1" | sed "s/[^0-9]*${SED_YEAR}${SED_YEARS}${SED_AFTER}/\1/i")

    # Compute years by length
    totalLength=${#1}
    beforeLength=${#before}
    afterLength=${#after}
    years=${1:$beforeLength:$totalLength - $beforeLength - $afterLength}

    years=$(UpdateYears "$years")

    echo "${before}${years}${after}"
}


function UpdateYears {
    years="$1"

    lastYear=${years:${#years} - 4:${#years}}
    let "yearDiff = $DESTINATION_YEAR - $lastYear"

    # If destination year is smaller or same with last copyright year, nothing
    # will happen, this program will not fix year error already exists.

    if [ $yearDiff -gt 1 ]; then
        # Eg: 2013 -> 2013, 2015
        # Eg: 2011-2013 --> 2011-2013, 2015
        # Eg: 2011, 2013 --> 2011, 2013, 2015
        years="${years}, ${DESTINATION_YEAR}"

    elif [ $yearDiff -eq 1 ]; then
        if [ 4 -eq ${#years} ]; then
            # Eg: 2014 -> 2014-2015
            years="${years}-${DESTINATION_YEAR}"

        else
            charBeforeLastYear=${years:${#years} - 5:1}
            if [ "x$charBeforeLastYear" = "x-" ]; then
                # Eg: 2011-2014 -> 2011-2015
                years=${years:0:${#years} - 4}${DESTINATION_YEAR}
            else
                # Eg: 2011,2014 -> 2011,2014-2015
                # Eg: 2011, 2014 -> 2011, 2014-2015
                years="${years}-${DESTINATION_YEAR}"
            fi
        fi
    fi

    echo "$years"
}
