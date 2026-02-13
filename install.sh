#!/bin/bash

# TODO add an automated version

IGNORE_FILES="LICENSE|README|install.sh|claude|codex|AGENTS.md"

function link_file () {
  if [[ $1 == gitconfig.template ]]; then
    # Git config is generated from the template with user-specific values.
    printf "generating ~/.gitconfig\n"

    read -p "Enter name " name
    read -p "Enter email " email
    read -p "Enter Github username " user

    cp ./gitconfig.template ~/.gitconfig

    if [[ "$OSTYPE" == darwin* ]]; then
      sed -i '' -e "s/<replace_name>/$name/g" ~/.gitconfig
      sed -i '' -e "s/<replace_email>/$email/g" ~/.gitconfig
      sed -i '' -e "s/<replace_user>/$user/g" ~/.gitconfig
    else
      sed -i -e "s/<replace_name>/$name/g" ~/.gitconfig
      sed -i -e "s/<replace_email>/$email/g" ~/.gitconfig
      sed -i -e "s/<replace_user>/$user/g" ~/.gitconfig
    fi
  else
    printf "linking ~/.$1\n"
    ln -s "$PWD/$1" "$HOME/.$1"
  fi
}

function replace_file () {
  rm -rf "$HOME/.$1"
  link_file "$1"
}

# Returns 0 when destination is a symlink that resolves to source.
function is_link_to_target () {
  local source destination source_real target_link target_real
  source="$1"
  destination="$2"

  if [ ! -L "$destination" ]; then
    return 1
  fi

  source_real=$(cd "$source" 2>/dev/null && pwd -P) || return 1
  target_link=$(readlink "$destination") || return 1

  if [[ "$target_link" = /* ]]; then
    target_real=$(cd "$target_link" 2>/dev/null && pwd -P) || return 1
  else
    target_real=$(cd "$(dirname "$destination")/$target_link" 2>/dev/null && pwd -P) || return 1
  fi

  [ "$source_real" = "$target_real" ]
}

replace_all=false

for file in *
do
  if printf "%s\n" "$file" | grep -Eq "^($IGNORE_FILES)$"; then
    continue
  fi
  home_file=${file%%.template}
  if [ ! -e "$HOME/.$home_file" ]; then
    link_file "$file"
    continue
  fi

  if cmp -s "./$file" "$HOME/.$home_file"; then
    printf "identical .$file\n"
  elif [[ $replace_all == true ]]; then
    replace_file "$file"
  else
    read -p "overwrite ~/.$home_file? [ynaq] " choice
    case $choice in
      a )
        replace_all=true
        replace_file "$file"
        ;;
      y )
        replace_file "$file"
        ;;
      n )
        printf "skipping ~/.$file\n"
        ;;
      q )
        exit 0
        ;;
    esac
  fi
done

claude_settings="$PWD/claude/settings.json"
home_claude_settings="$HOME/.claude/settings.json"
claude_skills="$PWD/claude/skills"
home_claude_skills="$HOME/.claude/skills"
if [ -f "$claude_settings" ]; then
  # Claude settings are stored under ~/.claude, so link this file explicitly.
  if [ ! -e "$home_claude_settings" ]; then
    mkdir -p "$HOME/.claude"
    printf "linking ~/.claude/settings.json\n"
    ln -s "$claude_settings" "$home_claude_settings"
  elif cmp -s "$claude_settings" "$home_claude_settings"; then
    printf "identical .claude/settings.json\n"
  elif [[ $replace_all == true ]]; then
    rm -f "$home_claude_settings"
    mkdir -p "$HOME/.claude"
    printf "linking ~/.claude/settings.json\n"
    ln -s "$claude_settings" "$home_claude_settings"
  else
    read -p "overwrite ~/.claude/settings.json? [ynaq] " choice
    case $choice in
      a )
        replace_all=true
        rm -f "$home_claude_settings"
        mkdir -p "$HOME/.claude"
        printf "linking ~/.claude/settings.json\n"
        ln -s "$claude_settings" "$home_claude_settings"
        ;;
      y )
        rm -f "$home_claude_settings"
        mkdir -p "$HOME/.claude"
        printf "linking ~/.claude/settings.json\n"
        ln -s "$claude_settings" "$home_claude_settings"
        ;;
      n )
        printf "skipping ~/.claude/settings.json\n"
        ;;
      q )
        exit 0
        ;;
    esac
  fi
fi

if [ -d "$claude_skills" ]; then
  # Claude skills are stored under ~/.claude, so link this directory explicitly.
  if [ ! -e "$home_claude_skills" ]; then
    mkdir -p "$HOME/.claude"
    printf "linking ~/.claude/skills\n"
    ln -s "$claude_skills" "$home_claude_skills"
  elif is_link_to_target "$claude_skills" "$home_claude_skills"; then
    printf "identical .claude/skills\n"
  elif [[ $replace_all == true ]]; then
    rm -rf "$home_claude_skills"
    mkdir -p "$HOME/.claude"
    printf "linking ~/.claude/skills\n"
    ln -s "$claude_skills" "$home_claude_skills"
  else
    read -p "overwrite ~/.claude/skills? [ynaq] " choice
    case $choice in
      a )
        replace_all=true
        rm -rf "$home_claude_skills"
        mkdir -p "$HOME/.claude"
        printf "linking ~/.claude/skills\n"
        ln -s "$claude_skills" "$home_claude_skills"
        ;;
      y )
        rm -rf "$home_claude_skills"
        mkdir -p "$HOME/.claude"
        printf "linking ~/.claude/skills\n"
        ln -s "$claude_skills" "$home_claude_skills"
        ;;
      n )
        printf "skipping ~/.claude/skills\n"
        ;;
      q )
        exit 0
        ;;
    esac
  fi
fi

claude_md="$PWD/claude/CLAUDE.md"
home_claude_md="$HOME/.claude/CLAUDE.md"
if [ -f "$claude_md" ]; then
  # Global Claude instructions live at ~/.claude/CLAUDE.md.
  if [ ! -e "$home_claude_md" ]; then
    mkdir -p "$HOME/.claude"
    printf "linking ~/.claude/CLAUDE.md\n"
    ln -s "$claude_md" "$home_claude_md"
  elif cmp -s "$claude_md" "$home_claude_md"; then
    printf "identical .claude/CLAUDE.md\n"
  elif [[ $replace_all == true ]]; then
    rm -f "$home_claude_md"
    mkdir -p "$HOME/.claude"
    printf "linking ~/.claude/CLAUDE.md\n"
    ln -s "$claude_md" "$home_claude_md"
  else
    read -p "overwrite ~/.claude/CLAUDE.md? [ynaq] " choice
    case $choice in
      a )
        replace_all=true
        rm -f "$home_claude_md"
        mkdir -p "$HOME/.claude"
        printf "linking ~/.claude/CLAUDE.md\n"
        ln -s "$claude_md" "$home_claude_md"
        ;;
      y )
        rm -f "$home_claude_md"
        mkdir -p "$HOME/.claude"
        printf "linking ~/.claude/CLAUDE.md\n"
        ln -s "$claude_md" "$home_claude_md"
        ;;
      n )
        printf "skipping ~/.claude/CLAUDE.md\n"
        ;;
      q )
        exit 0
        ;;
    esac
  fi
fi

codex_config="$PWD/codex/config.toml"
home_codex_config="$HOME/.codex/config.toml"
codex_skills="$PWD/codex/skills"
home_codex_skills="$HOME/.codex/skills"
codex_rules="$PWD/codex/rules"
home_codex_rules="$HOME/.codex/rules"
codex_agents="$PWD/codex/AGENTS.md"
home_codex_agents="$HOME/.codex/AGENTS.md"
if [ -f "$codex_config" ]; then
  # Codex config lives under ~/.codex, so link it explicitly.
  if [ ! -e "$home_codex_config" ]; then
    mkdir -p "$HOME/.codex"
    printf "linking ~/.codex/config.toml\n"
    ln -s "$codex_config" "$home_codex_config"
  elif cmp -s "$codex_config" "$home_codex_config"; then
    printf "identical .codex/config.toml\n"
  elif [[ $replace_all == true ]]; then
    rm -f "$home_codex_config"
    mkdir -p "$HOME/.codex"
    printf "linking ~/.codex/config.toml\n"
    ln -s "$codex_config" "$home_codex_config"
  else
    read -p "overwrite ~/.codex/config.toml? [ynaq] " choice
    case $choice in
      a )
        replace_all=true
        rm -f "$home_codex_config"
        mkdir -p "$HOME/.codex"
        printf "linking ~/.codex/config.toml\n"
        ln -s "$codex_config" "$home_codex_config"
        ;;
      y )
        rm -f "$home_codex_config"
        mkdir -p "$HOME/.codex"
        printf "linking ~/.codex/config.toml\n"
        ln -s "$codex_config" "$home_codex_config"
        ;;
      n )
        printf "skipping ~/.codex/config.toml\n"
        ;;
      q )
        exit 0
        ;;
    esac
  fi
fi

if [ -d "$codex_skills" ]; then
  # Codex skills live under ~/.codex, so link them explicitly.
  if [ ! -e "$home_codex_skills" ]; then
    mkdir -p "$HOME/.codex"
    printf "linking ~/.codex/skills\n"
    ln -s "$codex_skills" "$home_codex_skills"
  elif is_link_to_target "$codex_skills" "$home_codex_skills"; then
    printf "identical .codex/skills\n"
  elif [[ $replace_all == true ]]; then
    rm -rf "$home_codex_skills"
    mkdir -p "$HOME/.codex"
    printf "linking ~/.codex/skills\n"
    ln -s "$codex_skills" "$home_codex_skills"
  else
    read -p "overwrite ~/.codex/skills? [ynaq] " choice
    case $choice in
      a )
        replace_all=true
        rm -rf "$home_codex_skills"
        mkdir -p "$HOME/.codex"
        printf "linking ~/.codex/skills\n"
        ln -s "$codex_skills" "$home_codex_skills"
        ;;
      y )
        rm -rf "$home_codex_skills"
        mkdir -p "$HOME/.codex"
        printf "linking ~/.codex/skills\n"
        ln -s "$codex_skills" "$home_codex_skills"
        ;;
      n )
        printf "skipping ~/.codex/skills\n"
        ;;
      q )
        exit 0
        ;;
    esac
  fi
fi

if [ -d "$codex_rules" ]; then
  # Codex rules live under ~/.codex, so link them explicitly.
  if [ ! -e "$home_codex_rules" ]; then
    mkdir -p "$HOME/.codex"
    printf "linking ~/.codex/rules\n"
    ln -s "$codex_rules" "$home_codex_rules"
  elif is_link_to_target "$codex_rules" "$home_codex_rules"; then
    printf "identical .codex/rules\n"
  elif [[ $replace_all == true ]]; then
    rm -rf "$home_codex_rules"
    mkdir -p "$HOME/.codex"
    printf "linking ~/.codex/rules\n"
    ln -s "$codex_rules" "$home_codex_rules"
  else
    read -p "overwrite ~/.codex/rules? [ynaq] " choice
    case $choice in
      a )
        replace_all=true
        rm -rf "$home_codex_rules"
        mkdir -p "$HOME/.codex"
        printf "linking ~/.codex/rules\n"
        ln -s "$codex_rules" "$home_codex_rules"
        ;;
      y )
        rm -rf "$home_codex_rules"
        mkdir -p "$HOME/.codex"
        printf "linking ~/.codex/rules\n"
        ln -s "$codex_rules" "$home_codex_rules"
        ;;
      n )
        printf "skipping ~/.codex/rules\n"
        ;;
      q )
        exit 0
        ;;
    esac
  fi
fi

if [ -f "$codex_agents" ]; then
  # Global Codex instructions live at ~/.codex/AGENTS.md.
  if [ ! -e "$home_codex_agents" ]; then
    mkdir -p "$HOME/.codex"
    printf "linking ~/.codex/AGENTS.md\n"
    ln -s "$codex_agents" "$home_codex_agents"
  elif cmp -s "$codex_agents" "$home_codex_agents"; then
    printf "identical .codex/AGENTS.md\n"
  elif [[ $replace_all == true ]]; then
    rm -f "$home_codex_agents"
    mkdir -p "$HOME/.codex"
    printf "linking ~/.codex/AGENTS.md\n"
    ln -s "$codex_agents" "$home_codex_agents"
  else
    read -p "overwrite ~/.codex/AGENTS.md? [ynaq] " choice
    case $choice in
      a )
        replace_all=true
        rm -f "$home_codex_agents"
        mkdir -p "$HOME/.codex"
        printf "linking ~/.codex/AGENTS.md\n"
        ln -s "$codex_agents" "$home_codex_agents"
        ;;
      y )
        rm -f "$home_codex_agents"
        mkdir -p "$HOME/.codex"
        printf "linking ~/.codex/AGENTS.md\n"
        ln -s "$codex_agents" "$home_codex_agents"
        ;;
      n )
        printf "skipping ~/.codex/AGENTS.md\n"
        ;;
      q )
        exit 0
        ;;
    esac
  fi
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  printf "Installing oh-my-zsh\n"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
