#!/bin/bash
# set -x

green() {
    echo -n -e "\033[32m$1\033[0m"
}

red() {
    echo -n -e "\033[31m$1\033[0m"
}

rtest() {
    echo -n "${line}. ${2} "
    [[ "$(echo ${1} | ./emoji-expander)" == "${2}" ]] && green "\tpassed" || red "\tfailed" # stdin test
    echo -n ..
    [[ $(./emoji-expander "${1}") == "${2}" ]] && green passed || red failed # arg test
    echo
    line=$((line+1))
}

line=1
rtest "" ""
rtest : :
rtest :: ::
rtest :blush: 😊
rtest hello hello
rtest :hello :hello
rtest hello: hello:
rtest :hey:man :hey:man
rtest hey:blush: hey😊
rtest hey:blush:hey hey😊hey
rtest "hey :blush:hey" "hey 😊hey"
rtest ": blush:" ": blush:"
rtest ":blush :" ":blush :"
rtest :blush::smirk: 😊😏
rtest ":blush: stop" "😊 stop"
rtest "start :blush:" "start 😊"
rtest 😄:laughing:😊:smiley:😌 😄😂😊😃😌
rtest "this is a sentence" "this is a sentence"
rtest "start :blush" "start :blush"
rtest "start blush:" "start blush:"
rtest ":blush stop" ":blush stop"
rtest "my blush is :blush:" "my blush is 😊"
rtest "my blush is \:blush:" "my blush is \😊"
rtest "this is a text: text" "this is a text: text"
rtest "my blush is :blush: stop" "my blush is 😊 stop"
rtest "my blush is not :blush" "my blush is not :blush"
rtest "my blush is not :bb::lL" "my blush is not :bb::lL"
rtest :smiling:laughing:blush:smiley:relieved:smirk: 🙂laughing😊smiley😌smirk:
rtest "my blush is not :blush no stop" "my blush is not :blush no stop"
rtest "my blush is not then is \:blush:blush:" "my blush is not then is \😊blush:"
