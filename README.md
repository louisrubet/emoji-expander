# remo - shortcode to emoji expander

Originally intended for git commits, this shortcode expander allows to insert emoji glyphs into all commands from the zsh terminal.

* list of more than 400 most common emojis
* complete with emojibase 17.0
* common shorcodes (case insensitive)

## Installation from build

Options:
- triggering key
- language (could be auto)
- subset : android, iOS, standard (? python ? unicode ?), gitmoji

## emoji lists

Apple: Unicode 15.1 (3,782 emojis)
gboard on android: Google Noto Color Emoji, which implements the full Unicode standard = Unicode 15.1 is supported in Android 14 / Gboard updates
GitHub:
    - Apple emoji images on Apple devices, and Twemoji (Twitter’s emoji set) as fallback on other platforms
    - own shortcode set, which originated from early GitHub markdown
      - :tada: → 🎉
      - :bug: → 🐛
    - Some GitHub shortcodes are not standard (e.g., :shipit: 🐿️ was a GitHub easter egg).
Slack:
    - Apple’s emoji set on macOS/iOS, and Noto Color Emoji (Google)
    - Slack has a large shortcode set, very similar to GitHub’s (many overlap).
    - Example:
      - :joy: → 😂
      - :sob: → 😭
      - :heart: → ❤️
    - Plus custom emoji support, where teams can upload their own images and assign them shortcodes.
Discord:
    - Uses Twemoji (Twitter’s open-source emoji set) for all devices, to keep it consistent.
    - Uses a GitHub/Slack-inspired shortcode system (very similar mappings).
    - examples:
      - :thinking: → 🤔
      - :fire: → 🔥
      - :100: → 💯

Slack, GitHub, Discord, Twitter
Android

## Build

## Credits
* https://unicode.org/Public/emoji/
* https://home.unicode.org/emoji/emoji-frequency/
* https://github.com/espanso/espanso
* https://github.com/babarot/emoji-cli
* https://www.webfx.com/tools/emoji-cheat-sheet/
* https://github.com/carloscuesta/gitmoji and https://github.com/carloscuesta/gitmoji-cli
