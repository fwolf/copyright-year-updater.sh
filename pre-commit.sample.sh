#!/usr/bin/env bash
#====================================================================
# Git pre commit hook to update copyright year
#
# Copy this file as '.git/hooks/pre-commit', chmod +x.
#
# @see https://stackoverflow.com/questions/22858850
#====================================================================


export COPYRIGHT_YEAR_UPDATER='copyright-year-updater.sh'


# Command mktemp is a little different in MacOS X, need '-t' param
git diff-index --cached --name-only HEAD | xargs -I % sh -c '
    git ls-files --stage % | while read MODE OBJECT STAGE FILE_PATH; do
        case ${MODE} in
        10*)
            # Copy file to temporary
            STAGED_FILE=$(mktemp -t copyright_year-XXXXXXXXXX)
            git show ${OBJECT} > "${STAGED_FILE}"

            # Do change copyright year
            FORMATTED_FILE=$(mktemp -t copyright_year-XXXXXXXXXX)
            cp "${STAGED_FILE}" "${FORMATTED_FILE}"
            ${COPYRIGHT_YEAR_UPDATER} "${FORMATTED_FILE}"

            # Write new file blob to object database
            FORMATTED_HASH=`git hash-object -w "${FORMATTED_FILE}"`

            # Register new written file to working tree index
            git update-index --cacheinfo ${MODE} ${FORMATTED_HASH} "${FILE_PATH}"

            # Patch file in workspace, make it seems changed too
            diff "${STAGED_FILE}" "${FORMATTED_FILE}" | patch "${FILE_PATH}"

            rm "${STAGED_FILE}"
            rm "${FORMATTED_FILE}"
        ;;
        esac
    done
'


exit 0
