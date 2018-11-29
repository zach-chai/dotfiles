source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/paths
source ~/.bash/config
source ~/.bash/prompt

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
