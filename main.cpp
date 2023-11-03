#include <iostream>
#include <sstream>
#include <string>

#include "emojis.h"

/// @file   main    emoji shortcodes to unicode expander
/// @brief  emoji shortcodes to unicode expander
/// @details Substitute emoji shortcodes (like :smile:) with unicode emoji
/// @details Input is stdin, output is stdout
/// @details Implementation is character-based
/// @details and does just one comparison by character read

// cf https://github.com/espanso/espanso
// cf https://github.com/babarot/emoji-cli
// cf https://www.webfx.com/tools/emoji-cheat-sheet/

static bool substitute(const std::string &emoji) {
    auto found = emojis.find(emoji);
    if (found != emojis.end()) {
        std::cout << found->second;
        return true;
    }
    std::cout << ':' << emoji;
    return false;
}

static void syntax() {
    std::cerr << "Syntax: remo [text]" << std::endl;
    std::cerr << "  text: substitute emoji shortnames in command arguments"
              << std::endl;
    std::cerr
        << "  (no argument): substitute emoji shortnames on standard input"
        << std::endl;
    std::cerr << "  Example:" << std::endl;
    std::cerr << "  ➜  remo :monkey:, :horse: and :cow:" << std::endl;
    std::cerr << "  🐒, 🐴 and 🐮" << std::endl;
}

static void remo(std::istream &input) {
    std::string emoji;
    char c;

    while (true) {
        while (input.get(c) && c != ':') std::cout << c;
        if (input.eof()) return;

        emoji.clear();
        while (input.get(c)) {
            if (c == ':') {
                if (substitute(emoji)) break;
                emoji.clear();
            } else
                emoji += c;
        }
        if (input.eof()) {
            std::cout << ':' << emoji;
            return;
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc == 1) {
        remo(std::cin);
        return 0;
    } else {
        for (int i = 1; i < argc; i++) {
            std::istringstream input(argv[i]);
            remo(input);
            if (i > 1) std::cout << ' ';
        }
        std::cout << std::endl;
    }
    return 0;
}
