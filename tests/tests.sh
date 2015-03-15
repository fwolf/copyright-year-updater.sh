#!/usr/bin/env bash

set -e

P2T=${0%/*}/        # Path to tests
cd "${P2T}/"
PROGRAM=../copyright-year-updater.sh

source assert.sh


# Print usage
assert_raises "$PROGRAM" 1
assert_end "PrintUsage"


# Fully run
cp example.original.txt example.txt
assert_raises "$PROGRAM example.txt" 0
DIFF_CMD="diff example.txt example.updated.txt"
assert "$DIFF_CMD" ""
assert_raises "$DIFF_CMD" 0
assert_end "FullyRun"


# Cleanup
rm example.txt
