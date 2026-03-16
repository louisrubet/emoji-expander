// SPDX-License-Identifier: MIT

use std::env;
use std::io::{self, Read, Write};

mod emojis;
use emojis::EMOJIS;

/// print syntax help
fn syntax() {
    eprintln!("Syntax: emoji-expander [-a | --all, -h | --help] [text]");
    eprintln!("  -a | --all: list all emojis");
    eprintln!("  -h | --help: this help");
    eprintln!("  text: substitute emoji shortnames in command arguments");
    eprintln!("  (no argument): substitute emoji shortnames on standard input");
    eprintln!("  Example:");
    eprintln!("  ➜  emoji-expander \":cool: :panda:\"");
    eprintln!("  😎🐼");
}

/// substitute emoji shortname with unicode emoji in place
/// returns true if substitution happened
fn substitute<W: Write>(out: &mut W, emoji: &str) -> io::Result<bool> {
    if let Some(&replacement) = EMOJIS.get(emoji) {
        write!(out, "{replacement}")?;
        Ok(true)
    } else {
        write!(out, ":{emoji}:")?;
        Ok(false)
    }
}

/// substitute emoji shortnames in an input stream
fn remo<R: Read, W: Write>(mut input: R, mut out: W) -> io::Result<()> {
    let mut buf = Vec::new();

    input.read_to_end(&mut buf)?;
    // This "read all" strategy works well for short inputs
    // For bigger inputs (eg GB files) a buffered streaming approach should be preferred

    let mut i = 0;
    while i < buf.len() {
        if buf[i] != b':' {
            out.write_all(&buf[i..i+1])?;
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
            i += 1;// consume closing ':'

            // write substitution (or original form)
            substitute(&mut out, &shortcode)?;
        }
    }

    Ok(())
}

/// list all emojis
fn all<W: Write>(mut out: W) -> io::Result<()> {
    // HashMap iteration order is nondeterministic. Let's sort by key so output is stable.
    let mut pairs: Vec<(&str, &str)> = EMOJIS.iter().map(|(k, v)| (*k, *v)).collect();
    pairs.sort_by(|a, b| a.0.cmp(b.0));

    for (short, emoji) in pairs {
        writeln!(out, "{emoji} :{short}:")?;
    }
    Ok(())
}

fn main() -> io::Result<()> {
    let args: Vec<String> = env::args().collect();

    if args.len() == 1 {
        remo(io::stdin().lock(), io::stdout().lock())?;
    } else if args.len() == 2 && (args[1] == "-a" || args[1] == "--all") {
        all(io::stdout().lock())?;
    } else if args.len() == 2 && (args[1] == "-h" || args[1] == "--help") {
        syntax();
    } else {
        // treat each arg as its own "input stream"
        // and print them separated by spaces
        let mut first = true;
        for arg in args.iter().skip(1) {
            if !first {
                print!(" ");
            }
            first = false;

            let mut out_buf: Vec<u8> = Vec::new();
            remo(arg.as_bytes(), &mut out_buf)?;
            print!("{}", String::from_utf8_lossy(&out_buf));
        }
        println!();
    }

    Ok(())
}
