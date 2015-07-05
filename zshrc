# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="pygmalion"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(osx brew yum git ruby bundler heroku adb vagrant)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

. ~/.zsh/config
. ~/.zsh/aliases
. ~/.zsh/completion

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Load boxen configuration
[[ -f ~/opt/boxen/env.sh ]] && . /opt/boxen/env.sh

# Load project configurations
if [[ -d ~/.projects ]]; then
  for file in ~/.projects/*; do
    [[ -f $file ]] && . $file
  done
fi

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && . ~/.localrc

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
