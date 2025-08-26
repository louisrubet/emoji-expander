// SPDX-License-Identifier: MIT

#include <iostream>
#include <sstream>
#include <string>

#include "emojis.h"

/// @file main emoji shortcodes to unicode expander
/// @brief emoji shortcodes to unicode expander
/// @details Substitute emoji shortcodes (like :smile:) with unicode emoji
/// @details Input is stdin, output is stdout
/// @details Implementation is character-based
/// @details and does just one comparison by character read

/// @brief substitute emoji shortname with unicode emoji in place
/// @param emoji the shortname to substitute without leading ':'
/// @return true if substitution was done
static bool substitute(const std::string& emoji) {
    auto found = emojis.find(emoji);
    if (found != emojis.end()){
        std::cout << found->second;
        return true;
    }
    std::cout << ':' << emoji;
    return false;
}

/// @brief print syntax help
static void syntax() {
    std::cerr << "Syntax: remo [-a | --all, -h | --help] [text]" << std::endl;
    std::cerr << "  -a | --all: list all emojis" << std::endl;
    std::cerr << "  -h | --help: this help" << std::endl;
    std::cerr << "  text: substitute emoji shortnames in command arguments" << std::endl;
    std::cerr << "  (no argument): substitute emoji shortnames on standard input" << std::endl;
    std::cerr << "  Example:" << std::endl;
    std::cerr << "  ➜  remo \":cool: :panda:\"" << std::endl;
    std::cerr << "  😎🐼" << std::endl;
}

/// @brief substitute emoji shortnames in input stream
/// @param input input stream
static void remo(std::istream& input) {
    std::string emoji;
    char c;

    while (true) {
        while (input.get(c) && c != ':')
            std::cout << c;
        if (input.eof())
            return;

        emoji.clear();
        while (input.get(c)) {
            if (c == ':') {
                if (substitute(emoji))
                    break;
                emoji.clear();
            }
            else
                emoji += c;
        }
        if (input.eof()) {
            std::cout << ':' << emoji;
            return;
        }
    }
}

static void all() {
    for (auto& emoji : emojis)
        std::cout << emoji.second << " :" << emoji.first << ':' << std::endl;
}

int main(int argc, char* argv[]) {
    if (argc == 1)
        remo(std::cin);
    else if (argc == 2 && (std::string(argv[1]) == "-a" || std::string(argv[1]) == "--all"))
        all();
    else if (argc == 2 && (std::string(argv[1]) == "-h" || std::string(argv[1]) == "--help"))
        syntax();
    else {
        for (int i = 1; i < argc; i++) {
            std::istringstream input(argv[i]);
            remo(input);
            if (i > 1)
                std::cout << ' ';
        }
        std::cout << std::endl;
    }
    return 0;
}
