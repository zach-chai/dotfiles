#!/bin/bash

# TODO add an automated version

IGNORE_FILES="LICENSE|README|install.sh|Rakefile|gitconfig.erb"

function link_file () {
  if [[ $1 == gitconfig.template ]]; then
    cp ./gitconfig.template ~/.gitconfig

    read -p "Enter name " name
    read -p "Enter email " email
    read -p "Enter Github username " user
    read -p "Enter Github token " token

    echo "generating ~/.gitconfig"

    sed -i -e "s/<replace_name>/$name/g" ~/.gitconfig
    sed -i -e "s/<replace_email>/$email/g" ~/.gitconfig
    sed -i -e "s/<replace_user>/$user/g" ~/.gitconfig
    sed -i -e "s/<replace_token>/$token/g" ~/.gitconfig
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
  if [ ! -e ~/.$file ]; then
    link_file $file
    continue
  fi

  if cmp -s ./$file ~/.$file; then
    echo "identical .$file"
  elif $replace_all == true; then
    replace_file $file
  else
    read -p "overwrite ~/.$file? [ynaq] " choice
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

if [ -d ".oh-my-zsh" ]; then
  echo "Installing oh-my-zsh"
  $(git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh)
fi
