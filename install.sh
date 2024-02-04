#!/bin/bash

# TODO add an automated version

IGNORE_FILES="LICENSE|README|install.sh"
TEMPLATE_SUFFIX=.template

function link_file () {
  if [[ $1 == gitconfig.template ]]; then
    echo "generating ~/.gitconfig"

    read -p "Enter name " name
    read -p "Enter email " email
    read -p "Enter Github username " user
    read -p "Enter Github token " token

    cp ./gitconfig.template ~/.gitconfig

    sed -i -e "s/<replace_name>/$name/g" ~/.gitconfig
    sed -i -e "s/<replace_email>/$email/g" ~/.gitconfig
    sed -i -e "s/<replace_user>/$user/g" ~/.gitconfig
    sed -i -e "s/<replace_token>/$token/g" ~/.gitconfig
  elif [[ $1 == gitconfig_work.template ]]; then
    echo "generating ~/.gitconfig_work"

    read -p "Enter work email " work_email

    cp ./gitconfig_work.template ~/.gitconfig_work

    sed -i -e "s/<replace_email>/$work_email/g" ~/.gitconfig_work
  else
    echo "linking ~/.$1"
    $(ln -s "$PWD/$1" "$HOME/.$1")
  fi
}

function replace_file () {
  $(rm -rf $HOME/.$1)
  link_file $1
}

replace_all=false

for file in $(ls | grep -vE $IGNORE_FILES)
do
  home_file=${file%%.template}
  if [ ! -e ~/.$home_file ]; then
    link_file $file
    continue
  fi

  if cmp -s ./$file ~/.$home_file; then
    echo "identical .$file"
  elif [[ $replace_all == true ]]; then
    replace_file $file
  else
    read -p "overwrite ~/.$home_file? [ynaq] " choice
    case $choice in
      a )
        replace_all=true
        replace_file $file
        ;;
      y )
        replace_file $file
        ;;
      n )
        echo "skipping ~/.$file"
        ;;
      q )
        exit 0
        ;;
    esac
  fi
done

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
