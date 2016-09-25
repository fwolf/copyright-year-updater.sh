# Copyright Year Updater

[![Build Status](https://travis-ci.org/fwolf/copyright-year-updater.sh.svg?branch=master)](https://travis-ci.org/fwolf/copyright-year-updater.sh)

Automatic update year in copyright notice, follow
[GNU Suggestion](https://www.gnu.org/licenses/gpl-howto.html).


## Usage


    copyright-year-updater.sh [Options] [File]


### Options

    -y, --year              Copyright end year, default is current year

All options must set before `[File]`.


### Multiple files

Currently can only update single file, but we can use `find` and `xargs`  to
treat multiple files:

    find *.sh | xargs -L1 copyright-year-updater.sh


## Git pre-commit hook

Copy `pre-commit.sample.sh` as `.git/hooks/pre-commit`, chmod +x.

This hook will not touch un-staged file, even this file have staged part.


## Notice for usage in MacOS X

MacOS X uses BSD version command utils, so you need GNU versons:

    - Bash v4
    - grep
    - sed
    - xargs

You can install them via brew and configure to use them, here is some useful
links:

    - http://superuser.com/a/1038813/190139
    - https://gist.github.com/samnang/1759336
    - http://apple.stackexchange.com/a/193300
    - http://stackoverflow.com/questions/30003570/how-to-use-gnu-sed-on-mac-os-x
    - https://sagebionetworks.jira.com/wiki/display/PLFM/Fixing+sed+on+OSx
    - https://twitter.com/fwolf/status/780103797745987584

Brew by default install `grep`, `sed`, `xargs` with prefixed with `g`, like
`ggrep`, to overwrite system grep:

    - In `/usr/local/bin/`, ln `ggrep` to `grep`, so do `gsed` and `xargs`
    - Config PATH, put `/usr/local/bin/` before `/usr/bin/` or `$PATH`
    - Restart bash


## License

MIT
