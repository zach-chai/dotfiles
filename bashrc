source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/paths
source ~/.bash/config
source ~/.bash/prompt

# Set up rbenv
if type "rbenv" > /dev/null; then
  eval "$(rbenv init -)"
fi

# Load project configurations
if [[ -d ~/.projects ]]; then
  for file in ~/.projects/*; do
    [[ -f $file ]] && . $file
  done
fi

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
