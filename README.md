# Dot Files

## Bash Installation

```
git clone https://github.com/zach-chai/dotfiles.git .dotfiles
cd ~/.dotfiles
./install.sh
```

At this point you can restart your terminal to see changes

## Environment

I am running on Linux. I primarily use zsh,
but this includes some older bash files as well. If you would like to switch
to zsh, you can do so with the following command.

```
chsh -s $(which zsh)
```

## Features

I normally place all of my coding projects in ~/workspace, so this directory
can easily be accessed (and tab completed) with the "c" command. This can
be configured by exporting CODE_PATH from the .localrc file.

```
c re<tab>
```

There are a few key bindings set. Many of these require option to be
set as the meta key. Option-left/right arrow will move cursor by word,
and control-left/right will move to beginning and end of line.
Control-option-N will open a new tab with the current directory under
Mac OS X Terminal.

If you're using git, you'll notice the current branch name shows up in
the prompt while in a git repository.

See the other aliases in ~/.zsh/aliases

If there are some shell configuration settings which you want secure or
specific to one system, place it into a ~/.localrc file. This will be
loaded automatically if it exists.
