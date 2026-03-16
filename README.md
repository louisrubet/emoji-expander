# emoji-expander - emoji shortcode expander

`emoji-expander` expands `:shortcodes:` into Unicode emoji. Originally intended for git commits, it works with any text from the terminal.

```
$ emoji-expander ":rocket: deploy v2.1"
🚀 deploy v2.1

$ echo ":bug: fix null pointer" | emoji-expander
🐛 fix null pointer
```

Features:

- 500+ common emoji with multiple aliases (e.g. `:heart:`, `:red_heart:`, `:love:` all produce ❤️)
- Works with stdin and command-line arguments
- Shell integration: bind `:` to an interactive fuzzy emoji picker (bash, zsh, fish)

## Installation

### Build from source

Requires [Rust](https://www.rust-lang.org/tools/install).

```sh
cargo build --release
sudo cp target/release/emoji-expander /usr/local/bin/
```

### Shell integration (emoji picker)

The included shell scripts bind the `:` key to an interactive emoji picker using [fzf](https://github.com/junegunn/fzf) (or peco/percol/fzy).

#### Zsh

```sh
sudo cp emoji-expander_zsh_completion_script /usr/local/share/zsh/site-functions/_emoji-expander
```

Add to `~/.zshrc`:

```sh
source /usr/local/share/zsh/site-functions/_emoji-expander
```

#### Bash

```sh
sudo cp emoji-expander_bash_completion_script /usr/local/share/emoji-expander/emoji-expander.bash
```

Add to `~/.bashrc`:

```sh
source /usr/local/share/emoji-expander/emoji-expander.bash
```

#### Fish

```sh
cp emoji-expander_fish_completion_script ~/.config/fish/conf.d/emoji-expander.fish
```

Reload your shell or open a new terminal. Pressing `:` will open the emoji picker.

## Usage

```
emoji-expander [-a | --all] [-h | --help] [text]
```

| Mode | Example |
|------|---------|
| Expand arguments | `emoji-expander ":tada: release"` |
| Expand stdin | `echo ":fire:" \| emoji-expander` |
| List all emoji | `emoji-expander -a` |
| Help | `emoji-expander -h` |

## Credits

- [Unicode emoji data](https://unicode.org/Public/emoji/)
- [Unicode emoji frequency](https://home.unicode.org/emoji/emoji-frequency/)
- [espanso](https://github.com/espanso/espanso)
- [emoji-cli](https://github.com/babarot/emoji-cli)
- [gitmoji](https://github.com/carloscuesta/gitmoji)
- [emoji cheat sheet](https://www.webfx.com/tools/emoji-cheat-sheet/)

## License

MIT - see [LICENSE](LICENSE)
