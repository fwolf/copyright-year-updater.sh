# Copyright Year Updater

[![Build Status](https://travis-ci.org/fwolf/copyright-year-updater.sh.svg?branch=master)](https://travis-ci.org/fwolf/copyright-year-updater.sh)

Automatic update year in copyright notice, follow 
[GNU Suggestion](https://www.gnu.org/licenses/gpl-howto.html).


## Usage


    copyright-year-updater.sh [FILE]
    
Currently can only update single file, but we can use `find` and `xargs`  to
treat multiple files:

    find *.sh | xargs -L1 copyright-year-updater.sh


## License

MIT
