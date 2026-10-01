#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./install.sh [OPTIONS]

Install emoji-expander and optional shell integrations.

Options:
  --prefix DIR        Install binary with cargo under DIR (default: ~/.local)
  --zsh               Install binary + zsh integration
  --bash              Install binary + bash integration
  --fish              Install binary + fish integration
  --all-shells        Install binary + zsh, bash and fish integrations
  --no-binary         Do not run cargo install; install shell integration only
  --dry-run           Print actions without changing files
  -h, --help          Show this help

Default:
  Install binary and detect the current shell integration from $SHELL.
  Use --no-binary with --zsh/--bash/--fish to install only shell files.

Examples:
  ./install.sh
  ./install.sh --zsh
  ./install.sh --all-shells --prefix ~/.local
  ./install.sh --no-binary --fish
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

install_file() {
  local mode=$1
  local src=$2
  local dst=$3

  if [[ ! -r "$src" ]]; then
    printf 'error: missing source file: %s\n' "$src" >&2
    exit 1
  fi

  run install -Dm"$mode" "$src" "$dst"
}

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
prefix="$HOME/.local"
xdg_data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
xdg_config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
dry_run=false
install_binary=true
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
      install_binary=false
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

cd "$repo_dir"

if [[ "$install_binary" == true ]]; then
  if ! command -v cargo >/dev/null 2>&1; then
    echo 'error: cargo is required to install the binary' >&2
    exit 1
  fi
  run cargo install --path . --root "$prefix"
fi

if [[ "$want_zsh" == true ]]; then
  install_file 0644 \
    "$repo_dir/shell_extensions/emoji-expander_zsh_completion_script" \
    "$xdg_data_home/emoji-expander/shell/emoji-expander.zsh"
fi

if [[ "$want_bash" == true ]]; then
  install_file 0644 \
    "$repo_dir/shell_extensions/emoji-expander_bash_completion_script" \
    "$xdg_data_home/emoji-expander/shell/emoji-expander.bash"
fi

if [[ "$want_fish" == true ]]; then
  install_file 0644 \
    "$repo_dir/shell_extensions/emoji-expander_fish_completion_script" \
    "$xdg_config_home/fish/conf.d/emoji-expander.fish"
fi

if [[ "$dry_run" == true ]]; then
  status='Dry run complete. No files changed.'
else
  status='Install complete.'
fi

cat <<EOF

$status

Binary:
  $prefix/bin/emoji-expander

Add this to ~/.zshrc if you installed zsh integration:
  [[ -r "$xdg_data_home/emoji-expander/shell/emoji-expander.zsh" ]] && source "$xdg_data_home/emoji-expander/shell/emoji-expander.zsh"

Add this to ~/.bashrc if you installed bash integration:
  [[ -r "$xdg_data_home/emoji-expander/shell/emoji-expander.bash" ]] && source "$xdg_data_home/emoji-expander/shell/emoji-expander.bash"

Fish integration is loaded automatically from:
  $xdg_config_home/fish/conf.d/emoji-expander.fish

Make sure this is in PATH:
  $prefix/bin
EOF
