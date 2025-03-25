#!/bin/bash
# set -x

green() {
    echo -n -e "\033[32m$1\033[0m"
}

red() {
    echo -n -e "\033[31m$1\033[0m"
}

rtest() {
    echo -n "${1} ${3} "
    [[ "$(echo ${2} | ./remo)" == "${3}" ]] && green passed || red failed
    echo -n .. 
    [[ $(./remo "${2}") == "${3}" ]] && green passed || red failed
    echo
}

rtest 1. "" ""
rtest 2. hello hello
rtest 3. :hello :hello
rtest 4. hello: hello:
rtest 5. : :
rtest 6. :hey:man :hey:man
rtest 7. :: ::
rtest 8. "this is a sentence" "this is a sentence"
rtest 9. "this is a text: text" "this is a text: text"
rtest 10. :blush: 😊
rtest 10. hey:blush: hey😊
rtest 12. hey:blush:hey hey😊hey
rtest 13. "hey :blush:hey" "hey 😊hey"
rtest 14. ": blush:" ": blush:"
rtest 15. ":blush :" ":blush :"
rtest 16. :blush::smirk: 😊😏
rtest 17. ":blush: stop" "😊 stop"
rtest 18. "start :blush:" "start 😊"
rtest 19. "start :blush" "start :blush"
rtest 20. "start blush:" "start blush:"
rtest 21. ":blush stop" ":blush stop"
rtest 22. "my blush is :blush:" "my blush is 😊"
rtest 23. "my blush is :blush: stop" "my blush is 😊 stop"
rtest 24. "my blush is not :blush" "my blush is not :blush"
rtest 25. "my blush is not :blush no stop" "my blush is not :blush no stop"
rtest 26. "my blush is not :bb::lL" "my blush is not :bb::lL"
rtest 27. "my blush is \:blush:" "my blush is \😊"
rtest 28. "my blush is not then is \:blush:blush:" "my blush is not then is \😊blush:"
rtest 29. :smile:laughing:blush:smiley:relieved:smirk: 😄laughing😊smiley😌smirk:
rtest 30. 😄:laughing:😊:smiley:😌 😄😆😊😃😌
