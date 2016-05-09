#!/bin/bash

IGNORE_FILES="LICENSE|README|install.sh|Rakefile|gitconfig"

function link_file () {
  echo "linking ~/.$1"
  $(ln -s "$PWD/$1" "$HOME/.$1")
}

function replace_file () {
  $(rm -rf $HOME/.$1)
  link_file $1
}

read -p "Enter name " name
read -p "Enter email " email
read -p "Enter Github username " user
read -p "Enter Github token " token

cp ./gitconfig.template ~/.gitconfig

sed -i -e "s/<replace_name>/$name/g" ~/.gitconfig
sed -i -e "s/<replace_email>/$email/g" ~/.gitconfig
sed -i -e "s/<replace_user>/$user/g" ~/.gitconfig
sed -i -e "s/<replace_token>/$token/g" ~/.gitconfig

for file in $(ls | grep -vE $IGNORE_FILES)
do
  if [ ! -e ~/.$file ]; then
    link_file $file
    continue
  fi

  if cmp ./$file ~/.$file; then
    echo "identical .$file"
  else
    replace_file $file
  fi
done

if [ -d ".oh-my-zsh" ]; then
  echo "Installing oh-my-zsh"
  $(git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh)
fi
