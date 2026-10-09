// SPDX-License-Identifier: MIT

use std::env;
use std::io::{self, Write};

use emoji_expander::{EMOJIS, expand_stream};

/// print syntax help
fn syntax() {
    eprintln!("Syntax: emoji-expander [-a | --all, -h | --help, --version] [text]");
    eprintln!("  -a | --all: list all emojis");
    eprintln!("  -h | --help: this help");
    eprintln!("  --version: print version");
    eprintln!("  text: substitute emoji shortnames in command arguments");
    eprintln!("  (no argument): substitute emoji shortnames on standard input");
    eprintln!("  Example:");
    eprintln!("  ➜  emoji-expander \":cool: :panda:\"");
    eprintln!("  😎🐼");
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
        expand_stream(io::stdin().lock(), io::stdout().lock())?;
    } else if args.len() == 2 && (args[1] == "-a" || args[1] == "--all") {
        all(io::stdout().lock())?;
    } else if args.len() == 2 && (args[1] == "-h" || args[1] == "--help") {
        syntax();
    } else if args.len() == 2 && args[1] == "--version" {
        println!("{}", env!("EMOJI_EXPANDER_VERSION"));
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
            expand_stream(arg.as_bytes(), &mut out_buf)?;
            print!("{}", String::from_utf8_lossy(&out_buf));
        }
        println!();
    }

    Ok(())
}
