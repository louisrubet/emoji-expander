# emoji-expander - terminal emoji shortcode expander

![demo](demo/demo.gif)

`emoji-expander` expands `:shortcodes:` into UTF-8 encoded Unicode emojis. Originally intended for git commits, it works with any text from the terminal.

```
$ emoji-expander ":rocket: deploy v2.1"
🚀 deploy v2.1

$ echo ":bug: fix null pointer" | emoji-expander
🐛 fix null pointer
```

Shell completion is available for bash, zsh and fish after `:` is pressed. After installing a completion script (see below), you get tab-completion on shortcode names.

Features:

- 500+ common emoji with multiple aliases (e.g. `:heart:`, `:red_heart:`, `:love:` all produce ❤️)
- Works with stdin and command-line arguments
- Shell integration: bind `:` to an interactive fuzzy emoji picker (bash, zsh, fish)

## Installation

Requires [Rust](https://www.rust-lang.org/tools/install).

### Install from Git

Install the binary directly from GitHub:

```sh
cargo install --git https://github.com/louisrubet/emoji-expander --root ~/.local
```

Then ensure the binary directory is in `PATH`:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

This installs the `emoji-expander` command only. To install shell integration too, clone the repository and run `install.sh --no-binary`:

```sh
git clone https://github.com/louisrubet/emoji-expander.git
cd emoji-expander
./install.sh --no-binary
```

### Install after cloning

Clone the repository, then run `install.sh`:

```sh
git clone https://github.com/louisrubet/emoji-expander.git
cd emoji-expander
./install.sh
```

`install.sh` installs the binary with `cargo install --path . --root ~/.local` and detects the shell integration from `$SHELL`.

Useful options:

```sh
./install.sh --zsh
./install.sh --bash
./install.sh --fish
./install.sh --all-shells
./install.sh --prefix ~/.local
./install.sh --no-binary --zsh
./install.sh --dry-run
```

For zsh or bash, add the source line printed by `install.sh` to your shell rc file. Fish integration is installed under `~/.config/fish/conf.d/` and loads automatically.

The shell integration binds the `:` key to an interactive emoji picker using [fzf](https://github.com/junegunn/fzf) (or peco/percol/fzy). Reload your shell or open a new terminal. Pressing `:` will open the emoji picker.

Temporarily disable shell completion:

```sh
export NOEMO=1
```

Enable it again:

```sh
export NOEMO=
```

`NOEMO` only affects shell integrations; `emoji-expander` still works normally.

## Usage

```
emoji-expander [-a | --all] [-h | --help] [--version] [text]
```

| Mode | Example |
|------|---------|
| Expand arguments | `emoji-expander ":tada: release"` |
| Expand stdin | `echo ":fire:" \| emoji-expander` |
| List all emoji | `emoji-expander -a` |
| Version | `emoji-expander --version` |
| Help | `emoji-expander -h` |

`--version` prints the latest git tag, with `+<5-char-commit-sha>` appended when the current commit is not exactly that tag.

## Git commit emoji

A set of emoji for git commits is included. Each one is available by its shortcode and also with a `git_` prefix (e.g. `:fix:` or `:git_fix:`).

```
$ emoji-expander ":git_fix: resolve null pointer"
🔧 resolve null pointer
```

| Shortcode | Emoji | Use |
|-----------|-------|-----|
| `:fix:` `:wrench:` | 🔧 | Bug fixes |
| `:build:` `:hammer:` | 🔨 | Build system |
| `:docs:` `:memo:` | 📝 | Documentation |
| `:test:` `:test_tube:` | 🧪 | Tests |
| `:check:` `:done:` | ✅ | Completed |
| `:remove:` `:cross_mark:` | ❌ | Remove |
| `:add:` `:heavy_plus_sign:` | ➕ | Add |
| `:delete:` `:trash:` | 🗑️ | Delete |
| `:refactor:` `:recycle:` | ♻️ | Refactor |
| `:move:` `:rename:` | 🚚 | Move/rename |
| `:wip:` `:construction:` | 🚧 | Work in progress |
| `:hotfix:` `:ambulance:` | 🚑 | Critical fix |
| `:config:` `:gear:` | ⚙️ | Configuration |
| `:security:` `:lock:` | 🔒 | Security |
| `:upgrade:` `:arrow_up:` | ⬆️ | Upgrade |
| `:downgrade:` `:arrow_down:` | ⬇️ | Downgrade |
| `:merge:` | 🔀 | Merge |
| `:revert:` `:rewind:` | ⏪ | Revert |
| `:init:` `:seedling:` | 🌱 | Initial commit |
| `:patch:` | 🩹 | Minor fix |
| `:cleanup:` `:broom:` | 🧹 | Cleanup |
| `:deprecate:` `:coffin:` | ⚰️ | Deprecation |
| `:ci:` | 🟢 | CI |
| `:docker:` | 🐳 | Docker |
| `:gitignore:` | 🙈 | .gitignore |
| `:license:` | 📜 | License |
| `:announce:` | 📢 | Announcements |
| `:deploy:` `:rocket:` | 🚀 | Deploy |
| `:release:` `:tada:` | 🎉 | Release |
| `:fire:` | 🔥 | Remove code/files |
| `:sparkles:` | ✨ | New feature |
| `:bug:` | 🐛 | Bug |
| `:art:` | 🎨 | Style/structure |

## Credits

- [Unicode emoji data](https://unicode.org/Public/emoji/)
- [Unicode emoji frequency](https://home.unicode.org/emoji/emoji-frequency/)
- [espanso](https://github.com/espanso/espanso)
- [emoji-cli](https://github.com/babarot/emoji-cli)
- [gitmoji](https://github.com/carloscuesta/gitmoji)
- [emoji cheat sheet](https://www.webfx.com/tools/emoji-cheat-sheet/)

## License

MIT - see [LICENSE](LICENSE)
