#!/bin/bash

# Symlink map: repo-relative source : absolute target (one per line).
# Entries whose source does not exist in the repo are silently skipped.
SYMLINK_MAP="
zshrc:$HOME/.zshrc
zsh:$HOME/.zsh
claude/settings.json:$HOME/.claude/settings.json
claude/skills:$HOME/.claude/skills
claude/CLAUDE.md:$HOME/.claude/CLAUDE.md
codex/config.toml:$HOME/.codex/config.toml
codex/skills:$HOME/.codex/skills
codex/rules:$HOME/.codex/rules
codex/AGENTS.md:$HOME/.codex/AGENTS.md
"

# Template map: files that are copied and variable-substituted, not symlinked.
TEMPLATE_MAP="
gitconfig.template:$HOME/.gitconfig
"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Portable absolute-path resolver (avoids GNU readlink -f).
# For directories: cd + pwd -P.  For files: resolve the parent dir.
resolve_path () {
  if [ -d "$1" ]; then
    (cd "$1" && pwd -P)
  else
    local dir base
    dir=$(cd "$(dirname "$1")" && pwd -P) || return 1
    base=$(basename "$1")
    printf '%s/%s' "$dir" "$base"
  fi
}

# Follow a symlink one level and resolve the result to an absolute path.
resolve_link () {
  local link_target
  link_target=$(readlink "$1") || return 1
  if [[ "$link_target" != /* ]]; then
    link_target="$(dirname "$1")/$link_target"
  fi
  resolve_path "$link_target"
}

# Replace $HOME prefix with ~ for display.
display_path () {
  printf '%s' "${1/#$HOME/~}"
}

# Returns 0 when the target already matches the source.
# For symlinks: checks whether the link resolves to the source path.
# For regular files: falls back to byte-for-byte comparison.
is_identical () {
  local source="$1" target="$2"

  if [ -L "$target" ]; then
    local source_real target_real
    source_real=$(resolve_path "$source") || return 1
    target_real=$(resolve_link "$target") || return 1
    [ "$source_real" = "$target_real" ] && return 0
  fi

  if [ -f "$source" ] && [ -f "$target" ]; then
    cmp -s "$source" "$target" && return 0
  fi

  return 1
}

# Create a symlink, creating parent directories as needed.
do_link () {
  local source="$1" target="$2"
  mkdir -p "$(dirname "$target")"
  printf "linking %s\n" "$(display_path "$target")"
  ln -s "$source" "$target"
}

# Remove existing target and re-link.
do_replace () {
  local source="$1" target="$2"
  rm -rf "$target"
  do_link "$source" "$target"
}

# Process a template file: copy to target and perform substitutions.
process_template () {
  local source="$1" target="$2"

  printf "generating %s\n" "$(display_path "$target")"
  read -p "Enter email: " email

  mkdir -p "$(dirname "$target")"
  cp "$source" "$target"

  if [[ "$OSTYPE" == darwin* ]]; then
    sed -i '' -e "s/<replace_email>/$email/g" "$target"
  else
    sed -i -e "s/<replace_email>/$email/g" "$target"
  fi
}

# Prompt for overwrite and act. Shared by both loops.
# Sets replace_all=true when the user picks "a".
prompt_overwrite () {
  local source="$1" target="$2" action="$3"
  read -p "overwrite $(display_path "$target")? [ynaq] " choice
  case $choice in
    a ) replace_all=true; $action "$source" "$target" ;;
    y ) $action "$source" "$target" ;;
    n ) printf "skipping %s\n" "$(display_path "$target")" ;;
    q ) exit 0 ;;
  esac
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

replace_all=false

# --- Templates (copy + substitute) ---
while IFS=: read -r src tgt; do
  [ -z "$src" ] && continue
  source_path="$PWD/$src"
  [ ! -e "$source_path" ] && continue

  if [ ! -e "$tgt" ]; then
    process_template "$source_path" "$tgt"
  elif is_identical "$source_path" "$tgt"; then
    printf "identical %s\n" "$(display_path "$tgt")"
  elif [[ $replace_all == true ]]; then
    rm -f "$tgt"
    process_template "$source_path" "$tgt"
  else
    read -p "overwrite $(display_path "$tgt")? [ynaq] " choice
    case $choice in
      a ) replace_all=true; rm -f "$tgt"; process_template "$source_path" "$tgt" ;;
      y ) rm -f "$tgt"; process_template "$source_path" "$tgt" ;;
      n ) printf "skipping %s\n" "$(display_path "$tgt")" ;;
      q ) exit 0 ;;
    esac
  fi
done <<< "$TEMPLATE_MAP"

# --- Symlinks ---
while IFS=: read -r src tgt; do
  [ -z "$src" ] && continue
  source_path="$PWD/$src"
  [ ! -e "$source_path" ] && continue

  if [ ! -e "$tgt" ]; then
    do_link "$source_path" "$tgt"
  elif is_identical "$source_path" "$tgt"; then
    printf "identical %s\n" "$(display_path "$tgt")"
  elif [[ $replace_all == true ]]; then
    do_replace "$source_path" "$tgt"
  else
    prompt_overwrite "$source_path" "$tgt" do_replace
  fi
done <<< "$SYMLINK_MAP"

# --- Install oh-my-zsh if missing ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  printf "Installing oh-my-zsh\n"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
