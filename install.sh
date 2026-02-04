#!/bin/bash

# TODO add an automated version

IGNORE_FILES="LICENSE|README|install.sh|claude"

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

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  printf "Installing oh-my-zsh\n"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
