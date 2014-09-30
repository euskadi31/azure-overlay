#!/bin/bash

# see http://technicalpickles.com/posts/ebuild-protip-only-fetch-from-src_uri/
export GENTOO_MIRRORS=""

DIGEST_PATH=$(pwd)
DIGEST_LOG="$DIGEST_PATH/digest.log"

SYSTEM=$(uname -s)


# Define function if Mac OS X
if [[ "$SYSTEM" == 'Darwin' ]]; then

    # colors def
    COLOR_END="\x1b[0m"
    COLOR_GREEN="\x1b[32;01m"
    COLOR_RED="\x1b[31;01m"
    COLOR_YELLOW="\x1b[33;01m"
    COLOR_PURPLE_UNDERLINE="\x1b[35;04m"

    # string def
    STRING_OK="$COLOR_GREEN[  ok  ]$COLOR_END"
    STRING_ERROR="$COLOR_RED[  error  ]$COLOR_END"
    STRING_WARN="$COLOR_YELLOW[  warning  ]$COLOR_END"

    einfo() {
        echo -e "$1 $STRING_OK"
    }

    ewarn() {
        echo -e "$1 $COLOR_YELLOW"
    }

    eerror() {
        echo -e "$1 $COLOR_RED"
    }

    ebegin() {
        echo -en "$1 "
    }

    eend() {
        if [ $1 -eq 0 ]; then
            echo -e "$STRING_OK"
        else
            echo -e "$STRING_ERROR"
        fi
    }

    ebuild() {
        echo "Digest $1"
    }

else
    source "${PORTAGE_BIN_PATH:-/usr/lib/portage/bin}/isolated-functions.sh"
fi


# digest ebuild
digest() {
    ebegin "Digesting $1"
    ebuild $1 digest >> $DIGEST_LOG
    eend $?
}

# worker
worker() {
    # save current directory then cd to "$1"
    pushd "$1" > /dev/null

    for file in * ; do

        if [ -d "$file" ]; then
            worker "$file"
        else
            # check if ebuild file
            if [[ ${file: -7} == ".ebuild" ]]; then
                digest "$file"
            fi
        fi

    done

    # restore directory
    popd > /dev/null
}

main() {
    # clean log file
    if [ -f "$DIGEST_LOG" ]; then
        rm "$DIGEST_LOG"
    fi

    # start worker
    worker .

    #ebegin "Update eix"
    #eix-update >> $DIGEST_LOG
    #eend $?
}

# run
main
