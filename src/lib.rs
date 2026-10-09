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
    let mut found: Vec<(&str, &str)> =
        EMOJIS.iter().filter(|(short, _)| short.starts_with(prefix)).map(|(k, v)| (*k, *v)).collect();
    found.sort_by(|a, b| a.0.cmp(b.0));
    found
}

/// `text` with its `:shortcodes:` replaced by their emoji (unknown ones are kept as is).
pub fn expand(text: &str) -> String {
    let mut out = Vec::with_capacity(text.len());
    expand_stream(text.as_bytes(), &mut out).expect("writing to a Vec does not fail");
    String::from_utf8_lossy(&out).into_owned()
}

/// substitute emoji shortname with unicode emoji in place
/// returns true if substitution happened
fn substitute<W: Write>(out: &mut W, emoji: &str) -> io::Result<bool> {
    if let Some(replacement) = lookup(emoji) {
        write!(out, "{replacement}")?;
        Ok(true)
    } else {
        write!(out, ":{emoji}:")?;
        Ok(false)
    }
}

/// substitute emoji shortnames in an input stream
pub fn expand_stream<R: Read, W: Write>(mut input: R, mut out: W) -> io::Result<()> {
    let mut buf = Vec::new();

    input.read_to_end(&mut buf)?;
    // This "read all" strategy works well for short inputs
    // For bigger inputs (eg GB files) a buffered streaming approach should be preferred

    let mut i = 0;
    while i < buf.len() {
        if buf[i] != b':' {
            out.write_all(&buf[i..i + 1])?;
            i += 1;
            continue;
        }

        i += 1; // consume ':'
        let start = i;
        while i < buf.len() && buf[i] != b':' {
            i += 1;
        }

        if i >= buf.len() {
            // hit EOF without closing ':'
            out.write_all(b":")?;
            out.write_all(&buf[start..])?;
            break;
        } else {
            // buf[i] == b':', so we have ":shortcode:"
            let shortcode_bytes = &buf[start..i];
            let shortcode = String::from_utf8_lossy(shortcode_bytes);
            i += 1; // consume closing ':'

            // write substitution (or original form)
            substitute(&mut out, &shortcode)?;
        }
    }

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
    fn lookup_and_search() {
        assert_eq!(lookup("heart"), Some("❤️"));
        assert_eq!(lookup("not_an_emoji"), None);
        let found = search("thumbs");
        assert!(found.iter().any(|(_, emoji)| *emoji == "👍"));
        assert!(found.windows(2).all(|w| w[0].0 <= w[1].0), "sorted");
        assert!(search("zzz_none").is_empty());
    }
}
