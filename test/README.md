# Tests

Run from the repo root:

```sh
cargo build --release
EMOJI_EXPANDER_BIN=./target/release/emoji-expander ./test/test.sh
```

`test.sh` checks both input modes:

- stdin
- command argument

It covers:

- valid shortcodes
- unknown shortcodes
- missing or extra colons
- adjacent shortcodes
- punctuation and spacing
- colon-heavy text such as URLs, times and ratios

It also runs a simple throughput test on `test-perf.txt` and prints:

```text
Performance: <bytes> bytes in <ms> ms (<MiB/s> MiB/s)
```

Override inputs if needed:

```sh
EMOJI_EXPANDER_BIN=/path/to/emoji-expander ./test/test.sh
EMOJI_EXPANDER_PERF_FILE=/path/to/file.txt ./test/test.sh
```
