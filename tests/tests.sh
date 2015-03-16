#!/usr/bin/env bash

set -e

P2T=${0%/*}/        # Path to tests
cd "${P2T}/"
PROGRAM=../copyright-year-updater.sh

source assert.sh
source ../lib/update-file.sh


# Print usage
assert_raises "$PROGRAM" 1
assert_end "PrintUsage"


# UpdateLine
CURRENT_YEAR=2015
# Disable file expansion, see https://stackoverflow.com/a/104023/1759745
set -f
# Disable word splitting, see https://www.gnu.org/software/bash/manual/bashref.html#Word-Splitting
IFS=""

x=" * @copyright   Copyright 2013 Holder"
y=" * @copyright   Copyright 2013, 2015 Holder"
assert "UpdateLine \"$x\"" "$y"

x=" * @copyright   Copyright (c) 2013 Holder"
y=" * @copyright   Copyright (c) 2013, 2015 Holder"
assert "UpdateLine \"$x\"" "$y"

x=" * @copyright   Copyright (C) 2013 Holder"
y=" * @copyright   Copyright (C) 2013, 2015 Holder"
assert "UpdateLine \"$x\"" "$y"

x=" * @copyright   COPYRIGHT &copy; 2013 Holder"
y=" * @copyright   COPYRIGHT &copy; 2013, 2015 Holder"
assert "UpdateLine \"$x\"" "$y"

x=" * @copyright   Copyright © 2013 Holder"
y=" * @copyright   Copyright © 2013, 2015 Holder"
assert "UpdateLine \"$x\"" "$y"

# Holder must not be empty
x=" * @copyright   Copyright 2013"
assert "UpdateLine \"$x\"" ""

assert_end "UpdateLine"


# Fully run
cp example.original.txt example.txt
assert_raises "$PROGRAM example.txt" 0
DIFF_CMD="diff example.txt example.updated.txt"
assert "$DIFF_CMD" ""
assert_raises "$DIFF_CMD" 0
assert_end "FullyRun"


# Cleanup
rm example.txt
