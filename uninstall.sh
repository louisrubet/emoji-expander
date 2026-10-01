#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./uninstall.sh [OPTIONS]

Uninstall emoji-expander and optional shell integrations installed by install.sh.

Options:
  --prefix DIR        Remove binary from DIR/bin (default: ~/.local)
  --zsh               Remove binary + zsh integration
  --bash              Remove binary + bash integration
  --fish              Remove binary + fish integration
  --all-shells        Remove binary + zsh, bash and fish integrations
  --no-binary         Do not remove the binary; remove shell integration only
  --dry-run           Print actions without changing files
  -h, --help          Show this help

Default:
  Remove binary and detect the current shell integration from $SHELL.
  Use --no-binary with --zsh/--bash/--fish to remove only shell files.

Notes:
  This script removes installed files only. It does not edit ~/.zshrc or ~/.bashrc.

Examples:
  ./uninstall.sh
  ./uninstall.sh --zsh
  ./uninstall.sh --all-shells --prefix ~/.local
  ./uninstall.sh --no-binary --fish
EOF
}

log() {
  printf '%s\n' "$*"
}

run() {
  if [[ "$dry_run" == true ]]; then
    printf 'DRY-RUN:'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

remove_file() {
  local path=$1

  if [[ -e "$path" || -L "$path" ]]; then
    run rm -f -- "$path"
  else
    log "skip: not found: $path"
  fi
}

remove_empty_dir() {
  local path=$1

  if [[ -d "$path" ]]; then
    run rmdir --ignore-fail-on-non-empty -- "$path"
  fi
}

prefix="$HOME/.local"
xdg_data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
xdg_config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
dry_run=false
remove_binary=true
want_zsh=false
want_bash=false
want_fish=false
shell_option_seen=false

while (($#)); do
  case "$1" in
    --prefix)
      [[ $# -ge 2 ]] || { echo 'error: --prefix needs a directory' >&2; exit 1; }
      prefix=$2
      shift 2
      ;;
    --prefix=*)
      prefix=${1#*=}
      shift
      ;;
    --zsh)
      want_zsh=true
      shell_option_seen=true
      shift
      ;;
    --bash)
      want_bash=true
      shell_option_seen=true
      shift
      ;;
    --fish)
      want_fish=true
      shell_option_seen=true
      shift
      ;;
    --all-shells)
      want_zsh=true
      want_bash=true
      want_fish=true
      shell_option_seen=true
      shift
      ;;
    --no-binary)
      remove_binary=false
      shift
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'error: unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ "$shell_option_seen" == false ]]; then
  case "$(basename "${SHELL:-}")" in
    zsh) want_zsh=true ;;
    bash) want_bash=true ;;
    fish) want_fish=true ;;
    *)
      log "No supported shell detected from SHELL=${SHELL:-}."
      log "Use --zsh, --bash, --fish, or --all-shells."
      ;;
  esac
fi

if [[ "$remove_binary" == true ]]; then
  remove_file "$prefix/bin/emoji-expander"
fi

if [[ "$want_zsh" == true ]]; then
  remove_file "$xdg_data_home/emoji-expander/shell/emoji-expander.zsh"
fi

if [[ "$want_bash" == true ]]; then
  remove_file "$xdg_data_home/emoji-expander/shell/emoji-expander.bash"
fi

if [[ "$want_fish" == true ]]; then
  remove_file "$xdg_config_home/fish/conf.d/emoji-expander.fish"
fi

remove_empty_dir "$xdg_data_home/emoji-expander/shell"
remove_empty_dir "$xdg_data_home/emoji-expander"

if [[ "$dry_run" == true ]]; then
  status='Dry run complete. No files changed.'
else
  status='Uninstall complete.'
fi

cat <<EOF

$status

Removed if selected and present:
  $prefix/bin/emoji-expander
  $xdg_data_home/emoji-expander/shell/emoji-expander.zsh
  $xdg_data_home/emoji-expander/shell/emoji-expander.bash
  $xdg_config_home/fish/conf.d/emoji-expander.fish

If you added source lines to ~/.zshrc or ~/.bashrc, remove them manually.
EOF
