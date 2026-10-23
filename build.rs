// SPDX-License-Identifier: MIT

use std::process::Command;

fn git_output(args: &[&str]) -> Option<String> {
    let output = Command::new("git").args(args).output().ok()?;
    if !output.status.success() {
        return None;
    }

    let value = String::from_utf8(output.stdout).ok()?;
    let value = value.trim().to_string();
    if value.is_empty() { None } else { Some(value) }
}

fn git_path(path: &str) -> Option<String> {
    git_output(&["rev-parse", "--git-path", path])
}

fn rerun_if_git_path(path: &str) {
    if let Some(path) = git_path(path) {
        println!("cargo:rerun-if-changed={path}");
    }
}

/// Whether the sources are the checkout of the repository itself: not the archive of a
/// published crate, which may sit inside some other repository.
fn in_own_repository() -> bool {
    let Some(top) = git_output(&["rev-parse", "--show-toplevel"]) else {
        return false;
    };
    let manifest = std::env::var("CARGO_MANIFEST_DIR").unwrap_or_default();
    match (std::fs::canonicalize(top), std::fs::canonicalize(manifest)) {
        (Ok(top), Ok(manifest)) => top == manifest,
        _ => false,
    }
}

fn main() {
    println!("cargo:rerun-if-changed=build.rs");

    let fallback_version = format!("v{}", std::env::var("CARGO_PKG_VERSION").unwrap());
    if !in_own_repository() {
        println!("cargo:rustc-env=EMOJI_EXPANDER_VERSION={fallback_version}");
        return;
    }

    rerun_if_git_path("HEAD");
    rerun_if_git_path("refs/tags");
    rerun_if_git_path("packed-refs");

    if let Some(head_ref) = git_output(&["symbolic-ref", "--quiet", "HEAD"]) {
        rerun_if_git_path(&head_ref);
    }

    let last_tag = git_output(&["describe", "--tags", "--abbrev=0"]).unwrap_or(fallback_version);
    let exact_tag = git_output(&["describe", "--tags", "--exact-match", "HEAD"]);
    let commit = git_output(&["rev-parse", "--short=5", "HEAD"]);

    let version = if exact_tag.as_deref() == Some(last_tag.as_str()) {
        last_tag
    } else if let Some(commit) = commit {
        format!("{last_tag}+{commit}")
    } else {
        last_tag
    };

    println!("cargo:rustc-env=EMOJI_EXPANDER_VERSION={version}");
}
