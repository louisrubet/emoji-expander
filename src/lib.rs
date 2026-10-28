// SPDX-License-Identifier: MIT

//! Emoji `:shortcodes:` to Unicode emoji, as a library.
//!
//! ```
//! assert_eq!(emoji_expander::expand(":rocket: deploy"), "🚀 deploy");
//! assert_eq!(emoji_expander::lookup("bug"), Some("🐛"));
//! ```

use std::io::{self, Read, Write};

pub mod emojis;
pub use emojis::EMOJIS;

/// The emoji for `shortcode` (without the surrounding colons).
pub fn lookup(shortcode: &str) -> Option<&'static str> {
    EMOJIS.get(shortcode).copied()
}

/// The `(shortcode, emoji)` pairs whose shortcode starts with `prefix`, sorted by shortcode.
pub fn search(prefix: &str) -> Vec<(&'static str, &'static str)> {
    let mut found: Vec<(&str, &str)> = EMOJIS
        .iter()
        .filter(|(short, _)| short.starts_with(prefix))
        .map(|(k, v)| (*k, *v))
        .collect();
    found.sort_by(|a, b| a.0.cmp(b.0));
    found
}

/// `text` with its `:shortcodes:` replaced by their emoji (unknown ones are kept as is).
pub fn expand(text: &str) -> String {
    let mut out = Vec::with_capacity(text.len());
    expand_stream(text.as_bytes(), &mut out).expect("writing to a Vec does not fail");
    String::from_utf8_lossy(&out).into_owned()
}

/// The emoji of the `:shortcode:` starting `text`, and the length of that shortcode.
/// A shortcode has no whitespace.
fn shortcode_at(text: &[u8]) -> Option<(&'static str, usize)> {
    let end = 1 + text[1..]
        .iter()
        .position(|&b| b == b':' || b.is_ascii_whitespace())?;
    if text[end] != b':' {
        return None;
    }
    let emoji = std::str::from_utf8(&text[1..end]).ok().and_then(lookup)?;
    Some((emoji, end + 1))
}

/// substitute emoji shortnames in an input stream
pub fn expand_stream<R: Read, W: Write>(mut input: R, mut out: W) -> io::Result<()> {
    let mut buf = Vec::new();

    input.read_to_end(&mut buf)?;
    // This "read all" strategy works well for short inputs
    // For bigger inputs (eg GB files) a buffered streaming approach should be preferred

    let mut i = 0;
    while let Some(colon) = buf[i..].iter().position(|&b| b == b':') {
        out.write_all(&buf[i..i + colon])?;
        i += colon;
        match shortcode_at(&buf[i..]) {
            Some((emoji, len)) => {
                out.write_all(emoji.as_bytes())?;
                i += len;
            }
            // Not a shortcode: this ':' is text, the next one may open one.
            None => {
                out.write_all(b":")?;
                i += 1;
            }
        }
    }
    out.write_all(&buf[i..])?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn expands_known_shortcodes_only() {
        assert_eq!(expand(":rocket: deploy :nope: v2"), "🚀 deploy :nope: v2");
        assert_eq!(expand("no colon"), "no colon");
        assert_eq!(expand("open :rocket"), "open :rocket");
    }

    #[test]
    fn stray_colons_are_text() {
        assert_eq!(expand("see: :bug: fix"), "see: 🐛 fix");
        assert_eq!(expand("ratio 1:2 then :rocket:"), "ratio 1:2 then 🚀");
        assert_eq!(expand("a: b :tada: c :fire:"), "a: b 🎉 c 🔥");
        assert_eq!(expand("http://x :fire:"), "http://x 🔥");
        assert_eq!(expand("note :a :rocket: here"), "note :a 🚀 here");
        assert_eq!(expand("::rocket::"), ":🚀:");
        assert_eq!(expand(":rocket::tada:"), "🚀🎉");
        assert_eq!(expand("at 10:30:45, ok"), "at 10:30:45, ok");
        assert_eq!(expand("é:rocket:ü :"), "é🚀ü :");
    }

    #[test]
    fn lookup_and_search() {
        assert_eq!(lookup("heart"), Some("❤️"));
        assert_eq!(lookup("not_an_emoji"), None);
        let found = search("thumbs");
        assert!(found.iter().any(|(_, emoji)| *emoji == "👍"));
        assert!(found.windows(2).all(|w| w[0].0 <= w[1].0), "sorted");
        assert!(search("zzz_none").is_empty());
    }
}
